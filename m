From: fgao@ikuai8.com
Subject: [PATCH v7 nf] netfilter: synproxy: Check oom when adding synproxy and seqadj ct extensions
Date: Fri,  9 Sep 2016 22:50:21 +0800
Message-ID: <1473432621-20908-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg320.qq.com ([14.17.32.29]:59559 "EHLO smtpbg320.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751290AbcIIOvI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 10:51:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

When memory is exhausted, nfct_seqadj_ext_add may fail to add the
synproxy and seqadj extensions. The function nf_ct_seqadj_init doesn't
check if get valid seqadj pointer by the nfct_seqadj.

Now drop the packet directly when fail to add seqadj extension to
avoid dereference NULL pointer in nf_ct_seqadj_init from
init_conntrack().

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v7: Remove one debug log and revert to NF_DROP again;
 v6: Add one helper function to add synproxy
 v5: Return NF_ACCEPT instead of NF_DROP when nfct_seqadj_ext_add failed in nf_nat_setup_info
 v4: Drop the packet directly when fail to add seqadj extension;
 v3: Remove the warning log when seqadj is null;
 v2: Remove the unnessary seqadj check in nf_ct_seq_adjust
 v1: Initial patch

 include/net/netfilter/nf_conntrack_synproxy.h | 13 +++++++++++++
 net/netfilter/nf_conntrack_core.c             |  6 +++---
 net/netfilter/nf_nat_core.c                   |  3 ++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index 6793614..e8cf825 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -27,6 +27,19 @@ static inline struct nf_conn_synproxy *nfct_synproxy_ext_add(struct nf_conn *ct)
 #endif
 }
 
+static inline bool nf_ct_add_synproxy(struct nf_conn *ct, const struct nf_conn *tmpl)
+{
+	if (tmpl && nfct_synproxy(tmpl)) {
+		if (!nfct_seqadj_ext_add(ct))
+			return false;
+
+		if (!nfct_synproxy_ext_add(ct))
+			return false;
+	}
+
+	return true;
+}
+
 struct synproxy_stats {
 	unsigned int			syn_received;
 	unsigned int			cookie_invalid;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index dd2c43a..64aabeb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1035,9 +1035,9 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	if (IS_ERR(ct))
 		return (struct nf_conntrack_tuple_hash *)ct;
 
-	if (tmpl && nfct_synproxy(tmpl)) {
-		nfct_seqadj_ext_add(ct);
-		nfct_synproxy_ext_add(ct);
+	if (!nf_ct_add_synproxy(ct, tmpl)) {
+		nf_conntrack_free(ct);
+		return NULL;
 	}
 
 	timeout_ext = tmpl ? nf_ct_timeout_find(tmpl) : NULL;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index de31818..b82282a 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -441,7 +441,8 @@ nf_nat_setup_info(struct nf_conn *ct,
 			ct->status |= IPS_DST_NAT;
 
 		if (nfct_help(ct))
-			nfct_seqadj_ext_add(ct);
+			if (!nfct_seqadj_ext_add(ct))
+				return NF_DROP;
 	}
 
 	if (maniptype == NF_NAT_MANIP_SRC) {
-- 
1.9.1

