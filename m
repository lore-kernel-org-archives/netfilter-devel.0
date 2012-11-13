From: Chris Wilson <chris-netfilter-110904@aptivate.org>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Tue, 13 Nov 2012 16:09:57 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1211131601040.23195@lap-x201>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121805330.23195@lap-x201> <alpine.DEB.2.00.1211121940290.18729@blackhole.kfki.hu> <alpine.DEB.2.00.1211122014550.4432@chris-desktop.fen.aptivate.org> <alpine.DEB.2.00.1211131639320.21144@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:35281 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2KMQKQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:10:16 -0500
In-Reply-To: <alpine.DEB.2.00.1211131639320.21144@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Tue, 13 Nov 2012, Jozsef Kadlecsik wrote:

>>>> I think the problem applies even more to portless protocols such as GRE.
>>>> Devices have no choice to "change the source port" when making a new
>>>> connection. Any packets that they send, will definitely keep a stale entry
>>>> alive.
>
> Please note, I believe only the second example you wrote is relevant.
> Starting VPN just out of the blue *after* connections are built up is just
> not the right thing.

I don't want to argue too strongly for the VPN case because I didn't 
experience it myself. I found it while researching to understand this 
problem, and it was never solved (properly and reported) by the sysadmin 
who experienced it.

The problem I have with that is that I don't know how to configure the 
Linux firewall and devices behind it correctly to avoid this.

Devices behind the firewall are trying to establish connections with 
devices outside, constantly. The firewall reboots. As soon as networking 
is up and iptables allows the devices' packets to pass, they start 
creating conntrack entries, even if the VPN is not up and therefore the 
packets are being routed out of the wrong interface.

The VPN cannot be brought up until networking is up, so the only ways I 
can see to prevent this are:

* the firewall ruleset forbids packets destined for VPN addresses to leave 
via the public interface. But the VPN destinations not be known until the 
tunnel comes up and the VPN server declares to the client which subnets 
should be routed through it. It might even change every time. Or it might 
be the default route. Should we then forbid all packets from leaving on 
the public interface? How will the VPN communication happen then?

* disable IP forwarding until the VPN comes up. Affects all non-VPN 
traffic as well.

* keep the internal interface down until VPN comes up. Affects all non-VPN 
traffic as well.

* shoot lusers/device vendors in the head. Maybe the best option?

* flush the existing conntrack entries when the VPN comes up.

* any others?

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

