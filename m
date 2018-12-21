From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 36/37] netfilter: conntrack: remove empty pernet fini stubs
Date: Fri, 21 Dec 2018 01:28:40 +0100
Message-ID: <20181221002841.28587-37-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

after moving sysctl handling into single place, the init functions
can't fail anymore and some of the fini functions are empty.

Remove them and change return type to void.
This also simplifies error unwinding in conntrack module init path.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_acct.h      |  3 +--
 include/net/netfilter/nf_conntrack_ecache.h    |  7 ++-----
 include/net/netfilter/nf_conntrack_helper.h    |  3 +--
 include/net/netfilter/nf_conntrack_timestamp.h | 13 ++----------
 net/netfilter/nf_conntrack_acct.c              |  7 +------
 net/netfilter/nf_conntrack_core.c              | 28 ++++++--------------------
 net/netfilter/nf_conntrack_ecache.c            |  3 +--
 net/netfilter/nf_conntrack_helper.c            |  7 +------
 net/netfilter/nf_conntrack_timestamp.c         |  7 +------
 9 files changed, 16 insertions(+), 62 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index ae5a1c37387e..bc6745d3010e 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -58,8 +58,7 @@ static inline void nf_ct_set_acct(struct net *net, bool enable)
 	net->ct.sysctl_acct = enable;
 }
 
-int nf_conntrack_acct_pernet_init(struct net *net);
-void nf_conntrack_acct_pernet_fini(struct net *net);
+void nf_conntrack_acct_pernet_init(struct net *net);
 
 int nf_conntrack_acct_init(void);
 void nf_conntrack_acct_fini(void);
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 3f1ce9a8776e..52b44192b43f 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -142,7 +142,7 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			       struct nf_conntrack_expect *exp,
 			       u32 portid, int report);
 
-int nf_conntrack_ecache_pernet_init(struct net *net);
+void nf_conntrack_ecache_pernet_init(struct net *net);
 void nf_conntrack_ecache_pernet_fini(struct net *net);
 
 int nf_conntrack_ecache_init(void);
@@ -182,10 +182,7 @@ static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
  					     u32 portid,
  					     int report) {}
 
-static inline int nf_conntrack_ecache_pernet_init(struct net *net)
-{
-	return 0;
-}
+static inline void nf_conntrack_ecache_pernet_init(struct net *net) {}
 
 static inline void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 2492120b8097..ec52a8dc32fd 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -124,8 +124,7 @@ static inline void *nfct_help_data(const struct nf_conn *ct)
 	return (void *)help->data;
 }
 
-int nf_conntrack_helper_pernet_init(struct net *net);
-void nf_conntrack_helper_pernet_fini(struct net *net);
+void nf_conntrack_helper_pernet_init(struct net *net);
 
 int nf_conntrack_helper_init(void);
 void nf_conntrack_helper_fini(void);
diff --git a/include/net/netfilter/nf_conntrack_timestamp.h b/include/net/netfilter/nf_conntrack_timestamp.h
index 3b661986be8f..0ed617bf0a3d 100644
--- a/include/net/netfilter/nf_conntrack_timestamp.h
+++ b/include/net/netfilter/nf_conntrack_timestamp.h
@@ -49,21 +49,12 @@ static inline void nf_ct_set_tstamp(struct net *net, bool enable)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
-int nf_conntrack_tstamp_pernet_init(struct net *net);
-void nf_conntrack_tstamp_pernet_fini(struct net *net);
+void nf_conntrack_tstamp_pernet_init(struct net *net);
 
 int nf_conntrack_tstamp_init(void);
 void nf_conntrack_tstamp_fini(void);
 #else
