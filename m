From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 0/7] add payload set support for sub-byte sizes
Date: Mon, 1 Aug 2016 17:12:01 +0200
Message-ID: <20160801151201.GB29772@breakpoint.cc>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
 <20160801103538.GA2385@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45758 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985AbcHAPMG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 11:12:06 -0400
Content-Disposition: inline
In-Reply-To: <20160801103538.GA2385@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jul 27, 2016 at 02:43:09AM +0200, Florian Westphal wrote:
> > This series adds support for setting ipv6 flowlabel and e.g.
> > ecn/dscp header fields for ipv4 and ipv6 by adding the needed
> > bitwise ops (and removing them during netlink decoding).
> 
> I'm hitting whitespace errors here:
> 
>         warning: 2 lines add whitespace errors
> 
> Please, amend these and other nitpicks and push these series, we can
> later on refine them if needed.
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

I pushed this to master, thanks for reviewing.
