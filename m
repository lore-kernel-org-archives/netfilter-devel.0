Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B53BC6FA8E
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 13:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjCBNeg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 08:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCBNef (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 08:34:35 -0500
X-Greylist: delayed 499 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Mar 2023 05:34:30 PST
Received: from mail.balasys.hu (mail.balasys.hu [185.199.30.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5FA42BD2
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2023 05:34:30 -0800 (PST)
Received: from [10.90.6.8] (dmajor.balasys [10.90.6.8])
        by mail.balasys.hu (Postfix) with ESMTPSA id 207272B48E0;
        Thu,  2 Mar 2023 14:26:08 +0100 (CET)
Message-ID: <401bd6ed-314a-a196-1cdc-e13c720cc8f2@balasys.hu>
Date:   Thu, 2 Mar 2023 14:26:08 +0100
MIME-Version: 1.0
From:   =?UTF-8?Q?Major_D=c3=a1vid?= <major.david@balasys.hu>
To:     netfilter-devel@vger.kernel.org
Content-Language: en-US
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: CPU soft lockup in a spin lock using tproxy and nfqueue
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all, Hi Pablo,

Following comments on bug: https://bugzilla.netfilter.org/show_bug.cgi?id=1662

I researched a little bit further. I started to use older kernels from
Ubuntu mainline PPA to get a rough estimate about affected kernel versions.
At kernel version v3.18.140 still getting a soft lockup, I spun up a good
oldie' Ubuntu Precise VM environment to test older kernels. No nftables
support in Precise so I ported my test ruleset to iptables:

iptables -t mangle -F
iptables -t mangle -X

iptables -t mangle -A PREROUTING --match state --state NEW \
--protocol tcp --dport 80 --match mark ! --mark 0x80000000/0x80000000 \
--jump NFQUEUE --queue-num 0

iptables -t mangle -A PREROUTING --match state --state NEW \
--protocol tcp --dport 80 --match mark --mark 0x80000000/0x80000000 \
--jump CONNMARK --save-mark

iptables -t mangle -A PREROUTING --match connmark \
--mark 0x80000000/0x80000000 --protocol tcp --jump TPROXY \
--on-ip 127.0.0.1 --on-port 44444 --tproxy-mark 0x80000000/0x80000000

iptables -t mangle -A PREROUTING --match socket \
--transparent --jump MARK --set-mark 0x80000000/0x80000000

And for my surprise, I did not get any soft lockup on Precise with the
same v3.18.140 kernel as Jammy env had.

Using the above rules in Jammy, there is a soft lockup.

After comparing the lsmod output of the two systems I realized that
the iptables command on Jammy uses the nf_tables backend. Re-running
the test with the above ruleset, but changed to "iptables-legacy", on
Ubuntu Jammy I did not get any soft lockup.

I think the iptables code-path does not trigger the issue but nftables does.

I checked out the first commit were tproxy support was added to nftables:

4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support", 2018-07-30)

And after a small adjustment in the nftables example rules (counter keyword not supported),
I got the soft lockup again in the Jammy env:

[ 1268.393958] watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [sample-queue-ha:957]
[ 1268.395321] Kernel panic - not syncing: softlockup: hung tasks
[ 1268.396132] CPU: 1 PID: 957 Comm: sample-queue-ha Tainted: G             L    4.18.0-rc6custom+ #1
[ 1268.397385] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
[ 1268.398576] Call Trace:
[ 1268.399015]  <IRQ>
[ 1268.399406]  dump_stack+0x76/0xb5
[ 1268.399887]  panic+0xfd/0x322
[ 1268.400329]  watchdog_timer_fn+0x26c/0x2b0
[ 1268.400977]  ? watchdog+0x30/0x30
[ 1268.401470]  __hrtimer_run_queues+0x113/0x3c0
[ 1268.402084]  hrtimer_interrupt+0x110/0x370
[ 1268.402707]  smp_apic_timer_interrupt+0x7b/0x210
[ 1268.403367]  apic_timer_interrupt+0xf/0x20
[ 1268.403979] RIP: 0010:native_queued_spin_lock_slowpath+0x72/0x490
[ 1268.404763] Code: b1 23 85 c0 75 e8 48 8b 45 d0 65 48 33 04 25 28 00 00 00 0f 85 ef
03 00 00 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f 5d c3 f3 90 <eb> c2 8b 45 bc 3d 00 01
00 00 0f 84 a5 01 00 00 30 c0 85 c0 0f 84
[ 1268.408080] RSP: 0018:ffff9a60ffc837f8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
[ 1268.409374] RAX: 0000000000000001 RBX: ffffa6af0054fbc0 RCX: 0000000000000050
[ 1268.410499] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffffa6af0054fbc0
[ 1268.411764] RBP: ffff9a60ffc83848 R08: 0000000000000000 R09: ffff9a60fb802330
[ 1268.413033] R10: ffffffff87466780 R11: ffff9a60f85c82dc R12: 0000000000000001
[ 1268.441802] R13: 0000000000000050 R14: ffff9a60f8710000 R15: ffffffff883df540
[ 1268.474297]  ? apic_timer_interrupt+0xa/0x20
[ 1268.506655]  ? sk_clone_lock+0x5b2/0x820
[ 1268.535705]  ? tcp_compressed_ack_kick+0xa0/0xa0
[ 1268.566980]  ? tcp_delack_timer_handler+0x2b0/0x2b0
[ 1268.598468]  _raw_spin_lock+0x21/0x30
[ 1268.625308]  __inet_inherit_port+0x97/0x300
[ 1268.650538]  ? tcp_assign_congestion_control+0x4c/0x280
[ 1268.676091]  ? tcp_create_openreq_child+0x395/0x5e0
[ 1268.699038]  tcp_v4_syn_recv_sock+0x2e4/0x690
[ 1268.724238]  tcp_get_cookie_sock+0x64/0x250
[ 1268.747900]  cookie_v4_check+0x6dd/0xf00
[ 1268.774811]  tcp_v4_do_rcv+0x222/0x320
[ 1268.799555]  tcp_v4_rcv+0x136a/0x1390
[ 1268.826036]  ip_local_deliver_finish+0x8b/0x3d0
[ 1268.850129]  ip_local_deliver+0x7c/0x170
[ 1268.875474]  ? inet_del_offload+0x40/0x40
[ 1268.896954]  ip_rcv_finish+0x72/0x110
[ 1268.919959]  ip_rcv+0x66/0x100
[ 1268.942994]  ? ip_rcv_finish_core.isra.0+0x710/0x710
[ 1268.964075]  __netif_receive_skb_one_core+0x64/0xa0
[ 1268.986015]  __netif_receive_skb+0x24/0x120
[ 1269.009437]  netif_receive_skb_internal+0x47/0x160
[ 1269.027549]  napi_gro_receive+0x11b/0x1b0
[ 1269.048952]  e1000_receive_skb+0xad/0x170 [e1000e]
[ 1269.069667]  ? __napi_alloc_skb+0xad/0x1d0
[ 1269.087054]  e1000_clean_rx_irq+0x356/0x630 [e1000e]
[ 1269.107997]  e1000e_poll+0xf3/0x400 [e1000e]
[ 1269.127928]  napi_poll+0xd9/0x360
[ 1269.145398]  net_rx_action+0xe0/0x3c0
[ 1269.164703]  __do_softirq+0x12f/0x52d
[ 1269.180301]  irq_exit+0x92/0xe0
[ 1269.198312]  do_IRQ+0xa3/0x140
[ 1269.215611]  common_interrupt+0xf/0xf
[ 1269.235155]  </IRQ>
[ 1269.253222] RIP: 0010:inet_bind_bucket_destroy+0x33/0xc0
[ 1269.269167] Code: 41 56 41 55 41 54 53 49 89 fe 48 89 f3 48 83 ec 10 65 48 8b 04 25
28 00 00 00 48 89 45 d8 31 c0 48 83 fe c8 74 5a 48 8b 43 38 <48> 85 c0 75 30 48 83 fb
d8 74 6b 4c 8b 6b 30 4c 8b 63 28 4d 85 ed
[ 1269.324560] RSP: 0018:ffffa6af008f73f0 EFLAGS: 00000293 ORIG_RAX: ffffffffffffffd5
[ 1269.363328] RAX: ffff9a60f8245a68 RBX: ffff9a60f93aea00 RCX: 0000000000000000
[ 1269.387817] RDX: 0000000000000001 RSI: ffff9a60f93aea00 RDI: ffff9a60fc99b680
[ 1269.410607] RBP: ffffa6af008f7420 R08: 0000000006422a0a R09: 0000000000000000
[ 1269.433872] R10: 0000000000000010 R11: ffffffff86f7a768 R12: ffff9a60f82455b8
[ 1269.459357] R13: ffff9a60f93aea00 R14: ffff9a60fc99b680 R15: ffffffff883df540
[ 1269.482675]  inet_twsk_bind_unhash+0x84/0x100
[ 1269.506983]  inet_twsk_kill+0x10d/0x1e0
[ 1269.531047]  inet_twsk_deschedule_put+0x25/0x30
[ 1269.554010]  nf_tproxy_handle_time_wait4+0x16b/0x200 [nf_tproxy_ipv4]
[ 1269.577850]  nft_tproxy_eval+0x5b1/0x9c6 [nft_tproxy]
[ 1269.602276]  nft_do_chain+0x172/0xb30 [nf_tables]
[ 1269.628693]  ? nft_tproxy_init+0x240/0x240 [nft_tproxy]
[ 1269.656098]  ? nft_do_chain+0x172/0xb30 [nf_tables]
[ 1269.679579]  ? consume_skb+0x47/0x100
[ 1269.703950]  ? security_sock_rcv_skb+0x2f/0x50
[ 1269.728455]  ? sk_filter_trim_cap+0x54/0x290
[ 1269.754011]  ? tcp_v4_do_rcv+0x111/0x320
[ 1269.777794]  ? tcp_v4_do_rcv+0x111/0x320
[ 1269.802569]  ? tcp_v4_rcv+0x136a/0x1390
[ 1269.827199]  ? ip_local_deliver_finish+0x8b/0x3d0
[ 1269.850628]  nft_do_chain_inet+0x8d/0x150 [nf_tables]
[ 1269.875429]  ? nft_do_chain_inet+0x8d/0x150 [nf_tables]
[ 1269.899376]  ? inet_del_offload+0x40/0x40
[ 1269.923031]  nf_reinject+0x11e/0x370
[ 1269.947908]  nfqnl_reinject+0x60/0x90 [nfnetlink_queue]
[ 1269.972695]  nfqnl_recv_verdict+0x46d/0xa80 [nfnetlink_queue]
[ 1269.994270]  ? nla_parse+0xe0/0x1f0
[ 1270.015330]  nfnetlink_rcv_msg+0x19d/0x520 [nfnetlink]
[ 1270.038142]  ? __accumulate_pelt_segments+0x2e/0x50
[ 1270.057147]  ? security_capable+0x3c/0x60
[ 1270.076403]  ? nfnetlink_net_exit_batch+0x110/0x110 [nfnetlink]
[ 1270.098143]  netlink_rcv_skb+0x4d/0x150
[ 1270.114926]  nfnetlink_rcv+0xa6/0x1c0 [nfnetlink]
[ 1270.135217]  netlink_unicast+0x1e1/0x320
[ 1270.151675]  netlink_sendmsg+0x426/0x610
[ 1270.170631]  sock_sendmsg+0x51/0xa0
[ 1270.187027]  ___sys_sendmsg+0x322/0x480
[ 1270.204820]  ? netlink_recvmsg+0x2a4/0x750
[ 1270.221160]  ? sock_recvmsg+0x5c/0xa0
[ 1270.239267]  ? __sys_recvfrom+0xf3/0x180
[ 1270.257812]  __sys_sendmsg+0x63/0xa0
[ 1270.274550]  ? __sys_sendmsg+0x63/0xa0
[ 1270.294016]  __x64_sys_sendmsg+0x28/0x40
[ 1270.310840]  do_syscall_64+0x66/0x210
[ 1270.328774]  ? prepare_exit_to_usermode+0x9c/0x110
[ 1270.345359]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1270.364286] RIP: 0033:0x7ff17d7cbb17
[ 1270.382162] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e
fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51
c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
[ 1270.442986] RSP: 002b:00007ffd06666018 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[ 1270.484914] RAX: ffffffffffffffda RBX: 00005591b5934510 RCX: 00007ff17d7cbb17
[ 1270.510398] RDX: 0000000000000000 RSI: 00007ffd06666030 RDI: 0000000000000003
[ 1270.534988] RBP: 00007ffd06666090 R08: 0000000000000028 R09: 0000000000000301
[ 1270.558997] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[ 1270.584564] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000080
[ 1270.610953] Kernel Offset: 0x4600000 from 0xffffffff81000000 (relocation range:
0xffffffff80000000-0xffffffffbfffffff)
[ 1270.659917] ---[ end Kernel panic - not syncing: softlockup: hung tasks ]---


