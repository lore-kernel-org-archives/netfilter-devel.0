From: Matteo Croce <technoboy85@gmail.com>
Subject: nftables null pointer
Date: Tue, 5 Aug 2014 10:01:56 +0200
Message-ID: <CAFnufp1157iUqOpax6Po-PZivC_7TQSeQqtmJnnpNLVm3hzH9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:52565 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbaHEICh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:02:37 -0400
Received: by mail-ob0-f176.google.com with SMTP id wo20so406645obc.7
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Aug 2014 01:02:36 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

with vanilla linux 3.16.0 and  ntf 0.3:

# nft list table nat
Killed
nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: [<d0b4beef>] nf_tables_fill_chain_info+0x27f/0x350 [nf_tables]
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: nft_nat nft_meta nft_chain_nat_ipv4 nf_tables_ipv4
nf_tables nfnetlink ctr ccm tun sit tunnel4 ip_tunnel ipt_MASQUERADE
xt_TCPMSS xt_tcpudp xt_nat xt_multiport iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter
ip_tables x_tables geodewdt ppp_async crc_ccitt ppp_generic slhc
bridge stp llc ftdi_sio usbserial ohci_pci arc4 ath9k ohci_hcd
ath9k_common ath9k_hw ehci_pci ath ehci_hcd mac80211 cfg80211
geode_aes usbcore firmware_class usb_common nls_base via_rhine
geode_rng rng_core mii gpio_cs5535 lm90 hwmon cs5535_clockevt
cs5535_mfd mfd_core cs5535_mfgpt scx200_acb i2c_core autofs4
CPU: 0 PID: 9836 Comm: nft Not tainted 3.16.0-alix #1
task: cf91c3e0 ti: c85a2000 task.ti: c85a2000
EIP: 0060:[<d0b4beef>] EFLAGS: 00010046 CPU: 0
EIP is at nf_tables_fill_chain_info+0x27f/0x350 [nf_tables]
EAX: 00000000 EBX: cd4820c0 ECX: 00000000 EDX: 00000000
ESI: cc3e8fc0 EDI: c85a3afc EBP: cc3e8fc0 ESP: c85a3ab8
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
CR0: 8005003b CR2: 00000008 CR3: 03b24000 CR4: 00000090
Stack:
 d0b10024 00000004 00000002 c85a3aec 00000000 00000000 01000000 00000000
 03000000 00000000 0f690000 00000000 9b010000 00000000 00000000 00000000
 00000000 cfb794cc c39135bc cc3b0840 00000001 d0b4c1b7 00000003 00000002
Call Trace:
 [<d0b4c1b7>] ? nf_tables_dump_chains+0xf7/0x190 [nf_tables]
 [<c12078f8>] ? netlink_dump+0x108/0x280
 [<c1208099>] ? __netlink_dump_start+0x189/0x1e0
 [<c1208099>] ? __netlink_dump_start+0x189/0x1e0
 [<d0b4c3ae>] ? nf_tables_getchain+0x15e/0x1a0 [nf_tables]
 [<d0b4c0c0>] ? nf_tables_chain_notify+0x100/0x100 [nf_tables]
 [<d0b4c250>] ? nf_tables_dump_chains+0x190/0x190 [nf_tables]
 [<d0c36379>] ? nfnetlink_rcv_msg+0x1d9/0x1f0 [nfnetlink]
 [<d0c361a0>] ? nfnetlink_bind+0x50/0x50 [nfnetlink]
 [<c120991e>] ? netlink_rcv_skb+0x8e/0xb0
 [<c1208f83>] ? netlink_unicast+0xe3/0x160
 [<c12092e9>] ? netlink_sendmsg+0x2e9/0x740
 [<c11d2162>] ? sock_sendmsg+0x62/0x80
 [<c107367c>] ? __alloc_pages_nodemask+0xdc/0x760
 [<c11d4239>] ? SYSC_sendto+0xd9/0x120
 [<c11d62fb>] ? sock_init_data+0x6b/0x1c0
 [<c1205997>] ? __netlink_create+0x77/0xd0
 [<c11d4bfb>] ? __sys_recvmsg+0x4b/0x90
 [<c11d5742>] ? SYSC_socketcall+0x892/0xa60
 [<c1087ef4>] ? do_set_pte+0x74/0xb0
 [<c106cb9f>] ? filemap_map_pages+0x28f/0x2a0
 [<c108813b>] ? do_read_fault.isra.113+0x20b/0x260
 [<c108882e>] ? handle_mm_fault+0x36e/0x6a0
 [<c1013e51>] ? __do_page_fault+0x1c1/0x480
 [<c108cebc>] ? do_mmap_pgoff+0x29c/0x380
 [<c107f8eb>] ? vm_mmap_pgoff+0x5b/0x80
 [<c11d59dd>] ? SyS_socketcall+0xd/0x10
 [<c1290d9d>] ? sysenter_do_call+0x12/0x12
Code: 3c 24 8d 48 01 89 d8 e8 50 41 62 f0 85 c0 0f 85 2f fe ff ff 8b
7c 24 68 b9 04 00 00 00 8b 57 fc 8d 7c 24 34 89 7c 24 0c f3 ab fa <8b>
7a 08 8b 6a 0c 8b 02 8b 52 04 fb 01 7c 24 3c 8b bb 98 00 00
EIP: [<d0b4beef>] nf_tables_fill_chain_info+0x27f/0x350 [nf_tables]
SS:ESP 0068:c85a3ab8
CR2: 0000000000000008
---[ end trace 3ca575d06b5960d9 ]---

-- 
Matteo Croce
OpenWrt Developer
