From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/22]: nf_conntrack: uninline notifier registration
	functions
Date: Wed, 14 Mar 2007 09:50:27 +0100 (MET)
Message-ID: <20070314085012.15282.91041.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: uninline notifier registration functions

SIgned-off-by: Patrick McHardy <kaber@trash.net>

---
commit f8184abb940940e7503c5b089e89d2d88b4eb34c
tree 5a953b2f7dc58cb1b2b4ff96b5e0094a1d33e9dd
parent 9a256881f5e3027a9833ad87b1fe36c0be0c20fb
author Patrick McHardy <kaber@trash.net> Thu, 08 Mar 2007 18:25:12 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:30:39 +0100

 include/net/netfilter/nf_conntrack_ecache.h |   30 +++++----------------------
 net/netfilter/nf_conntrack_ecache.c         |   23 +++++++++++++++++++++
 2 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index b62a8a9..811c907 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -20,30 +20,8 @@ DECLARE_PER_CPU(struct nf_conntrack_ecac
 #define CONNTRACK_ECACHE(x)	(__get_cpu_var(nf_conntrack_ecache).x)
 
 extern struct atomic_notifier_head nf_conntrack_chain;
-extern struct atomic_notifier_head nf_conntrack_expect_chain;
-
-static inline int nf_conntrack_register_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&nf_conntrack_chain, nb);
-}
-
-static inline int nf_conntrack_unregister_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&nf_conntrack_chain, nb);
-}
-
-static inline int
-nf_conntrack_expect_register_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&nf_conntrack_expect_chain, nb);
-}
-
-static inline int
-nf_conntrack_expect_unregister_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&nf_conntrack_expect_chain,
-			nb);
-}
+extern int nf_conntrack_register_notifier(struct notifier_block *nb);
+extern int nf_conntrack_unregister_notifier(struct notifier_block *nb);
 
 extern void nf_ct_deliver_cached_events(const struct nf_conn *ct);
 extern void __nf_ct_event_cache_init(struct nf_conn *ct);
@@ -71,6 +49,10 @@ static inline void nf_conntrack_event(en
 		atomic_notifier_call_chain(&nf_conntrack_chain, event, ct);
 }
 
+extern struct atomic_notifier_head nf_conntrack_expect_chain;
+extern int nf_conntrack_expect_register_notifier(struct notifier_block *nb);
+extern int nf_conntrack_expect_unregister_notifier(struct notifier_block *nb);
+
 static inline void
 nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
 			  struct nf_conntrack_expect *exp)
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 1a223e0..6bd421d 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -91,3 +91,26 @@ void nf_ct_event_cache_flush(void)
 	}
 }
 
+int nf_conntrack_register_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&nf_conntrack_chain, nb);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
+
+int nf_conntrack_unregister_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&nf_conntrack_chain, nb);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
+
+int nf_conntrack_expect_register_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&nf_conntrack_expect_chain, nb);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_expect_register_notifier);
+
+int nf_conntrack_expect_unregister_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&nf_conntrack_expect_chain, nb);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_expect_unregister_notifier);
