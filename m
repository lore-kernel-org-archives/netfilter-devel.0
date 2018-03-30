From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/47] netfilter: x_tables: add counters allocation wrapper
Date: Fri, 30 Mar 2018 13:38:40 +0200
Message-ID: <20180330113914.18431-4-pablo@netfilter.org>
References: <20180330113914.18431-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113914.18431-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

allows to have size checks in a single spot.
This is supposed to reduce oom situations when fuzz-testing xtables.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |  1 +
 net/ipv4/netfilter/arp_tables.c    |  2 +-
 net/ipv4/netfilter/ip_tables.c     |  2 +-
 net/ipv6/netfilter/ip6_tables.c    |  2 +-
 net/netfilter/x_tables.c           | 15 +++++++++++++++
 5 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index fa0c19c328f1..0bd93c589a8c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -301,6 +301,7 @@ int xt_data_to_user(void __user *dst, const void *src,
 
 void *xt_copy_counters_from_user(const void __user *user, unsigned int len,
 				 struct xt_counters_info *info, bool compat);
+struct xt_counters *xt_counters_alloc(unsigned int counters);
 
 struct xt_table *xt_register_table(struct net *net,
 				   const struct xt_table *table,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index be5821215ea0..82ba09b50fdb 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -883,7 +883,7 @@ static int __do_replace(struct net *net, const char *name,
 	struct arpt_entry *iter;
 
 	ret = 0;
-	counters = vzalloc(num_counters * sizeof(struct xt_counters));
+	counters = xt_counters_alloc(num_counters);
 	if (!counters) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 29bda9484a33..4901ca6c3e09 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1045,7 +1045,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct ipt_entry *iter;
 
 	ret = 0;
-	counters = vzalloc(num_counters * sizeof(struct xt_counters));
+	counters = xt_counters_alloc(num_counters);
 	if (!counters) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ba3776a4d305..e84cec49b60f 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1063,7 +1063,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct ip6t_entry *iter;
 
 	ret = 0;
-	counters = vzalloc(num_counters * sizeof(struct xt_counters));
+	counters = xt_counters_alloc(num_counters);
 	if (!counters) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 01f8e122e74e..82b1f8f52ac6 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1290,6 +1290,21 @@ static int xt_jumpstack_alloc(struct xt_table_info *i)
 	return 0;
 }
 
+struct xt_counters *xt_counters_alloc(unsigned int counters)
+{
+	struct xt_counters *mem;
+
+	if (counters == 0 || counters > INT_MAX / sizeof(*mem))
+		return NULL;
+
+	counters *= sizeof(*mem);
+	if (counters > XT_MAX_TABLE_SIZE)
+		return NULL;
+
+	return vzalloc(counters);
+}
+EXPORT_SYMBOL(xt_counters_alloc);
+
 struct xt_table_info *
 xt_replace_table(struct xt_table *table,
 	      unsigned int num_counters,
-- 
2.11.0