-static inline int nf_conntrack_tstamp_pernet_init(struct net *net)
-{
-	return 0;
-}
-
-static inline void nf_conntrack_tstamp_pernet_fini(struct net *net)
-{
-	return;
-}
+static inline void nf_conntrack_tstamp_pernet_init(struct net *net) {}
 
 static inline int nf_conntrack_tstamp_init(void)
 {
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 89c58946ec61..49e523cc49d0 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -31,14 +31,9 @@ static const struct nf_ct_ext_type acct_extend = {
 	.id	= NF_CT_EXT_ACCT,
 };
 
-int nf_conntrack_acct_pernet_init(struct net *net)
+void nf_conntrack_acct_pernet_init(struct net *net)
 {
 	net->ct.sysctl_acct = nf_ct_acct;
-	return 0;
-}
-
-void nf_conntrack_acct_pernet_fini(struct net *net)
-{
 }
 
 int nf_conntrack_acct_init(void)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e92e749aff53..e87c21e47efe 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2110,10 +2110,7 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		nf_conntrack_proto_pernet_fini(net);
-		nf_conntrack_helper_pernet_fini(net);
 		nf_conntrack_ecache_pernet_fini(net);
-		nf_conntrack_tstamp_pernet_fini(net);
-		nf_conntrack_acct_pernet_fini(net);
 		nf_conntrack_expect_pernet_fini(net);
 		free_percpu(net->ct.stat);
 		free_percpu(net->ct.pcpu_lists);
@@ -2410,32 +2407,19 @@ int nf_conntrack_init_net(struct net *net)
 	ret = nf_conntrack_expect_pernet_init(net);
 	if (ret < 0)
 		goto err_expect;
-	ret = nf_conntrack_acct_pernet_init(net);
-	if (ret < 0)
-		goto err_acct;
-	ret = nf_conntrack_tstamp_pernet_init(net);
-	if (ret < 0)
-		goto err_tstamp;
-	ret = nf_conntrack_ecache_pernet_init(net);
-	if (ret < 0)
-		goto err_ecache;
-	ret = nf_conntrack_helper_pernet_init(net);
-	if (ret < 0)
-		goto err_helper;
+
+	nf_conntrack_acct_pernet_init(net);
+	nf_conntrack_tstamp_pernet_init(net);
+	nf_conntrack_ecache_pernet_init(net);
+	nf_conntrack_helper_pernet_init(net);
+
 	ret = nf_conntrack_proto_pernet_init(net);
 	if (ret < 0)
 		goto err_proto;
 	return 0;
 
 err_proto:
-	nf_conntrack_helper_pernet_fini(net);
-err_helper:
 	nf_conntrack_ecache_pernet_fini(net);
-err_ecache:
-	nf_conntrack_tstamp_pernet_fini(net);
-err_tstamp:
-	nf_conntrack_acct_pernet_fini(net);
-err_acct:
 	nf_conntrack_expect_pernet_fini(net);
 err_expect:
 	free_percpu(net->ct.stat);
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 75118b75aa50..3d042f8ff183 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -342,11 +342,10 @@ static const struct nf_ct_ext_type event_extend = {
 	.id	= NF_CT_EXT_ECACHE,
 };
 
-int nf_conntrack_ecache_pernet_init(struct net *net)
+void nf_conntrack_ecache_pernet_init(struct net *net)
 {
 	net->ct.sysctl_events = nf_ct_events;
 	INIT_DELAYED_WORK(&net->ct.ecache_dwork, ecache_work);
-	return 0;
 }
 
 void nf_conntrack_ecache_pernet_fini(struct net *net)
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 8b6fab94501d..274baf1dab87 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -472,15 +472,10 @@ static const struct nf_ct_ext_type helper_extend = {
 	.id	= NF_CT_EXT_HELPER,
 };
 
-int nf_conntrack_helper_pernet_init(struct net *net)
+void nf_conntrack_helper_pernet_init(struct net *net)
 {
 	net->ct.auto_assign_helper_warned = false;
 	net->ct.sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
-	return 0;
-}
-
-void nf_conntrack_helper_pernet_fini(struct net *net)
-{
 }
 
 int nf_conntrack_helper_init(void)
diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/nf_conntrack_timestamp.c
index bae151d93bea..705b912bd91f 100644
--- a/net/netfilter/nf_conntrack_timestamp.c
+++ b/net/netfilter/nf_conntrack_timestamp.c
@@ -28,14 +28,9 @@ static const struct nf_ct_ext_type tstamp_extend = {
 	.id	= NF_CT_EXT_TSTAMP,
 };
 
-int nf_conntrack_tstamp_pernet_init(struct net *net)
+void nf_conntrack_tstamp_pernet_init(struct net *net)
 {
 	net->ct.sysctl_tstamp = nf_ct_tstamp;
-	return 0;
-}
-
-void nf_conntrack_tstamp_pernet_fini(struct net *net)
-{
 }
 
 int nf_conntrack_tstamp_init(void)
-- 
2.11.0
