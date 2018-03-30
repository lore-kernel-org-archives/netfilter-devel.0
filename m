From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/47] netfilter: x_tables: enforce unique and ascending entry points
Date: Fri, 30 Mar 2018 13:38:37 +0200
Message-ID: <20180330113914.18431-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Harmless from kernel point of view, but iptables assumes that this is
true when decoding a ruleset.

iptables walks the dumped blob from kernel, and, for each entry that
creates a new chain it prints out rule/chain information.
Base chains (hook entry points) are thus only shown when they appear
in the rule blob.  One base chain that is referenced multiple times
in hook blob is then only printed once.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 5d8ba89a8da8..4e6cbb38e616 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -529,10 +529,15 @@ static int xt_check_entry_match(const char *match, const char *target,
  */
 int xt_check_table_hooks(const struct xt_table_info *info, unsigned int valid_hooks)
 {
-	unsigned int i;
+	const char *err = "unsorted underflow";
+	unsigned int i, max_uflow, max_entry;
+	bool check_hooks = false;
 
 	BUILD_BUG_ON(ARRAY_SIZE(info->hook_entry) != ARRAY_SIZE(info->underflow));
 
+	max_entry = 0;
+	max_uflow = 0;
+
 	for (i = 0; i < ARRAY_SIZE(info->hook_entry); i++) {
 		if (!(valid_hooks & (1 << i)))
 			continue;
@@ -541,9 +546,33 @@ int xt_check_table_hooks(const struct xt_table_info *info, unsigned int valid_ho
 			return -EINVAL;
 		if (info->underflow[i] == 0xFFFFFFFF)
 			return -EINVAL;
+
+		if (check_hooks) {
+			if (max_uflow > info->underflow[i])
+				goto error;
+
+			if (max_uflow == info->underflow[i]) {
+				err = "duplicate underflow";
+				goto error;
+			}
+			if (max_entry > info->hook_entry[i]) {
+				err = "unsorted entry";
+				goto error;
+			}
+			if (max_entry == info->hook_entry[i]) {
+				err = "duplicate entry";
+				goto error;
+			}
+		}
+		max_entry = info->hook_entry[i];
+		max_uflow = info->underflow[i];
+		check_hooks = true;
 	}
 
 	return 0;
+error:
+	pr_err_ratelimited("%s at hook %d\n", err, i);
+	return -EINVAL;
 }
 EXPORT_SYMBOL(xt_check_table_hooks);
 
-- 
2.11.0
