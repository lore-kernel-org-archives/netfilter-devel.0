From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] bridge: superfluous skb->nfct check in
 br_nf_dev_queue_xmit
Date: Mon, 5 May 2014 16:07:55 +0200
Message-ID: <20140505140755.GA12018@localhost>
References: <20140504192517.GA13876@localhost>
 <5366A06C.7060509@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53463 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548AbaEEOIF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 10:08:05 -0400
Content-Disposition: inline
In-Reply-To: <5366A06C.7060509@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 05, 2014 at 12:17:48AM +0400, Vasily Averin wrote:
> [v2: #ifdef is changed from NF_CONNTRACK_IPV4 to NF_DEFRAG_IPV4]
> 
> Currently bridge can silently drop ipv4 fragments.
> If node have loaded nf_defrag_ipv4 module but have no nf_conntrack_ipv4,
> br_nf_pre_routing defragments incoming ipv4 fragments
> but nfct check in br_nf_dev_queue_xmit does not allow re-fragment combined
> packet back, and therefore it is dropped in br_dev_queue_push_xmit without
> incrementing of any failcounters
> 
> It seems the only way to hit the ip_fragment code in the bridge xmit
> path is to have a fragment list whose reassembled fragments go over
> the mtu. This only happens if nf_defrag is enabled. Thanks to
> Florian Westphal for providing feedback to clarify this.
> 
> Defragmentation ipv4 is required not only in conntracks but at least in
> TPROXY target and socket match, therefore #ifdef is changed from
> NF_CONNTRACK_IPV4 to NF_DEFRAG_IPV4

Applied, thanks Vasily.
