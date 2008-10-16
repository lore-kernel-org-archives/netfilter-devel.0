From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix arptable_filter wrong hook registering
Date: Thu, 16 Oct 2008 13:52:21 +0200
Message-ID: <48F72AF5.5060000@netfilter.org>
References: <20081016012451.6126.34071.stgit@Decadence> <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr> <48F69EF2.5000104@netfilter.org> <alpine.LNX.1.10.0810152201290.28060@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44019 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754762AbYJPLw1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:52:27 -0400
In-Reply-To: <alpine.LNX.1.10.0810152201290.28060@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
>>> Perhaps the following helps?
>> Yes, your patch will also work, but it introduces an inconsistency in
>> the naming used to register hooks in the family field.
> 
> No, not really. Netfilter Hooks are supposed to register with
> 	.pf = NFPROTO_FOO
> instead of
> 	.pf = PF_FOO
> because the nf_hooks list itself is indexed by nfproto numbers,
> not PF numbers:
> 
> struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS] __read_mostly; 
> 
> (The fact that there's still PF_ in the source is merely historical,
> and as you see, PF_foo == NFPROTO_foo for that exact reason.)

This makes sense, but then I think that a cleanup for all the NF_HOOK
calls in the net code to use NFPROTO_* instead of the family would be
interesting for consistency.

BTW, I think that the last chunk of your patch should be a different one
since it fixes NFQUEUE for arptables.

I don't mind about using your patch or mine, both works. Let's fix it,
that's all. Patrick, I leave this up to you.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
