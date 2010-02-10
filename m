From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/4] netfilter: xtables: compact table hook functions
 (1/2)
Date: Wed, 10 Feb 2010 16:32:12 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002101631500.15347@obet.zrqbmnf.qr>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-2-git-send-email-jengelh@medozas.de> <4B72CF34.6000701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43403 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0BJPcN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:32:13 -0500
In-Reply-To: <4B72CF34.6000701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-02-10 16:22, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
>> index 9733760..78bb72e 100644
>> --- a/net/ipv4/netfilter/arptable_filter.c
>> +++ b/net/ipv4/netfilter/arptable_filter.c
>> @@ -53,43 +53,38 @@ static const struct xt_table packet_filter = {
>>  };
>>  
>>  /* The work comes in here from netfilter.c */
>> -static unsigned int arpt_in_hook(unsigned int hook,
>> +static unsigned int arptable_filter_hook(unsigned int hook,
>>  				 struct sk_buff *skb,
>>  				 const struct net_device *in,
>>  				 const struct net_device *out,
>>  				 int (*okfn)(struct sk_buff *))
>
>I'm fine with this patch, but can we please keep the arguments aligned
>neatly? As I said previously, I've let this slip too often, but intend
>not to in the future.

Was not sure whether that would only apply to lines modified.
