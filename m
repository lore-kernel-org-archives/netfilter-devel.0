From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/47] netfilter: compat: prepare xt_compat_init_offsets to return errors
Date: Fri, 30 Mar 2018 13:38:41 +0200
Message-ID: <20180330113914.18431-5-pablo@netfilter.org>
References: <20180330113914.18431-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113914.18431-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

should have no impact, function still always returns 0.
This patch is only to ease review.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |  2 +-
 net/bridge/netfilter/ebtables.c    | 10 ++++++++--
 net/ipv4/netfilter/arp_tables.c    | 10 +++++++---
 net/ipv4/netfilter/ip_tables.c     |  8 ++++++--
 net/ipv6/netfilter/ip6_tables.c    | 10 +++++++---
 net/netfilter/x_tables.c           |  4 +++-
 6 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 0bd93c589a8c..7bd896dc78df 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -510,7 +510,7 @@ void xt_compat_unlock(u_int8_t af);
 
 int xt_compat_add_offset(u_int8_t af, unsigned int offset, int delta);
 void xt_compat_flush_offsets(u_int8_t af);
-void xt_compat_init_offsets(u_int8_t af, unsigned int number);
+int xt_compat_init_offsets(u8 af, unsigned int number);
 int xt_compat_calc_jump(u_int8_t af, unsigned int offset);
 
 int xt_compat_match_offset(const struct xt_match *match);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 02c4b409d317..217aa79f7b2a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1819,10 +1819,14 @@ static int compat_table_info(const struct ebt_table_info *info,
 {
 	unsigned int size = info->entries_size;
 	const void *entries = info->entries;
+	int ret;
 
 	newinfo->entries_size = size;
 
-	xt_compat_init_offsets(NFPROTO_BRIDGE, info->nentries);
+	ret = xt_compat_init_offsets(NFPROTO_BRIDGE, info->nentries);
+	if (ret)
+		return ret;
+
 	return EBT_ENTRY_ITERATE(entries, size, compat_calc_entry, info,
 							entries, newinfo);
 }
@@ -2245,7 +2249,9 @@ static int compat_do_replace(struct net *net, void __user *user,
 
 	xt_compat_lock(NFPROTO_BRIDGE);
 
-	xt_compat_init_offsets(NFPROTO_BRIDGE, tmp.nentries);
+	ret = xt_compat_init_offsets(NFPROTO_BRIDGE, tmp.nentries);
+	if (ret < 0)
+		goto out_unlock;
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
 	if (ret < 0)
 		goto out_unlock;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 82ba09b50fdb..aaafdbd15ad3 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -769,7 +769,9 @@ static int compat_table_info(const struct xt_table_info *info,
 	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
 	newinfo->initial_entries = 0;
 	loc_cpu_entry = info->entries;
-	xt_compat_init_offsets(NFPROTO_ARP, info->number);
+	ret = xt_compat_init_offsets(NFPROTO_ARP, info->number);
+	if (ret)
+		return ret;
 	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
 		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
 		if (ret != 0)
@@ -1156,7 +1158,7 @@ static int translate_compat_table(struct xt_table_info **pinfo,
 	struct compat_arpt_entry *iter0;
 	struct arpt_replace repl;
 	unsigned int size;
-	int ret = 0;
+	int ret;
 
 	info = *pinfo;
 	entry0 = *pentry0;
@@ -1165,7 +1167,9 @@ static int translate_compat_table(struct xt_table_info **pinfo,
 
 	j = 0;
 	xt_compat_lock(NFPROTO_ARP);
-	xt_compat_init_offsets(NFPROTO_ARP, compatr->num_entries);
+	ret = xt_compat_init_offsets(NFPROTO_ARP, compatr->num_entries);
+	if (ret)
+		goto out_unlock;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter0, entry0, compatr->size) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4901ca6c3e09..f9063513f9d1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -933,7 +933,9 @@ static int compat_table_info(const struct xt_table_info *info,
 	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
 	newinfo->initial_entries = 0;
 	loc_cpu_entry = info->entries;
-	xt_compat_init_offsets(AF_INET, info->number);
+	ret = xt_compat_init_offsets(AF_INET, info->number);
+	if (ret)
+		return ret;
 	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
 		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
 		if (ret != 0)
@@ -1407,7 +1409,9 @@ translate_compat_table(struct net *net,
 
 	j = 0;
 	xt_compat_lock(AF_INET);
-	xt_compat_init_offsets(AF_INET, compatr->num_entries);
+	ret = xt_compat_init_offsets(AF_INET, compatr->num_entries);
+	if (ret)
+		goto out_unlock;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter0, entry0, compatr->size) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e84cec49b60f..3c36a4c77f29 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -950,7 +950,9 @@ static int compat_table_info(const struct xt_table_info *info,
 	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
 	newinfo->initial_entries = 0;
 	loc_cpu_entry = info->entries;
-	xt_compat_init_offsets(AF_INET6, info->number);
+	ret = xt_compat_init_offsets(AF_INET6, info->number);
+	if (ret)
+		return ret;
 	xt_entry_foreach(iter, loc_cpu_entry, info->size) {
 		ret = compat_calc_entry(iter, info, loc_cpu_entry, newinfo);
 		if (ret != 0)
@@ -1414,7 +1416,7 @@ translate_compat_table(struct net *net,
 	struct compat_ip6t_entry *iter0;
 	struct ip6t_replace repl;
 	unsigned int size;
-	int ret = 0;
+	int ret;
 
 	info = *pinfo;
 	entry0 = *pentry0;
@@ -1423,7 +1425,9 @@ translate_compat_table(struct net *net,
 
 	j = 0;
 	xt_compat_lock(AF_INET6);
-	xt_compat_init_offsets(AF_INET6, compatr->num_entries);
+	ret = xt_compat_init_offsets(AF_INET6, compatr->num_entries);
+	if (ret)
+		goto out_unlock;
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter0, entry0, compatr->size) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 82b1f8f52ac6..e878c85a9268 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -632,10 +632,12 @@ int xt_compat_calc_jump(u_int8_t af, unsigned int offset)
 }
 EXPORT_SYMBOL_GPL(xt_compat_calc_jump);
 
-void xt_compat_init_offsets(u_int8_t af, unsigned int number)
+int xt_compat_init_offsets(u8 af, unsigned int number)
 {
 	xt[af].number = number;
 	xt[af].cur = 0;
+
+	return 0;
 }
 EXPORT_SYMBOL(xt_compat_init_offsets);
 
-- 
2.11.0
