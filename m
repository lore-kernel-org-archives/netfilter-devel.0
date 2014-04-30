From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] bridge: Superfluous skb->nfct check in
 br_nf_dev_queue_xmit
Date: Wed, 30 Apr 2014 12:02:28 +0200
Message-ID: <20140430100228.GR31953@breakpoint.cc>
References: <20140428131646.GP31953@breakpoint.cc>
 <5360BA5A.7020200@parallels.com>
 <20140430093905.GA4318@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vasily Averin <vvs@parallels.com>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Saikiran Madugula <hummerbliss@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52061 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757798AbaD3KCb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:02:31 -0400
Content-Disposition: inline
In-Reply-To: <20140430093905.GA4318@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Apr 30, 2014 at 12:54:50PM +0400, Vasily Averin wrote:
> > Currently bridge can silently drop ipv4 fragments.
> > If node have loaded nf_defrag_ipv4 module but have no nf_conntrack_ipv4,
> > br_nf_pre_routing defragments incoming ipv4 fragments
> > but nfct check in br_nf_dev_queue_xmit does not allow re-fragment combined packet back,
> > and therefore it is dropped in br_dev_queue_push_xmit without incrementing of any failcounters
> 
> Patrick already mentioned that bridges should not defragment unless
> conntrack is enabled.
> 
> Please, see: http://marc.info/?l=netfilter-devel&m=139878065822267&w=2
> 
> I think we have to consider some alternative way to fix what you
> report.

Could you explain how br_nf_dev_queue_xmit could encouter
an IP packet that doesn't fit link MTU without netfilter
defrag?

Because I do not see any way of this happening, all bridge
ports must have the same MTU?
