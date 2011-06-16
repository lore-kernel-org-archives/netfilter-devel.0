From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] netfilter: xtables: move ipt_ecn to xt_ecn
Date: Thu, 16 Jun 2011 17:34:14 +0200
Message-ID: <4DFA2276.8070305@trash.net>
References: <1307651037-20520-1-git-send-email-jengelh@medozas.de> <1307651037-20520-2-git-send-email-jengelh@medozas.de> <4DFA1F60.7080704@trash.net> <alpine.LNX.2.01.1106161730540.10380@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60154 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab1FPPeR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:34:17 -0400
In-Reply-To: <alpine.LNX.2.01.1106161730540.10380@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.06.2011 17:31, Jan Engelhardt wrote:
> 
> On Thursday 2011-06-16 17:21, Patrick McHardy wrote:
>> On 09.06.2011 22:23, Jan Engelhardt wrote:
>>> --- a/net/ipv4/netfilter/Kconfig
>>> +++ b/net/ipv4/netfilter/Kconfig
>>> @@ -76,11 +76,11 @@ config IP_NF_MATCH_AH
>>>  config IP_NF_MATCH_ECN
>>>  	tristate '"ecn" match support'
>>>  	depends on NETFILTER_ADVANCED
>>> -	help
>>> -	  This option adds a `ECN' match, which allows you to match against
>>> -	  the IPv4 and TCP header ECN fields.
>>> -
>>> -	  To compile it as a module, choose M here.  If unsure, say N.
>>> +	select NETFILTER_XT_MATCH_ECN
>>> +	---help---
>>> +	This is a backwards-compat option for the user's convenience
>>> +	(e.g. when running oldconfig). It selects
>>> +	CONFIG_NETFILTER_XT_MATCH_ECN.
>>>  
>>
>> Did this work? I've tried myself, but it would still show the new
>> option.
> 
> What do you mean? Of course it is supposed to show NETFILTER_XT_MATCH_ECN.

Well, ideally not, but fine as long as its still automatically
selected.

I'll pull your patches once the first two fixes are upstream.

