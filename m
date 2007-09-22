From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_time 2007-09-22
Date: Sat, 22 Sep 2007 17:39:53 +0200
Message-ID: <46F53749.5070303@trash.net>
References: <Pine.LNX.4.64.0709221315590.15712@fbirervta.pbzchgretzou.qr> <46F53283.90204@trash.net> <Pine.LNX.4.64.0709221734080.15712@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58122 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbXIVPlm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2007 11:41:42 -0400
In-Reply-To: <Pine.LNX.4.64.0709221734080.15712@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Sep 22 2007 17:19, Patrick McHardy wrote:
>   
>> A thought just occured to me (a bit late, but better than never :) ..
>>
>> Can't we just convert the user-specified times/dates to unix time
>> and match on that without all these expensive calculations? At least
>> for pure time matching without days this should work fine ..
>>     
>
> Pure time matching (--datestart, --datestop) already use unix timing.
>   
Right, I missed that.

> Daytime (--timestart) ... I wonder how you'd model
> "from 12:00 to 13:00, each day" other than it is done now.
> Same for weekday.
>   

You're right again, that doesn't seem to be possible.

> Leaves monthday matching, which could probably be done with some more
> static tables, but I'd have to dig up some old encyclopedia from 1972
> and see how they did it.
>   

I guess that will be a very rarely used feature anyway, don't
bother.

>   
>>> +	localtime_3(&current_time, stamp);
>>> +
>>> +	if (!(info->monthdays_match & (1 << current_time.monthday)))
>>> +		return false;
>>>   
>>>       
>> I'd add a flag or check whether weekdays_match/monthdays_match
>> equals ~0 before doing the localtime calculations.
>>     
>
> Certainly.
>
>   

Thanks.
