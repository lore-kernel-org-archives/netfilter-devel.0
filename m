From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_time 2007-09-22
Date: Sun, 23 Sep 2007 18:20:44 +0200
Message-ID: <46F6925C.3000909@trash.net>
References: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr> <46F53283.90204@trash.net> <Pine.LNX.4.64.0709221734080.15712@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709221757300.15712@fbirervta.pbzchgretzou.qr> <46F680B7.4000907@trash.net> <Pine.LNX.4.64.0709231729310.15712@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49677 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbXIWQ30 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Sep 2007 12:29:26 -0400
In-Reply-To: <Pine.LNX.4.64.0709231729310.15712@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Sep 23 2007 17:05, Patrick McHardy wrote:
> 
>>>+	localtime_2(&current_time, stamp);
>>>+
>>>+	if (!(info->weekdays_match & (1 << current_time.weekday)))
>>>+		return false;
>>
>>Shouldn't this do the same optimization as below?
> 
> 
> No, it's not worth it. localtime_3 requires that localtime_2 be run
> before, so it would look like:
> 
> if (info->weekdays_match != XT_TIME_ALL_WEEKDAYS &&
>     info->monthdays_match != XT_TIME_ALL_MONTHDAYS) {
> 	localtime_2(&current_time, stamp);
> 	if (!(info->weekdays_match & (1 << current_time.weekday)))
> 		return false;
> 	if (info->monthdays_match != XT_TIME_ALL_MONTHDAYS) {
> 		localtime_3(&current_time, stamp);
> 		if (!(info->monthdays_match & (1 << current_time.monthday)))
> 			return false;
> 	}
> }
> 
> Since localtime_2() is miniscule, all this if'ing does not improve
> things at all.


OK, thanks for the explanation.
