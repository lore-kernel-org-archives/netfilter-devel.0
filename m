From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Tue, 15 Nov 2011 15:09:20 +0100
Message-ID: <20111115140920.GA31321@1984>
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
Received: from mail.us.es ([193.147.175.20]:47248 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab1KOOJ1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Nov 2011 09:09:27 -0500
Content-Disposition: inline
In-Reply-To: <61996646E807F2E67842E57F@nimrod.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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

I didn't test my patch yet, I just wanted to ping you that I was
looking into this.
