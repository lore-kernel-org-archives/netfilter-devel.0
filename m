From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_time 20070915
Date: Mon, 17 Sep 2007 15:54:02 +0200
Message-ID: <46EE86FA.10604@trash.net>
References: <Pine.LNX.4.64.0709151806080.24423@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0709151806080.24423@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> ipt_time from POM-ng augmented by:
>=20
>  * xtables
>  * ipv6 support


I bet this was tricky :)

>  * day-of-month support (for example "match on the 15th of each month")
>  * timezone (it was there before though) -
>    it does *what the user expects* (which is good).


Indeed. We decided to merge it despite the so-far existing timezone
limitation, but this is even better.

>=20
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>=20
> ---
> +++ linux-2.6.23/include/linux/netfilter/xt_time.h
> @@ -0,0 +1,13 @@
> +#ifndef _XT_TIME_H
> +#define _XT_TIME_H 1
> +
> +struct xt_time_info {
> +	time_t date_start;
> +	time_t date_stop;


This is an arch-dependant type and must not be used within the
iptables ABI.

> +	u_int32_t monthdays_match;
> +	u_int16_t time_start;
> +	u_int16_t time_stop;
> +	u_int8_t weekdays_match;


No inversion?

> +++ linux-2.6.23/net/netfilter/xt_time.c
> @@ -0,0 +1,208 @@
> +/*
> + *	xt_time
> + *	Copyright =A9 Jan Engelhardt <jengelh@computergmbh.de>, 2007
> + *
> + *	based on ipt_time by Fabrice MARIE <fabrice@netfilter.org>
> + *	This is a module which is used for time matching
> + *	It is using some modified code from dietlibc (localtime() function)
> + *	that you can find at http://www.fefe.de/dietlibc/
> + *	This file is distributed under the terms of the GNU General Public
> + *	License (GPL). Copies of the GPL can be obtained from gnu.org/gpl.
> + */
> +#include <linux/ktime.h>
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/netfilter/x_tables.h>
> +#include "xt_time.h"


This should be <include/netfilter/xt_time.h> I suppose?

> +
> +struct xtm {
> +	unsigned int month;    /* (1-12) */
> +	unsigned int monthday; /* (1-31) */
> +	unsigned int weekday;  /* (1-7) */
> +	unsigned int hour;     /* (0-23) */
> +	unsigned int minute;   /* (0-59) */
> +};
> +
> +extern struct timezone sys_tz; /* ouch */
> +
> +static const u_int16_t days_since_year[] =3D {
> +	0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334,
> +};
> +
> +static const u_int16_t days_since_leapyear[] =3D {
> +	0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335,
> +};
> +
> +/*
> + * Since time progresses forward, it is best to organize this array in=
 reverse,
> + * to minimize lookup time.
> + */
> +enum {
> +	DSE_FIRST =3D 2039,
> +};
> +static const u_int16_t days_since_epoch[] =3D {
> +	/* 2039 - 2030 */
> +	25202, 24837, 24472, 24106, 23741, 23376, 23011, 22645, 22280, 21915,
> +	/* 2029 - 2020 */
> +	21550, 21184, 20819, 20454, 20089, 19723, 19358, 18993, 18628, 18262,
> +	/* 2019 - 2010 */
> +	17897, 17532, 17167, 16801, 16436, 16071, 15706, 15340, 14975, 14610,
> +	/* 2009 - 2000 */
> +	14245, 13879, 13514, 13149, 12784, 12418, 12053, 11688, 11323, 10957,
> +	/* 1999 - 1990 */
> +	10592, 10227, 9862, 9496, 9131, 8766, 8401, 8035, 7670, 7305,
> +	/* 1989 - 1980 */
> +	6940, 6574, 6209, 5844, 5479, 5113, 4748, 4383, 4018, 3652,
> +	/* 1979 - 1970 */
> +	3287, 2922, 2557, 2191, 1826, 1461, 1096, 730, 365, 0,
> +};
> +
> +static inline bool is_leap(unsigned int y)
> +{
> +	return y % 4 =3D=3D 0 && (y % 100 !=3D 0 || y % 400 =3D=3D 0);
> +}
> +
> +static void localtime(struct xtm *r, time_t time)
> +{
> +	unsigned int year, i, w;
> +
> +	time -=3D 60 * sys_tz.tz_minuteswest;
> +
> +	/* 1d=3D86400s. Daytime. */
> +	w  =3D time % 86400;
> +	w /=3D 60;
> +	r->minute =3D w % 60;
> +	r->hour   =3D w / 60;
> +
> +	/* Days since 1970-01-01 */
> +	w =3D time / 86400;
> +	r->weekday =3D (4 + w) % 7;
> +
> +	/*
> +	 * Consider x=3D21551. Loop will abort on dse[i] <=3D x, which is wit=
h
> +	 * dse[i] =3D 21550 (=3D> 2029-01-02).
> +	 */
> +	for (i =3D 0, year =3D DSE_FIRST; days_since_epoch[i] > w;
> +	    ++i, --year)
> +		/* just loop */;
> +
> +	w -=3D days_since_epoch[i];
> +	/* r->yearday =3D w; */
> +
> +	if (is_leap(year)) {
> +		for (i =3D ARRAY_SIZE(days_since_leapyear) - 1;
> +		    i > 0 && days_since_year[i] > w; --i)
> +			/* just loop */;
> +	} else {
> +		for (i =3D ARRAY_SIZE(days_since_year) - 1;
> +		    i > 0 && days_since_year[i] > w; --i)
> +			/* just loop */;
> +	}
> +
> +	r->month    =3D i + 1;
> +	r->monthday =3D w - days_since_year[i] + 1;
> +	printk(KERN_ERR "m=3D%u md=3D%u\n", r->month, r->monthday);
> +	return;
> +}


Some explanation what the above is doing would be appreciated.

> +static bool xt_time_match(const struct sk_buff *skb,
> +                          const struct net_device *in,
> +                          const struct net_device *out,
> +                          const struct xt_match *match, const void *ma=
tchinfo,
> +                          int offset, unsigned int protoff, bool *hotd=
rop)
> +{
> +	const struct xt_time_info *info =3D matchinfo;
> +	unsigned int packet_time;
> +	struct xtm current_time;
> +	s64 stamp;
> +
> +	if (skb->tstamp.tv64 =3D=3D 0)
> +		__net_timestamp((struct sk_buff *)skb);
> +
> +	stamp =3D skb->tstamp.tv64;
> +	do_div(stamp, NSEC_PER_SEC);


Would get_seconds() work?

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
> +	localtime(&current_time, stamp);
> +
> +	if (!(info->monthdays_match & (1 << current_time.monthday)))
> +		return false;
> +	if (!(info->weekdays_match & (1 << current_time.weekday)))
> +		return false;
> +
> +	packet_time =3D current_time.hour * 60 + current_time.minute;
> +	if (info->time_start < info->time_stop) {
> +		if (packet_time < info->time_start ||
> +		    packet_time > info->time_stop)
> +			return false;
> +	} else {
> +		if (packet_time < info->time_start &&
> +		    packet_time > info->time_stop)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool xt_time_check(const char *tablename, const void *ip,
> +                          const struct xt_match *match, void *matchinf=
o,
> +                          unsigned int hook_mask)
> +{
> +	struct xt_time_info *info =3D matchinfo;
> +
> +	/* xt_time's granularity is a minute, hence 24*60 =3D 1day */
> +	if (info->time_start > 24 * 60 || info->time_stop >=3D 24 * 60) {
> +		printk(KERN_WARNING "ipt_time: invalid argument - start or stop time=
 greater than 23:59h\n");
> +		return false;
> +	}


Is there a reason for minute granularity? The data types look large
enough for at least second granularity (more is probably useless).
