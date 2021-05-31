Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841ACC47083
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 May 2021 22:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6756F6135A
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 May 2021 22:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhEaWUF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 May 2021 18:20:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37718 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhEaWUE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 May 2021 18:20:04 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C1B6C64182;
        Tue,  1 Jun 2021 00:17:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     kadlec@netfilter.org
Subject: [PATCH ipset 2/3] lib: Detach restore routine from parser
Date:   Tue,  1 Jun 2021 00:18:17 +0200
Message-Id: <20210531221818.24867-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210531221818.24867-1-pablo@netfilter.org>
References: <20210531221818.24867-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not call restore() from ipset_parser(). Instead, ipset_parser()
returns the IPSET_CMD_RESTORE command and the caller invokes restore().

This patch comes in preparation for the ipset to nftables translation
infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 lib/ipset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/ipset.c b/lib/ipset.c
index 3077f9793f84..5232d8b76c46 100644
--- a/lib/ipset.c
+++ b/lib/ipset.c
@@ -1231,7 +1231,7 @@ ipset_parser(struct ipset *ipset, int oargc, char *oargv[])
 			return ipset->custom_error(ipset,
 				p, IPSET_PARAMETER_PROBLEM,
 				"Unknown argument %s", argv[1]);
-		return restore(ipset);
+		return IPSET_CMD_RESTORE;
 	case IPSET_CMD_ADD:
 	case IPSET_CMD_DEL:
 	case IPSET_CMD_TEST:
@@ -1296,6 +1296,9 @@ ipset_parse_argv(struct ipset *ipset, int oargc, char *oargv[])
 	if (cmd < 0)
 		return cmd;
 
+	if (cmd == IPSET_CMD_RESTORE)
+		return restore(ipset);
+
 	ret = ipset_cmd(session, cmd, ipset->restore_line);
 	D("ret %d", ret);
 	/* In the case of warning, the return code is success */
-- 
2.20.1

