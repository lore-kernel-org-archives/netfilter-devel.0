From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] netfilter: xtables: inclusion of xt_TEE
Date: Wed, 14 Apr 2010 12:56:35 +0200
Message-ID: <4BC59F63.2060803@trash.net>
References: <1271200907-5262-1-git-send-email-jengelh@medozas.de>  <1271200907-5262-2-git-send-email-jengelh@medozas.de> <1271224379.16881.610.camel@edumazet-laptop> <alpine.LSU.2.01.1004141159390.9499@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37069 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0DNK4h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:56:37 -0400
In-Reply-To: <alpine.LSU.2.01.1004141159390.9499@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-04-14 07:52, Eric Dumazet wrote:
>>> +#ifdef WITH_CONNTRACK
>>> +	/* Avoid counting cloned packets towards the original connection. */
>>> +	nf_conntrack_put(skb->nfct);
>>> +	skb->nfct     = &nf_conntrack_untracked.ct_general;
>>> +	skb->nfctinfo = IP_CT_NEW;
>>> +	nf_conntrack_get(skb->nfct);
>> This atomic increment on a global variable worries me... Would it be
>> possible to avoid it (and the associated decrement and test if null)
>>
>> I would like to use this TEE facility but with xxx kpps for instance ;)
> 
> Correctness before speed. You're free to send patches on top.
> 

Pablo suggest to encode "untracked" in one of the nfctinfo bits a
while ago, which would avoid all atomic operations. Anyways, this
can be done later.
