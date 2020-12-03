Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C294C63777
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 12:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B789320671
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 12:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgLCMpL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 07:45:11 -0500
Received: from correo.us.es ([193.147.175.20]:54072 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgLCMpL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 07:45:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAA25891985
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 13:44:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D0A7DA791
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 13:44:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 92917DA78E; Thu,  3 Dec 2020 13:44:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26509DA730
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 13:44:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 03 Dec 2020 13:44:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1018F42EF42B
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 13:44:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: report EPERM for non-root users
Date:   Thu,  3 Dec 2020 13:44:23 +0100
Message-Id: <20201203124423.14137-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

$ /usr/sbin/nft list ruleset
Operation not permitted (you must be root)

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1372
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 7 ++++++-
 src/netlink.c     | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index a180a9a30b3d..044365914747 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -463,8 +463,13 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 	parser_rc = rc;
 
 	rc = nft_evaluate(nft, &msgs, &cmds);
-	if (rc < 0)
+	if (rc < 0) {
+		if (errno == EPERM) {
+			fprintf(stderr, "%s (you must be root)\n",
+				strerror(errno));
+		}
 		goto err;
+	}
 
 	if (parser_rc) {
 		rc = parser_rc;
diff --git a/src/netlink.c b/src/netlink.c
index f8ac2b9e3665..2ea2d4457664 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -635,7 +635,7 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h)
 		if (errno == EINTR)
 			return -1;
 
-		return 0;
+		return -1;
 	}
 
 	ctx->data = h;
-- 
2.20.1

