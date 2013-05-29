From: Florian Westphal <fw@strlen.de>
Subject: Re: nfqueue: detect when packet has already been checksummed?
Date: Wed, 29 May 2013 14:03:29 +0200
Message-ID: <20130529120329.GF6578@breakpoint.cc>
References: <20130526204826.GC6578@breakpoint.cc>
 <20130529111423.GA4989@localhost>
 <20130529112542.GE6578@breakpoint.cc>
 <20130529115705.GA5315@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	nf-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45071 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965645Ab3E2MDa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 08:03:30 -0400
Content-Disposition: inline
In-Reply-To: <20130529115705.GA5315@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I agree that the current situation is inconsistent. We have no way to
> know if the kernel validated the checksum or not from user-space, and
> I think this needs a fix.

Good :-)

> We can add a new NFQA_CFG_F_CSUM flag so user-space explicitly ask for
> assistance regarding checksumming from the kernel. If user-space tries
> to set that flag and the kernel does not support it, it will hit
> -EOPNOTSUPP. Thus, we can skip the feature retrieval thing.

Yes, but this looks like abuse of the flag semantics to me.
Unless you mean that setting this feat flag should prompt the kernel
to explicitly call a valiation function in case skb_csum_unnecessary()
returns false?

I think that this is overkill, and, it might not work
in all cases (e.g. if the layer4 protocol is unknown to us).
