From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next] netfilter: meta: add PRANDOM support
Date: Tue, 16 Feb 2016 14:56:23 +0100
Message-ID: <56C32A87.2000104@iogearbox.net>
References: <1455624554-16005-1-git-send-email-fw@strlen.de> <56C31ABA.1050801@iogearbox.net> <20160216131910.GC13417@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:45631 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbcBPN4Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 08:56:25 -0500
In-Reply-To: <20160216131910.GC13417@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/16/2016 02:19 PM, Florian Westphal wrote:
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>>> +	case NFT_META_PRANDOM:
>>> +		if (!prand_inited) {
>>> +			prandom_seed_full_state(&nft_prandom_state);
>>> +			prand_inited = true;
>>> +		}
>>
>> Should this be: prandom_init_once() ?
>
> Thought about that but this is slowpath so I considered
> the use of static key magic a bit overkill....
>
> I don't mind, if you think prandom_init_once is prefereable I'll respin.

You'd have the benefit that the prng init would be race free. nft_meta_get_init()
could be called in parallel from multiple CPUs, right?

> Let me know, thanks!
