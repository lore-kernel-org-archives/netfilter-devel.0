Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4C7C77B7D
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 May 2023 09:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjERJSi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 May 2023 05:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjERJSh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2023 05:18:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5686E1FEB
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2023 02:18:36 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack 1/2] conntrack: do not ignore errors coming from the kernel
Date:   Thu, 18 May 2023 11:18:31 +0200
Message-Id: <20230518091832.90570-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not ignore error from kernel for command invocation.

e42ea65e9c93 ("conntrack: introduce new -A command") ignores CT_ADD
in print_stats, which should not be required.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 23eaf274a78a..926213a27efc 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2886,7 +2886,7 @@ static int print_stats(const struct ct_cmd *cmd)
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr, exit_msg[cmd->cmd], counter);
 		if (counter == 0 &&
-		    !(cmd->command & (CT_LIST | EXP_LIST | CT_ADD)))
+		    !(cmd->command & (CT_LIST | EXP_LIST)))
 			return -1;
 	}
 
@@ -3835,7 +3835,7 @@ int main(int argc, char *argv[])
 			exit_error(OTHER_PROBLEM, "OOM");
 
 		do_parse(cmd, argc, argv);
-		do_command_ct(argv[0], cmd, sock);
+		res |= do_command_ct(argv[0], cmd, sock);
 		res = print_stats(cmd);
 		free(cmd);
 	}
-- 
2.30.2

