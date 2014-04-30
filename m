From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] bridge: Superfluous skb->nfct check in
 br_nf_dev_queue_xmit
Date: Wed, 30 Apr 2014 11:39:05 +0200
Message-ID: <20140430093905.GA4318@localhost>
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
Received: from mail.us.es ([193.147.175.20]:52490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaD3Jtc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:49:32 -0400
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

Patrick already mentioned that bridges should not defragment unless
conntrack is enabled.

Please, see: http://marc.info/?l=netfilter-devel&m=139878065822267&w=2

I think we have to consider some alternative way to fix what you
report.
