From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: packet flow - ebtables broute DROP target
Date: Thu, 15 Jul 2010 21:26:09 +0200
Message-ID: <4C3F60D1.8040706@pandora.be>
References: <1DB91DF937A4544C81E636468B91C21C06F1EC28@CNSHGSMBS03.ad4.ad.alcatel.com>	 <1DB91DF937A4544C81E636468B91C21C06F1ECAF@CNSHGSMBS03.ad4.ad.alcatel.com>	 <AANLkTil_RodsXwi2y8-tOeLsZ8Cl3TN0WYfsAMrrx-VP@mail.gmail.com> <1279202558.5524.10.camel@aijazbaig1-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: aijazbaig1@gmail.com
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1279202558.5524.10.camel@aijazbaig1-desktop>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Aijaz Baig schreef:
> Hello people,
>
> Im relatively new to the ebtables + iptables firewalling architecture. I
> have read the ebtables and iptables firewall interaction document and
> also seen the GIF specified at the end of the document. For those
> unfamiliar with it, here are the links to the same:
> http://ebtables.sourceforge.net/br_fw_ia/br_fw_ia.html for the document
> and http://ebtables.sourceforge.net/br_fw_ia/PacketFlow.png for the
> picture.
>
> Im trying to understand what happens to a packet which is DROPped in the
> BROUTING chain of the broute table. If I have understood correctly from
> the document above, it goes to L3 where the routing subsystem can decide
> where to send the packet to depending on L3 information in it isn't it?
> So i'm assuming that the first place it should be visible should be the
> PREROUTING chain of the mangle table isn't it? But I tried with a LOG
> target rule matching the criteria I used in constructing the DROP target
> in the broute table's BROUTING chain. 
>
> And then after that I checked the packet counters for both the rules
> viz. the one in the BROUTING chain and the one in the PREROUTING chain
> of the mangle table. The packet did hit the first rule and it is
> dropped. I cannot see it on br0, the bridge interface too. But the
> packet count in the latter rule is 0 which means that the packet didnt
> arrive in the mangle table's
> PREhttp://ebtables.sourceforge.net/br_fw_ia/PacketFlow.pngROUTING chain.
> But this behavior is contrary to what the GIF above shows.
>
> Im rather confused. Please do shed some light on it if people have had
> similar experiences before.
>
>   
Your traffic is probably dropped by the networking code because the 
destination MAC address differs from that of the bridge port. You should 
redirect the traffic with ebtables. See 
http://ebtables.sourceforge.net/examples/basic.html#ex_brouter

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

