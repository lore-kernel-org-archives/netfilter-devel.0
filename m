Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75F9C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Nov 2021 01:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbhKYBhn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 20:37:43 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38436 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347659AbhKYBfn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 20:35:43 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 74516607C1
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Nov 2021 02:30:19 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cli: print newline with ctrl-d with editline
Date:   Thu, 25 Nov 2021 02:32:24 +0100
Message-Id: <20211125013224.615716-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If user does not explicitly 'quit' then print a newline before going
back to the shell.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cli.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/cli.c b/src/cli.c
index 11fc85abeaa2..8762a636fd41 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -38,6 +38,7 @@
 #define CMDLINE_QUIT		"quit"
 
 static char histfile[PATH_MAX];
+static bool quit;
 
 static void
 init_histfile(void)
@@ -140,6 +141,7 @@ static void cli_complete(char *line)
 		return;
 
 	if (!strcmp(line, CMDLINE_QUIT)) {
+		quit = true;
 		cli_exit();
 		exit(0);
 	}
@@ -221,6 +223,9 @@ void cli_exit(void)
 {
 	rl_deprep_terminal();
 	write_history(histfile);
+	/* Print \n when user exits via ^D */
+	if (!quit)
+		printf("\n");
 }
 
 #else /* HAVE_LINENOISE */
-- 
2.30.2

