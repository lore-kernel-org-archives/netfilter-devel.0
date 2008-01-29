From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: kernel crash
Date: Tue, 29 Jan 2008 18:55:16 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291852070.14907@fbirervta.pbzchgretzou.qr>
References: <479F0419.0057A9.30859@m12-15.163.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>, kaber@trash.net
To: fenglg <flg2932946@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54144 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbYA2RzR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:55:17 -0500
In-Reply-To: <479F0419.0057A9.30859@m12-15.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 29 2008 18:32, fenglg wrote:
>
>I use linux-2.6.18, and there is a bridge with eth0 and eth1. The eth0 and
>eth1 connetcswitchs which use vlan trunk(802.1q). When i run system some
>hours, the kernel is crash, anyone can help me.
>
>BUG: unable to handle kernel NULL pointer dereference at virtual address 00000010
>EIP is at br_nf_pre_routing_finish+0x1d/0x340
>eax: c16e7980   ebx: 00000000   ecx: 00000001   edx: c16e7980
>esi: de4cb020   edi: c0456520   ebp: de8d2000   esp: c03fbce4
>Code: 10 01 e9 7a ff ff ff 8d b4 26 00 00 00 00 55 57 56 53 81 ec c0 00 00 00 8b
> 94 24 d4 00 00 00 8b 9a 80 00 00 00 8b 6a 14 8b 72 20 <8b> 43 10 a8 01 74 14 0f
> b6 42 75 24 f8 0c 03 88 42 75 8b 43 10

Thanks for the report.

All signs point to skb->nf_bridge being NULL.

	static int br_nf_pre_routing_finish(struct sk_buff *skb)
	{
	        struct net_device *dev = skb->dev;
	        struct iphdr *iph = ip_hdr(skb);
	        struct nf_bridge_info *nf_bridge = skb->nf_bridge;
	        int err;

boom->		if (nf_bridge->mask & BRNF_PKT_TYPE) {


Hm... now what? :)
