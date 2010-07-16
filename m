From: Payam Chychi <pchychi@gmail.com>
Subject: Re: packet flow - ebtables broute DROP target
Date: Fri, 16 Jul 2010 19:06:28 +0200
Message-ID: <F120B598-C3AD-4C3E-A99F-AB8D2212217B@gmail.com>
References: <1DB91DF937A4544C81E636468B91C21C06F1EC28@CNSHGSMBS03.ad4.ad.alcatel.com> <1DB91DF937A4544C81E636468B91C21C06F1ECAF@CNSHGSMBS03.ad4.ad.alcatel.com> <AANLkTil_RodsXwi2y8-tOeLsZ8Cl3TN0WYfsAMrrx-VP@mail.gmail.com> <1279202558.5524.10.camel@aijazbaig1-desktop> <alpine.LSU.2.01.1007151616400.7169@obet.zrqbmnf.qr> <4C3F60E9.3090106@pandora.be> <1279267539.4086.28.camel@aijazbaig1-desktop>
Mime-Version: 1.0 (iPhone Mail 8A293)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Jan Engelhardt <jengelh@medozas.de>,
	"netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "aijazbaig1@gmail.com" <aijazbaig1@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36751 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0GPRG4 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 13:06:56 -0400
In-Reply-To: <1279267539.4086.28.camel@aijazbaig1-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hey,

how are u checking the table? make sure u are looking at the NAT table and not input or forwarding.

Regards,
--
Payam Tarverdyan Chychi
Network Engineer

Sent from my iPhone

On 2010-07-16, at 10:05 AM, Aijaz Baig <aijazbaig1@gmail.com> wrote:

> Hello Bart and Jan,
> 
> Sorry for the belated reply. Im in India so the time gaps makes it bad.
> Thank you for your great inputs. I would surely consider them now. Thank
> you Jan for letting us know you guys are writing a book on netfilter.
> Lord knows we need it. More and more companies across the globe are
> using linux more and more now. This would be of immense help to
> academicians and professionals alike.
> 
> Ive got 2 linux boxes, one virtual and one real. The real one has a eth0
> interface which connects to my LAN. It's vmnet8 interface is behind the
> virtual linux box's eth0 interface i.e. the latter is the former's
> gateway. The virtual box has 3 interfaces eth0, eth1 and eth2. Out of
> which eth0 and eth1 are bridged and enslaved to br0. eth2 connects to
> the same LAN as does my real box's eth0. I have added a static route for
> a PC in my outer LAN to force the traffic to go through vmnet8.
> 
> Now when I DROP packets for the target PC in the broute table, the
> problem that I described above happens. I did what was told to be done
> as shown the basic brouter example. But still..zilch..nothing seemed to
> be working. 
> 
> To be specific, I added a rule:
> ebtables -t broute -A BROUTING -p 0x806 --d$MAC_OF_eth0 -j DROP 
> to allow the arp replies to arrive on eth0 and not on br0. But even
> after that it didn't work. Even the packet count for this new rule was
> zero all the time so I guess something was suspicious here.
> 
> Could someone, bart maybe, let me know what it means by his quote: "Your
> traffic is probably dropped by the networking code because the 
> destination MAC address differs from that of the bridge port."
> 
> May be I don't really know ARP works to infer how such a rule would be
> helpful in the first place.
> 
> I am keen to hear frm you guys and once again, thank you for your input
> and such wonderful open source software that would put the big guys out
> there to shame.
> 
> Regards,
> Aijaz
> 
> On Thu, 2010-07-15 at 21:26 +0200, Bart De Schuymer wrote: 
>> Jan Engelhardt schreef:
>>> On Thursday 2010-07-15 16:02, Aijaz Baig wrote:
>>> 
>>>> unfamiliar with it, here are the links to the same:
>>>> http://ebtables.sourceforge.net/br_fw_ia/br_fw_ia.html for the document
>>>> and http://ebtables.sourceforge.net/br_fw_ia/PacketFlow.png for the
>>>> picture.
>>>> 
>>> 
>>> Use http://jengelh.medozas.de/images/nf-packet-flow.png
>>> 
>>> 
>>>> Im trying to understand what happens to a packet which is DROPped in the
>>>> BROUTING chain of the broute table. If I have understood correctly from
>>>> the document above, it goes to L3 where the routing subsystem can decide
>>>> where to send the packet to depending on L3 information in it isn't it?
>>>> 
>>> 
>>> In net/core/dev.c, the packet is passed to all "taps". Taps include 
>>> raw sockets (think tcpdump), but also bridge and the IPvX layers 
>>> themselves. Each of them basically gets a copy, thus it is important to 
>>> not have an address on the ethernet interface (so that the IPvX tap 
>>> ignores it). Only the bridge interface should have an address, because 
>>> the bridge code will pass it to IPvX on its own.
>>> 
>>> 
>> When using a brouter, you actually assign IP addresses to the bridge 
>> ports (different subnets) instead of the virtual bridge interface 
>> itself. IP traffic is then DROPped in the BROUTE chain, so it's not 
>> bridged. See http://ebtables.sourceforge.net/examples/real.html#example1 
>> for an example usage.
>> 
>> cheers,
>> Bart
>> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
