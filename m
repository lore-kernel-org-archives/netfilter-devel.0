Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD378C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Feb 2022 17:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243575AbiBQRJt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:09:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239347AbiBQRJs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Feb 2022 12:09:48 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E673D22F755
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Feb 2022 09:09:31 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 52464601E7
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Feb 2022 18:08:49 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink: check key is EXPR_CONCAT before accessing field
Date:   Thu, 17 Feb 2022 18:09:27 +0100
Message-Id: <20220217170927.2575155-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

alloc_nftnl_setelem() needs to check for EXPR_CONCAT before accessing
field_count.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index b6d348321739..ac73e96f9d24 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -135,7 +135,8 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	default:
 		__netlink_gen_data(key, &nld, false);
 		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
-		if (set->set_flags & NFT_SET_INTERVAL && key->field_count > 1) {
+		if (set->set_flags & NFT_SET_INTERVAL &&
+		    key->etype == EXPR_CONCAT && key->field_count > 1) {
 			key->flags |= EXPR_F_INTERVAL_END;
 			__netlink_gen_data(key, &nld, false);
 			key->flags &= ~EXPR_F_INTERVAL_END;
-- 
2.30.2

