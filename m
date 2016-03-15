From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 3/3] ct: add conntrack label set support
Date: Wed, 16 Mar 2016 00:01:32 +0100
Message-ID: <20160315230132.GC8185@breakpoint.cc>
References: <1458058211-11147-1-git-send-email-fw@strlen.de>
 <1458058211-11147-4-git-send-email-fw@strlen.de>
 <20160315171157.GB25284@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56001 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbcCOXBe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 19:01:34 -0400
Content-Disposition: inline
In-Reply-To: <20160315171157.GB25284@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If we have some generic way to parse immediates, this would look like:
> 
>         if (nfntl_attr_is_set(nle, NFTNL_EXPR_CT_SREG)) {
>                 ...
>         } else if (nftnl_attr_is_set(nle, NFTNL_EXPR_CT_IMM)) {
>                 ...
>         }
> 
> Would this look nicer this way to you?

I'll give it a try.
We can't escape a bit more work anyway as the _IMM type will depend
on the key.

