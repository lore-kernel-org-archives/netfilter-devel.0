From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: packet flow - ebtables broute DROP target
Date: Thu, 15 Jul 2010 16:34:15 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007151616400.7169@obet.zrqbmnf.qr>
References: <1DB91DF937A4544C81E636468B91C21C06F1EC28@CNSHGSMBS03.ad4.ad.alcatel.com>  <1DB91DF937A4544C81E636468B91C21C06F1ECAF@CNSHGSMBS03.ad4.ad.alcatel.com>  <AANLkTil_RodsXwi2y8-tOeLsZ8Cl3TN0WYfsAMrrx-VP@mail.gmail.com>
 <1279202558.5524.10.camel@aijazbaig1-desktop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Aijaz Baig <aijazbaig1@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37220 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933361Ab0GOOeR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:34:17 -0400
In-Reply-To: <1279202558.5524.10.camel@aijazbaig1-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-07-15 16:02, Aijaz Baig wrote:
>unfamiliar with it, here are the links to the same:
>http://ebtables.sourceforge.net/br_fw_ia/br_fw_ia.html for the document
>and http://ebtables.sourceforge.net/br_fw_ia/PacketFlow.png for the
>picture.

Use http://jengelh.medozas.de/images/nf-packet-flow.png

>Im trying to understand what happens to a packet which is DROPped in the
>BROUTING chain of the broute table. If I have understood correctly from
>the document above, it goes to L3 where the routing subsystem can decide
>where to send the packet to depending on L3 information in it isn't it?

In net/core/dev.c, the packet is passed to all "taps". Taps include 
raw sockets (think tcpdump), but also bridge and the IPvX layers 
themselves. Each of them basically gets a copy, thus it is important to 
not have an address on the ethernet interface (so that the IPvX tap 
ignores it). Only the bridge interface should have an address, because 
the bridge code will pass it to IPvX on its own.

(You probably knew this, but this is a nice question plus answer for our 
planned book(s).)

So considering only bridge.c, the brouting chain can then be used to 
either move the packet along the blue L2 path or the green L3 path.

If a packet remains travelling in the blue domain (i.e. it is bridged), 
the packet _must_ have the bridge's own dst mac address to go "upwards" 
at the "bridging decision" (sort of Ethernet routing, if you want to 
call it so) circle to reach IPvX routing.

>And then after that I checked the packet counters for both the rules
>viz. the one in the BROUTING chain and the one in the PREROUTING chain
>of the mangle table. The packet did hit the first rule and it is
>dropped. I cannot see it on br0, the bridge interface too. But the
>packet count in the latter rule is 0 which means that the packet didnt
>arrive in the mangle table's

To be eligible for green traversal as a result of (bridge check), the 
packet of course needs to be one of the supported protocols.
Sending STP into the green domain has no bearing. IPX packets will be 
conntracked, but of course you won't see them in iptables or ip6tables 
(since they are not IPv4/IPv6, naturally).
