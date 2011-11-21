From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Tue, 22 Nov 2011 00:39:42 +0100
Message-ID: <20111121233942.GA13815@1984>
References: <20111108221634.GA13261@p183.telecom.by>
 <20111109143423.GA24158@1984>
 <20111115095642.GA28944@1984>
 <61996646E807F2E67842E57F@nimrod.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Dobriyan <adobriyan@gmail.com>, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Alex Bligh <alex@alex.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45113 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab1KUXjv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:39:51 -0500
Content-Disposition: inline
In-Reply-To: <61996646E807F2E67842E57F@nimrod.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Alex,

On Tue, Nov 15, 2011 at 10:13:58AM +0000, Alex Bligh wrote:
> Pablo,
> 
> Have you tried this patch (without the ->nfnl NULL check change) with
> the perl program I wrote that reliably replicates the original bug?
> 
> https://bugs.launchpad.net/ubuntu/+source/linux-lts-backport-natty/+bug/843892
> 
> specifically the attachment in comment #6:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux-lts-backport-natty/+bug/843892/+attachment/2382526/+files/testns.pl

I didn't try with this script, but the problem can be easily
triggered with:

0) make sure nf_conntrack_netlink and nf_conntrack_ipv4 are loaded.
1) container is started.
2) connect to it via lxc-console.
3) generate some traffic with the container to create some conntrack
   entries in its table.
4) stop the container: hit the oops.

I've been testing the patch that I proposed with this recipe, now it
works fine.

I'll pass my patch for 3.2-rc soon, in case you want to make further
testing of it.
