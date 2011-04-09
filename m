From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 3/3] netfilter: ipset: set match and SET target fixes
Date: Sat,  9 Apr 2011 22:03:02 +0200
Message-ID: <1302379382-32338-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1302379382-32338-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1302379382-32338-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1302379382-32338-3-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:41258 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab1DIUDF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Apr 2011 16:03:05 -0400
In-Reply-To: <1302379382-32338-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The SET target with --del-set did not work due to using wrongly
the internal dimension of --add-set instead of --del-set.
Also, the checkentries did not release the set references when
returned an error. Bugs reported by Lennert Buytenhek.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/xt_set.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 061d48c..b3babae 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -81,6 +81,7 @@ set_match_v0_checkentry(const struct xt_mtchk_param *par)
 	if (info->match_set.u.flags[IPSET_DIM_MAX-1] != 0) {
 		pr_warning("Protocol error: set match dimension "
 			   "is over the limit!\n");
+		ip_set_nfnl_put(info->match_set.index);
 		return -ERANGE;
 	}
 
@@ -135,6 +136,8 @@ set_target_v0_checkentry(const struct xt_tgchk_param *par)
 		if (index == IPSET_INVALID_ID) {
 			pr_warning("Cannot find del_set index %u as target\n",
 				   info->del_set.index);
+			if (info->add_set.index != IPSET_INVALID_ID)
+				ip_set_nfnl_put(info->add_set.index);
 			return -ENOENT;
 		}
 	}
@@ -142,6 +145,10 @@ set_target_v0_checkentry(const struct xt_tgchk_param *par)
 	    info->del_set.u.flags[IPSET_DIM_MAX-1] != 0) {
 		pr_warning("Protocol error: SET target dimension "
 			   "is over the limit!\n");
+		if (info->add_set.index != IPSET_INVALID_ID)
+			ip_set_nfnl_put(info->add_set.index);
+		if (info->del_set.index != IPSET_INVALID_ID)
+			ip_set_nfnl_put(info->del_set.index);
 		return -ERANGE;
 	}
 
@@ -192,6 +199,7 @@ set_match_checkentry(const struct xt_mtchk_param *par)
 	if (info->match_set.dim > IPSET_DIM_MAX) {
 		pr_warning("Protocol error: set match dimension "
 			   "is over the limit!\n");
+		ip_set_nfnl_put(info->match_set.index);
 		return -ERANGE;
 	}
 
@@ -219,7 +227,7 @@ set_target(struct sk_buff *skb, const struct xt_action_param *par)
 	if (info->del_set.index != IPSET_INVALID_ID)
 		ip_set_del(info->del_set.index,
 			   skb, par->family,
-			   info->add_set.dim,
+			   info->del_set.dim,
 			   info->del_set.flags);
 
 	return XT_CONTINUE;
@@ -245,13 +253,19 @@ set_target_checkentry(const struct xt_tgchk_param *par)
 		if (index == IPSET_INVALID_ID) {
 			pr_warning("Cannot find del_set index %u as target\n",
 				   info->del_set.index);
+			if (info->add_set.index != IPSET_INVALID_ID)
+				ip_set_nfnl_put(info->add_set.index);
 			return -ENOENT;
 		}
 	}
 	if (info->add_set.dim > IPSET_DIM_MAX ||
-	    info->del_set.flags > IPSET_DIM_MAX) {
+	    info->del_set.dim > IPSET_DIM_MAX) {
 		pr_warning("Protocol error: SET target dimension "
 			   "is over the limit!\n");
+		if (info->add_set.index != IPSET_INVALID_ID)
+			ip_set_nfnl_put(info->add_set.index);
+		if (info->del_set.index != IPSET_INVALID_ID)
+			ip_set_nfnl_put(info->del_set.index);
 		return -ERANGE;
 	}
 
-- 
1.7.0.4

