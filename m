From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Tue, 13 Nov 2012 17:19:49 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211131712210.21144@blackhole.kfki.hu>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121805330.23195@lap-x201> <alpine.DEB.2.00.1211121940290.18729@blackhole.kfki.hu> <alpine.DEB.2.00.1211122014550.4432@chris-desktop.fen.aptivate.org> <alpine.DEB.2.00.1211131639320.21144@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211131601040.23195@lap-x201>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Chris Wilson <chris-netfilter-110904@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:42730 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab2KMQTv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:19:51 -0500
In-Reply-To: <alpine.DEB.2.02.1211131601040.23195@lap-x201>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Chris,

On Tue, 13 Nov 2012, Chris Wilson wrote:

> On Tue, 13 Nov 2012, Jozsef Kadlecsik wrote:
> 
> > Please note, I believe only the second example you wrote is relevant.
> > Starting VPN just out of the blue *after* connections are built up is just
> > not the right thing.
> 
> I don't want to argue too strongly for the VPN case because I didn't
> experience it myself. I found it while researching to understand this problem,
> and it was never solved (properly and reported) by the sysadmin who
> experienced it.
> 
> The problem I have with that is that I don't know how to configure the Linux
> firewall and devices behind it correctly to avoid this.
> 
> Devices behind the firewall are trying to establish connections with devices
> outside, constantly. The firewall reboots. As soon as networking is up and
> iptables allows the devices' packets to pass, they start creating conntrack
> entries, even if the VPN is not up and therefore the packets are being routed
> out of the wrong interface.

Ahh, the niceties of living systems! :-))
 
> The VPN cannot be brought up until networking is up, so the only ways I can
> see to prevent this are:
> 
> * the firewall ruleset forbids packets destined for VPN addresses to leave via
> the public interface. But the VPN destinations not be known until the tunnel
> comes up and the VPN server declares to the client which subnets should be
> routed through it. It might even change every time. Or it might be the default
> route. Should we then forbid all packets from leaving on the public interface?
> How will the VPN communication happen then?

But *something* selects which traffic is forwarded via the VPN tunnels. As 
egress-ingress filtering, the same selection can be used to allow the 
proper interfaces only.
 
> * disable IP forwarding until the VPN comes up. Affects all non-VPN traffic as
> well.
> 
> * keep the internal interface down until VPN comes up. Affects all non-VPN
> traffic as well.
> 
> * shoot lusers/device vendors in the head. Maybe the best option?
> 
> * flush the existing conntrack entries when the VPN comes up.
> 
> * any others?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
