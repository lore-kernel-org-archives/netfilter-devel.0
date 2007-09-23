From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_time 2007-09-22
Date: Sun, 23 Sep 2007 17:05:27 +0200
Message-ID: <46F680B7.4000907@trash.net>
References: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr> <46F53283.90204@trash.net> <Pine.LNX.4.64.0709221734080.15712@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709221757300.15712@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48269 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbXIWPOI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Sep 2007 11:14:08 -0400
In-Reply-To: <Pine.LNX.4.64.0709221757300.15712@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Add the xt_time netfilter match
> 
> This is ipt_time from POM-ng enhanced by the following:
> 
>  * xtables/ipv6 support
>  * second granularity for daytime
>  * day-of-month support (for example "match on the 15th of each month")
>  * match against UTC or local timezone
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Applied, thanks Jan.

Unfortunately gcc-4.2 seems to ignore casts from const -> non-const,
so the __net_timestamp call causes this warning:

net/netfilter/xt_time.c: In function 'xt_time_match':
net/netfilter/xt_time.c:170: warning: passing argument 1 of
'__net_timestamp' discards qualifiers from pointer target type

Not sure how we could shut this up, I definitely don't want to make
all match functions take non-const skb args. ip_queue has the same
warning.

> +	localtime_2(&current_time, stamp);
> +
> +	if (!(info->weekdays_match & (1 << current_time.weekday)))
> +		return false;

Shouldn't this do the same optimization as below?

> +
> +	/* Do not spend time computing monthday if all days match anyway */
> +	if (info->monthdays_match != XT_TIME_ALL_MONTHDAYS) {
> +		localtime_3(&current_time, stamp);
> +		if (!(info->monthdays_match & (1 << current_time.monthday)))
> +			return false;
> +	}
> +
> +	return true;
> +}
