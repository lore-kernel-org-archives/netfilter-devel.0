From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_time 2007-09-22
Date: Sun, 23 Sep 2007 17:32:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709231729310.15712@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr>
 <46F53283.90204@trash.net> <Pine.LNX.4.64.0709221734080.15712@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709221757300.15712@fbirervta.pbzchgretzou.qr>
 <46F680B7.4000907@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55543 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbXIWPcP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Sep 2007 11:32:15 -0400
In-Reply-To: <46F680B7.4000907@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 23 2007 17:05, Patrick McHardy wrote:
>
>Unfortunately gcc-4.2 seems to ignore casts from const -> non-const,
>so the __net_timestamp call causes this warning:
>
>net/netfilter/xt_time.c: In function 'xt_time_match':
>net/netfilter/xt_time.c:170: warning: passing argument 1 of
>'__net_timestamp' discards qualifiers from pointer target type
>
>Not sure how we could shut this up, I definitely don't want to make
>all match functions take non-const skb args. ip_queue has the same
>warning.

Introduce some const_cast<> from C++ in C?
Blame some GCC guys? :-)

>> +	localtime_2(&current_time, stamp);
>> +
>> +	if (!(info->weekdays_match & (1 << current_time.weekday)))
>> +		return false;
>
>Shouldn't this do the same optimization as below?

No, it's not worth it. localtime_3 requires that localtime_2 be run
before, so it would look like:

if (info->weekdays_match != XT_TIME_ALL_WEEKDAYS &&
    info->monthdays_match != XT_TIME_ALL_MONTHDAYS) {
	localtime_2(&current_time, stamp);
	if (!(info->weekdays_match & (1 << current_time.weekday)))
		return false;
	if (info->monthdays_match != XT_TIME_ALL_MONTHDAYS) {
		localtime_3(&current_time, stamp);
		if (!(info->monthdays_match & (1 << current_time.monthday)))
			return false;
	}
}

Since localtime_2() is miniscule, all this if'ing does not improve
things at all.
