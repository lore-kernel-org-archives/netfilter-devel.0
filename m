Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B0DC2D0CD
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F9E021582
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfLQRRM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:17:12 -0500
Received: from correo.us.es ([193.147.175.20]:37942 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbfLQRRL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 12:17:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1BBF21C4446
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D35CDA705
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 02D49DA70A; Tue, 17 Dec 2019 18:17:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A7C7DA705;
        Tue, 17 Dec 2019 18:17:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 18:17:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E55AB4265A5A;
        Tue, 17 Dec 2019 18:17:06 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 05/11] osf: add parse and build userdata interface
Date:   Tue, 17 Dec 2019 18:16:56 +0100
Message-Id: <20191217171702.31493-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191217171702.31493-1-pablo@netfilter.org>
References: <20191217171702.31493-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for meta userdata area.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c |  1 +
 src/osf.c        | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index 191bc2be104b..7d198222c90b 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1230,6 +1230,7 @@ const struct expr_ops *expr_ops_by_type(enum expr_types etype)
 	case EXPR_EXTHDR: return &exthdr_expr_ops;
 	case EXPR_META: return &meta_expr_ops;
 	case EXPR_SOCKET: return &socket_expr_ops;
+	case EXPR_OSF: return &osf_expr_ops;
 	default:
 		break;
 	}
diff --git a/src/osf.c b/src/osf.c
index f0c22393cd85..cb58315d714d 100644
--- a/src/osf.c
+++ b/src/osf.c
@@ -37,6 +37,17 @@ static bool osf_expr_cmp(const struct expr *e1, const struct expr *e2)
 	       (e1->osf.flags == e2->osf.flags);
 }
 
+static int osf_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				 const struct expr *expr)
+{
+	return 0;
+}
+
+static struct expr *osf_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	return osf_expr_alloc(&internal_location, 0, 0);
+}
+
 const struct expr_ops osf_expr_ops = {
 	.type		= EXPR_OSF,
 	.name		= "osf",
@@ -44,6 +55,8 @@ const struct expr_ops osf_expr_ops = {
 	.clone		= osf_expr_clone,
 	.cmp		= osf_expr_cmp,
 	.json		= osf_expr_json,
+	.parse_udata	= osf_expr_parse_udata,
+	.build_udata	= osf_expr_build_udata,
 };
 
 struct expr *osf_expr_alloc(const struct location *loc, const uint8_t ttl,
-- 
2.11.0

