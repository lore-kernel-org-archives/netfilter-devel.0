From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: packet flow - ebtables broute DROP target
Date: Thu, 15 Jul 2010 21:26:33 +0200
Message-ID: <4C3F60E9.3090106@pandora.be>
References: <1DB91DF937A4544C81E636468B91C21C06F1EC28@CNSHGSMBS03.ad4.ad.alcatel.com>  <1DB91DF937A4544C81E636468B91C21C06F1ECAF@CNSHGSMBS03.ad4.ad.alcatel.com>  <AANLkTil_RodsXwi2y8-tOeLsZ8Cl3TN0WYfsAMrrx-VP@mail.gmail.com> <1279202558.5524.10.camel@aijazbaig1-desktop> <alpine.LSU.2.01.1007151616400.7169@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Aijaz Baig <aijazbaig1@gmail.com>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:43533 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934428Ab0GOT0i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:26:38 -0400
In-Reply-To: <alpine.LSU.2.01.1007151616400.7169@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt schreef:
> On Thursday 2010-07-15 16:02, Aijaz Baig wrote:
>   
>> unfamiliar with it, here are the links to the same:
>> http://ebtables.sourceforge.net/br_fw_ia/br_fw_ia.html for the document
>> and http://ebtables.sourceforge.net/br_fw_ia/PacketFlow.png for the
>> picture.
>>     
>
> Use http://jengelh.medozas.de/images/nf-packet-flow.png
>
>   
>> Im trying to understand what happens to a packet which is DROPped in the
>> BROUTING chain of the broute table. If I have understood correctly from
>> the document above, it goes to L3 where the routing subsystem can decide
>> where to send the packet to depending on L3 information in it isn't it?
>>     
>
> In net/core/dev.c, the packet is passed to all "taps". Taps include 
> raw sockets (think tcpdump), but also bridge and the IPvX layers 
> themselves. Each of them basically gets a copy, thus it is important to 
> not have an address on the ethernet interface (so that the IPvX tap 
> ignores it). Only the bridge interface should have an address, because 
> the bridge code will pass it to IPvX on its own.
>
>   
When using a brouter, you actually assign IP addresses to the bridge 
ports (different subnets) instead of the virtual bridge interface 
itself. IP traffic is then DROPped in the BROUTE chain, so it's not 
bridged. See http://ebtables.sourceforge.net/examples/real.html#example1 
for an example usage.

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

