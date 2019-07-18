Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68182C76192
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 03:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C622077C
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 03:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389556AbfGRDj4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 23:39:56 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:33914 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389174AbfGRDjz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 23:39:55 -0400
Received: from localhost ([::1]:47004 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hnxGs-0008RL-Tx; Thu, 18 Jul 2019 05:39:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/3] meta: Reject zero ifindex values
Date:   Thu, 18 Jul 2019 05:39:38 +0200
Message-Id: <20190718033940.12820-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/meta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/meta.c b/src/meta.c
index 1e8964eb48c4d..b12340991f35a 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -155,7 +155,7 @@ static struct error_record *ifindex_type_parse(const struct expr *sym,
 		errno = 0;
 		res = strtol(sym->identifier, &end, 10);
 
-		if (res < 0 || res > INT_MAX || *end || errno)
+		if (res <= 0 || res > INT_MAX || *end || errno)
 			return error(&sym->location, "Interface does not exist");
 
 		ifindex = (int)res;
-- 
2.22.0

