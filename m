From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] bridge: Superfluous skb->nfct check in
 br_nf_dev_queue_xmit
Date: Sun, 4 May 2014 14:54:27 +0200
Message-ID: <20140504125427.GA4344@localhost>
References: <20140428131646.GP31953@breakpoint.cc>
 <5360BA5A.7020200@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Saikiran Madugula <hummerbliss@gmail.com>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42222 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbaEDMyd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 08:54:33 -0400
Content-Disposition: inline
In-Reply-To: <5360BA5A.7020200@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 30, 2014 at 12:54:50PM +0400, Vasily Averin wrote:
> Currently bridge can silently drop ipv4 fragments.
> If node have loaded nf_defrag_ipv4 module but have no nf_conntrack_ipv4,
> br_nf_pre_routing defragments incoming ipv4 fragments
> but nfct check in br_nf_dev_queue_xmit does not allow re-fragment combined packet back,
> and therefore it is dropped in br_dev_queue_push_xmit without incrementing of any failcounters

If no further objections, I'll push this original patch appending this comment
to the description:

[ It seems the only way to hit the ip_fragment code in the bridge xmit
  path is to have a fragment list whose reassembled fragments go over
  the mtu. This only happens if nf_defrag is enabled. Thanks to
  Florian Westphal for providing feedback to clarify this. ]
