From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Tue, 22 Nov 2011 15:23:58 +0100
Message-ID: <20111122142358.GC24496@1984>
References: <20111108221634.GA13261@p183.telecom.by>
 <20111109143423.GA24158@1984>
 <20111115095642.GA28944@1984>
 <61996646E807F2E67842E57F@nimrod.local>
 <20111121233942.GA13815@1984>
 <20C4F518A396D69CC6A1B157@nimrod.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Dobriyan <adobriyan@gmail.com>, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Alex Bligh <alex@alex.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38109 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab1KVOYD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:24:03 -0500
Content-Disposition: inline
In-Reply-To: <20C4F518A396D69CC6A1B157@nimrod.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 21, 2011 at 11:50:36PM +0000, Alex Bligh wrote:
> 
> 
> --On 22 November 2011 00:39:42 +0100 Pablo Neira Ayuso
> <pablo@netfilter.org> wrote:
> 
> >I didn't try with this script, but the problem can be easily
> >triggered with:
> >
> >0) make sure nf_conntrack_netlink and nf_conntrack_ipv4 are loaded.
> >1) container is started.
> >2) connect to it via lxc-console.
> >3) generate some traffic with the container to create some conntrack
> >   entries in its table.
> >4) stop the container: hit the oops.
> >
> >I've been testing the patch that I proposed with this recipe, now it
> >works fine.
> >
> >I'll pass my patch for 3.2-rc soon, in case you want to make further
> >testing of it.
> 
> I will try to, when I have a minute. Occasionally I was getting a
> double oops before. My theory at the time was that this was to do
> with passing traffic /as/ the container was being destroyed. I have
> little to substantiate that, but that was the reason for the perl
> script (which really just runs a ping as the container is being
> destroyed, which ensures there are conntrack entries).

I think my fix is OK but more validation is always welcome, so I'd
appreciate if you validate this with your script ;-).
