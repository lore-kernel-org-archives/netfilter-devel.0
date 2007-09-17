From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_time 20070915
Date: Mon, 17 Sep 2007 17:01:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709171616070.4516@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709151806080.24423@fbirervta.pbzchgretzou.qr>
	<46EE86FA.10604@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46EE86FA.10604@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 17 2007 15:54, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> ipt_time from POM-ng augmented by:
>> 
>>  * xtables
>>  * ipv6 support
>
>I bet this was tricky :)

Yes, indeed. It's too easy to forget .family in the iptables part...

>> +++ linux-2.6.23/include/linux/netfilter/xt_time.h
>> @@ -0,0 +1,13 @@
>> +#ifndef _XT_TIME_H
>> +#define _XT_TIME_H 1
>> +
>> +struct xt_time_info {
>> +	time_t date_start;
>> +	time_t date_stop;
>
>This is an arch-dependant type and must not be used within the
>iptables ABI.

So what would you suggest? time_t will only work for 30 more years,
then we'll have to change it. So what is your pick for ABI-complete
time_t, uint64 or uint32?

>> +	u_int32_t monthdays_match;
>> +	u_int16_t time_start;
>> +	u_int16_t time_stop;
>> +	u_int8_t weekdays_match;
>
>No inversion?

Inversion is a funny thing with xt_time because (almost) all possible
times are _finite_.

Consider xt_connlimit and --connlimit x. The set of possible values
for x is infinite (assuming we were not limited by 32/64-bit CPUs).

Along comes xt_time. The set of possible values for --weekdays
is finite, there are exactly seven days for any given week. Since
this is the case, the negation of any set/bitmap of weekdays can
again be represented as a bitmap. So the inversion is done in
libxt_time.c (iptables).  !(Fri..Sun) == (Mon..Thu)

The same applies to time_start. Got a noon match that matches
from 10:00 to 15:00? Its inversion is (simply put) 15:00 to
10:00.

>> +#include "xt_time.h"
>
>This should be <include/netfilter/xt_time.h> I suppose?

Indeed.

>> +static void localtime(struct xtm *r, time_t time)
>> +{
>> +	unsigned int year, i, w;
>> +
>> +	time -= 60 * sys_tz.tz_minuteswest;
>> +
>> +	/* 1d=86400s. Daytime. */
>> +	w  = time % 86400;
>> +	w /= 60;
>> +	r->minute = w % 60;
>> +	r->hour   = w / 60;
>> +
>> +	/* Days since 1970-01-01 */
>> +	w = time / 86400;
>> +	r->weekday = (4 + w) % 7;
>> +
>> +	/*
>> +	 * Consider x=21551. Loop will abort on dse[i] <= x, which is with
>> +	 * dse[i] = 21550 (=> 2029-01-02).
>> +	 */
>> +	for (i = 0, year = DSE_FIRST; days_since_epoch[i] > w;
>> +	    ++i, --year)
>> +		/* just loop */;
>> +
>> +	w -= days_since_epoch[i];
>> +	/* r->yearday = w; */
>> +
>> +	if (is_leap(year)) {
>> +		for (i = ARRAY_SIZE(days_since_leapyear) - 1;
>> +		    i > 0 && days_since_year[i] > w; --i)
>> +			/* just loop */;
>> +	} else {
>> +		for (i = ARRAY_SIZE(days_since_year) - 1;
>> +		    i > 0 && days_since_year[i] > w; --i)
>> +			/* just loop */;
>> +	}
>> +
>> +	r->month    = i + 1;
>> +	r->monthday = w - days_since_year[i] + 1;
>> +	printk(KERN_ERR "m=%u md=%u\n", r->month, r->monthday);
>> +	return;
>> +}
>
>Some explanation what the above is doing would be appreciated.

/*
 * Each network packet has a (nano)seconds-since-the-epoch (SSTE) timestamp.
 * Since we match against days and daytime, the SSTE value needs to be
 * computed back into human-readable dates.
 */
static void localtime(struct xtm *r, time_t time)
{
	unsigned int year, i, w;

	time -= 60 * sys_tz.tz_minuteswest;

	/* Each day has 86400s, so finding the hour/minute is actually easy. */
	w  = time % 86400;
	w /= 60;
	r->minute = w % 60;
	r->hour   = w / 60;

	/*
	 * Here comes the rest (weekday, monthday). First, divide the SSTE
	 * by seconds-per-day to get the number of _days_ since the epoch.
	 */
	w = time / 86400;

	/* 1970-01-01 (w=0) was a Thursday (4). */
	r->weekday = (4 + w) % 7;

	/*
	 * In each year, a certain number of days-since-the-epoch have passed.
	 * Find the year that is closest to said days.
	 *
	 * Consider, for example, w=21612 (2029-03-04). Loop will abort on
	 * dse[i] <= w, which happens when dse[i] == 21550. This implies
	 * year == 2009. w will then be 62.
	 */
	for (i = 0, year = DSE_FIRST; days_since_epoch[i] > w;
	    ++i, --year)
		/* just loop */;

	w -= days_since_epoch[i];

	/*
	 * By now we have the current year, and the day of the year.
	 * r->yearday = w;
	 *
	 * On to finding the month (like above). In each month, a certain
	 * number of days-since-New Year have passed, and find the closest
	 * one.
	 *
	 * Consider w=62 (in a non-leap year). Loop will abort on
	 * dsy[i] < w, which happens when dsy[i] == 31+28 (i == 2).
	 * Concludes i == 2, i.e. 3rd month => March.
	 *
	 * (A different approach to use would be to subtract a monthlength
	 * from w repeatedly while counting.)
	 */
	if (is_leap(year)) {
		for (i = ARRAY_SIZE(days_since_leapyear) - 1;
		    i > 0 && days_since_year[i] > w; --i)
			/* just loop */;
	} else {
		for (i = ARRAY_SIZE(days_since_year) - 1;
		    i > 0 && days_since_year[i] > w; --i)
			/* just loop */;
	}

	r->month    = i + 1;
	r->monthday = w - days_since_year[i] + 1;
	return;
}

>> +	s64 stamp;
>> +
>> +	if (skb->tstamp.tv64 == 0)
>> +		__net_timestamp((struct sk_buff *)skb);
>> +
>> +	stamp = skb->tstamp.tv64;
>> +	do_div(stamp, NSEC_PER_SEC);
>
>Would get_seconds() work?

One might think so, but there is a race involved, for example:

[16:59:59.100000 || 1190041199.100000]

	network code stamps the packet, with 1190040556 (we will
	ignore the subsecond part since xt_time does not deal with
	it.)

[16:59:59.200000 || 1190041199.200000]

	It may happen that the network code, or some iptables code,
	or whatever other code takes time. Assume the user added an
	xt_complex_match.ko which takes _at least_ that many jiffies
	until the next second.

[17:00:00.000000 || 1190041200.000000]

	Now it's 17:00. But the packet stamp still is 16:59:59.
	Consider the user had a

	-m time --timestart 15:00 --timestop 17:00

Now what? Further consider the following hypothetical case where we
inflate the times to show the problem -- since xt_time has only
minute resolution:

The user has a multi-core (#Cores >= 2) machine, and xt_complex_match
takes "a lot of time", say, 3 minutes per packet. It may sound
unrealistic, but shows the point. Then xt_time entrance would be at
17:03, __way__ after the packet actually arrived at the box, and way
after the 17:00 time boundary that was set.

Conclusion: It is not really a race, it just depends on what you
measure time relative against, i.e. whether xt_time is relative to
the packet timestamp or the actual processing {point in time}.

>> +static bool xt_time_check(const char *tablename, const void *ip,
>> +                          const struct xt_match *match, void *matchinfo,
>> +                          unsigned int hook_mask)
>> +{
>> +	struct xt_time_info *info = matchinfo;
>> +
>> +	/* xt_time's granularity is a minute, hence 24*60 = 1day */
>> +	if (info->time_start > 24 * 60 || info->time_stop >= 24 * 60) {
>> +		printk(KERN_WARNING "ipt_time: invalid argument - start or stop time greater than 23:59h\n");
>> +		return false;
>> +	}
>
>Is there a reason for minute granularity? The data types look large
>enough for at least second granularity (more is probably useless).

Yeah I can do that. Not that I see a real benefit for the user ;^) to
match on sub-minute times. ("Help me, my internet only works for 30
seconds for each minute!") The more I think about it, it might be a
really evil way to shape traffic (ha!)

for $h (0..23) {
for $m (1..60) {
-m time --timestart $h:$m:00 --timestop $h:$m:30 -j MARK --set-mark 1
-m time --timestart $h:$m:00 --timestop $h:$m:30 -j MARK --set-mark 2
}
}
