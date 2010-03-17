From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/9] netfilter: xtables: slightly more detailed checkentry
 return values
Date: Wed, 17 Mar 2010 15:05:51 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003171443330.6297@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-3-git-send-email-jengelh@medozas.de> <4BA0DB87.9040709@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56840 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab0CQOFx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:05:53 -0400
In-Reply-To: <4BA0DB87.9040709@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-17 14:39, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> When extended status codes are available, such as ENOMEM on failed
>> allocations, or subsequent functions (e.g. nf_ct_get_l3proto), passing
>> them up to userspace seems like a good idea compared to just always
>> EINVAL.
>
>> diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
>> index 5d11767..7b6f4c4 100644
>> --- a/net/bridge/netfilter/ebt_802_3.c
>> +++ b/net/bridge/netfilter/ebt_802_3.c
>> @@ -36,7 +36,7 @@ ebt_802_3_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>>  	return true;
>>  }
>>  
>> -static bool ebt_802_3_mt_check(const struct xt_mtchk_param *par)
>> +static int ebt_802_3_mt_check(const struct xt_mtchk_param *par)
>>  {
>>  	const struct ebt_802_3_info *info = par->matchinfo;
>
>Sigh, so we're basically going back to the old signatures.

To err is human :-)

>I guess this makes sense, however iptables has special interpretations
>of errno values. How will this interact?

Since we are "just going back", the effect should be none - dig out
an old iptables and kernel and you get the same environment.

Well, libiptc prints a few specialized error messages for certain
codes (cf libiptc.c, TC_STRERROR), else uses plain libc strerror.

Besides handling EAGAIN, there seems to be no special errno handling.
