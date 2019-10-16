Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F170EFA3728
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 23:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF31F207FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 23:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405683AbfJPXDt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 19:03:49 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40208 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbfJPXDt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 19:03:49 -0400
Received: from localhost ([::1]:53298 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKsKZ-0005fF-TQ; Thu, 17 Oct 2019 01:03:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/4] monitor: Add missing newline to error message
Date:   Thu, 17 Oct 2019 01:03:19 +0200
Message-Id: <20191016230322.24432-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016230322.24432-1-phil@nwl.cc>
References: <20191016230322.24432-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These shouldn't happen in practice and printing to stderr is not the
right thing either, but fix this anyway.

Fixes: f9563c0feb24d ("src: add events reporting")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/monitor.c b/src/monitor.c
index 40c381149cdaa..20810a5de0cfb 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -388,7 +388,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 
 	set = set_lookup_global(family, table, setname, &monh->ctx->nft->cache);
 	if (set == NULL) {
-		fprintf(stderr, "W: Received event for an unknown set.");
+		fprintf(stderr, "W: Received event for an unknown set.\n");
 		goto out;
 	}
 
-- 
2.23.0

