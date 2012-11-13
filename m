From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Tue, 13 Nov 2012 19:01:39 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211131851001.26379@nerf07.vanv.qr>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121805330.23195@lap-x201> <alpine.DEB.2.00.1211121940290.18729@blackhole.kfki.hu> <alpine.DEB.2.00.1211122014550.4432@chris-desktop.fen.aptivate.org> <alpine.DEB.2.00.1211131639320.21144@blackhole.kfki.hu> <alpine.DEB.2.02.1211131601040.23195@lap-x201>
 <alpine.DEB.2.00.1211131712210.21144@blackhole.kfki.hu> <alpine.DEB.2.02.1211131659230.23195@lap-x201>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Chris Wilson <chris-netfilter-110904@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:59443 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab2KMSBk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:01:40 -0500
In-Reply-To: <alpine.DEB.2.02.1211131659230.23195@lap-x201>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-11-13 18:02, Chris Wilson wrote:
>
> The VPN software may decide, based on configuration received from the remote
> server, what traffic is routed. Almost all tunneled VPNs work this way; the
> only exception I can think of is IPsec. OpenVPN and anything PPP-based (PPTP
> and L2TP) all create an interface with a subnet and mask assigned by the
> server, and the kernel automatically routes all traffic for that subnet through
> the VPN.

StrongSWAN (as a setup daemon for the kernel's IPsec) also supports
dynamic address assignment. It's been some years since I did that;
looking at ipsec.conf now would hint towards "leftsourceip=%config"
being the magic option.

Furthermore, also in the IPsec case does the kernel automatically
route traffic for the rightsubnet properly - because Strongswan will
add the required routes (in local table no. 220, if you care).

> We could say "you must know which subnet will be assigned in order to write
> your policy" which is technically correct, but not user friendly.

I'm digressing here, but I'll throw it in nevertheless. Allowing the
tunnel traffic is pretty much the same:

openvpn: iptables -A OUTPUT -d 1.2.3.4 ...
ipsec: iptables -A OUTPUT -m policy --tunnel-dst 1.2.3.4 ...
