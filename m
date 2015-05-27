From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: REOUTE target extenstion
Date: Wed, 27 May 2015 14:40:37 +0200
Message-ID: <20150527124037.GA19766@salvia>
References: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com>
 <20150527113746.GA23992@breakpoint.cc>
 <CADgXnSPkPdWdWcNJHrcv_9=oomWsE4ZfzoJZ3CTur=zW5LY9cQ@mail.gmail.com>
 <20150527121130.GC23992@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eddi Linder <eddi@guardicore.com>, netfilter-devel@vger.kernel.org,
	jengelh@inai.de
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42292 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbbE0Mfq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 08:35:46 -0400
Content-Disposition: inline
In-Reply-To: <20150527121130.GC23992@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 27, 2015 at 02:11:30PM +0200, Florian Westphal wrote:
> Eddi Linder <eddi@guardicore.com> wrote:
> > TEE is for gateway redirections, which means the redirected device has
> > to have a configured ip, and to be reachable from the original device.
> 
> That makes no sense to me.  The to-redirected device always needs to be
> reachable.  And iptables is L3 and upwards, so I don't see how 1:1
> copying would fit in here.
> 
> > Florian, I didn't find the mirror target in the mainline documentation or code.
> 
> I meant the tc action:
> 
> tc filter add dev eth0 parent $parent protocol ip [..] action mirred egress redirect dev eth1
> 
> > REROUTE redirection is more like the openvswitch output action, copy
> > the packet from one device into another.
> 
> Sorry, but my feeling is that this is out of scope for iptables.

Agreed.

There is an incomplete patch to add TEE support to nf_tables bridge
family. You only have to specify the destination device as Eddi needs.

Another alternative is to add this TEE support to ebtables, which is
where this belongs.
