From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink: fix element addition to map with stateful object
Date: Tue, 17 Oct 2017 12:32:50 +0200
Message-ID: <20171017103250.9441-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50920 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933321AbdJQKdF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 06:33:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 553B952313
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 12:33:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41908BAAB4
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 12:33:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8BB55BAAA7
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 12:32:56 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4BE3640584DC
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 12:32:56 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Expressions with EXPR_F_INTERVAL_END flag set on have no right hand side,
so they store no stateful object. Skip them so we don't crash on this.

 # nft add map x testmap { type inet_service: counter\; flags interval\;}
 # nft add counter x testcounter
 # nft add element x testmap { 0-100 : "testcounter" }
 Segmentation fault

This patch also fixes the listing codepath.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1190
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index d5d410a84762..e8d0e31348f0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -261,7 +261,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 			break;
 		}
 	}
-	if (set->set_flags & NFT_SET_OBJECT) {
+	if (set->set_flags & NFT_SET_OBJECT && data != NULL) {
 		netlink_gen_data(data, &nld);
 		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_OBJREF,
 				   nld.value, nld.len);
@@ -1595,8 +1595,13 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		expr = mapping_expr_alloc(&netlink_location, expr, data);
 	}
 	if (set->flags & NFT_SET_OBJECT) {
-		nld.value = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_OBJREF,
-					       &nld.len);
+		if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_OBJREF)) {
+			nld.value = nftnl_set_elem_get(nlse,
+						       NFTNL_SET_ELEM_OBJREF,
+						       &nld.len);
+		} else
+			goto out;
+
 		data = netlink_alloc_value(&netlink_location, &nld);
 		data->dtype = &string_type;
 		data->byteorder = BYTEORDER_HOST_ENDIAN;
-- 
2.11.0

