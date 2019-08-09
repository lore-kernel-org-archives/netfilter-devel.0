Return-Path: <SRS0=FL4W=WF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D8FC32756
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 07:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDCE3206DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 07:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfHIHEN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 03:04:13 -0400
Received: from mail.thelounge.net ([91.118.73.15]:23605 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfHIHEN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 03:04:13 -0400
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 464bnj1YykzXYc
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 09:04:09 +0200 (CEST)
To:     netfilter-devel@vger.kernel.org
From:   Reindl Harald <h.reindl@thelounge.net>
Subject: kernel BUG at lib/list_debug.c:47! invalid opcode: 0000 [#1] SMP
 NOPTI
Openpgp: id=9D2B46CDBC140A36753AE4D733174D5A5892B7B8;
 url=https://arrakis-tls.thelounge.net/gpg/h.reindl_thelounge.net.pub.txt
Organization: the lounge interactive design
Message-ID: <c2e5ca37-7039-c420-a359-41c08246d2b1@thelounge.net>
Date:   Fri, 9 Aug 2019 09:04:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: de-CH
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

i know that 5.1.15 was a little old, update after 6 weeks uptime was
originally planned with the 5.2.8 release in the hope it contains the
"netfilter: conntrack: always store window size un-scaled" patch

maybe the root vause is already fixed, upgraded now to 5.2.7

[3723834.867725] kernel BUG at lib/list_debug.c:47!
[3723834.870392] invalid opcode: 0000 [#1] SMP NOPTI
[3723834.872843] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
5.1.15-200.fc29.x86_64 #1
[3723834.876700] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 09/19/2018
[3723834.881939] RIP: 0010:__list_del_entry_valid.cold.1+0x12/0x4c
[3723834.882943] Code: c7 ff 0f 0b 48 89 c1 4c 89 c6 48 c7 c7 f0 6b 11
b9 e8 7c 38 c7 ff 0f 0b 48 89 fe 48 89 c2 48 c7 c7 80 6c 11 b9 e8 68 38
c7 ff <0f> 0b 48 c7 c7 30 6d 11 b9 e8 5a 38 c7 ff 0f 0b 48 89 f2 48 89 fe
[3723834.886123] RSP: 0018:ffff92a4dd2038e8 EFLAGS: 00010246
[3723834.887060] RAX: 000000000000004e RBX: ffff92a4d5fd6000 RCX:
0000000000000000
[3723834.888315] RDX: 0000000000000000 RSI: 00000000000000f6 RDI:
0000000000000300
[3723834.889570] RBP: ffff92a4c5500000 R08: 000000000000048f R09:
0000000000000003
[3723834.890825] R10: 0000000000000000 R11: 0000000000000001 R12:
ffff92a4d5fd6010
[3723834.892082] R13: ffff92a4c6a4bfa8 R14: ffff92a4c55000f8 R15:
ffff92a4c5500000
[3723834.893343] FS:  0000000000000000(0000) GS:ffff92a4dd200000(0000)
knlGS:0000000000000000
[3723834.894758] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[3723834.895859] CR2: 00007fb811913048 CR3: 00000000996da002 CR4:
00000000003606f0
[3723834.897173] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[3723834.898445] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[3723834.899715] Call Trace:
[3723834.900262]  <IRQ>
[3723834.900678]  recent_entry_update+0x52/0xa0 [xt_recent]
[3723834.901619]  recent_mt+0x197/0x37d [xt_recent]
[3723834.902444]  ipt_do_table+0x25f/0x630 [ip_tables]
[3723834.903312]  ? l4proto_manip_pkt+0x299/0x450 [nf_nat]
[3723834.904230]  nf_hook_slow+0x44/0xc0
[3723834.904886]  ip_forward+0x458/0x480
[3723834.905541]  ? ip_defrag.cold.12+0x33/0x33
[3723834.906297]  ip_rcv+0xbc/0xd0
[3723834.906868]  ? ip_rcv_finish_core.isra.19+0x350/0x350
[3723834.907785]  __netif_receive_skb_one_core+0x52/0x70
[3723834.908671]  netif_receive_skb_internal+0x42/0xf0
[3723834.909554]  ? fdb_find_rcu+0xe7/0x160 [bridge]
[3723834.910383]  netif_receive_skb+0x17/0xa0
[3723834.911111]  br_pass_frame_up+0x12f/0x150 [bridge]
[3723834.911995]  ? fdb_find_rcu+0xe7/0x160 [bridge]
[3723834.912826]  br_handle_frame_finish+0x170/0x430 [bridge]
[3723834.913807]  ? nf_confirm+0xcb/0xf0 [nf_conntrack]
[3723834.914682]  ? br_handle_frame_finish+0x430/0x430 [bridge]
[3723834.915690]  br_handle_frame+0x154/0x330 [bridge]
[3723834.916550]  ? ip_output+0x69/0xe0
[3723834.917191]  __netif_receive_skb_core+0x34a/0xc60
[3723834.918051]  ? __build_skb+0x25/0xe0
[3723834.918720]  ? ip_defrag.cold.12+0x33/0x33
[3723834.919477]  ? __build_skb+0x25/0xe0
[3723834.920146]  __netif_receive_skb_one_core+0x36/0x70
[3723834.921033]  netif_receive_skb_internal+0x42/0xf0
[3723834.921897]  napi_gro_receive+0xed/0x150
[3723834.922632]  vmxnet3_rq_rx_complete+0x950/0xe80 [vmxnet3]
[3723834.923606]  vmxnet3_poll_rx_only+0x31/0xa0 [vmxnet3]
[3723834.924521]  net_rx_action+0x149/0x3b0
[3723834.925220]  __do_softirq+0xe3/0x30a
[3723834.925891]  irq_exit+0xeb/0xf0
[3723834.926488]  do_IRQ+0x85/0xd0
[3723834.927058]  common_interrupt+0xf/0xf
[3723834.927740]  </IRQ>
[3723834.928163] RIP: 0010:native_safe_halt+0xe/0x10
[3723834.928991] Code: ff ff 7f c3 65 48 8b 04 25 00 5c 01 00 3e 80 48
02 20 48 8b 00 a8 08 75 c4 eb 80 90 e9 07 00 00 00 0f 00 2d 76 60 46 00
fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d 66 60 46 00 f4 c3 90 90 0f 1f 44 00
[3723834.932213] RSP: 0018:ffffffffb9203e98 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffffdb
[3723834.933578] RAX: ffffffffb89a2410 RBX: 0000000000000000 RCX:
7ff2c5223c3f2f4a
[3723834.934897] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
ffff92a4dd21b4e0
[3723834.936171] RBP: 0000000000000000 R08: ffffb6e0c0957a50 R09:
0000000000000000
[3723834.937440] R10: 0000000000000000 R11: 0000000000000001 R12:
0000000000000000
[3723834.938709] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[3723834.939980]  ? __sched_text_end+0x6/0x6
[3723834.940693]  default_idle+0x1c/0x140
[3723834.941364]  do_idle+0x1e1/0x260
[3723834.942070]  ? do_idle+0x7/0x260
[3723834.942735]  cpu_startup_entry+0x19/0x20
[3723834.943465]  start_kernel+0x4f7/0x517
[3723834.944151]  secondary_startup_64+0xa4/0xb0
[3723834.944922] Modules linked in: nf_conntrack_netlink sch_hfsc bridge
stp llc xt_multiport ipt_REJECT nf_reject_ipv4 iptable_filter
nfnetlink_log xt_NFLOG xt_limit xt_tcpmss xt_connlimit nf_conncount
xt_recent xt_conntrack iptable_mangle xt_CT iptable_raw xt_iprange
xt_NETMAP xt_nat xt_set iptable_nat ip_set_list_set ip_set_hash_ip
ip_set_hash_net ip_set_bitmap_port ip_set nfnetlink nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel vmxnet3 ip_tables
crc32c_intel vmw_pvscsi [last unloaded: inet_diag]
[3723834.958381] ---[ end trace 22f5d74f90a5d340 ]---
[3723834.960984] RIP: 0010:__list_del_entry_valid.cold.1+0x12/0x4c
[3723834.962674] Code: c7 ff 0f 0b 48 89 c1 4c 89 c6 48 c7 c7 f0 6b 11
b9 e8 7c 38 c7 ff 0f 0b 48 89 fe 48 89 c2 48 c7 c7 80 6c 11 b9 e8 68 38
c7 ff <0f> 0b 48 c7 c7 30 6d 11 b9 e8 5a 38 c7 ff 0f 0b 48 89 f2 48 89 fe
[3723834.965917] RSP: 0018:ffff92a4dd2038e8 EFLAGS: 00010246
[3723834.966867] RAX: 000000000000004e RBX: ffff92a4d5fd6000 RCX:
0000000000000000
[3723834.968144] RDX: 0000000000000000 RSI: 00000000000000f6 RDI:
0000000000000300
[3723834.969422] RBP: ffff92a4c5500000 R08: 000000000000048f R09:
0000000000000003
[3723834.970714] R10: 0000000000000000 R11: 0000000000000001 R12:
ffff92a4d5fd6010
[3723834.971990] R13: ffff92a4c6a4bfa8 R14: ffff92a4c55000f8 R15:
ffff92a4c5500000
[3723834.973266] FS:  0000000000000000(0000) GS:ffff92a4dd200000(0000)
knlGS:0000000000000000
[3723834.974697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[3723834.975730] CR2: 00007fb811913048 CR3: 00000000996da002 CR4:
00000000003606f0
[3723834.977050] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[3723834.978323] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[3723834.979600] Kernel panic - not syncing: Fatal exception in interrupt
[3723834.980790] Kernel Offset: 0x37000000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[3723834.982677] Rebooting in 1 seconds..
[3723835.983434] ACPI MEMORY or I/O RESET_REG
