From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv7 4/4] netfilter: bridge: forward IPv6 fragmented packets
Date: Fri, 12 Jun 2015 14:26:22 +0200
Message-ID: <20150612122622.GG13530@salvia>
References: <1432992616-4195-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55803 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbbFLMVJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:21:09 -0400
Content-Disposition: inline
In-Reply-To: <1432992616-4195-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 30, 2015 at 03:30:16PM +0200, Bernhard Thaler wrote:
> IPv6 fragmented packets are not forwarded on an ethernet bridge
> with netfilter ip6_tables loaded. e.g. steps to reproduce
> 
> 1) create a simple bridge like this
> 
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
> IPv6 fragmented packets traverse the bridge cleanly until somebody runs.
> "ip6tables -t nat -nvL". As soon as it is run (and netfilter modules are
> loaded) IPv6 fragmented packets do not traverse the bridge any more (you
> see no more responses in ping's output).
> 
> After applying this patch IPv6 fragmented packets traverse the bridge
> cleanly in above scenario.

Applied, thanks Bernhard.

