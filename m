Return-Path: <SRS0=8ADT=2G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAD5C3F68F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 12:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52EF6206D3
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 12:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfLPMmc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 07:42:32 -0500
Received: from correo.us.es ([193.147.175.20]:32922 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbfLPMmc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 07:42:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4B154E865A
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:42:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BA3EDA707
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:42:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3130DDA70B; Mon, 16 Dec 2019 13:42:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A607DA707;
        Mon, 16 Dec 2019 13:42:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Dec 2019 13:42:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1627842EF42B;
        Mon, 16 Dec 2019 13:42:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 2/3] expr: add expr_ops_by_type()
Date:   Mon, 16 Dec 2019 13:42:21 +0100
Message-Id: <20191216124222.356618-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191216124222.356618-1-pablo@netfilter.org>
References: <20191216124222.356618-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fetch expression operation from the expression type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0

