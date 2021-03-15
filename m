Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914EDC433E6
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6595F64F35
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCOQza (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 12:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhCOQzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 12:55:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7464C06175F
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Mar 2021 09:55:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D53506353D;
        Mon, 15 Mar 2021 17:49:39 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@cloud.ionos.com
Subject: [PATCH conntrack 6/6] conntrack: add function to print command stats
Date:   Mon, 15 Mar 2021 17:49:29 +0100
Message-Id: <20210315164929.23608-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315164929.23608-1-pablo@netfilter.org>
References: <20210315164929.23608-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wrap code to display command stats in a function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index b9b0e31c8269..4bc340f69cfc 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2791,6 +2791,18 @@ nfct_set_nat_details(const int opt, struct nf_conntrack *ct,
 
 }
 
+static int print_stats(const struct ct_cmd *cmd)
+{
+	if (cmd->command && exit_msg[cmd->cmd][0]) {
+		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
+		fprintf(stderr, exit_msg[cmd->cmd], counter);
+		if (counter == 0 && !(cmd->command & (CT_LIST | EXP_LIST)))
+			return -1;
+	}
+
+	return 0;
+}
+
 static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 {
 	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
@@ -3528,13 +3540,6 @@ try_proc:
 	if (labelmap)
 		nfct_labelmap_destroy(labelmap);
 
-	if (cmd->command && exit_msg[cmd->cmd][0]) {
-		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
-		fprintf(stderr, exit_msg[cmd->cmd], counter);
-		if (counter == 0 && !(cmd->command & (CT_LIST | EXP_LIST)))
-			return EXIT_FAILURE;
-	}
-
 	return EXIT_SUCCESS;
 }
 
@@ -3553,6 +3558,10 @@ int main(int argc, char *argv[])
 	register_unknown();
 
 	do_parse(cmd, argc, argv);
+	do_command_ct(argv[0], cmd);
 
-	return do_command_ct(argv[0], cmd);
+	if (print_stats(cmd) < 0)
+		return EXIT_FAILURE;
+
+	return EXIT_SUCCESS;
 }
-- 
2.20.1

