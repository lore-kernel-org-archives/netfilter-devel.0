From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Bridge-nf and iptables SNAT
Date: Sun, 23 Jun 2013 22:09:38 +0200
Message-ID: <51C75602.8000507@pandora.be>
References: <CAAobQ8eDxDYaewZM2AmPK0MnbNnamXOnOmtJjsH=4CD90Hct-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Tsachi <tsachi.kimel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:43230 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FWUJp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Jun 2013 16:09:45 -0400
In-Reply-To: <CAAobQ8eDxDYaewZM2AmPK0MnbNnamXOnOmtJjsH=4CD90Hct-A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 18/06/2013 16:11, Tsachi schreef:
> The problem is that enabling bridge-nf-call-iptables, has an effect on
> bridge traffic throughput:
> 96Mb/s when disabled.
> 70Mb/s when enabled.
>
> First question:
> When I check the same without bridge (routing + SNAT) throughput was 86Mb/s.
> When bridge-nf-call-iptables is enabled, packets are going through L2
> bridge code as well as L3 netfilter code, but, why it has such an
> effects on the throughput?
I think to answer that will require performance profiling of the code, 
since as far as I know it's never happened.
Here are some thoughts:
- W.r.t. ebtables, the performance impact of let's say a FORWARD chain 
rule is bound to be higher for ebtables compared to iptables because it 
will be called more for the same traffic. Fragmented IP packets, f.e., 
will be processed one by one by the FORWARD chain (if 
bridge-nf-call-iptables is disabled) while an iptables FORWARD rule 
would only be called once. Flooded packets are seen multiple times by 
some ebtables chains (once for each output device). In the bridge-nf 
case, these flooded packets are also seen multiple time by some iptables 
chains.
- The function call stack is bigger in the bridge-nf compared to the 
standard iptables case because we have the combination of NF_HOOKs for 
NFPROTO_BRIDGE and NFPROTO_IPV4. NF_HOOK_THRESH adds to the equation. 
Note that due to the design of netfilter, the call stack can grow quite 
big because the NF_HOOK okfn is executed up the call stack.

> Second question:
> In order to share an IP (with iptables SNAT, without enabling
> bridge-nf-call-iptables) ,
> One solution I thought about, is to write a new ebtable module (used
> in the brouting chain) which looks for the packet in the conntrack.
> In case it finds it, Drop (routed) the packet, thus going through the
> iptables code, if not found - Accept it (bridged).
> This means some skb header work and conntrack searching for every
> packet, do you think is a good approach?
What you could also try is making something based on br_netfilter.c that 
only lets iptables connection tracking and POSTROUTING see the packets.
If you want full performance also for the traffic originating from the 
bridge, it's best if you do your magic using brouting: traffic that 
enters the IP stack through br0 is queued once more in the kernel than 
traffic that enters the IP stack through one of the bridge ports (by 
brouting the packet).

cheers,
Bart

