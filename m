From: Alex Bligh <alex@alex.org.uk>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Mon, 21 Nov 2011 23:50:36 +0000
Message-ID: <20C4F518A396D69CC6A1B157@nimrod.local>
References: <20111108221634.GA13261@p183.telecom.by>
 <20111109143423.GA24158@1984> <20111115095642.GA28944@1984>
 <61996646E807F2E67842E57F@nimrod.local> <20111121233942.GA13815@1984>
Reply-To: Alex Bligh <alex@alex.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alexey Dobriyan <adobriyan@gmail.com>, kaber@trash.net,
	netfilter-devel@vger.kernel.org, Alex Bligh <alex@alex.org.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.avalus.com ([89.16.176.221]:52133 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab1KUXuk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:50:40 -0500
In-Reply-To: <20111121233942.GA13815@1984>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



--On 22 November 2011 00:39:42 +0100 Pablo Neira Ayuso 
<pablo@netfilter.org> wrote:

> I didn't try with this script, but the problem can be easily
> triggered with:
>
> 0) make sure nf_conntrack_netlink and nf_conntrack_ipv4 are loaded.
> 1) container is started.
> 2) connect to it via lxc-console.
> 3) generate some traffic with the container to create some conntrack
>    entries in its table.
> 4) stop the container: hit the oops.
>
> I've been testing the patch that I proposed with this recipe, now it
> works fine.
>
> I'll pass my patch for 3.2-rc soon, in case you want to make further
> testing of it.

I will try to, when I have a minute. Occasionally I was getting a
double oops before. My theory at the time was that this was to do
with passing traffic /as/ the container was being destroyed. I have
little to substantiate that, but that was the reason for the perl
script (which really just runs a ping as the container is being
destroyed, which ensures there are conntrack entries).

-- 
Alex Bligh
