Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27969C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 21:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F156C21852
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 21:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfBZVNg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 16:13:36 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:47986 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfBZVNg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 16:13:36 -0500
Received: from localhost ([::1]:32844 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1gyk2g-0006mN-KE; Tue, 26 Feb 2019 22:13:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 5/5] parser_json: Respect base chain priority
Date:   Tue, 26 Feb 2019 22:13:42 +0100
Message-Id: <20190226211342.15125-6-phil@nwl.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190226211342.15125-1-phil@nwl.cc>
References: <20190226211342.15125-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Priority value was parsed but not assigned to allocated chain object.

Fixes: 586ad210368b7 ("libnftables: Implement JSON parser")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/parser_json.c b/src/parser_json.c
index c92113ba516c2..7b190bc78103e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2395,6 +2395,7 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 	chain = chain_alloc(NULL);
 	chain->flags |= CHAIN_F_BASECHAIN;
 	chain->type = xstrdup(type);
+	chain->priority.num = prio;
 	chain->hookstr = chain_hookname_lookup(hookstr);
 	if (!chain->hookstr) {
 		json_error(ctx, "Invalid chain hook '%s'.", hookstr);
-- 
2.20.1

