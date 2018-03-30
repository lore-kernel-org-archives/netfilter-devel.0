From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch nf] nf_conntrack_extend: silent a memory leak warning
Date: Fri, 30 Mar 2018 13:22:06 -0700
Message-ID: <20180330202206.19565-1-xiyou.wangcong@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The following memory leak is false postive:

unreferenced object 0xffff8f37f156fb38 (size 128):
  comm "softirq", pid 0, jiffies 4294899665 (age 11.292s)
  hex dump (first 32 bytes):
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    00 00 00 00 30 00 20 00 48 6b 6b 6b 6b 6b 6b 6b  ....0. .Hkkkkkkk
  backtrace:
    [<000000004fda266a>] __kmalloc_track_caller+0x10d/0x141
    [<000000007b0a7e3c>] __krealloc+0x45/0x62
    [<00000000d08e0bfb>] nf_ct_ext_add+0xdc/0x133
    [<0000000099b47fd8>] init_conntrack+0x1b1/0x392
    [<0000000086dc36ec>] nf_conntrack_in+0x1ee/0x34b
    [<00000000940592de>] nf_hook_slow+0x36/0x95
    [<00000000d1bd4da7>] nf_hook.constprop.43+0x1c3/0x1dd
    [<00000000c3673266>] __ip_local_out+0xae/0xb4
    [<000000003e4192a6>] ip_local_out+0x17/0x33
    [<00000000b64356de>] igmp_ifc_timer_expire+0x23e/0x26f
    [<000000006a8f3032>] call_timer_fn+0x14c/0x2a5
    [<00000000650c1725>] __run_timers.part.34+0x150/0x182
    [<0000000090e6946e>] run_timer_softirq+0x2a/0x4c
    [<000000004d1e7293>] __do_softirq+0x1d1/0x3c2
    [<000000004643557d>] irq_exit+0x53/0xa2
    [<0000000029ddee8f>] smp_apic_timer_interrupt+0x22a/0x235

because __krealloc() is not supposed to release the old
memory and it is released later via kfree_rcu(). Since this is
the only external user of __krealloc(), just mark it as not leak
here.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/nf_conntrack_extend.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 9fe0ddc333fb..bd71a828ebde 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -71,6 +71,7 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	rcu_read_unlock();
 
 	alloc = max(newlen, NF_CT_EXT_PREALLOC);
+	kmemleak_not_leak(old);
 	new = __krealloc(old, alloc, gfp);
 	if (!new)
 		return NULL;
-- 
2.13.0
