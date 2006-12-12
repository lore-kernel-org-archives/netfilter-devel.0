From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/06]: x_tables: error if ip_conntrack is asked to
	handle IPv6 packets
Date: Tue, 12 Dec 2006 09:06:22 +0100 (MET)
Message-ID: <20061212080946.4788.55095.sendpatchset@localhost.localdomain>
References: <20061212080941.4788.16630.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061212080941.4788.16630.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: error if ip_conntrack is asked to handle IPv6 packets

To do that, this makes nf_ct_l3proto_try_module_{get,put} compatible
functions. As a result we can remove '#ifdef' surrounds and direct call of
need_conntrack().

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 806a57fff01366038e04747ea75adf2c7c5db09f
tree 70890f4a68f8422b0daaf7e20b5ba23e3afdf1e7
parent bc5ca5410c8fa8930ea4cf55ae034e163cb02b76
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 12 Dec 2006 08:50:42 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 12 Dec 2006 08:50:42 +0100

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
@@ -140,7 +136,6 @@ #endif
 
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
@@ -20,6 +20,7 @@ #endif
 
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
@@ -24,6 +24,7 @@ #include <net/netfilter/nf_conntrack_hel
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
@@ -157,9 +156,7 @@ #endif
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
 
