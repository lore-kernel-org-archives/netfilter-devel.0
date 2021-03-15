Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8220C433E9
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98FE764EFD
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhCOQza (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 12:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbhCOQzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 12:55:02 -0400
X-Greylist: delayed 323 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Mar 2021 09:55:01 PDT
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF076C06174A
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Mar 2021 09:55:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A3DE463535;
        Mon, 15 Mar 2021 17:49:37 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@cloud.ionos.com
Subject: [PATCH conntrack 2/6] conntrack: pass ct_cmd to nfct_filter_init()
Date:   Mon, 15 Mar 2021 17:49:25 +0100
Message-Id: <20210315164929.23608-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315164929.23608-1-pablo@netfilter.org>
References: <20210315164929.23608-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass command object to initialize the userspace filter.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 333da0f83453..31630eb1f926 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2627,9 +2627,11 @@ nfct_network_attr_prepare(const int family, enum ct_direction dir,
 	nfct_attr_unset(tmpl->ct, attr);
 }
 
-static void
-nfct_filter_init(const int family, const struct ct_tmpl *tmpl)
+static void nfct_filter_init(const struct ct_cmd *cmd)
 {
+	const struct ct_tmpl *tmpl = &cmd->tmpl;
+	int family = cmd->family;
+
 	filter_family = family;
 	if (options & CT_OPT_MASK_SRC) {
 		assert(family != AF_UNSPEC);
@@ -3125,7 +3127,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			exit_error(PARAMETER_PROBLEM, "Can't use -z with "
 						      "filtering parameters");
 
-		nfct_filter_init(cmd->family, &cmd->tmpl);
+		nfct_filter_init(cmd);
 
 		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd);
 
@@ -3216,7 +3218,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_filter_init(cmd->family, &cmd->tmpl);
+		nfct_filter_init(cmd);
 
 		nfct_callback_register(cth, NFCT_T_ALL, update_cb, cmd);
 
@@ -3231,7 +3233,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_filter_init(cmd->family, &cmd->tmpl);
+		nfct_filter_init(cmd);
 
 		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, cmd);
 
@@ -3352,7 +3354,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 					socketbuffersize);
 		}
 
-		nfct_filter_init(cmd->family, &cmd->tmpl);
+		nfct_filter_init(cmd);
 
 		signal(SIGINT, event_sighandler);
 		signal(SIGTERM, event_sighandler);
-- 
2.20.1

