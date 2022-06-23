Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4F9C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 19:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiFWTCv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 15:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiFWTC3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 15:02:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3386D1141
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 11:07:56 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: memleak when parsing concatenation data
Date:   Thu, 23 Jun 2022 20:07:52 +0200
Message-Id: <20220623180752.86126-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

netlink_get_register() clones the expression in the register,
release after using it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 068c3bba1159..3bdd98d47eb0 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -200,6 +200,7 @@ static struct expr *netlink_parse_concat_data(struct netlink_parse_ctx *ctx,
 
 		len -= netlink_padded_len(expr->len);
 		reg += netlink_register_space(expr->len);
+		expr_free(expr);
 	}
 	return concat;
 
-- 
2.30.2

