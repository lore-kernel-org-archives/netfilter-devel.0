From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/13]: xt_tables: add centralized error checking
Date: Thu, 16 Feb 2006 22:32:11 +0100 (MET)
Message-ID: <20060216213211.6933.4862.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_tables: add centralized error checking

Introduce new functions for common match/target checks (private data
size, valid hooks, valid tables and valid protocols) to get more consistent
error reporting and to avoid each module duplicating them.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ef8e3f5ae821c8023c72faf255f2256a5326d723
tree 1539653b16ea0d3c4cc7ec0ae1c5223807e575dc
parent a99f01294a6531c0511ff84bc735e92e12e88c99
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:01 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:01 +0100

 include/linux/netfilter/x_tables.h |   23 ++++++++++--
 net/netfilter/x_tables.c           |   72 +++++++++++++++++++++++++++++++++---
 2 files changed, 84 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 6500d4e..b9c37e1 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -92,8 +92,6 @@ struct xt_match
 
 	const char name[XT_FUNCTION_MAXNAMELEN-1];
 
-	u_int8_t revision;
-
 	/* Return true or false: return FALSE and set *hotdrop = 1 to
            force immediate packet drop. */
 	/* Arguments changed since 2.6.9, as this must now handle
@@ -120,6 +118,12 @@ struct xt_match
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
+
+	char *table;
+	unsigned int matchsize;
+	unsigned int hooks;
+	unsigned short proto;
+	u_int8_t revision;
 };
 
 /* Registration hooks for targets. */
@@ -129,8 +133,6 @@ struct xt_target
 
 	const char name[XT_FUNCTION_MAXNAMELEN-1];
 
-	u_int8_t revision;
-
 	/* Returns verdict. Argument order changed since 2.6.9, as this
 	   must now handle non-linear skbs, using skb_copy_bits and
 	   skb_ip_make_writable. */
@@ -156,6 +158,12 @@ struct xt_target
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
+
+	char *table;
+	unsigned int targetsize;
+	unsigned int hooks;
+	unsigned short proto;
+	u_int8_t revision;
 };
 
 /* Furniture shopping... */
@@ -207,6 +215,13 @@ extern void xt_unregister_target(int af,
 extern int xt_register_match(int af, struct xt_match *target);
 extern void xt_unregister_match(int af, struct xt_match *target);
 
+extern int xt_check_match(const struct xt_match *match, unsigned short family,
+			  unsigned int size, const char *table, unsigned int hook,
+			  unsigned short proto, int inv_proto);
+extern int xt_check_target(const struct xt_target *target, unsigned short family,
+			   unsigned int size, const char *table, unsigned int hook,
+			   unsigned short proto, int inv_proto);
+
 extern int xt_register_table(struct xt_table *table,
 			     struct xt_table_info *bootstrap,
 			     struct xt_table_info *newinfo);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d7817af..750b928 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -52,6 +52,12 @@ enum {
 	MATCH,
 };
 
+static const char *xt_prefix[NPROTO] = {
+	[AF_INET] 	= "ip",
+	[AF_INET6] 	= "ip6",
+	[NF_ARP]	= "arp",
+};
+
 /* Registration hooks for targets. */
 int
 xt_register_target(int af, struct xt_target *target)
@@ -158,18 +164,12 @@ struct xt_target *xt_find_target(int af,
 }
 EXPORT_SYMBOL(xt_find_target);
 
-static const char *xt_prefix[NPROTO] = {
-	[AF_INET] 	= "ipt_%s",
-	[AF_INET6] 	= "ip6t_%s",
-	[NF_ARP]	= "arpt_%s",
-};
-
 struct xt_target *xt_request_find_target(int af, const char *name, u8 revision)
 {
 	struct xt_target *target;
 
 	target = try_then_request_module(xt_find_target(af, name, revision),
-					 xt_prefix[af], name);
+					 "%st_%s", xt_prefix[af], name);
 	if (IS_ERR(target) || !target)
 		return NULL;
 	return target;
@@ -237,6 +237,64 @@ int xt_find_revision(int af, const char 
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
 
+int xt_check_match(const struct xt_match *match, unsigned short family,
+                   unsigned int size, const char *table, unsigned int hook_mask,
+		   unsigned short proto, int inv_proto)
+{
+	if (XT_ALIGN(match->matchsize) != size) {
+		printk("%s_tables: %s match: invalid size %Zu != %u\n",
+		       xt_prefix[family], match->name,
+		       XT_ALIGN(match->matchsize), size);
+		return -EINVAL;
+	}
+	if (match->table && strcmp(match->table, table)) {
+		printk("%s_tables: %s match: only valid in %s table, not %s\n",
+		       xt_prefix[family], match->name, match->table, table);
+		return -EINVAL;
+	}
+	if (match->hooks && (hook_mask & ~match->hooks) != 0) {
+		printk("%s_tables: %s match: bad hook_mask %u\n",
+		       xt_prefix[family], match->name, hook_mask);
+		return -EINVAL;
+	}
+	if (match->proto && (match->proto != proto || inv_proto)) {
+		printk("%s_tables: %s match: only valid for protocol %u\n",
+		       xt_prefix[family], match->name, match->proto);
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xt_check_match);
+
+int xt_check_target(const struct xt_target *target, unsigned short family,
+		    unsigned int size, const char *table, unsigned int hook_mask,
+		    unsigned short proto, int inv_proto)
+{
+	if (XT_ALIGN(target->targetsize) != size) {
+		printk("%s_tables: %s target: invalid size %Zu != %u\n",
+		       xt_prefix[family], target->name,
+		       XT_ALIGN(target->targetsize), size);
+		return -EINVAL;
+	}
+	if (target->table && strcmp(target->table, table)) {
+		printk("%s_tables: %s target: only valid in %s table, not %s\n",
+		       xt_prefix[family], target->name, target->table, table);
+		return -EINVAL;
+	}
+	if (target->hooks && (hook_mask & ~target->hooks) != 0) {
+		printk("%s_tables: %s target: bad hook_mask %u\n",
+		       xt_prefix[family], target->name, hook_mask);
+		return -EINVAL;
+	}
+	if (target->proto && (target->proto != proto || inv_proto)) {
+		printk("%s_tables: %s target: only valid for protocol %u\n",
+		       xt_prefix[family], target->name, target->proto);
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xt_check_target);
+
 struct xt_table_info *xt_alloc_table_info(unsigned int size)
 {
 	struct xt_table_info *newinfo;
