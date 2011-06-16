From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/4] netfilter: xtables: move ipt_ecn to xt_ecn
Date: Thu, 16 Jun 2011 17:43:28 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106161743000.10544@frira.zrqbmnf.qr>
References: <1307651037-20520-1-git-send-email-jengelh@medozas.de> <1307651037-20520-2-git-send-email-jengelh@medozas.de> <4DFA1F60.7080704@trash.net> <alpine.LNX.2.01.1106161730540.10380@frira.zrqbmnf.qr> <4DFA2276.8070305@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:32835 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab1FPPna (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:43:30 -0400
In-Reply-To: <4DFA2276.8070305@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-06-16 17:34, Patrick McHardy wrote:

>On 16.06.2011 17:31, Jan Engelhardt wrote:
>> 
>> On Thursday 2011-06-16 17:21, Patrick McHardy wrote:
>>> On 09.06.2011 22:23, Jan Engelhardt wrote:
>>>> --- a/net/ipv4/netfilter/Kconfig
>>>> +++ b/net/ipv4/netfilter/Kconfig
>>>> @@ -76,11 +76,11 @@ config IP_NF_MATCH_AH
>>>>  config IP_NF_MATCH_ECN
>>>>  	tristate '"ecn" match support'
>>>>  	depends on NETFILTER_ADVANCED
>>>> -	help
>>>> -	  This option adds a `ECN' match, which allows you to match against
>>>> -	  the IPv4 and TCP header ECN fields.
>>>> -
>>>> -	  To compile it as a module, choose M here.  If unsure, say N.
>>>> +	select NETFILTER_XT_MATCH_ECN
>>>> +	---help---
>>>> +	This is a backwards-compat option for the user's convenience
>>>> +	(e.g. when running oldconfig). It selects
>>>> +	CONFIG_NETFILTER_XT_MATCH_ECN.
>>>>  
>>>
>>> Did this work? I've tried myself, but it would still show the new
>>> option.
>> 
>> What do you mean? Of course it is supposed to show NETFILTER_XT_MATCH_ECN.
>
>Well, ideally not, but fine as long as its still automatically
>selected.
>
>I'll pull your patches once the first two fixes are upstream.

We are doing the same thing with the old options for nfmark/ctmark
(cf. Documentation/feature-removal-schedule.txt) so I guess that was ok.
The old options are supposed to be gone in a few releases anyway.
