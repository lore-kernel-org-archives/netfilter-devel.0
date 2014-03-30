From: mathieu.poirier@linaro.org
Subject: [RFC PATCH 2/2] netfilter: xt_nfacct: Add quota to nfacct filter
Date: Sun, 30 Mar 2014 15:10:44 -0600
Message-ID: <1396213844-10528-3-git-send-email-mathieu.poirier@linaro.org>
References: <1396213844-10528-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40431 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaC3VK7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 17:10:59 -0400
Received: by mail-pd0-f179.google.com with SMTP id w10so7042107pde.24
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Mar 2014 14:10:58 -0700 (PDT)
In-Reply-To: <1396213844-10528-1-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Fixing quota management in accounting framework, most notably:
- Clearing overquota bit in 'nfnl_acct_fill_info' when userspace
resets accounting statistics.
- Decoupling quota attainment verification and message dispatch
in 'nfnl_acct_overquota'.

With the above adding quota limits to xt_nfacct is trival.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 include/linux/netfilter/nfnetlink_acct.h |  3 ++-
 net/netfilter/nfnetlink_acct.c           | 36 ++++++++++++++++++++++----------
 net/netfilter/xt_nfacct.c                | 13 ++++++++++++
 3 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index b2e85e5..cfc210d 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -9,5 +9,6 @@ struct nf_acct;
 struct nf_acct *nfnl_acct_find_get(const char *filter_name);
 void nfnl_acct_put(struct nf_acct *acct);
 void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
-
+extern bool nfnl_acct_overquota(const struct sk_buff *skb,
+				struct nf_acct *nfacct);
 #endif /* _NFNL_ACCT_H */
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 25afecf..e0b5147 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -147,6 +147,10 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
 		pkts = atomic64_xchg(&acct->pkts, 0);
 		bytes = atomic64_xchg(&acct->bytes, 0);
+		if (acct->flags & NFACCT_F_QUOTA) {
+			smp_mb__before_clear_bit();
+			clear_bit(NFACCT_F_OVERQUOTA, &acct->flags);
+		}
 	} else {
 		pkts = atomic64_read(&acct->pkts);
 		bytes = atomic64_read(&acct->bytes);
@@ -393,23 +397,33 @@ static void nfnl_overquota_report(struct nf_acct *nfacct)
 			  GFP_ATOMIC);
 }
 
+/* Check 'skb' statistics against accounting object 'nfacct'.  Quotas limits
+ * are considered inclusive.  A message is sent to userspace if at or above
+ * a quota.
+ *
+ * Returns -EINVAL if nfacct object doesn't have a quota, true if above quota
+ * and false is below or at quota.
+ */
 bool nfnl_acct_overquota(const struct sk_buff *skb, struct nf_acct *nfacct)
 {
+	u64 now;
 	u64 *quota;
 	bool ret = false;
 
-	if (nfacct->flags & NFACCT_F_QUOTA_PKTS) {
-		quota = (u64 *)nfacct->data;
-		ret = atomic64_read(&nfacct->pkts) >= *quota &&
-		      !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags);
-	}
-	if (nfacct->flags & NFACCT_F_QUOTA_BYTES) {
-		quota = (u64 *)nfacct->data;
-		ret = atomic64_read(&nfacct->bytes) >= *quota &&
-		      !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags);
-	}
-	if (ret)
+	/* no place here if we don't have a quota */
+	if (!(nfacct->flags & NFACCT_F_QUOTA))
+		return -EINVAL;
+
+	quota = (u64 *)nfacct->data;
+	now = (nfacct->flags & NFACCT_F_QUOTA_PKTS) ?
+	       atomic64_read(&nfacct->pkts) : atomic64_read(&nfacct->bytes);
+
+	ret = now > *quota;
+
+	if (now >= *quota &&
+	    !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags)) {
 		nfnl_overquota_report(nfacct);
+	}
 
 	return ret;
 }
diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index b3be0ef..bbe1491 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -21,10 +21,23 @@ MODULE_ALIAS("ip6t_nfacct");
 
 static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
+	bool overquota;
 	const struct xt_nfacct_match_info *info = par->targinfo;
 
 	nfnl_acct_update(skb, info->nfacct);
 
+	overquota = nfnl_acct_overquota(skb, info->nfacct);
+
+	/* The only time packets are allowed through is when:
+	 * 1) A quota has been specivied.
+	 * 2) That quota hasn't been reached yet.
+	 */
+	if (overquota == false)
+		return false;
+
+	 /* Return true if a quota hasn't been specified or if
+	  * quota has been attained.
+	  */
 	return true;
 }
 
-- 
1.8.3.2

