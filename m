From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_time 2007-09-22
Date: Sat, 22 Sep 2007 17:19:31 +0200
Message-ID: <46F53283.90204@trash.net>
References: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57779 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbXIVPVT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2007 11:21:19 -0400
In-Reply-To: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> +/*
> + * Each network packet has a (nano)seconds-since-the-epoch (SSTE) timestamp.
> + * Since we match against days and daytime, the SSTE value needs to be
> + * computed back into human-readable dates.
> + *
> + * This is done in three separate functions so that the most expensive
> + * calculations are done last, in case a "simple match" can be found earlier.
> + */
> +static inline unsigned int localtime_1(struct xtm *r, time_t time)
> +{
> +	unsigned int v, w;
> +
> +	/* Each day has 86400s, so finding the hour/minute is actually easy. */
> +	v         = time % 86400;
> +	r->second = v % 60;
> +	w         = v / 60;
> +	r->minute = w % 60;
> +	r->hour   = w / 60;
> +	return v;
> +}
> +
> +static inline void localtime_2(struct xtm *r, time_t time)
> +{
> +	/*
> +	 * Here comes the rest (weekday, monthday). First, divide the SSTE
> +	 * by seconds-per-day to get the number of _days_ since the epoch.
> +	 */
> +	r->dse = time / 86400;
> +
> +	/* 1970-01-01 (w=0) was a Thursday (4). */
> +	r->weekday = (4 + r->dse) % 7;
> +}
> +
> +static void localtime_3(struct xtm *r, time_t time)
> +{
> +	unsigned int year, i, w = r->dse;
> +
> +	/*
> +	 * In each year, a certain number of days-since-the-epoch have passed.
> +	 * Find the year that is closest to said days.
> +	 *
> +	 * Consider, for example, w=21612 (2029-03-04). Loop will abort on
> +	 * dse[i] <= w, which happens when dse[i] == 21550. This implies
> +	 * year == 2009. w will then be 62.
> +	 */
> +	for (i = 0, year = DSE_FIRST; days_since_epoch[i] > w;
> +	    ++i, --year)
> +		/* just loop */;
> +
> +	w -= days_since_epoch[i];
> +
> +	/*
> +	 * By now we have the current year, and the day of the year.
> +	 * r->yearday = w;
> +	 *
> +	 * On to finding the month (like above). In each month, a certain
> +	 * number of days-since-New Year have passed, and find the closest
> +	 * one.
> +	 *
> +	 * Consider w=62 (in a non-leap year). Loop will abort on
> +	 * dsy[i] < w, which happens when dsy[i] == 31+28 (i == 2).
> +	 * Concludes i == 2, i.e. 3rd month => March.
> +	 *
> +	 * (A different approach to use would be to subtract a monthlength
> +	 * from w repeatedly while counting.)
> +	 */
> +	if (is_leap(year)) {
> +		for (i = ARRAY_SIZE(days_since_leapyear) - 1;
> +		    i > 0 && days_since_year[i] > w; --i)
> +			/* just loop */;
> +	} else {
> +		for (i = ARRAY_SIZE(days_since_year) - 1;
> +		    i > 0 && days_since_year[i] > w; --i)
> +			/* just loop */;
> +	}
> +
> +	r->month    = i + 1;
> +	r->monthday = w - days_since_year[i] + 1;
> +	return;
> +}
>   

A thought just occured to me (a bit late, but better than never :) ..

Can't we just convert the user-specified times/dates to unix time
and match on that without all these expensive calculations? At least
for pure time matching without days this should work fine ..


> +
> +static bool xt_time_match(const struct sk_buff *skb,
> +                          const struct net_device *in,
> +                          const struct net_device *out,
> +                          const struct xt_match *match, const void *matchinfo,
> +                          int offset, unsigned int protoff, bool *hotdrop)
> +{
> +	const struct xt_time_info *info = matchinfo;
> +	unsigned int packet_time;
> +	struct xtm current_time;
> +	s64 stamp;
> +
> +	/*
> +	 * We cannot use get_seconds() instead of __net_timestamp() here.
> +	 * Suppose you have two rules:
> +	 * 	1. match before 13:00
> +	 * 	2. match after 13:00
> +	 * If you match against processing time (get_seconds) it
> +	 * may happen that the same packet matches both rules if
> +	 * it arrived at the right moment before 13:00.
> +	 */
> +	if (skb->tstamp.tv64 == 0)
> +		__net_timestamp((struct sk_buff *)skb);
> +
> +	stamp = skb->tstamp.tv64;
> +	do_div(stamp, NSEC_PER_SEC);
> +
> +	if (info->flags & XT_TIME_LOCAL_TZ)
> +		/* Adjust for local timezone */
> +		stamp -= 60 * sys_tz.tz_minuteswest;
> +
> +	/*
> +	 * xt_time will match when _all_ of the following hold:
> +	 *   - 'now' is in the global time range date_start..date_end
> +	 *   - 'now' is in the monthday mask
> +	 *   - 'now' is in the weekday mask
> +	 *   - 'now' is in the daytime range time_start..time_end
> +	 * (and by default, libxt_time will set these so as to match)
> +	 */
> +
> +	if (stamp < info->date_start || stamp > info->date_stop)
> +		return false;
> +
> +	packet_time = localtime_1(&current_time, stamp);
> +
> +	if (info->daytime_start < info->daytime_stop) {
> +		if (packet_time < info->daytime_start ||
> +		    packet_time > info->daytime_stop)
> +			return false;
> +	} else {
> +		if (packet_time < info->daytime_start &&
> +		    packet_time > info->daytime_stop)
> +			return false;
> +	}
> +
> +	localtime_2(&current_time, stamp);
> +
> +	if (!(info->weekdays_match & (1 << current_time.weekday)))
> +		return false;
> +
> +	localtime_3(&current_time, stamp);
> +
> +	if (!(info->monthdays_match & (1 << current_time.monthday)))
> +		return false;
>   

I'd add a flag or check whether weekdays_match/monthdays_match
equals ~0 before doing the localtime calculations.

Besides that, looks good to me, thanks for doing this work.
