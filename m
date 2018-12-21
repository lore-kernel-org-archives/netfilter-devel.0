From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 32/37] netfilter: conntrack: un-export seq_print_acct
Date: Fri, 21 Dec 2018 01:28:36 +0100
Message-ID: <20181221002841.28587-33-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Only one caller, just place it where its needed.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_acct.h |  3 ---
 net/netfilter/nf_conntrack_acct.c         | 19 -------------------
 net/netfilter/nf_conntrack_standalone.c   | 18 ++++++++++++++++++
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index 79d8d16732b4..ae5a1c37387e 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -46,9 +46,6 @@ struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 	return acct;
 };
 
-unsigned int seq_print_acct(struct seq_file *s, const struct nf_conn *ct,
-			    int dir);
-
 /* Check if connection tracking accounting is enabled */
 static inline bool nf_ct_acct_enabled(struct net *net)
 {
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 1d66de5151b2..a7ad0e19e0de 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -38,25 +38,6 @@ static struct ctl_table acct_sysctl_table[] = {
 };
 #endif /* CONFIG_SYSCTL */
 
-unsigned int
-seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
-{
-	struct nf_conn_acct *acct;
-	struct nf_conn_counter *counter;
-
-	acct = nf_conn_acct_find(ct);
-	if (!acct)
-		return 0;
-
-	counter = acct->counter;
-	seq_printf(s, "packets=%llu bytes=%llu ",
-		   (unsigned long long)atomic64_read(&counter[dir].packets),
-		   (unsigned long long)atomic64_read(&counter[dir].bytes));
-
-	return 0;
-};
-EXPORT_SYMBOL_GPL(seq_print_acct);
-
 static const struct nf_ct_ext_type acct_extend = {
 	.len	= sizeof(struct nf_conn_acct),
 	.align	= __alignof__(struct nf_conn_acct),
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 463d17d349c1..feeff346f946 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -267,6 +267,24 @@ static const char* l4proto_name(u16 proto)
 	return "unknown";
 }
 
+static unsigned int
+seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
+{
+	struct nf_conn_acct *acct;
+	struct nf_conn_counter *counter;
+
+	acct = nf_conn_acct_find(ct);
+	if (!acct)
+		return 0;
+
+	counter = acct->counter;
+	seq_printf(s, "packets=%llu bytes=%llu ",
+		   (unsigned long long)atomic64_read(&counter[dir].packets),
+		   (unsigned long long)atomic64_read(&counter[dir].bytes));
+
+	return 0;
+}
+
 /* return 0 on success, 1 in case of error */
 static int ct_seq_show(struct seq_file *s, void *v)
 {
-- 
2.11.0
