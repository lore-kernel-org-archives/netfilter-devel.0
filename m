Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BAAC48BD1
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 16:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D44613BA
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 16:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhFKQnh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 12:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhFKQng (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 12:43:36 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9020FC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jun 2021 09:41:37 -0700 (PDT)
Received: from localhost ([::1]:41354 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1lrkDv-0005ef-Vs; Fri, 11 Jun 2021 18:41:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 07/10] netlink: Avoid memleak in error path of netlink_delinearize_table()
Date:   Fri, 11 Jun 2021 18:41:01 +0200
Message-Id: <20210611164104.8121-8-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611164104.8121-1-phil@nwl.cc>
References: <20210611164104.8121-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If parsing udata fails, 'table' has to be freed before returning to
caller.

Fixes: c156232a530b3 ("src: add comment support when adding tables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/netlink.c b/src/netlink.c
index 1bbdf98bd2ee2..be98bfb7f5c12 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -647,6 +647,7 @@ struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 		udata = nftnl_table_get_data(nlt, NFTNL_TABLE_USERDATA, &ulen);
 		if (nftnl_udata_parse(udata, ulen, table_parse_udata_cb, ud) < 0) {
 			netlink_io_error(ctx, NULL, "Cannot parse userdata");
+			table_free(table);
 			return NULL;
 		}
 		if (ud[NFTNL_UDATA_TABLE_COMMENT])
-- 
2.31.1

