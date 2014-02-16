From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nftables: fix nf_trace always-on with
 XT_TRACE=n
Date: Sun, 16 Feb 2014 12:06:27 +0100
Message-ID: <20140216110627.GE28751@breakpoint.cc>
References: <1392504525-21134-1-git-send-email-fw@strlen.de>
 <20140216102003.GA4981@localhost>
 <20140216102824.GC28751@breakpoint.cc>
 <20140216104311.GA3563@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52722 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbaBPLG2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:06:28 -0500
Content-Disposition: inline
In-Reply-To: <20140216104311.GA3563@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > OTOH I think that trace support is a very important thing to have and I
> > doubt that compiling it out would save a lot of size.
> > 
> > But sure, if you think it makes sense I can add CONFIG_NF_TRACE and
> > make nf_tables tracing conditional.
> 
> This is just a cosmetic comment, but I can live with that long #if
> line. Leave it up to you to decide.

I see.  I that case please consider applying the present patch.
I think adding extra kconfig symbol just for the sake of avoiding
two longer IS_ENABLED() statements is plain overkill :-)
