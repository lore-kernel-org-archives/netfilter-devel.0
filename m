From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: meta: add PRANDOM support
Date: Tue, 16 Feb 2016 14:19:10 +0100
Message-ID: <20160216131910.GC13417@breakpoint.cc>
References: <1455624554-16005-1-git-send-email-fw@strlen.de>
 <56C31ABA.1050801@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39456 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086AbcBPNTM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 08:19:12 -0500
Content-Disposition: inline
In-Reply-To: <56C31ABA.1050801@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Daniel Borkmann <daniel@iogearbox.net> wrote:
> >+	case NFT_META_PRANDOM:
> >+		if (!prand_inited) {
> >+			prandom_seed_full_state(&nft_prandom_state);
> >+			prand_inited = true;
> >+		}
> 
> Should this be: prandom_init_once() ?

Thought about that but this is slowpath so I considered
the use of static key magic a bit overkill....

I don't mind, if you think prandom_init_once is prefereable I'll respin.

Let me know, thanks!
