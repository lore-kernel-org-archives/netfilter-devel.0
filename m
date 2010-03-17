From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/9] netfilter: xtables: slightly more detailed checkentry
 return values
Date: Wed, 17 Mar 2010 15:16:48 +0100
Message-ID: <4BA0E450.3010902@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-3-git-send-email-jengelh@medozas.de> <4BA0DB87.9040709@trash.net> <alpine.LSU.2.01.1003171443330.6297@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58595 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0CQOQv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:16:51 -0400
In-Reply-To: <alpine.LSU.2.01.1003171443330.6297@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-03-17 14:39, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> When extended status codes are available, such as ENOMEM on failed
>>> allocations, or subsequent functions (e.g. nf_ct_get_l3proto), passing
>>> them up to userspace seems like a good idea compared to just always
>>> EINVAL.
>>> diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
>>> index 5d11767..7b6f4c4 100644
>>> --- a/net/bridge/netfilter/ebt_802_3.c
>>> +++ b/net/bridge/netfilter/ebt_802_3.c
>>> @@ -36,7 +36,7 @@ ebt_802_3_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>>>  	return true;
>>>  }
>>>  
>>> -static bool ebt_802_3_mt_check(const struct xt_mtchk_param *par)
>>> +static int ebt_802_3_mt_check(const struct xt_mtchk_param *par)
>>>  {
>>>  	const struct ebt_802_3_info *info = par->matchinfo;
>> Sigh, so we're basically going back to the old signatures.
> 
> To err is human :-)
> 
>> I guess this makes sense, however iptables has special interpretations
>> of errno values. How will this interact?
> 
> Since we are "just going back", the effect should be none - dig out
> an old iptables and kernel and you get the same environment.

No, we're now returning additional errno values from modules.

> Well, libiptc prints a few specialized error messages for certain
> codes (cf libiptc.c, TC_STRERROR), else uses plain libc strerror.

That's what I was talking about. Unfortunately quite a few
of the reasonable combinations have special meaning, f.i.
TC_INIT/ENOENT, TC_INIT/EINVAL, ...
