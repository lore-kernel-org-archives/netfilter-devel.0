From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5] [NF_CONNTRACK] load on demand layer 3 protocol handlers
Date: Mon, 27 Feb 2006 03:10:54 +0100
Message-ID: <44025FAE.1000400@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000100080005030807070905"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------000100080005030807070905
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

x_tables matches and targets that require nf_conntrack_ipv[4|6] to work
don't have enough information to load on demand these modules. This
patch introduces the following changes to solve this issue:

o nf_ct_l3proto_try_module_get: try to load the layer 3 connection
tracker module and increases the refcount.
o nf_ct_l3proto_module put: drop the refcount of the module.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------000100080005030807070905
Content-Type: text/plain;
 name="autoload.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="autoload.patch"

[NF_CONNTRACK] Support for layer 3 protocol load on demand

x_tables matches and targets that require nf_conntrack_ipv[4|6] to work
don't have enough information to load on demand these modules. This
patch introduces the following changes to solve this issue:

o nf_ct_l3proto_try_module_get: try to load the layer 3 connection
tracker module and increases the refcount.
o nf_ct_l3proto_module put: drop the refcount of the module.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_core.c	2006-02-27 02:25:20.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_core.c	2006-02-27 02:25:22.000000000 +0100
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
 
Index: net-2.6.git/include/net/netfilter/nf_conntrack.h
===================================================================
--- net-2.6.git.orig/include/net/netfilter/nf_conntrack.h	2006-02-27 01:44:14.000000000 +0100
+++ net-2.6.git/include/net/netfilter/nf_conntrack.h	2006-02-27 02:25:22.000000000 +0100
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
Index: net-2.6.git/net/netfilter/nf_conntrack_standalone.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_standalone.c	2006-02-27 01:44:14.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_standalone.c	2006-02-27 02:25:22.000000000 +0100
@@ -834,6 +834,8 @@ EXPORT_SYMBOL_GPL(__nf_ct_event_cache_in
 EXPORT_PER_CPU_SYMBOL_GPL(nf_conntrack_ecache);
 EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 #endif
+EXPORT_SYMBOL(nf_ct_l3proto_try_module_get);
+EXPORT_SYMBOL(nf_ct_l3proto_module_put);
 EXPORT_SYMBOL(nf_conntrack_l3proto_register);
 EXPORT_SYMBOL(nf_conntrack_l3proto_unregister);
 EXPORT_SYMBOL(nf_conntrack_protocol_register);
Index: net-2.6.git/net/netfilter/xt_connmark.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_connmark.c	2006-02-27 02:25:21.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_connmark.c	2006-02-27 02:25:22.000000000 +0100
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
Index: net-2.6.git/net/netfilter/xt_conntrack.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_conntrack.c	2006-02-27 02:25:21.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_conntrack.c	2006-02-27 02:25:22.000000000 +0100
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
Index: net-2.6.git/net/netfilter/xt_helper.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_helper.c	2006-02-27 02:25:21.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_helper.c	2006-02-27 02:25:22.000000000 +0100
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
Index: net-2.6.git/net/netfilter/xt_state.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_state.c	2006-02-27 02:25:21.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_state.c	2006-02-27 02:25:22.000000000 +0100
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
Index: net-2.6.git/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2006-02-25 13:45:47.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2006-02-27 02:43:59.000000000 +0100
@@ -568,6 +568,7 @@ static int init_or_cleanup(int init)
 	return ret;
 }
 
+MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
 MODULE_LICENSE("GPL");
 
 static int __init init(void)
Index: net-2.6.git/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2006-02-25 13:45:51.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2006-02-27 02:43:39.000000000 +0100
@@ -584,6 +584,7 @@ static int init_or_cleanup(int init)
 	return ret;
 }
 
+MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yasuyuki KOZAKAI @USAGI <yasuyuki.kozakai@toshiba.co.jp>");
 

--------------000100080005030807070905--
