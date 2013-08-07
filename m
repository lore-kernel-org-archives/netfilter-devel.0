From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 -next] netfilter: ctnetlink: attach expectations to
 unconfirmed conntracks
Date: Wed, 7 Aug 2013 13:27:36 +0200
Message-ID: <20130807112736.GA12841@localhost>
References: <1375795183-10820-1-git-send-email-pablo@netfilter.org>
 <52022107.30206@cn.fujitsu.com>
 <20130807104034.GA7500@localhost>
 <20130807104653.GA29345@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gao feng <gaofeng@cn.fujitsu.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46439 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab3HGL1l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:27:41 -0400
Content-Disposition: inline
In-Reply-To: <20130807104653.GA29345@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 07, 2013 at 12:46:53PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Aug 07, 2013 at 06:27:19PM +0800, Gao feng wrote:
> > > On 08/06/2013 09:19 PM, Pablo Neira Ayuso wrote:
> > > > This patch adds the capability to attach expectations to unconfirmed
> > > > conntrack entries. This patch is required by conntrack helpers that
> > > > trigger expectations based on the first packet seen like the TFTP and
> > > > the DHCPv6 user-space helpers.
> > > > 
> > > > There is no need to bump the conntrack refcount since unconfirmed
> > > > conntracks are not yet in the hashes, thus, they are just referenced
> > > > by one single packet. There is no trouble either in the get_next_corpse
> > > > path, as unconfirmed conntracks only get their dying bit set to
> > > > be discarded later on by nf_conntrack_confirm.
> > > > 
> > > 
> > > The use after free problem still may happen.
> > > 
> > > the unconfirmed conntrack is created when we receive the first packet,
> > > then this conntrack is linked in the per net global unconfirmed list.
> > > 
> > > And this conntrack may be destroyed when the return value of l4proto->packet
> > > low than 0 in nf_conntrack_in.
> > 
> > I'm calling this from nfqueue, so the packet is retained until the
> > user-space application issues the verdict on it, in that case that's
> > not possible.
> > 
> > But that interface is generic and to get this working in all cases, I
> > need the bump the refcount. So you're right, I'm going to revamp this.
> 
> Sorry, but I don't see how this approach will work in practice.
> 
> The kernel will frequently rip out entries from the unconfirmed list
> and put them in the hash table, so on busy machines you'll often end up NOT
> finding the conntrack you're looking for, because ct entry was moved to
> the hash table and you hit the nulls element of some table bucket...

I don't see any practical use for this out of the nfqueue context as
you won't likely find what you look for. But if that ever happens, we
may hold an invalid reference to a conntrack that does exist anymore,
so I think we need the refcount to prevent that.

In the nfqueue scenario, the packet and the conntrack are held until
userspace returns the verdict, so it will very likely find a matching.
