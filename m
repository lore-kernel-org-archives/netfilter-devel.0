From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: xtables: merge registration structure
 to NFPROTO_UNSPEC
Date: Wed, 31 Mar 2010 11:01:23 +0200
Message-ID: <4BB30F63.2030509@trash.net>
References: <1270022629-2494-1-git-send-email-jengelh@medozas.de> <1270022629-2494-5-git-send-email-jengelh@medozas.de> <4BB30861.3060101@trash.net> <alpine.LSU.2.01.1003311036110.4527@obet.zrqbmnf.qr> <4BB30AA0.9000904@trash.net> <alpine.LSU.2.01.1003311052490.6475@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57615 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976Ab0CaJBY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:01:24 -0400
In-Reply-To: <alpine.LSU.2.01.1003311052490.6475@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-03-31 10:41, Patrick McHardy wrote:
>>>>> +static struct xt_match state_mt_reg __read_mostly = {
>>>>> +	.name       = "state",
>>>>> +	.family     = NFPROTO_UNSPEC,
>>>>> +	.checkentry = state_mt_check,
>>>>> +	.match      = state_mt,
>>>>> +	.destroy    = state_mt_destroy,
>>>>> +	.matchsize  = sizeof(struct xt_state_info),
>>>>> +	.me         = THIS_MODULE,
>>>>>  };
>>>> The patch looks fine, however I'd prefer if in the future you'd add
>>>> a changelog entry for these conversions stating why this will work
>>>> properly in all cases even with arptables and ebtables using the
>>>> xtables infrastructure.
>>> This will work because x_tables scans for NFPROTO_UNSPEC,
>>> and arp/ebtables just using x_tables :-)
>> I'm not sure I'm parsing this correctly. Both will find the match,
>> however the nf_ct_l3proto_try_module_get() call will fail
> 
> It won't fail - it is using par->family, not par->match->family.

That's broken then.
