Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90950C4646B
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 00:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72C38205ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 00:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfFYAOt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 20:14:49 -0400
Received: from mail.us.es ([193.147.175.20]:38022 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729252AbfFYAMs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 02A54C04AF
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 02:12:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6896DA70C
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DC07BDA70A; Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD174DA704;
        Tue, 25 Jun 2019 02:12:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A0ACA4265A2F;
        Tue, 25 Jun 2019 02:12:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/26] netfilter: ipset: Fix error path in set_target_v3_checkentry()
Date:   Tue, 25 Jun 2019 02:12:13 +0200
Message-Id: <20190625001233.22057-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Fix error path and release the references properly.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/xt_set.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index bf2890b13212..cf67bbe07dc2 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -439,6 +439,7 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 {
 	const struct xt_set_info_target_v3 *info = par->targinfo;
 	ip_set_id_t index;
+	int ret = 0;
 
 	if (info->add_set.index != IPSET_INVALID_ID) {
 		index = ip_set_nfnl_get_byindex(par->net,
@@ -456,17 +457,16 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 		if (index == IPSET_INVALID_ID) {
 			pr_info_ratelimited("Cannot find del_set index %u as target\n",
 					    info->del_set.index);
-			if (info->add_set.index != IPSET_INVALID_ID)
-				ip_set_nfnl_put(par->net,
-						info->add_set.index);
-			return -ENOENT;
+			ret = -ENOENT;
+			goto cleanup_add;
 		}
 	}
 
 	if (info->map_set.index != IPSET_INVALID_ID) {
 		if (strncmp(par->table, "mangle", 7)) {
 			pr_info_ratelimited("--map-set only usable from mangle table\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto cleanup_del;
 		}
 		if (((info->flags & IPSET_FLAG_MAP_SKBPRIO) |
 		     (info->flags & IPSET_FLAG_MAP_SKBQUEUE)) &&
@@ -474,20 +474,16 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 					 1 << NF_INET_LOCAL_OUT |
 					 1 << NF_INET_POST_ROUTING))) {
 			pr_info_ratelimited("mapping of prio or/and queue is allowed only from OUTPUT/FORWARD/POSTROUTING chains\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto cleanup_del;
 		}
 		index = ip_set_nfnl_get_byindex(par->net,
 						info->map_set.index);
 		if (index == IPSET_INVALID_ID) {
 			pr_info_ratelimited("Cannot find map_set index %u as target\n",
 					    info->map_set.index);
-			if (info->add_set.index != IPSET_INVALID_ID)
-				ip_set_nfnl_put(par->net,
-						info->add_set.index);
-			if (info->del_set.index != IPSET_INVALID_ID)
-				ip_set_nfnl_put(par->net,
-						info->del_set.index);
-			return -ENOENT;
+			ret = -ENOENT;
+			goto cleanup_del;
 		}
 	}
 
@@ -495,16 +491,21 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 	    info->del_set.dim > IPSET_DIM_MAX ||
 	    info->map_set.dim > IPSET_DIM_MAX) {
 		pr_info_ratelimited("SET target dimension over the limit!\n");
-		if (info->add_set.index != IPSET_INVALID_ID)
-			ip_set_nfnl_put(par->net, info->add_set.index);
-		if (info->del_set.index != IPSET_INVALID_ID)
-			ip_set_nfnl_put(par->net, info->del_set.index);
-		if (info->map_set.index != IPSET_INVALID_ID)
-			ip_set_nfnl_put(par->net, info->map_set.index);
-		return -ERANGE;
+		ret = -ERANGE;
+		goto cleanup_mark;
 	}
 
 	return 0;
+cleanup_mark:
+	if (info->map_set.index != IPSET_INVALID_ID)
+		ip_set_nfnl_put(par->net, info->map_set.index);
+cleanup_del:
+	if (info->del_set.index != IPSET_INVALID_ID)
+		ip_set_nfnl_put(par->net, info->del_set.index);
+cleanup_add:
+	if (info->add_set.index != IPSET_INVALID_ID)
+		ip_set_nfnl_put(par->net, info->add_set.index);
+	return ret;
 }
 
 static void
-- 
2.11.0

