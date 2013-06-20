From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_conntrack_ipv6: Plug sk_buff leak in
 fragment handling
Date: Thu, 20 Jun 2013 11:56:54 +0200
Message-ID: <20130620095654.GC698@localhost>
References: <20130619104950.GA1343@gmail.com>
 <20130620092031.GC2124@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org,
	kaber@trash.net, davem@davemloft.net, security@kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35935 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab3FTJ47 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:56:59 -0400
Content-Disposition: inline
In-Reply-To: <20130620092031.GC2124@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 20, 2013 at 11:20:31AM +0200, Florian Westphal wrote:
> Phil Oester <kernel@linuxace.com> wrote:
> > In commit 4cdd3408 ("netfilter: nf_conntrack_ipv6: improve fragmentation
> > handling"), an sk_buff leak was introduced when dealing with reassembled
> > packets by grabbing a reference to the original skb instead of the
> > reassembled skb.  At this point, the leak only impacted conntracks with an
> > associated helper.  
> 
> David, could you please apply this patch directly in case Pablo doesn't
> apply it first?  This fixes a remote DoS, so it better hit -stable ASAP.

I'll take care of it.
