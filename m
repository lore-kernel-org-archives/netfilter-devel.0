From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH v2] net: netfilter: Replace printk() with appropriate pr_*()
 macro
Date: Mon, 12 Mar 2018 01:11:05 +0530
Message-ID: <20180311194104.GA17450@seema-Inspiron-15-3567>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Using pr_<loglevel>() is more concise than
printk(KERN_<LOGLEVEL>).
Replace printks having a log level with the appropriate
pr_*() macros.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
changes in v2
*in v1 printk() were replaced with netdev_*()

 net/netfilter/nf_conntrack_acct.c      | 2 +-
 net/netfilter/nf_conntrack_ecache.c    | 2 +-
 net/netfilter/nf_conntrack_timestamp.c | 2 +-
 net/netfilter/nf_nat_core.c            | 2 +-
 net/netfilter/nfnetlink_queue.c        | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 8669167..b1c3286 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -80,7 +80,7 @@ static int nf_conntrack_acct_init_sysctl(struct net *net)
 	net->ct.acct_sysctl_header = register_net_sysctl(net, "net/netfilter",
 							 table);
 	if (!net->ct.acct_sysctl_header) {
-		printk(KERN_ERR "nf_conntrack_acct: can't register to sysctl.\n");
+		pr_err("nf_conntrack_acct: can't register to sysctl.\n");
 		goto out_register;
 	}
 	return 0;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index caac41a..21a3048 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -372,7 +372,7 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 	net->ct.event_sysctl_header =
 		register_net_sysctl(net, "net/netfilter", table);
 	if (!net->ct.event_sysctl_header) {
-		printk(KERN_ERR "nf_ct_event: can't register to sysctl.\n");
+		pr_err("nf_ct_event: can't register to sysctl.\n");
 		goto out_register;
 	}
 	return 0;
diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/nf_conntrack_timestamp.c
index 4c4734b..f32cc86 100644
--- a/net/netfilter/nf_conntrack_timestamp.c
+++ b/net/netfilter/nf_conntrack_timestamp.c
@@ -58,7 +58,7 @@ static int nf_conntrack_tstamp_init_sysctl(struct net *net)
 	net->ct.tstamp_sysctl_header = register_net_sysctl(net,	"net/netfilter",
 							   table);
 	if (!net->ct.tstamp_sysctl_header) {
-		printk(KERN_ERR "nf_ct_tstamp: can't register to sysctl.\n");
+		pr_err("nf_ct_tstamp: can't register to sysctl.\n");
 		goto out_register;
 	}
 	return 0;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 6c38421..dcda5ac 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -814,7 +814,7 @@ static int __init nf_nat_init(void)
 	ret = nf_ct_extend_register(&nat_extend);
 	if (ret < 0) {
 		nf_ct_free_hashtable(nf_nat_bysource, nf_nat_htable_size);
-		printk(KERN_ERR "nf_nat_core: Unable to register extension\n");
+		pr_err("nf_nat_core: Unable to register extension\n");
 		return ret;
 	}
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 8bba231..f5ddab1 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -834,8 +834,8 @@ nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
 			nskb = skb_copy_expand(e->skb, skb_headroom(e->skb),
 					       diff, GFP_ATOMIC);
 			if (!nskb) {
-				printk(KERN_WARNING "nf_queue: OOM "
-				      "in mangle, dropping packet\n");
+				pr_warn("nf_queue: OOM "
+					"in mangle, dropping packet\n");
 				return -ENOMEM;
 			}
 			kfree_skb(e->skb);
-- 
2.7.4
