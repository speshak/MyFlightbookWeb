﻿using System;

/******************************************************
 * 
 * Copyright (c) 2007-2021 MyFlightbook LLC
 * Contact myflightbook-at-gmail.com for more information
 *
*******************************************************/

namespace MyFlightbook.Currency
{
    public class FlightExperienceCanada : IFlightExaminer
    {
        public bool HasExperience
        {
            get { return fHasPICExperience || fHasFlightReview; }
        }

        private bool fHasPICExperience;
        private bool fHasFlightReview;

        public FlightExperienceCanada() { }

        public void ExamineFlight(ExaminerFlightRow cfr)
        {
            if (cfr == null)
                throw new ArgumentNullException(nameof(cfr));

            if (cfr.dtFlight.CompareTo(DateTime.Now.AddYears(-5)) < 0)
                return;

            fHasPICExperience = fHasPICExperience || (cfr.PIC + cfr.SIC > 0);

            // Alternative to having PIC experience is having a flight review in the prior year
            if (cfr.dtFlight.CompareTo(DateTime.Now.AddYears(-1)) > 0)
            {
                cfr.FlightProps.ForEachEvent((pe) =>
                {
                    if (pe.PropertyType.IsBFR)
                        fHasFlightReview = true;
                });
            }
        }
    }
    /// <summary>
    /// Rules for Canada are a bit different.  See https://www.tc.gc.ca/eng/civilaviation/publications/tp185-1-10-takefive-559.htm and http://laws-lois.justice.gc.ca/eng/regulations/SOR-96-433/FullText.html#s-401.05
    /// </summary>
    public class PassengerCurrencyCanada : PassengerCurrency
    {
        private readonly FlightExperienceCanada fcCanada;

        public PassengerCurrencyCanada(string szName, bool fRequireDayLandings)
            : base(szName, fRequireDayLandings)
        {
            CurrencyTimespanType = TimespanType.CalendarMonths;
            ExpirationSpan = 6;
            RequiredEvents = Discrepancy = 5;
            fcCanada = new FlightExperienceCanada();

            Query = null;
        }

        public override void ExamineFlight(ExaminerFlightRow cfr)
        {
            base.ExamineFlight(cfr);
            fcCanada.ExamineFlight(cfr);
        }

        public override CurrencyState CurrentState
        {
            get { return fcCanada.HasExperience ? base.CurrentState : CurrencyState.NotCurrent; }
        }

        public override string DiscrepancyString
        {
            get { return (fcCanada.HasExperience) ? base.DiscrepancyString : Resources.Currency.CanadaNoPICTime; }
        }
    }

    /// <summary>
    /// Canadian rules are slightly different.  See https://www.tc.gc.ca/eng/civilaviation/publications/tp185-1-10-takefive-559.htm
    /// </summary>
    public class NightCurrencyCanada : NightCurrency
    {
        const int RequiredLandingsCanada = 5;
        const int RequiredTakeoffsCanada = 5;
        const int TimeSpanCanada = 6;
        private readonly FlightExperienceCanada fcCanada;

        public NightCurrencyCanada(string szName) : base(szName, true)  // night touch-and-go landings count.
        {
            NightTakeoffCurrency.CurrencyTimespanType = this.CurrencyTimespanType = TimespanType.CalendarMonths;
            NightTakeoffCurrency.ExpirationSpan = this.ExpirationSpan = TimeSpanCanada;
            this.RequiredEvents = this.Discrepancy = RequiredLandingsCanada;
            NightTakeoffCurrency.RequiredEvents = NightTakeoffCurrency.Discrepancy = RequiredTakeoffsCanada;
            fcCanada = new FlightExperienceCanada();

            Query = null;
        }

        public override void ExamineFlight(ExaminerFlightRow cfr)
        {
            if (cfr == null)
                throw new ArgumentNullException(nameof(cfr));
            base.ExamineFlight(cfr);    // Should handle touch-and-go landings regardless.
            fcCanada.ExamineFlight(cfr);
        }

        public override CurrencyState CurrentState
        {
            get { return fcCanada.HasExperience ? base.CurrentState : CurrencyState.NotCurrent; }
        }

        public override string DiscrepancyString
        {
            get { return (fcCanada.HasExperience) ? base.DiscrepancyString : Resources.Currency.CanadaNoPICTime; }
        }
    }

    /// <summary>
    /// Instrument Currency rules for Canada - see http://laws-lois.justice.gc.ca/eng/regulations/SOR-96-433/FullText.html#s-401.05
    /// </summary>
    public class InstrumentCurrencyCanada : CompositeFlightCurrency
    {
        readonly FlightCurrency fc401_05_3_a = new FlightCurrency(1.0M, 12, true, "IPC or new rating");
        readonly FlightCurrency fc401_05_3_bTime = new FlightCurrency(6.0M, 6, true, "6 Hours of IFR time");
        readonly FlightCurrency fc401_05_3_bApproaches = new FlightCurrency(6.0M, 6, true, "6 approaches");
        readonly FlightCurrency fc401_05_3_cTime = new FlightCurrency(6.0M, 6, true, "6 Hours of IFR time in a real aircraft");
        readonly FlightCurrency fc401_05_3_cApproaches = new FlightCurrency(6.0M, 6, true, "6 approaches in a real aircraft");

        public InstrumentCurrencyCanada() { }

        public override void ExamineFlight(ExaminerFlightRow cfr)
        {
            if (cfr == null)
                throw new ArgumentNullException(nameof(cfr));
            Invalidate();

            // 401.05(3)(a) - IPC or equivalent
            cfr.FlightProps.ForEachEvent((pfe) =>
            {
                // add any IPC or IPC equivalents
                if (pfe.PropertyType.IsIPC)
                    fc401_05_3_a.AddRecentFlightEvents(cfr.dtFlight, 1.0M);
            });

            decimal IFRTime = cfr.IMC + cfr.IMCSim;
            decimal IFRCFITime = Math.Min(IFRTime, cfr.CFI);

            // 401.05(3)(b) - flight in a real aircraft or sim
            fc401_05_3_bTime.AddRecentFlightEvents(cfr.dtFlight, Math.Max(0, IFRTime - IFRCFITime));
            fc401_05_3_bApproaches.AddRecentFlightEvents(cfr.dtFlight, cfr.cApproaches);

            // 401.05(3)(c) - IFR instruction in a real aircraft
            if (cfr.fIsRealAircraft)
            {
                fc401_05_3_cTime.AddRecentFlightEvents(cfr.dtFlight, IFRCFITime);
                fc401_05_3_cApproaches.AddRecentFlightEvents(cfr.dtFlight, cfr.CFI > 0 ? cfr.cApproaches : 0);
            }
        }

        protected override void ComputeComposite()
        {
            // 401.05(3)(a)-(c) say you have an IPC OR 6approaches+6hours OR 6approaches+6hours instructing.
            FlightCurrency fcIFRCanada = fc401_05_3_a.OR(fc401_05_3_bTime.AND(fc401_05_3_bApproaches)).OR(fc401_05_3_cTime.AND(fc401_05_3_cApproaches));
            CompositeCurrencyState = fcIFRCanada.CurrentState;
            CompositeExpiration = fcIFRCanada.ExpirationDate;
            if (CompositeCurrencyState== CurrencyState.NotCurrent)
                CompositeDiscrepancy = Resources.Currency.IPCRequired;

        }
    }
}