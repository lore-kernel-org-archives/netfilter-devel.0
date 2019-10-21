Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB45CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 15:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 524E020873
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 15:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbfJUPip (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 11:38:45 -0400
Received: from correo.us.es ([193.147.175.20]:57834 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfJUPip (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 11:38:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B37F11EB25
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 17:38:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EFE9CDA4D0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 17:38:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E57E8DA840; Mon, 21 Oct 2019 17:38:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C458DD1929
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 17:38:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 21 Oct 2019 17:38:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A2EB542EF4E1
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 17:38:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] main: misleading error reporting in chain definitions
Date:   Mon, 21 Oct 2019 17:38:35 +0200
Message-Id: <20191021153835.30123-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft add chain x y { type filter hook input priority -30\; }
 nft: invalid option -- '3'

Fix this by restricting getopt_long() to the first curly brace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/src/main.c b/src/main.c
index f77d8a820a02..0d4a45b30d20 100644
--- a/src/main.c
+++ b/src/main.c
@@ -192,19 +192,38 @@ static const struct {
 	},
 };
 
+static int argc_getopt(int argc, char * const *argv)
+{
+	int i;
+
+	/* Restrict getopt_long() parsing to the first curly brace, so users
+	 * do not need to invoke nft with an upfront -- to specify chain
+	 * priority.
+	 */
+	for (i = 0; i < argc; i++) {
+		if (argv[i][0] == '{') {
+			return i;
+		}
+	}
+
+	return argc;
+}
+
 int main(int argc, char * const *argv)
 {
 	char *buf = NULL, *filename = NULL;
 	unsigned int output_flags = 0;
+	int i, val, rc, __argc;
 	bool interactive = false;
 	unsigned int debug_mask;
 	unsigned int len;
-	int i, val, rc;
+
+	__argc = argc_getopt(argc, argv);
 
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
 
 	while (1) {
-		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
+		val = getopt_long(__argc, argv, OPTSTRING, options, NULL);
 		if (val == -1)
 			break;
 
-- 
2.11.0

