From: pablo@netfilter.org
Subject: [stable-3.7 12/14] netfilter: nf_conntrack: fix BUG_ON while removing nf_conntrack with netns
Date: Mon, 28 Jan 2013 20:31:31 +0100
Message-ID: <1359401493-6196-13-git-send-email-pablo@netfilter.org>
References: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

canqun zhang reported that we're hitting BUG_ON in the
nf_conntrack_destroy path when calling kfree_skb while
rmmod'ing the nf_conntrack module.

Currently, the nf_ct_destroy hook is being set to NULL in the
destroy path of conntrack.init_net. However, this is a problem
since init_net may be destroyed before any other existing netns
(we cannot assume any specific ordering while releasing existing
netns according to what I read in recent emails).

Thanks to Gao feng for initial patch to address this issue.

Reported-by: canqun zhang <canqunzhang@gmail.com>
Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h |    2 ++
 net/netfilter/nf_conntrack_core.c         |    9 +++++----
 net/netfilter/nf_conntrack_standalone.c   |    1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index d8f5b9f..e98aeb3 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -31,6 +31,8 @@ extern void nf_conntrack_cleanup(struct net *net);
 extern int nf_conntrack_proto_init(struct net *net);
 extern void nf_conntrack_proto_fini(struct net *net);
 
+extern void nf_conntrack_cleanup_end(void);
+
 extern bool
 nf_ct_get_tuple(const struct sk_buff *skb,
 		unsigned int nhoff,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0f241be..ec02168 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1383,11 +1383,12 @@ void nf_conntrack_cleanup(struct net *net)
 	synchronize_net();
 	nf_conntrack_proto_fini(net);
 	nf_conntrack_cleanup_net(net);
+}
 
-	if (net_eq(net, &init_net)) {
-		RCU_INIT_POINTER(nf_ct_destroy, NULL);
-		nf_conntrack_cleanup_init_net();
-	}
+void nf_conntrack_cleanup_end(void)
+{
+	RCU_INIT_POINTER(nf_ct_destroy, NULL);
+	nf_conntrack_cleanup_init_net();
 }
 
 void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 9b39432..df8aa3a 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -571,6 +571,7 @@ static int __init nf_conntrack_standalone_init(void)
 static void __exit nf_conntrack_standalone_fini(void)
 {
 	unregister_pernet_subsys(&nf_conntrack_net_ops);
+	nf_conntrack_cleanup_end();
 }
 
 module_init(nf_conntrack_standalone_init);
-- 
1.7.10.4
