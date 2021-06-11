Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDA7C48BE5
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 16:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DCDE611AE
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 16:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhFKQn3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 12:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhFKQn1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 12:43:27 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD328C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jun 2021 09:41:26 -0700 (PDT)
Received: from localhost ([::1]:41342 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1lrkDl-0005e8-C0; Fri, 11 Jun 2021 18:41:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 05/10] netlink: Avoid memleak in error path of netlink_delinearize_set()
Date:   Fri, 11 Jun 2021 18:40:59 +0200
Message-Id: <20210611164104.8121-6-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611164104.8121-1-phil@nwl.cc>
References: <20210611164104.8121-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duplicate string 'comment' later when the function does not fail
anymore.

Fixes: 0864c2d49ee8a ("src: add comment support for set declarations")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index e91b06e3ea971..41cce3379ca50 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -867,7 +867,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		if (ud[NFTNL_UDATA_SET_DATA_TYPEOF])
 			typeof_expr_data = set_make_key(ud[NFTNL_UDATA_SET_DATA_TYPEOF]);
 		if (ud[NFTNL_UDATA_SET_COMMENT])
-			comment = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_SET_COMMENT]));
+			comment = nftnl_udata_get(ud[NFTNL_UDATA_SET_COMMENT]);
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
@@ -905,7 +905,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.set.name = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 	set->automerge	   = automerge;
 	if (comment)
-		set->comment = comment;
+		set->comment = xstrdup(comment);
 
 	init_list_head(&set_parse_ctx.stmt_list);
 
-- 
2.31.1

