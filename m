From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] bridge: Superfluous skb->nfct check in
 br_nf_dev_queue_xmit
Date: Sun, 4 May 2014 21:25:17 +0200
Message-ID: <20140504192517.GA13876@localhost>
References: <20140428131646.GP31953@breakpoint.cc>
 <5360BA5A.7020200@parallels.com>
 <20140504125427.GA4344@localhost>
 <53668F3D.7080202@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Saikiran Madugula <hummerbliss@gmail.com>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37961 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaEDTZX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 15:25:23 -0400
Content-Disposition: inline
In-Reply-To: <53668F3D.7080202@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 04, 2014 at 11:04:29PM +0400, Vasily Averin wrote:
> On 05/04/2014 04:54 PM, Pablo Neira Ayuso wrote:
> > On Wed, Apr 30, 2014 at 12:54:50PM +0400, Vasily Averin wrote:
> >> Currently bridge can silently drop ipv4 fragments.
> >> If node have loaded nf_defrag_ipv4 module but have no nf_conntrack_ipv4,
> >> br_nf_pre_routing defragments incoming ipv4 fragments
> >> but nfct check in br_nf_dev_queue_xmit does not allow re-fragment combined packet back,
> >> and therefore it is dropped in br_dev_queue_push_xmit without incrementing of any failcounters
> > 
> > If no further objections, I'll push this original patch appending this comment
> > to the description:
> > 
> > [ It seems the only way to hit the ip_fragment code in the bridge xmit
> >   path is to have a fragment list whose reassembled fragments go over
> >   the mtu. This only happens if nf_defrag is enabled. Thanks to
> >   Florian Westphal for providing feedback to clarify this. ]
> 
> I have not objections, however I still do not understand why #if
> IS_ENABLED(CONFIG_NF_CONNTRACK_IPV4) is required in
> br_dev_queue_push_xmit()?
> 
> If ipv4 defragmentation is required not only for conntracks but for
> TPROXY target and xt_socket match I think we need to use
> NF_DEFRAG_IPV4 instead.

Before your patch, this was checking for skb->nfct which is defined by

#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)

in include/linux/skbuff.h.

But after removing that skb->nfct check, we can safely change it to
CONFIG_NF_DEFRAG_IPV4.

You can send me a new patch version including this change.
