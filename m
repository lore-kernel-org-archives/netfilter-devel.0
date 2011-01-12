From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 4/6] netfilter: reduce NF_VERDICT_MASK to 0xff
Date: Wed, 12 Jan 2011 21:52:16 +0100
Message-ID: <20110112205216.GC10801@Chamillionaire.breakpoint.cc>
References: <1293407904-31464-1-git-send-email-fw@strlen.de>
 <1293407904-31464-5-git-send-email-fw@strlen.de>
 <4D2DFAC5.8020802@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43204 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457Ab1ALUwR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:52:17 -0500
Content-Disposition: inline
In-Reply-To: <4D2DFAC5.8020802@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  /* only for userspace compatibility */
> >  #ifndef __KERNEL__
> > @@ -41,6 +44,9 @@
> >     <= 0x2000 is used for protocol-flags. */
> >  #define NFC_UNKNOWN 0x4000
> >  #define NFC_ALTERED 0x8000
> > +
> > +/* NF_VERDICT_BITS should be 8 now, but userspace might break if this changes */
> > +#define NF_VERDICT_BITS 16
> >  #endif
> 
> i don't find any use of this in user-space.

Alright, I will simply remove it, then :-)

