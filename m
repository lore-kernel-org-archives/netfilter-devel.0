From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/10]: nf_conntrack: support for layer 3 protocol load
	on demand
Date: Wed, 22 Mar 2006 19:47:53 +0100 (MET)
Message-ID: <20060322184752.5655.54704.sendpatchset@localhost.localdomain>
References: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: support for layer 3 protocol load on demand

x_tables matches and targets that require nf_conntrack_ipv[4|6] to work
don't have enough information to load on demand these modules. This
patch introduces the following changes to solve this issue:

o nf_ct_l3proto_try_module_get: try to load the layer 3 connection
tracker module and increases the refcount.
o nf_ct_l3proto_module put: drop the refcount of the module.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7eda410688c8365a37c036d9a6d7f6f5a90fa4a9
tree 80a30c473cffde7edfd606c42954dbd281754404
parent 502310b7e97c6bef65b331cd558abd11f5b6a77c
author Pablo Neira Ayuso <pablo@netfilter.org> Tue, 21 Mar 2006 22:30:24 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 21 Mar 2006 22:30:24 +0100

 include/net/netfilter/nf_conntrack.h           |    4 +++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    1 +
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 +
 net/netfilter/nf_conntrack_core.c              |   31 ++++++++++++++++++++++++
 net/netfilter/nf_conntrack_standalone.c        |    2 ++
 net/netfilter/xt_connmark.c                    |   17 +++++++++++++
 net/netfilter/xt_conntrack.c                   |   28 ++++++++++++++++++++++
 net/netfilter/xt_helper.c                      |   17 +++++++++++++
 net/netfilter/xt_state.c                       |   29 ++++++++++++++++++++++
 9 files changed, 130 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 2743c15..b6f0905 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -195,6 +195,10 @@ static inline void nf_ct_put(struct nf_c
 	nf_conntrack_put(&ct->ct_general);
 }
 
+/* Protocol module loading */
+extern int nf_ct_l3proto_try_module_get(unsigned short l3proto);
+extern void nf_ct_l3proto_module_put(unsigned short l3proto);
+
 extern struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_conn *ignored_conntrack);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index cb9c661..c8abc9d 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -568,6 +568,7 @@ static int init_or_cleanup(int init)
 	return ret;
 }
 
+MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
 MODULE_LICENSE("GPL");
 
 static int __init init(void)
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index ac35f95..c16f629 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -584,6 +584,7 @@ static int init_or_cleanup(int init)
 	return ret;
 }
 
+MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yasuyuki KOZAKAI @USAGI <yasuyuki.kozakai@toshiba.co.jp>");
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c288406..0ae281d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -23,6 +23,8 @@
  * 26 Jan 2006: Harald Welte <laforge@netfilter.org>
  * 	- restructure nf_conn (introduce nf_conn_help)
  * 	- redesign 'features' how they were originally intended
+ * 26 Feb 2006: Pablo Neira Ayuso <pablo@eurodev.net>
+ * 	- add support for L3 protocol module load on demand.
  *
  * Derived from net/ipv4/netfilter/ip_conntrack_core.c
  */
@@ -241,6 +243,35 @@ void nf_ct_l3proto_put(struct nf_conntra
 	module_put(p->me);
 }
 
+int
+nf_ct_l3proto_try_module_get(unsigned short l3proto)
+{
+	int ret;
+	struct nf_conntrack_l3proto *p;
+
+retry:	p = nf_ct_l3proto_find_get(l3proto);
+	if (p == &nf_conntrack_generic_l3proto) {
+		ret = request_module("nf_conntrack-%d", l3proto);
+		if (!ret)
+			goto retry;
+
+		return -EPROTOTYPE;
+	}
+
+	return 0;
+}
+
+void nf_ct_l3proto_module_put(unsigned short l3proto)
+{
+	struct nf_conntrack_l3proto *p;
+
+	preempt_disable();
+	p = __nf_ct_l3proto_find(l3proto);
+	preempt_enable();
+
+	module_put(p->me);
+}
+
 static int nf_conntrack_hash_rnd_initted;
 static unsigned int nf_conntrack_hash_rnd;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 290d5a0..75577e1 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -834,6 +834,8 @@ EXPORT_SYMBOL_GPL(__nf_ct_event_cache_in
 EXPORT_PER_CPU_SYMBOL_GPL(nf_conntrack_ecache);
 EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 #endif
+EXPORT_SYMBOL(nf_ct_l3proto_try_module_get);
+EXPORT_SYMBOL(nf_ct_l3proto_module_put);
 EXPORT_SYMBOL(nf_conntrack_l3proto_register);
 EXPORT_SYMBOL(nf_conntrack_l3proto_unregister);
 EXPORT_SYMBOL(nf_conntrack_protocol_register);
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index e810600..7b16f1e 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -64,14 +64,30 @@ checkentry(const char *tablename,
 		printk(KERN_WARNING "connmark: only support 32bit mark\n");
 		return 0;
 	}
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+		printk(KERN_WARNING "can't load nf_conntrack support for "
+				    "proto=%d\n", match->family);
+		return 0;
+	}
+#endif
 	return 1;
 }
 
