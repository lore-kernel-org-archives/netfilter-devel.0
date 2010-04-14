From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/4] netfilter: xtables: inclusion of xt_TEE
Date: Wed, 14 Apr 2010 12:00:00 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004141159390.9499@obet.zrqbmnf.qr>
References: <1271200907-5262-1-git-send-email-jengelh@medozas.de>  <1271200907-5262-2-git-send-email-jengelh@medozas.de> <1271224379.16881.610.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54304 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab0DNKAB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:00:01 -0400
In-Reply-To: <1271224379.16881.610.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-04-14 07:52, Eric Dumazet wrote:
>> +#ifdef WITH_CONNTRACK
>> +	/* Avoid counting cloned packets towards the original connection. */
>> +	nf_conntrack_put(skb->nfct);
>> +	skb->nfct     = &nf_conntrack_untracked.ct_general;
>> +	skb->nfctinfo = IP_CT_NEW;
>> +	nf_conntrack_get(skb->nfct);
>
>This atomic increment on a global variable worries me... Would it be
>possible to avoid it (and the associated decrement and test if null)
>
>I would like to use this TEE facility but with xxx kpps for instance ;)

Correctness before speed. You're free to send patches on top.
