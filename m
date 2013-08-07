From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 -next] netfilter: ctnetlink: attach expectations to
 unconfirmed conntracks
Date: Wed, 7 Aug 2013 12:40:34 +0200
Message-ID: <20130807104034.GA7500@localhost>
References: <1375795183-10820-1-git-send-email-pablo@netfilter.org>
 <52022107.30206@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40348 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249Ab3HGKkq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:40:46 -0400
Content-Disposition: inline
In-Reply-To: <52022107.30206@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 07, 2013 at 06:27:19PM +0800, Gao feng wrote:
> On 08/06/2013 09:19 PM, Pablo Neira Ayuso wrote:
> > This patch adds the capability to attach expectations to unconfirmed
> > conntrack entries. This patch is required by conntrack helpers that
> > trigger expectations based on the first packet seen like the TFTP and
> > the DHCPv6 user-space helpers.
> > 
> > There is no need to bump the conntrack refcount since unconfirmed
> > conntracks are not yet in the hashes, thus, they are just referenced
> > by one single packet. There is no trouble either in the get_next_corpse
> > path, as unconfirmed conntracks only get their dying bit set to
> > be discarded later on by nf_conntrack_confirm.
> > 
> 
> The use after free problem still may happen.
> 
> the unconfirmed conntrack is created when we receive the first packet,
> then this conntrack is linked in the per net global unconfirmed list.
> 
> And this conntrack may be destroyed when the return value of l4proto->packet
> low than 0 in nf_conntrack_in.

I'm calling this from nfqueue, so the packet is retained until the
user-space application issues the verdict on it, in that case that's
not possible.

But that interface is generic and to get this working in all cases, I
need the bump the refcount. So you're right, I'm going to revamp this.
Thanks for reviewing.