+static void
+destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+{
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	nf_ct_l3proto_module_put(match->family);
+#endif
+}
+
 static struct xt_match connmark_match = {
 	.name		= "connmark",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_connmark_info),
 	.checkentry	= checkentry,
+	.destroy	= destroy,
 	.family		= AF_INET,
 	.me		= THIS_MODULE
 };
@@ -81,6 +97,7 @@ static struct xt_match connmark6_match =
 	.match		= match,
 	.matchsize	= sizeof(struct xt_connmark_info),
 	.checkentry	= checkentry,
+	.destroy	= destroy,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE
 };
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 7d20caa..a6c7e93 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -203,9 +203,37 @@ match(const struct sk_buff *skb,
 
 #endif /* CONFIG_NF_IP_CONNTRACK */
 
+static int
+checkentry(const char *tablename,
+	   const void *ip,
+	   const struct xt_match *match,
+	   void *matchinfo,
+	   unsigned int matchsize,
+	   unsigned int hook_mask)
+{
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+		printk(KERN_WARNING "can't load nf_conntrack support for "
+				    "proto=%d\n", match->family);
+		return 0;
+	}
+#endif
+	return 1;
+}
+
+static void
+destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+{
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	nf_ct_l3proto_module_put(match->family);
+#endif
+}
+
 static struct xt_match conntrack_match = {
 	.name		= "conntrack",
 	.match		= match,
+	.checkentry	= checkentry,
+	.destroy	= destroy,
 	.matchsize	= sizeof(struct xt_conntrack_info),
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 7d2d68b..101f000 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -144,15 +144,31 @@ static int check(const char *tablename,
 {
 	struct xt_helper_info *info = matchinfo;
 
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+		printk(KERN_WARNING "can't load nf_conntrack support for "
+				    "proto=%d\n", match->family);
+		return 0;
+	}
+#endif
 	info->name[29] = '\0';
 	return 1;
 }
 
+static void
+destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+{
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	nf_ct_l3proto_module_put(match->family);
+#endif
+}
+
 static struct xt_match helper_match = {
 	.name		= "helper",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_helper_info),
 	.checkentry	= check,
+	.destroy	= destroy,
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
@@ -161,6 +177,7 @@ static struct xt_match helper6_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_helper_info),
 	.checkentry	= check,
+	.destroy	= destroy,
 	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 7cd557c..e6c0be9 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -44,9 +44,36 @@ match(const struct sk_buff *skb,
 	return (sinfo->statemask & statebit);
 }
 
+static int check(const char *tablename,
+		 const void *inf,
+		 const struct xt_match *match,
+		 void *matchinfo,
+		 unsigned int matchsize,
+		 unsigned int hook_mask)
+{
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+		printk(KERN_WARNING "can't load nf_conntrack support for "
+				    "proto=%d\n", match->family);
+		return 0;
+	}
+#endif
+	return 1;
+}
+
+static void
+destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+{
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+	nf_ct_l3proto_module_put(match->family);
+#endif
+}
+
 static struct xt_match state_match = {
 	.name		= "state",
 	.match		= match,
+	.checkentry	= check,
+	.destroy	= destroy,
 	.matchsize	= sizeof(struct xt_state_info),
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
@@ -55,6 +82,8 @@ static struct xt_match state_match = {
 static struct xt_match state6_match = {
 	.name		= "state",
 	.match		= match,
+	.checkentry	= check,
+	.destroy	= destroy,
 	.matchsize	= sizeof(struct xt_state_info),
 	.family		= AF_INET6,
 	.me		= THIS_MODULE,
