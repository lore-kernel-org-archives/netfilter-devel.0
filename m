From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add support for flextuples
Date: Wed, 6 May 2015 16:27:41 +0200
Message-ID: <20150506142741.GA3547@salvia>
References: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net>
 <20150504103451.GA12200@salvia>
 <55475F13.1000304@iogearbox.net>
 <20150504130828.GA3607@salvia>
 <20150504134733.GB1405@pox.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org,
	Madhu Challa <challa@noironetworks.com>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39520 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbbEFOXL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 May 2015 10:23:11 -0400
Content-Disposition: inline
In-Reply-To: <20150504134733.GB1405@pox.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 04, 2015 at 03:47:33PM +0200, Thomas Graf wrote:
[...] 
> Given that the multiple source zones which talk to a common
> destination zone may have conflicting IPs, the SNAT must either
> occur in the source zone where the source address is still unique
> or the CT tuple must be made unique with a source zone identifier
> so that the SNAT can occur in the destination zone.
> 
> Doing the SNAT in the source zone requires to use a unique IP pool
> to map to for each source zone as otherwise IP sources may clash again
> in the destination zone. We obviously can't do --SNAT -to 10.1.1.1 in
> two namespaces and then just route into a third namespace. This
> approach is not scalable in a container environment with 100s or even
> 1000s of containers each in its own network namespace.
> 
> What we want to do instead is to do the SNAT in the destination zone
> where we can have a single SNAT rule which overs all source zones.
> This allows inter namespace communication in a /31 with minimal waste
> of addresses.

Thanks for explaining. So you need to allocate an unique tuple using
the mark to avoid the clashes for the first packet that goes original
using the same pool. Then, the NAT engine will allocate an unique
tuple in the reply direction.

But what is the use case for -j CT --flextuple reply ? By when you see
the reply packet the tuple was already created.

Another question is if it makes sense to have part of the flows using
your flextuple idea while some others not, ie.

        -s x.y.z.w/24 -j CT --flextuple original

so shouldn't this be a global switch that includes the skb->mark
only for packets coming in the original direction?

I also wonder how you're going to deal with port redirections. This
only seem to be working SNAT/masquerade to me if the NAT happens from
VRF side.
