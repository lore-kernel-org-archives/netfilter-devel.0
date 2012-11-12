From: Ed W <lists@wildgooses.com>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Mon, 12 Nov 2012 19:56:40 +0000
Message-ID: <50A15478.6070801@wildgooses.com>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr> <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu> <alpine.DEB.2.02.1211121805330.23195@lap-x201>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Chris Wilson <chris-netfilter-110904@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:59546 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2KLT4n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 14:56:43 -0500
In-Reply-To: <alpine.DEB.2.02.1211121805330.23195@lap-x201>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> An in-kernel "route changed" notification were great, because then we 
>> could delete all MASQUERAD-ed entries where --update-source-address 
>> flag is set.
>
> If we could register to receive routing changed events for SNAT source 
> addresses, that would be great (more efficient) but if the mechanism 
> does not yet exist, it would be much more difficult to create.
>
> I suppose that if we just deleted them all on any routing change, then 
> that would solve the immediate problem for us. It would be ideal if 
> incoming packets could still be directed to the correct internal 
> source, but dropping them is a smaller problem than continuing to send 
> out invalid packets and keeping a broken entry alive forever.

I'm probably completely missing the point, but:

- Route changes such as you describe will be triggered by some user 
space event.
- Lets generically call that "dhcpcd" for the sake of a label
- These userspace events should all be capable of some kind of "hook" on 
change
- This userspace hook can zap the relevant conntrack entries

The pros/conns seem to be that:
- one more piece of userspace to maintain
- but there is now integration between the userspace routing decisions 
and the decision to zap certain conntrack entries


For example in my situation I dynamically tweak ipsets and an IP 
dropping into an IPset causes routing decisions to be made for just that 
user. When we add a user to an ipset we also zap previous conntrack 
entries relating to that user.

I'm not sure that I can see any way for the kernel to know when it 
should adjust conntrack entries in my situation?


Cheers

Ed W
