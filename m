From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_tables: add chain to pktinfo
 structure
Date: Mon, 28 Nov 2016 11:32:24 +0100
Message-ID: <20161128103224.GA28510@breakpoint.cc>
References: <1480291244-3666-1-git-send-email-pablo@netfilter.org>
 <20161128005649.GA17749@breakpoint.cc>
 <20161128084428.GA949@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35006 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754289AbcK1KfS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 05:35:18 -0500
Content-Disposition: inline
In-Reply-To: <20161128084428.GA949@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Nov 28, 2016 at 01:56:49AM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > This patch adds the chain object to the pktinfo structure. This
> > > potentially allow us to know what basechain this packet is walking over
> > > from the expression evaluation path.
> > 
> > ... for what?  Why...?
> 
> Quota depletion event notification needs to know from what table
> delivery is happening, so this one actually belongs to the stateful
> object patchset..

Which patch uses this?

I see nft_chain() call in patch 8, but it doesn't need the chain object
but uses it to fetch the table pointer.

However, table is available at init() time so this could also be stored
in ->priv area afaics.

[ I am not opposed to this chain store thing, but after getting rid of
  a lot of members from pktinfo it seems to me we should not add
  new ones without a compelling reason ]

