From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/47] netfilter: x_tables: move hook entry checks into core
Date: Fri, 30 Mar 2018 13:36:51 +0200
Message-ID: <20180330113729.18335-10-pablo@netfilter.org>
References: <20180330113729.18335-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113729.18335-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Allow followup patch to change on location instead of three.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |  2 ++
 net/ipv4/netfilter/arp_tables.c    | 13 +++----------
 net/ipv4/netfilter/ip_tables.c     | 13 +++----------
 net/ipv6/netfilter/ip6_tables.c    | 13 +++----------
 net/netfilter/x_tables.c           | 29 +++++++++++++++++++++++++++++
 5 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1313b35c3ab7..fa0c19c328f1 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -281,6 +281,8 @@ int xt_check_entry_offsets(const void *base, const char *elems,
 			   unsigned int target_offset,
 			   unsigned int next_offset);
 
+int xt_check_table_hooks(const struct xt_table_info *info, unsigned int valid_hooks);
+
 unsigned int *xt_alloc_entry_offsets(unsigned int size);
 bool xt_find_jump_offset(const unsigned int *offsets,
 			 unsigned int target, unsigned int size);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c9ffa884a4ee..be5821215ea0 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -555,16 +555,9 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	if (i != repl->num_entries)
 		goto out_free;
 
-	/* Check hooks all assigned */
-	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
-		/* Only hooks which are valid */
-		if (!(repl->valid_hooks & (1 << i)))
-			continue;
-		if (newinfo->hook_entry[i] == 0xFFFFFFFF)
-			goto out_free;
-		if (newinfo->underflow[i] == 0xFFFFFFFF)
-			goto out_free;
-	}
+	ret = xt_check_table_hooks(newinfo, repl->valid_hooks);
+	if (ret)
+		goto out_free;
 
 	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0, offsets)) {
 		ret = -ELOOP;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c9b57a6bf96a..29bda9484a33 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -702,16 +702,9 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	if (i != repl->num_entries)
 		goto out_free;
 
-	/* Check hooks all assigned */
-	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
-		/* Only hooks which are valid */
-		if (!(repl->valid_hooks & (1 << i)))
-			continue;
-		if (newinfo->hook_entry[i] == 0xFFFFFFFF)
-			goto out_free;
-		if (newinfo->underflow[i] == 0xFFFFFFFF)
-			goto out_free;
-	}
+	ret = xt_check_table_hooks(newinfo, repl->valid_hooks);
+	if (ret)
+		goto out_free;
 
 	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0, offsets)) {
 		ret = -ELOOP;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f46954221933..ba3776a4d305 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -720,16 +720,9 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	if (i != repl->num_entries)
 		goto out_free;
 
-	/* Check hooks all assigned */
-	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
-		/* Only hooks which are valid */
-		if (!(repl->valid_hooks & (1 << i)))
-			continue;
-		if (newinfo->hook_entry[i] == 0xFFFFFFFF)
-			goto out_free;
-		if (newinfo->underflow[i] == 0xFFFFFFFF)
-			goto out_free;
-	}
+	ret = xt_check_table_hooks(newinfo, repl->valid_hooks);
+	if (ret)
+		goto out_free;
 
 	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0, offsets)) {
 		ret = -ELOOP;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f045bb4f7063..5d8ba89a8da8 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -518,6 +518,35 @@ static int xt_check_entry_match(const char *match, const char *target,
 	return 0;
 }
 
+/** xt_check_table_hooks - check hook entry points are sane
+ *
+ * @info xt_table_info to check
+ * @valid_hooks - hook entry points that we can enter from
+ *
+ * Validates that the hook entry and underflows points are set up.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int xt_check_table_hooks(const struct xt_table_info *info, unsigned int valid_hooks)
+{
+	unsigned int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(info->hook_entry) != ARRAY_SIZE(info->underflow));
+
+	for (i = 0; i < ARRAY_SIZE(info->hook_entry); i++) {
+		if (!(valid_hooks & (1 << i)))
+			continue;
+
+		if (info->hook_entry[i] == 0xFFFFFFFF)
+			return -EINVAL;
+		if (info->underflow[i] == 0xFFFFFFFF)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(xt_check_table_hooks);
+
 #ifdef CONFIG_COMPAT
 int xt_compat_add_offset(u_int8_t af, unsigned int offset, int delta)
 {
-- 
2.11.0
