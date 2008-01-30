From: "fenglg" <flg2932946@163.com>
Subject: Re: Re: kernel crash
Date: Wed, 30 Jan 2008 10:15:55 +0800
Message-ID: <479FDD9E.01DEAD.20333@m5-84.163.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Cc: "jengelh" <jengelh@computergmbh.de>,
	"netfilter-devel" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m5-84.163.com ([202.108.5.84]:42224 "HELO m5-84.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750837AbYA3CPJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:15:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy

	

======= 2008-01-30 01:59:03 =======

>Jan Engelhardt wrote:
>> On Jan 29 2008 18:32, fenglg wrote:
>>> I use linux-2.6.18, and there is a bridge with eth0 and eth1. The eth0 and
>>> eth1 connetcswitchs which use vlan trunk(802.1q). When i run system some
>>> hours, the kernel is crash, anyone can help me.
>>>
>>> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000010
>>> EIP is at br_nf_pre_routing_finish+0x1d/0x340
>>> eax: c16e7980   ebx: 00000000   ecx: 00000001   edx: c16e7980
>>> esi: de4cb020   edi: c0456520   ebp: de8d2000   esp: c03fbce4
>>> Code: 10 01 e9 7a ff ff ff 8d b4 26 00 00 00 00 55 57 56 53 81 ec c0 00 00 00 8b
>>> 94 24 d4 00 00 00 8b 9a 80 00 00 00 8b 6a 14 8b 72 20 <8b> 43 10 a8 01 74 14 0f
>>> b6 42 75 24 f8 0c 03 88 42 75 8b 43 10
>> 
>> Thanks for the report.
>> 
>> All signs point to skb->nf_bridge being NULL.
>> 
>> 	static int br_nf_pre_routing_finish(struct sk_buff *skb)
>> 	{
>> 	        struct net_device *dev = skb->dev;
>> 	        struct iphdr *iph = ip_hdr(skb);
>> 	        struct nf_bridge_info *nf_bridge = skb->nf_bridge;
>> 	        int err;
>> 
>> boom->		if (nf_bridge->mask & BRNF_PKT_TYPE) {
>> 
>> 
>> Hm... now what? :)
>
>
>2.6.18 and 2.6.24 differ significantly in how the bridging stuff
>is handled, so the preferred way would be to try to reproduce this
>with 2.6.24. Debugging a 18 month old kernel doesn't seem too
>useful unless we know the problem is still present.

= = = = = = = = = = = = = = = = = = = =

Call Trace:           
 [<c02f0f53>] icmp_packet+0xc3/0xd0                                   
 [<e081854b>] ip_nat_fn+0x7b/0x1f0 [iptable_nat]                                                
 [<c030f140>] br_nf_pre_routing_finish+0x0/0x340 		

I think there is some wrong in icmp_packet, the icmp_packet is used in ip_conntrack_in.	I will try linux-2.6.24 later. Thanks!
			



