From: Chris Wilson <chris-netfilter-110904@aptivate.org>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Tue, 13 Nov 2012 17:02:53 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1211131659230.23195@lap-x201>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121805330.23195@lap-x201> <alpine.DEB.2.00.1211121940290.18729@blackhole.kfki.hu> <alpine.DEB.2.00.1211122014550.4432@chris-desktop.fen.aptivate.org> <alpine.DEB.2.00.1211131639320.21144@blackhole.kfki.hu> <alpine.DEB.2.02.1211131601040.23195@lap-x201>
 <alpine.DEB.2.00.1211131712210.21144@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:35444 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab2KMRDL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:03:11 -0500
In-Reply-To: <alpine.DEB.2.00.1211131712210.21144@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Tue, 13 Nov 2012, Jozsef Kadlecsik wrote:

>> The VPN cannot be brought up until networking is up, so the only ways I 
>> can see to prevent this are:
>>
>> * the firewall ruleset forbids packets destined for VPN addresses to 
>> leave via the public interface. But the VPN destinations not be known 
>> until the tunnel comes up and the VPN server declares to the client 
>> which subnets should be routed through it. It might even change every 
>> time. Or it might be the default route. Should we then forbid all 
>> packets from leaving on the public interface? How will the VPN 
>> communication happen then?
>
> But *something* selects which traffic is forwarded via the VPN tunnels. 
> As egress-ingress filtering, the same selection can be used to allow the 
> proper interfaces only.

The VPN software may decide, based on configuration received from the 
remote server, what traffic is routed. Almost all tunneled VPNs work this 
way; the only exception I can think of is IPsec. OpenVPN and anything 
PPP-based (PPTP and L2TP) all create an interface with a subnet and mask 
assigned by the server, and the kernel automatically routes all traffic 
for that subnet through the VPN. But what address will be assigned? Often, 
only the VPN server knows, and sometimes only at the moment of assignment.

We could say "you must know which subnet will be assigned in order to 
write your policy" which is technically correct, but not user friendly. 
I'm very heartened to see that you want to make the default behaviour 
(without resort to external tools) more user-friendly :)

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

