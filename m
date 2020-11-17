Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C4CC63777
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 10:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39DBE22447
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 10:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgKQKv0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 05:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgKQKv0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 05:51:26 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EA3C0613CF
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2020 02:51:25 -0800 (PST)
Received: from localhost ([::1]:53128 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1keya3-0004vf-04; Tue, 17 Nov 2020 11:51:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] ebtables: Fix for broken chain renaming
Date:   Tue, 17 Nov 2020 11:51:14 +0100
Message-Id: <20201117105114.5083-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Loading extensions pollutes 'errno' value, hence before using it to
indicate failure it should be sanitized. This was done by the called
function before the parsing/netlink split and not migrated by accident.
Move it into calling code to clarify the connection.

Fixes: a7f1e208cdf9c ("nft: split parsing from netlink commands")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                                                | 3 ---
 iptables/tests/shell/testcases/ebtables/0001-ebtables-basic_0 | 4 ++++
 iptables/xtables-eb.c                                         | 1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 39882a443a974..411e2597205c9 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1896,9 +1896,6 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 		return 0;
 	}
 
-	/* Config load changed errno. Ensure genuine info for our callers. */
-	errno = 0;
-
 	/* Find the old chain to be renamed */
 	c = nft_chain_find(h, table, chain);
 	if (c == NULL) {
diff --git a/iptables/tests/shell/testcases/ebtables/0001-ebtables-basic_0 b/iptables/tests/shell/testcases/ebtables/0001-ebtables-basic_0
index 0c1eb4ca66f52..6f11bd12593dd 100755
--- a/iptables/tests/shell/testcases/ebtables/0001-ebtables-basic_0
+++ b/iptables/tests/shell/testcases/ebtables/0001-ebtables-basic_0
@@ -86,4 +86,8 @@ if [ $? -eq 0 ]; then
 	exit 1
 fi
 
+$XT_MULTI ebtables -t filter -E FOO BAZ || exit 1
+$XT_MULTI ebtables -t filter -L | grep -q FOO && exit 1
+$XT_MULTI ebtables -t filter -L | grep -q BAZ || exit 1
+
 $XT_MULTI ebtables -t $t -F || exit 0
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 6641a21a72d32..5e4184b8e80de 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -853,6 +853,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 				else if (strchr(argv[optind], ' ') != NULL)
 					xtables_error(PARAMETER_PROBLEM, "Use of ' ' not allowed in chain names");
 
+				errno = 0;
 				ret = nft_cmd_chain_user_rename(h, chain, *table,
 							    argv[optind]);
 				if (ret != 0 && errno == ENOENT)
-- 
2.28.0

