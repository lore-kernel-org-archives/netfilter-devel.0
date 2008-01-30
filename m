From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Re: kernel crash
Date: Wed, 30 Jan 2008 03:18:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801300312080.22578@fbirervta.pbzchgretzou.qr>
References: <479FDC8F.01DE1E.20333@m5-84.163.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	"Pine.LNX.4.64.0801291852070.1490"
	<Pine.LNX.4.64.0801291852070.14907@fbirervta.pbzchgretzou.qr>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: fenglg <flg2932946@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59342 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYA3CSc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:18:32 -0500
In-Reply-To: <479FDC8F.01DE1E.20333@m5-84.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 30 2008 09:56, fenglg wrote:
>>>>
>>>> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000010
>>>> EIP is at br_nf_pre_routing_finish+0x1d/0x340
>>>> eax: c16e7980   ebx: 00000000   ecx: 00000001   edx: c16e7980
>>>> esi: de4cb020   edi: c0456520   ebp: de8d2000   esp: c03fbce4
>>>> Code: 10 01 e9 7a ff ff ff 8d b4 26 00 00 00 00 55 57 56 53 81 ec c0 00 00 00 8b
>>>> 94 24 d4 00 00 00 8b 9a 80 00 00 00 8b 6a 14 8b 72 20 <8b> 43 10 a8 01 74 14 0f
>>>> b6 42 75 24 f8 0c 03 88 42 75 8b 43 10
>>> 
>= = = = = = = = = = = = = = = = = = = =
>Call Trace:           
> [<c02f0f53>] icmp_packet+0xc3/0xd0                                   
> [<e081854b>] ip_nat_fn+0x7b/0x1f0 [iptable_nat]                                                
> [<c030f140>] br_nf_pre_routing_finish+0x0/0x340 		
>
>I think there is some wrong in icmp_packet, the icmp_packet is used in ip_conntrack_in.	
>
The stack trace is just junk. In the report you see "Code: ... <8b>
43 10 a8 01" and so on, which is:

	8b 43 10	mov eax, [ebx+0x10]

which means we have something like a pointer ebx and try to access
a members at offset 0x10. Then there is

	EIP is at br_nf_pre_routing_finish+0x1d

which gives us an approximate hint where in the C source code the
bug is. In that function, the "nf_bridge" variable has a member
at offset 0x10 (nf_bridge->mask), and +0x1d is near the top of
the function, which is why I believe it is

>>> 	static int br_nf_pre_routing_finish(struct sk_buff *skb)
>>> 	{
>>> 	        struct net_device *dev = skb->dev;
>>> 	        struct iphdr *iph = ip_hdr(skb);
>>> 	        struct nf_bridge_info *nf_bridge = skb->nf_bridge;
>>> 	        int err;
>>> 
>>> boom->		if (nf_bridge->mask & BRNF_PKT_TYPE) {

that line. From 8b 43 10 we see "[ebx+0x10]"; and from the register
dump we have "ebx: 00000000" which means that nf_bridge = NULL.

Forget about the stack trace, it's hardly ever accurate :-)
