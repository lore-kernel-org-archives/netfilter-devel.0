Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA9BC3F68F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC75E21775
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfLQL1h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:27:37 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57330 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbfLQL1g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 06:27:36 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihB0p-0006kZ-2w; Tue, 17 Dec 2019 12:27:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3 04/10] expr: add expr_ops_by_type()
Date:   Tue, 17 Dec 2019 12:27:07 +0100
Message-Id: <20191217112713.6017-5-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217112713.6017-1-fw@strlen.de>
References: <20191217112713.6017-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Fetch expression operation from the expression type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/expression.h |  1 +
 src/expression.c     | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index 717b67550381..d502fc2a8611 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -169,6 +169,7 @@ struct expr_ops {
 };
 
 const struct expr_ops *expr_ops(const struct expr *e);
+const struct expr_ops *expr_ops_by_type(enum expr_types etype);
 
 /**
  * enum expr_flags
diff --git a/src/expression.c b/src/expression.c
index 6fa2f1dd9b12..a7bbde7eec1a 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1222,3 +1222,15 @@ const struct expr_ops *expr_ops(const struct expr *e)
 
 	BUG("Unknown expression type %d\n", e->etype);
 }
+
+const struct expr_ops *expr_ops_by_type(enum expr_types etype)
+{
+	switch (etype) {
+	case EXPR_PAYLOAD:
+		return &payload_expr_ops;
+	default:
+		break;
+	}
+
+	BUG("Unknown expression type %d\n", etype);
+}
-- 
2.24.1

