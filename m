From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/3]: xtables: error if ip_conntrack is asked to handle
 IPv6 packets
Date: Fri, 08 Dec 2006 19:53:15 +0900 (JST)
Message-ID: <200612081053.kB8ArG3j011781@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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


To do that, this makes nf_ct_l3proto_try_module_{get,put} compatible
functions. As a result we can remove '#ifdef' surrounds and direct call of
need_conntrack().

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/nf_conntrack_compat.h |   10 ++++++++++
 net/netfilter/xt_connmark.c                 |    7 +------
 net/netfilter/xt_conntrack.c                |    8 ++------
 net/netfilter/xt_helper.c                   |    8 ++------
 net/netfilter/xt_state.c                    |    7 +------
 5 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_compat.h b/include/net/netfilter/nf_conntrack_compat.h
index f1b1482..b9ce5c8 100644
--- a/include/net/netfilter/nf_conntrack_compat.h
+++ b/include/net/netfilter/nf_conntrack_compat.h
@@ -64,6 +64,16 @@ static inline int nf_ct_get_ctinfo(const
 	return (ct != NULL);
 }
 
+static inline int nf_ct_l3proto_try_module_get(unsigned short l3proto)
+{
+	need_conntrack();
+	return l3proto == PF_INET ? 0 : -1;
+}
+
+static inline void nf_ct_l3proto_module_put(unsigned short l3proto)
+{
+}
+
 #else /* CONFIG_IP_NF_CONNTRACK */
 
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index a8f0305..36c2def 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -63,22 +63,18 @@ checkentry(const char *tablename,
 		printk(KERN_WARNING "connmark: only support 32bit mark\n");
 		return 0;
 	}
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
-		printk(KERN_WARNING "can't load nf_conntrack support for "
+		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", match->family);
 		return 0;
 	}
-#endif
 	return 1;
 }
 
 static void
 destroy(const struct xt_match *match, void *matchinfo)
 {
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
-#endif
 }
 
 #ifdef CONFIG_COMPAT
@@ -140,7 +136,6 @@ static struct xt_match xt_connmark_match
 
 static int __init xt_connmark_init(void)
 {
-	need_conntrack();
 	return xt_register_matches(xt_connmark_match,
 				   ARRAY_SIZE(xt_connmark_match));
 }
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 0ea501a..3dc2357 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -20,6 +20,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_conntrack.h>
+#include <net/netfilter/nf_conntrack_compat.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
@@ -228,21 +229,17 @@ checkentry(const char *tablename,
 	   void *matchinfo,
 	   unsigned int hook_mask)
 {
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
-		printk(KERN_WARNING "can't load nf_conntrack support for "
+		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", match->family);
 		return 0;
 	}
-#endif
 	return 1;
 }
 
 static void destroy(const struct xt_match *match, void *matchinfo)
 {
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
-#endif
 }
 
 static struct xt_match conntrack_match = {
@@ -257,7 +254,6 @@ static struct xt_match conntrack_match =
 
 static int __init xt_conntrack_init(void)
 {
-	need_conntrack();
 	return xt_register_match(&conntrack_match);
 }
 
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 5d7818b..04bc32b 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -24,6 +24,7 @@
 #endif
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_helper.h>
+#include <net/netfilter/nf_conntrack_compat.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Josefsson <gandalf@netfilter.org>");
@@ -143,13 +144,11 @@ static int check(const char *tablename,
 {
 	struct xt_helper_info *info = matchinfo;
 
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
-		printk(KERN_WARNING "can't load nf_conntrack support for "
+		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", match->family);
 		return 0;
 	}
-#endif
 	info->name[29] = '\0';
 	return 1;
 }
@@ -157,9 +156,7 @@ static int check(const char *tablename,
 static void
 destroy(const struct xt_match *match, void *matchinfo)
 {
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
-#endif
 }
 
 static struct xt_match xt_helper_match[] = {
@@ -185,7 +182,6 @@ static struct xt_match xt_helper_match[]
 
 static int __init xt_helper_init(void)
 {
-	need_conntrack();
 	return xt_register_matches(xt_helper_match,
 				   ARRAY_SIZE(xt_helper_match));
 }
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index d9010b1..df37b91 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -50,22 +50,18 @@ static int check(const char *tablename,
 		 void *matchinfo,
 		 unsigned int hook_mask)
 {
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
-		printk(KERN_WARNING "can't load nf_conntrack support for "
+		printk(KERN_WARNING "can't load conntrack support for "
 				    "proto=%d\n", match->family);
 		return 0;
 	}
-#endif
 	return 1;
 }
 
 static void
 destroy(const struct xt_match *match, void *matchinfo)
 {
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
-#endif
 }
 
 static struct xt_match xt_state_match[] = {
@@ -91,7 +87,6 @@ static struct xt_match xt_state_match[]
 
 static int __init xt_state_init(void)
 {
-	need_conntrack();
 	return xt_register_matches(xt_state_match, ARRAY_SIZE(xt_state_match));
 }
 
-- 
1.4.4
