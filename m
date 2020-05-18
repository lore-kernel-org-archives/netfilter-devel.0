Return-Path: <SRS0=f4Jo=7A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59416C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 15:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3654F20758
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 15:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgERPYK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 May 2020 11:24:10 -0400
Received: from mail.thelounge.net ([91.118.73.15]:18651 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgERPYJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 May 2020 11:24:09 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49QjTy3XQmzXR1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2020 17:24:06 +0200 (CEST)
To:     netfilter-devel@vger.kernel.org
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: kernel BUG at lib/list_debug.c:45!
Message-ID: <ef399625-d1c5-7ac2-e461-168fd43c4c67@thelounge.net>
Date:   Mon, 18 May 2020 17:24:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

the first kernel crash for a year or so

for now i disabled "gro" again on wan1, wan2 and the bridge device which
i had enabled in the past few weeks after add wiregaurd to the mix

xt_recent and xt_set can only be chains limited to the interface "wan"
doing ratelimits in "-t mangle"

thanks to vmware serial console this time there are infos

https://bugzilla.kernel.org/show_bug.cgi?id=207773

[226832.456068] kernel BUG at lib/list_debug.c:45!
[226832.510172] invalid opcode: 0000 [#1] SMP NOPTI
[226832.512592] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
5.6.13-200.fc31.x86_64 #1
[226832.516351] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 12/12/2018
[226832.518891] RIP: 0010:__list_del_entry_valid.cold+0xf/0x55
[226832.519859] Code: c3 ff 0f 0b 48 89 d1 4c 89 c6 4c 89 ca 48 c7 c7 c0
2a 3d 92 e8 15 c2 c3 ff 0f 0b 48 89 fe 48 c7 c7 50 2b 3d 92 e8 04 c2 c3
ff <0f> 0b 48 c7 c7 00 2c 3d 92 e8 f6 c1 c3 ff 0f 0b 48 89 f2 48 89 fe
[226832.523046] RSP: 0018:ffffaad240003918 EFLAGS: 00010286
[226832.523968] RAX: 000000000000004e RBX: ffff9d4a0b19a000 RCX:
0000000000000000
[226832.525205] RDX: ffff9d4a1d427c80 RSI: ffff9d4a1d419cc8 RDI:
0000000000000300
[226832.526444] RBP: ffff9d4a03b00000 R08: 0000000000000464 R09:
0000000000000003
[226832.527689] R10: 0000000000000000 R11: 0000000000000001 R12:
ffff9d4a0b19a010
[226832.528927] R13: ffff9d4a08c8c000 R14: ffff9d4a03b000f8 R15:
ffff9d4a03b00000
[226832.530165] FS:  0000000000000000(0000) GS:ffff9d4a1d400000(0000)
knlGS:0000000000000000
[226832.531560] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[226832.532589] CR2: 000055d7057581a8 CR3: 0000000098fe0003 CR4:
00000000003606f0
[226832.533889] Call Trace:
[226832.534377]  <IRQ>
[226832.534776]  recent_entry_update+0x52/0xa0 [xt_recent]
[226832.535690]  recent_mt+0x167/0x328 [xt_recent]
[226832.536488]  ? set_match_v4+0x96/0xb0 [xt_set]
[226832.537407]  ipt_do_table+0x24f/0x610 [ip_tables]
[226832.538277]  ? ipt_do_table+0x33e/0x610 [ip_tables]
[226832.539146]  ? l4proto_manip_pkt+0xde/0x440 [nf_nat]
[226832.540049]  ? ip_route_input_rcu+0x40/0x280
[226832.540831]  nf_hook_slow+0x40/0xb0
[226832.541477]  ip_forward+0x424/0x450
[226832.542116]  ? ip_defrag.cold+0x37/0x37
[226832.542814]  ip_rcv+0x9c/0xb0
[226832.543367]  ? ip_rcv_finish_core.isra.0+0x410/0x410
[226832.544251]  __netif_receive_skb_one_core+0x60/0x70
[226832.545123]  netif_receive_skb+0x36/0x130
[226832.545851]  br_pass_frame_up+0x113/0x140 [bridge]
[226832.546708]  ? fdb_find_rcu+0xe2/0x140 [bridge]
[226832.547522]  br_handle_frame_finish+0x179/0x440 [bridge]
[226832.548460]  ? ip_forward+0x348/0x450
[226832.549126]  ? br_handle_frame_finish+0x440/0x440 [bridge]
[226832.550094]  br_handle_frame+0x227/0x350 [bridge]
[226832.550931]  ? ip_sublist_rcv_finish+0x57/0x70
[226832.551733]  ? ip_sublist_rcv+0x185/0x1f0
[226832.552457]  ? br_handle_frame_finish+0x440/0x440 [bridge]
[226832.553424]  __netif_receive_skb_core+0x2b3/0xf50
[226832.554266]  ? __build_skb+0x1f/0x50
[226832.554921]  ? vmxnet3_msix_rx+0x4a/0x60 [vmxnet3]
[226832.555775]  __netif_receive_skb_list_core+0x128/0x2c0
[226832.556684]  ? dev_gro_receive+0x5e5/0x680
[226832.557426]  netif_receive_skb_list_internal+0x1bc/0x2d0
[226832.558366]  ? vmxnet3_rq_rx_complete+0xa29/0xef0 [vmxnet3]
[226832.559353]  gro_normal_list.part.0+0x19/0x40
[226832.560133]  napi_complete_done+0x86/0x130
[226832.560873]  vmxnet3_poll_rx_only+0x7b/0xa0 [vmxnet3]
[226832.561774]  net_rx_action+0x138/0x390
[226832.562468]  __do_softirq+0xee/0x2ff
[226832.563142]  irq_exit+0xe9/0xf0
[226832.563722]  do_IRQ+0x55/0xe0
[226832.564274]  common_interrupt+0xf/0xf
[226832.564941]  </IRQ>
[226832.565347] RIP: 0010:native_safe_halt+0xe/0x10
[226832.566159] Code: cc cc cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00
0f 00 2d a6 a7 5f 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 96 a7 5f 00 fb
f4 <c3> cc 0f 1f 44 00 00 41 54 55 53 e8 62 b7 74 ff 65 8b 2d 7b 41 60
[226832.569345] RSP: 0018:ffffffff92603e98 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffffdb
[226832.570664] RAX: ffffffff91a0ddf0 RBX: 0000000000000000 RCX:
7fffffffffffffff
[226832.571911] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
ffff9d4a1d41ea00
[226832.573159] RBP: 0000000000000000 R08: 00000066a1715ded R09:
0000000000000000
[226832.574405] R10: 000000000000000f R11: 0000000000000000 R12:
ffffffff92614840
[226832.575651] R13: 0000000000000000 R14: 0000000000000000 R15:
ffffffff92614840
[226832.576904]  ? __cpuidle_text_start+0x8/0x8
[226832.577677]  ? tick_nohz_idle_stop_tick+0x5f/0xc0
[226832.578515]  default_idle+0x1a/0x140
[226832.579172]  do_idle+0x1de/0x260
[226832.579768]  cpu_startup_entry+0x19/0x20
[226832.580501]  start_kernel+0x7a8/0x7b5
[226832.581177]  secondary_startup_64+0xb6/0xc0
[226832.581932] Modules linked in: sch_hfsc wireguard curve25519_x86_64
libchacha20poly1305 chacha_x86_64 poly1305_x86_64 ip6_udp_tunnel
udp_tunnel libblake2s blake2s_x86_64 libcurve25519_generic libchacha
libblake2s_generic bridge stp llc xt_NETMAP xt_nat iptable_nat xt_CT
iptable_raw xt_tcpmss xt_TCPMSS iptable_mangle nfnetlink_log xt_time
xt_NFLOG xt_recent xt_multiport xt_connlimit nf_conncount xt_iprange
ipt_REJECT nf_reject_ipv4 xt_set xt_limit xt_conntrack iptable_filter
ip_set_list_set ip_set_hash_ip ip_set_hash_net ip_set_bitmap_port ip_set
nfnetlink nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 libcrc32c crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel vmxnet3 ip_tables crc32c_intel vmw_pvscsi
[226832.592819] ---[ end trace ff2b6d140cf02850 ]---
[226832.593647] RIP: 0010:__list_del_entry_valid.cold+0xf/0x55
[226832.594617] Code: c3 ff 0f 0b 48 89 d1 4c 89 c6 4c 89 ca 48 c7 c7 c0
2a 3d 92 e8 15 c2 c3 ff 0f 0b 48 89 fe 48 c7 c7 50 2b 3d 92 e8 04 c2 c3
ff <0f> 0b 48 c7 c7 00 2c 3d 92 e8 f6 c1 c3 ff 0f 0b 48 89 f2 48 89 fe
[226832.597803] RSP: 0018:ffffaad240003918 EFLAGS: 00010286
[226832.598726] RAX: 000000000000004e RBX: ffff9d4a0b19a000 RCX:
0000000000000000
[226832.599971] RDX: ffff9d4a1d427c80 RSI: ffff9d4a1d419cc8 RDI:
0000000000000300
[226832.601218] RBP: ffff9d4a03b00000 R08: 0000000000000464 R09:
0000000000000003
[226832.602465] R10: 0000000000000000 R11: 0000000000000001 R12:
ffff9d4a0b19a010
[226832.603712] R13: ffff9d4a08c8c000 R14: ffff9d4a03b000f8 R15:
ffff9d4a03b00000
[226832.604961] FS:  0000000000000000(0000) GS:ffff9d4a1d400000(0000)
knlGS:0000000000000000
[226832.606367] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[226832.607381] CR2: 000055d7057581a8 CR3: 0000000098fe0003 CR4:
00000000003606f0
[226832.608655] Kernel panic - not syncing: Fatal exception in interrupt
[226832.609795] Kernel Offset: 0x10000000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[226832.611651] Rebooting in 1 seconds..
[226833.619635] ACPI MEMORY or I/O RESET_REG.
