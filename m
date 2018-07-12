From: Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] netfilter: nf_conntrack: prevent uninit-value in gc_worker
Date: Wed, 11 Jul 2018 17:40:37 -0700
Message-ID: <20180712004037.197064-1-edumazet@google.com>
Cc: netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KMSAN reported use of uninit-value in gc_worker [1]

We need to clear ct->timeout in __nf_conntrack_alloc()
otherwise __nf_conntrack_confirm() might propagate garbage when
adding nfct_time_stamp to ct->timeout :

	ct->timeout += nfct_time_stamp;

[1]
BUG: KMSAN: uninit-value in gc_worker+0x89e/0x1530 net/netfilter/nf_conntrack_core.c:1028
CPU: 1 PID: 19 Comm: kworker/1:0 Not tainted 4.18.0-rc4+ #24
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_power_efficient gc_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x185/0x1e0 lib/dump_stack.c:113
 kmsan_report+0x195/0x2c0 mm/kmsan/kmsan.c:1092
 __msan_warning_32+0x7d/0xe0 mm/kmsan/kmsan_instr.c:640
 gc_worker+0x89e/0x1530 net/netfilter/nf_conntrack_core.c:1028
 process_one_work+0x1655/0x2000 kernel/workqueue.c:2153
 worker_thread+0x1136/0x2490 kernel/workqueue.c:2296
 kthread+0x473/0x4b0 kernel/kthread.c:247
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:415

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:256 [inline]
 kmsan_save_stack mm/kmsan/kmsan.c:271 [inline]
 kmsan_internal_chain_origin+0x13c/0x240 mm/kmsan/kmsan.c:683
 __msan_chain_origin+0x76/0xd0 mm/kmsan/kmsan_instr.c:483
 __nf_conntrack_confirm+0x2700/0x3f70 net/netfilter/nf_conntrack_core.c:793
 nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:71 [inline]
 ipv6_confirm+0x573/0x740 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c:165
 nf_hook_entry_hookfn include/linux/netfilter.h:119 [inline]
 nf_hook_slow+0x15d/0x3e0 net/netfilter/core.c:511
 nf_hook include/linux/netfilter.h:242 [inline]
 NF_HOOK_COND include/linux/netfilter.h:275 [inline]
 ip6_output+0x37d/0x710 net/ipv6/ip6_output.c:171
 dst_output include/net/dst.h:444 [inline]
 ip6_local_out+0x164/0x1d0 net/ipv6/output_core.c:176
 ip6_send_skb net/ipv6/ip6_output.c:1696 [inline]
 ip6_push_pending_frames+0x218/0x4d0 net/ipv6/ip6_output.c:1716
 rawv6_push_pending_frames net/ipv6/raw.c:616 [inline]
 rawv6_sendmsg+0x45f0/0x5410 net/ipv6/raw.c:935
 inet_sendmsg+0x3fc/0x760 net/ipv4/af_inet.c:798
 sock_sendmsg_nosec net/socket.c:641 [inline]
 sock_sendmsg net/socket.c:651 [inline]
 __sys_sendto+0x798/0x8e0 net/socket.c:1797
 __do_sys_sendto net/socket.c:1809 [inline]
 __se_sys_sendto net/socket.c:1805 [inline]
 __x64_sys_sendto+0x1a1/0x210 net/socket.c:1805
 do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:256 [inline]
 kmsan_internal_poison_shadow+0xc8/0x1d0 mm/kmsan/kmsan.c:181
 kmsan_kmalloc+0xa1/0x120 mm/kmsan/kmsan_hooks.c:91
 kmem_cache_alloc+0xad2/0xbb0 mm/slub.c:2739
 __nf_conntrack_alloc+0x166/0x670 net/netfilter/nf_conntrack_core.c:1137
 init_conntrack+0x635/0x2840 net/netfilter/nf_conntrack_core.c:1219
 resolve_normal_ct net/netfilter/nf_conntrack_core.c:1333 [inline]
 nf_conntrack_in+0x1812/0x2070 net/netfilter/nf_conntrack_core.c:1416
 ipv6_conntrack_local+0xc3/0xf0 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c:179
 nf_hook_entry_hookfn include/linux/netfilter.h:119 [inline]
 nf_hook_slow+0x15d/0x3e0 net/netfilter/core.c:511
 nf_hook include/linux/netfilter.h:242 [inline]
 __ip6_local_out+0x64c/0x770 net/ipv6/output_core.c:164
 ip6_local_out+0xa4/0x1d0 net/ipv6/output_core.c:174
 ip6_send_skb net/ipv6/ip6_output.c:1696 [inline]
 ip6_push_pending_frames+0x218/0x4d0 net/ipv6/ip6_output.c:1716
 rawv6_push_pending_frames net/ipv6/raw.c:616 [inline]
 rawv6_sendmsg+0x45f0/0x5410 net/ipv6/raw.c:935
 inet_sendmsg+0x3fc/0x760 net/ipv4/af_inet.c:798
 sock_sendmsg_nosec net/socket.c:641 [inline]
 sock_sendmsg net/socket.c:651 [inline]
 __sys_sendto+0x798/0x8e0 net/socket.c:1797
 __do_sys_sendto net/socket.c:1809 [inline]
 __se_sys_sendto net/socket.c:1805 [inline]
 __x64_sys_sendto+0x1a1/0x210 net/socket.c:1805
 do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x63/0xe7

Fixes: f330a7fdbe16 ("netfilter: conntrack: get rid of conntrack timer")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netfilter/nf_conntrack_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3d52804250274602c521f3cfe6c0c3b8fa9e78e9..759d09bd27140c85f1a19fdb20390558e7e8f161 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1145,6 +1145,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* save hash for reusing when confirming */
 	*(unsigned long *)(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode.pprev) = hash;
 	ct->status = 0;
+	ct->timeout = 0;
 	write_pnet(&ct->ct_net, net);
 	memset(&ct->__nfct_init_offset[0], 0,
 	       offsetof(struct nf_conn, proto) -
-- 
2.18.0.203.gfac676dfb9-goog
