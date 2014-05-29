From: Vincent Tondellier <tondellier+ml.nfdev@dosisoft.fr>
Subject: Re: OOPS NULL pointer dereference in nf_nat_setup_info+0x471 (reproductible, 3.14.4)
Date: Thu, 29 May 2014 18:41:55 +0200
Message-ID: <9874911.sZTeTrmm52@quad>
References: <4667198.VVkvcgzEe7@luna>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from achille.dosisoft.fr ([46.105.6.253]:52926 "EHLO
	achille.dosisoft.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaE2QmI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 12:42:08 -0400
Received: from gaia.dosisoft.fr (unknown [10.16.64.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.dosisoft.fr", Issuer "DOSIsoft Internal webservices CA" (not verified))
	by achille.dosisoft.fr (Postfix) with ESMTPS id 3gfZSX4LN0z7q0T
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2014 18:42:04 +0200 (CEST)
Received: from tonton.team1664.org (unknown [IPv6:2001:41d0:fc86:1201:8982:5a7a:d37d:a069])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: tondellier)
	by gaia.dosisoft.fr (Postfix) with ESMTPSA id 3gfZSX11b7z8b
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2014 18:42:04 +0200 (CEST)
In-Reply-To: <4667198.VVkvcgzEe7@luna>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have a minimal test case for this bug (tested with kvm/qemu).

With this network config:

pptp_client <==> GW <=NAT=> pptp_server

On the GW (one interface, two IPs):

iptables -t raw -A PREROUTING -p tcp -m tcp --dport 1723 -j CT --helper pptp
iptables -A FORWARD -m state --state RELATED -p gre -m helper --helper pptp -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

sysctl -w net.ipv4.ip_forward=1
sysctl -w net.netfilter.nf_conntrack_helper=0
sysctl -w net.netfilter.nf_conntrack_acct=1

And try to connect the pptp client. Instant oops.

Reproduced on:
3.12.9-1~bpo70+1
3.13.10-1~bpo70+1
3.14.4-1~bpo70+1

Working:
3.11.10-1~bpo70+1

I don't have the time to bisect this now, I will try next week, if needed.

Backtrace on kvm:

[  617.843493] RIP: 0010:[<ffffffffa044ec41>]  [<ffffffffa044ec41>] nf_nat_setup_info+0x471/0x890 [nf_nat]
[  617.843493] RSP: 0018:ffff88003fc03978  EFLAGS: 00010246
[  617.843493] RAX: 0000000000000000 RBX: ffff880036f1a3c8 RCX: 0000000000000000
[  617.843493] RDX: ffff880000072b80 RSI: 00000000fc9c9c9b RDI: ffffffffa0451430
[  617.843493] RBP: 00000000000014a9 R08: ffffffff81886f80 R09: ffff880000072b80
[  617.843493] R10: ffff88003fc03958 R11: ffff88003ac50000 R12: 0000000000000000
[  617.843493] R13: ffff88003fc039d8 R14: 0000000000000000 R15: 0000000000000000
[  617.843493] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[  617.843493] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  617.843493] CR2: 0000000000000010 CR3: 0000000036c00000 CR4: 00000000001406f0
[  617.843493] Stack:
[  617.843493]  0000000000000003 ffffffffa0450280 ffffffff81886f80 ffffffffa045a060
[  617.843493]  ffffffffa045a068 ffffffffa0450290 ffffffff81476c2c 00000000017aa8c0
[  617.843493]  0000000000000000 0142420a00025ad1 0000000000000000 0006bb0600000000
[  617.843493] Call Trace:
[  617.843493]  <IRQ> 
[  617.843493]  [<ffffffff81476c2c>] ? fib_table_lookup+0x2bc/0x350
[  617.843493]  [<ffffffffa045e1b2>] ? masquerade_tg+0xf2/0x130 [ipt_MASQUERADE]
[  617.843493]  [<ffffffffa03f7260>] ? ipt_do_table+0x350/0x610 [ip_tables]
[  617.843493]  [<ffffffffa0454368>] ? nf_nat_ipv4_local_fn+0x58/0x120 [iptable_nat]
[  617.843493]  [<ffffffff81438840>] ? ip_forward_options+0x200/0x200
[  617.843493]  [<ffffffffa0454214>] ? nf_nat_ipv4_fn+0x194/0x290 [iptable_nat]
[  617.843493]  [<ffffffff8143a1f0>] ? ip_fragment+0x830/0x830
[  617.843493]  [<ffffffffa0454488>] ? nf_nat_ipv4_out+0x58/0x100 [iptable_nat]
[  617.843493]  [<ffffffff8142ebf6>] ? nf_iterate+0x86/0xc0
[  617.843493]  [<ffffffff81436e40>] ? ip_frag_mem+0x40/0x40
[  617.843493]  [<ffffffff8143a1f0>] ? ip_fragment+0x830/0x830
[  617.843493]  [<ffffffff8142eca7>] ? nf_hook_slow+0x77/0x150
[  617.843493]  [<ffffffff8143a1f0>] ? ip_fragment+0x830/0x830
[  617.843493]  [<ffffffff8143af2a>] ? ip_output+0x7a/0x90
[  617.843493]  [<ffffffff813fe293>] ? __netif_receive_skb_core+0x643/0x7c0
[  617.843493]  [<ffffffff813fe4aa>] ? netif_receive_skb_internal+0x1a/0x80
[  617.843493]  [<ffffffffa0105515>] ? virtnet_poll+0x4b5/0x7fc [virtio_net]
[  617.843493]  [<ffffffff810c4eee>] ? ktime_get+0x4e/0xe0
[  617.843493]  [<ffffffff813ff9a9>] ? net_rx_action+0x119/0x230
[  617.843493]  [<ffffffff810b8b41>] ? handle_irq_event_percpu+0x91/0x210
[  617.843493]  [<ffffffff81069a9e>] ? __do_softirq+0xee/0x2f0
[  617.843493]  [<ffffffff81069ebe>] ? irq_exit+0x7e/0xa0
[  617.843493]  [<ffffffff81017211>] ? do_IRQ+0x61/0x110
[  617.843493]  [<ffffffff814f162d>] ? common_interrupt+0x6d/0x6d
