Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE8EC433B4
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 20:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11CAE61208
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 20:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhECUfk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 May 2021 16:35:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40894 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhECUfk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 May 2021 16:35:40 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id AB30B63087
        for <netfilter-devel@vger.kernel.org>; Mon,  3 May 2021 22:34:03 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools] conntrack: release options after parsing
Date:   Mon,  3 May 2021 22:34:43 +0200
Message-Id: <20210503203443.10147-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix memleak in parser:

==8445== 3,808 bytes in 2 blocks are definitely lost in loss record 6 of 6
==8445==    at 0x483577F: malloc (vg_replace_malloc.c:299)
==8445==    by 0x112636: merge_options (conntrack.c:1056)
==8445==    by 0x112636: do_parse (conntrack.c:2903)
==8445==    by 0x11343E: ct_file_parse_line (conntrack.c:3672)
==8445==    by 0x11343E: ct_parse_file (conntrack.c:3693)
==8445==    by 0x10D819: main (conntrack.c:3750)

Fixes: 8f76d6360dbf ("conntrack: add struct ct_cmd")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 4bc340f69cfc..879f7548d19f 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -3102,6 +3102,8 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	if (!(command & CT_HELP) && h && h->final_check)
 		h->final_check(l4flags, cmd, tmpl->ct);
 
+	free_options();
+
 	ct_cmd->command = command;
 	ct_cmd->cmd = cmd;
 	ct_cmd->options = options;
@@ -3536,7 +3538,6 @@ try_proc:
 			   err2str(errno, cmd->command));
 
 	free_tmpl_objects(&cmd->tmpl);
-	free_options();
 	if (labelmap)
 		nfct_labelmap_destroy(labelmap);
 
-- 
2.20.1

