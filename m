From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_time 2007-09-22
Date: Sat, 22 Sep 2007 17:38:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709221734080.15712@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr>
 <46F53283.90204@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49022 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXIVPiQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2007 11:38:16 -0400
In-Reply-To: <46F53283.90204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 22 2007 17:19, Patrick McHardy wrote:
>
> A thought just occured to me (a bit late, but better than never :) ..
>
> Can't we just convert the user-specified times/dates to unix time
> and match on that without all these expensive calculations? At least
> for pure time matching without days this should work fine ..

Pure time matching (--datestart, --datestop) already use unix timing.

Daytime (--timestart) ... I wonder how you'd model
"from 12:00 to 13:00, each day" other than it is done now.
Same for weekday.

Leaves monthday matching, which could probably be done with some more
static tables, but I'd have to dig up some old encyclopedia from 1972
and see how they did it.

>> +	localtime_3(&current_time, stamp);
>> +
>> +	if (!(info->monthdays_match & (1 << current_time.monthday)))
>> +		return false;
>>   
>
> I'd add a flag or check whether weekdays_match/monthdays_match
> equals ~0 before doing the localtime calculations.

Certainly.
