From: Patrick McHardy <kaber@trash.net>
Subject: Re: How does iptables classify change skb priority
Date: Tue, 01 Feb 2011 17:36:27 +0100
Message-ID: <4D48368B.6050906@trash.net>
References: <AANLkTimK=LsDOGJGFSFNxH_zC-zDWv=Z3FpLZAPt1g0E@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Bhanu CV <vbhanu.mailinglists@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45448 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1BAQgc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:36:32 -0500
In-Reply-To: <AANLkTimK=LsDOGJGFSFNxH_zC-zDWv=Z3FpLZAPt1g0E@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 01.02.2011 17:31, schrieb Bhanu CV:
> Hi,
> 
> I am trying to change the skb priority of the packets going out to a
> particular destination. Then I use vlan set_egress_map to change the
> vlan priority of the packet. This works as I want it to, the confusing
> part is I do not know why it works!
> 
> I use the following two commands:
> 
> change the skb->priority (?) for the packets that I am interested in to 3:
> iptables -t mangle -A POSTROUTING -d 192.168.10.75 -j CLASSIFY --set-class 0:3
> 
> change the vlan priority of the packet leaving over the vlan
> vconfig set_egress_map eth4.2 3 3
> 
> This does send a packet on the wire with MAC layer priority of 3,
> which is what I want. What I am trying to understand is the action
> that iptables is taking. I do not have any class under the root qdisc
> on eth4. The root qdisc has handle 0:
> 
> It would be great if someone could explain how iptables is classifying
> the packet in a way which changes the skb->priority of the packet.

It simply changes the skb->priority value, which used by the VLAN
driver to map to VLAN proprities. This is done by the VLAN driver
internally and unrelated to qdiscs.
