From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH] netfilter: ipset: fix ip_set_list allocation failure
Date: Wed,  1 Aug 2018 19:46:29 +0300
Message-ID: <20180801164629.3621-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

ip_set_create() and ip_set_net_init() attempt to allocate physically
contiguous memory for ip_set_list. If memory is fragmented, the
allocations could easily fail:

	vzctl: page allocation failure: order:7, mode:0xc0d0

	Call Trace:
	 dump_stack+0x19/0x1b
	 warn_alloc_failed+0x110/0x180
	 __alloc_pages_nodemask+0x7bf/0xc60
	 alloc_pages_current+0x98/0x110
	 kmalloc_order+0x18/0x40
	 kmalloc_order_trace+0x26/0xa0
	 __kmalloc+0x279/0x290
	 ip_set_net_init+0x4b/0x90 [ip_set]
	 ops_init+0x3b/0xb0
	 setup_net+0xbb/0x170
	 copy_net_ns+0xf1/0x1c0
	 create_new_namespaces+0xf9/0x180
	 copy_namespaces+0x8e/0xd0
	 copy_process+0xb61/0x1a00
	 do_fork+0x91/0x320

Use kvcalloc() to fallback to 0-order allocations if high order
page isn't available.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 net/netfilter/ipset/ip_set_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index bc4bd247bb7d..96dd57c48b1c 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -961,7 +961,7 @@ static int ip_set_create(struct net *net, struct sock *ctnl,
 			/* Wraparound */
 			goto cleanup;
 
-		list = kcalloc(i, sizeof(struct ip_set *), GFP_KERNEL);
+		list = kvcalloc(i, sizeof(struct ip_set *), GFP_KERNEL);
 		if (!list)
 			goto cleanup;
 		/* nfnl mutex is held, both lists are valid */
@@ -973,7 +973,7 @@ static int ip_set_create(struct net *net, struct sock *ctnl,
 		/* Use new list */
 		index = inst->ip_set_max;
 		inst->ip_set_max = i;
-		kfree(tmp);
+		kvfree(tmp);
 		ret = 0;
 	} else if (ret) {
 		goto cleanup;
@@ -2059,7 +2059,7 @@ ip_set_net_init(struct net *net)
 	if (inst->ip_set_max >= IPSET_INVALID_ID)
 		inst->ip_set_max = IPSET_INVALID_ID - 1;
 
-	list = kcalloc(inst->ip_set_max, sizeof(struct ip_set *), GFP_KERNEL);
+	list = kvcalloc(inst->ip_set_max, sizeof(struct ip_set *), GFP_KERNEL);
 	if (!list)
 		return -ENOMEM;
 	inst->is_deleted = false;
@@ -2087,7 +2087,7 @@ ip_set_net_exit(struct net *net)
 		}
 	}
 	nfnl_unlock(NFNL_SUBSYS_IPSET);
-	kfree(rcu_dereference_protected(inst->ip_set_list, 1));
+	kvfree(rcu_dereference_protected(inst->ip_set_list, 1));
 }
 
 static struct pernet_operations ip_set_net_ops = {
-- 
2.16.4
