From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCHv3 1/1] bridge: forward IPv6 fragmented packets when
 passing netfilter
Date: Tue, 27 Jan 2015 10:39:51 +0100
Message-ID: <20150127093951.GE1373@breakpoint.cc>
References: <20150122234940.GD16045@breakpoint.cc>
 <1422321724-325-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59518 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbbA0JkC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:40:02 -0500
Content-Disposition: inline
In-Reply-To: <1422321724-325-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bernhard Thaler <bernhard.thaler@wvnet.at> wrote:
>         modprobe br_netfilter
>         brctl addbr br0
>         brctl addif br0 eth0
>         brctl addif br0 eth2
>         ifconfig eth0 up
>         ifconfig eth2 up
>         ifconfig br0 up
> 
> 2) place a host with an IPv6 address on each side of the bridge
> 
>         set IPv6 address on host A:
>         ip -6 addr add fd01:2345:6789:1::1/64 dev eth0
> 
>         set IPv6 address on host B:
>         ip -6 addr add fd01:2345:6789:1::2/64 dev eth0
> 
> 3) run a simple ping command on host A with packets > MTU
> 
>         ping6 -s 4000 fd01:2345:6789:1::2
> 
> 4) wait some time and run e.g. "ip6tables -t nat -nvL" on the bridge
> 
> IPv6 fragmented packets traverse the bridge cleanly until "ip6tables -t nat -nvL"
> is run. As soon as it is run (and netfilter modules are loaded) IPv6 fragmented
> packets do not traverse the bridge any more (you see no more responses in ping's
> output).
> 
> Patch exports ip6_fragment() in include/net/ipv6.h and net/ipv6/ip6_output.c
> to use it in net/bridge/br_netfilter.c's br_nf_dev_queue_xmit() for IPv6 packets
> that need to be fragmented.

I think this looks good, however afaics there is now a direct dependeny on
ipv6.ko module.  I think it would be nice if we could avoid this.

There are 2 ways to do this,
a) add fragment to nf_ipv6_ops
or
b) add fragment to pingv6_ops in include/net/ping.h

Ideally, those two should be merged into a single one, say e.g. ipv6_ops,
exported by core and wired up when ipv6 module is present, but I don't
want to push this on you, so e.g. adding fragment to nf_ipv6_ops is
fine with me.

With indirect call we could avoid ip6_fragment dependency.

