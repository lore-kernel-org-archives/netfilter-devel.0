From: Tim Gardner <timg@tpi.com>
Subject: Re: iptables pull request, add XT_RECENT_REAP support
Date: Wed, 17 Mar 2010 14:26:52 -0600
Message-ID: <4BA13B0C.2030301@tpi.com>
References: <20100317184852.89F0DF89BB@sepang.rtg.net> <alpine.LSU.2.01.1003172021450.16169@obet.zrqbmnf.qr>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4368 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0CQU1H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:27:07 -0400
In-Reply-To: <alpine.LSU.2.01.1003172021450.16169@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/17/2010 02:13 PM, Jan Engelhardt wrote:
>
> On Wednesday 2010-03-17 19:48, Tim Gardner wrote:
>>
>> @@ -36,6 +37,7 @@ static void recent_help(void)
>> "    --hitcount hits             For check and update commands above.\n"
>> "                                Specifies that the match will only occur if source address seen hits times.\n"
>> "                                May be used in conjunction with the seconds option.\n"
>> +"    --reap                      Remove entries that have expired. Can only be used with --seconds\n"
>
> What's going to happen if you mix a "--reap --seconds 60" rule with
> "--reap --seconds 3600" rule?
>

If both rules are operating on the same '--name', then I would expect 
the rule that is invoked to reap according to the '--seconds' specified 
in that rule.

Mixing rules like this on the same table doesn't seem like a likely 
scenario to me.

>> +/* Only allowed with --rcheck and --update */
>> +#define XT_RECENT_MODIFIERS (XT_RECENT_TTL|XT_RECENT_REAP)
>> +
>> +#define XT_RECENT_VALID_FLAGS (XT_RECENT_CHECK|XT_RECENT_SET|XT_RECENT_UPDATE|\
>> +	XT_RECENT_REMOVE|XT_RECENT_TTL|XT_RECENT_REAP)
>> +
>
> Since these two are only used on the kernel side, it would have made
> sense to put them into xt_recent.c only.
>

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
