From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: packet flow - ebtables broute DROP target
Date: Fri, 16 Jul 2010 18:54:57 +0200
Message-ID: <4C408EE1.8070105@pandora.be>
References: <1DB91DF937A4544C81E636468B91C21C06F1EC28@CNSHGSMBS03.ad4.ad.alcatel.com>	 <1DB91DF937A4544C81E636468B91C21C06F1ECAF@CNSHGSMBS03.ad4.ad.alcatel.com>	 <AANLkTil_RodsXwi2y8-tOeLsZ8Cl3TN0WYfsAMrrx-VP@mail.gmail.com>	 <1279202558.5524.10.camel@aijazbaig1-desktop>	 <alpine.LSU.2.01.1007151616400.7169@obet.zrqbmnf.qr>	 <4C3F60E9.3090106@pandora.be> <1279267539.4086.28.camel@aijazbaig1-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: aijazbaig1@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:46309 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab0GPQzI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:55:08 -0400
In-Reply-To: <1279267539.4086.28.camel@aijazbaig1-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Aijaz Baig schreef:
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
>   
This is explained at the link I gave you. If something is unclear in my 
description on the website, feel free to let me know.
Try it out with the example rules I mention on that site and adapt to 
your situation from there. In the future, please explicitly list your 
complete test setup, including a dump of the firewall tables.

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

