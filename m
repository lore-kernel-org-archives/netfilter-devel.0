Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A8AC43381
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Jan 2021 12:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDCFD22ADF
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Jan 2021 12:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbhAFMZj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 07:25:39 -0500
Received: from correo.us.es ([193.147.175.20]:44044 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbhAFMZj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 07:25:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3CEA9FC46D
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jan 2021 13:24:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D266DA730
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jan 2021 13:24:19 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 22D4FDA72F; Wed,  6 Jan 2021 13:24:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A27F5DA73F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jan 2021 13:24:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Jan 2021 13:24:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 88D4D426CC84
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jan 2021 13:24:16 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] cli: use plain readline() interface
Date:   Wed,  6 Jan 2021 13:24:35 +0100
Message-Id: <20210106122436.24589-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210106122436.24589-1-pablo@netfilter.org>
References: <20210106122436.24589-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of the alternate interface [1].

I spent a bit of time debugging an issue with libedit support
9420423900a2 ("cli: add libedit support") that broke tests/shell.

This is the reproducer:

 # nft -i << EOF
 list ruleset
 EOF

which makes rl_callback_read_char() loop forever on read() as shown by
strace. The rl_line_buffer variable does not accumulate the typed
characters as it should when redirecting the standard input for some
reason.

Given our interactive interface is fairly simple at this stage, switch
to use the readline() interface instead of rl_callback_read_char().

[1] https://docs.freebsd.org/info/readline/readline.info.Alternate_Interface.html

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cli.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/src/cli.c b/src/cli.c
index 45811595fc77..f46971b848e5 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -154,28 +154,29 @@ static void cli_complete(char *line)
 	free(line);
 }
 
-static char **cli_completion(const char *text, int start, int end)
-{
-	return NULL;
-}
-
 int cli_init(struct nft_ctx *nft)
 {
+	char *line;
+
 	cli_nft = nft;
 	rl_readline_name = (char *)"nft";
 	rl_instream  = stdin;
 	rl_outstream = stdout;
 
-	rl_callback_handler_install(CMDLINE_PROMPT, cli_complete);
-	rl_attempted_completion_function = cli_completion;
-
 	init_histfile();
 
 	read_history(histfile);
 	history_set_pos(history_length);
 
-	while (true)
-		rl_callback_read_char();
+	rl_set_prompt(CMDLINE_PROMPT);
+	while ((line = readline(rl_prompt)) != NULL) {
+		line = cli_append_multiline(line);
+		if (!line)
+			continue;
+
+		cli_complete(line);
+	}
+
 	return 0;
 }
 
-- 
2.20.1

