From: Pedro Garcia <pedro.netdev@dondevamos.com>
Subject: New target to manage L2 QoS (802.1p) in a no VLAN (i.e home user)
 environment
Date: Fri, 01 Feb 2013 00:17:57 +0100
Message-ID: <1c428f6dcdf8c9907325791f4167ba76@dondevamos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 13.Red-213-97-209.staticIP.rima-tde.net ([213.97.209.13]:44551
	"EHLO smtp1.dondevamos.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab3AaXpg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:45:36 -0500
Received: from localhost ([127.0.0.1] helo=webmail.dondevamos.com)
	by smtp1.dondevamos.com with esmtp (Exim 4.80)
	(envelope-from <pedro.netdev@dondevamos.com>)
	id 1U13OH-00056X-8Z
	for netfilter-devel@vger.kernel.org; Fri, 01 Feb 2013 00:18:00 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

There is pretty good module in the kernel for managing L2 QoS (8021q), 
but it cannot properly manage QoS in an enviroment with no VLANs. 
Effectively, the only way to manage it today is defining VLAN 0 with 
8021q module, but it screws the connectivity as it treats VLAN 0 as a 
differentiated device from the parent one, so i.e. ARP requests come 
thorugh a device but are answered through the other one, etc: it just 
does not work.

If you want to CoS mark packets in VLAN 0 and honour QoS on incoming 
packets, again 8021q module has good ingress and egress priomaps, but as 
commented if we define VLAN 0 it will not work on an normal environment.

After looking at the kernel, 8021q module, and other places, I found no 
clean way to implement this. But the kernel's dev.c alrady handles 
tagging and untagging VLAN 0 packets without the need of 8021q module 
even being loaded, so we only need a way to put into skb->vlan_tci the 
proper info from the skb->priority and vice-versa...

I know iptables (and ARP tables) are aimed at L3, so mangling the L2 
info should be done elsewhere, but ebtables is only for bridging, so I 
went for iptables target anyway. Clean an easy as xtables are 
powerful...

I wrote a xt_L2QOS target module and libxt_L2QOS, working like this:

> iptables -t mangle -A POSTROUTING -o eth-inet -p icmp -j CLASSIFY 
> --set-class 1:14
> iptables -t mangle -A POSTROUTING -o eth-inet -j L2QOS --priomap 
> 1:10,1:11,1:12,1:13,1:14,1:15,1:16,1:17
> ping www.google.es
>> 23:58:19.050551 xx:xx:xx:xx:xx:xx > xx:xx:xx:xx:xx:xx, ethertype 
>> 802.1Q (0x8100), length 102: vlan 0, p 4, ethertype IPv4, (tos 0x0, 
>> ttl 64, id 0, offset 0, flags [DF], proto ICMP (1), length 84)
>> xxx.xxx.xxx.xxx > 173.194.45.87: ICMP echo request, id 19357, seq 6, 
>> length 64

It also works the other way (even though I do not see ingress priority 
to be so useful), and marks incoming packets to be able to filter in 
iptables based on the priority 802.1p tagging. The module refuses to 
work with anything rather than VLAN 0 (we should use 8021p module for 
real VLANs).

Willing to submit it as a patch to the kernel, but only if the fact 
that this is L2 mangling in iptables is well seen (I did not see a clean 
way to do it elsewhere...)

By the way, if you are using a net device with vlan HW acceleration, 
you may need to (just) load 8021q module to get the device accept VLAN 0 
in its HW filter: 8021q module does this, I wrote the patch couple of 
years ago, even if now there is not too much of the original one... O:-)

Regards,
Pedro
