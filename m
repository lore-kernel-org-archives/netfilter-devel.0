Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB16C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A9002054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfIYV0h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:26:37 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45812 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbfIYV0h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:26:37 -0400
Received: from localhost ([::1]:58902 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEo0-0005DK-69; Wed, 25 Sep 2019 23:26:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 22/24] xtables-restore: Remove some pointless linebreaks
Date:   Wed, 25 Sep 2019 23:26:03 +0200
Message-Id: <20190925212605.1005-23-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Due to reduced indenting level, some linebreaks are no longer needed.
OTOH, strings should not be split to aid in grepping for error output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-restore.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 1a3739b3350c8..e9cdf2093bfcb 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -135,8 +135,7 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 			return;
 
 		if (h->noflush == 0) {
-			DEBUGP("Cleaning all chains of table '%s'\n",
-				table);
+			DEBUGP("Cleaning all chains of table '%s'\n", table);
 			if (cb->table_flush)
 				cb->table_flush(h, table);
 		}
@@ -161,8 +160,7 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 
 		if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid chain name `%s' "
-				   "(%u chars max)",
+				   "Invalid chain name `%s' (%u chars max)",
 				   chain, XT_EXTENSION_MAXNAMELEN - 1);
 
 		policy = strtok(NULL, " \t\n");
@@ -179,16 +177,15 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 
 				if (!ctrs || !parse_counters(ctrs, &count))
 					xtables_error(PARAMETER_PROBLEM,
-						   "invalid policy counters "
-						   "for chain '%s'\n", chain);
+						   "invalid policy counters for chain '%s'\n",
+						   chain);
 
 			}
 			if (cb->chain_set &&
 			    cb->chain_set(h, p->curtable->name,
 					  chain, policy, &count) < 0) {
 				xtables_error(OTHER_PROBLEM,
-					      "Can't set policy `%s'"
-					      " on `%s' line %u: %s\n",
+					      "Can't set policy `%s' on `%s' line %u: %s\n",
 					      policy, chain, line,
 					      ops->strerror(errno));
 			}
@@ -197,15 +194,13 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		} else if (cb->chain_restore(h, chain, p->curtable->name) < 0 &&
 			   errno != EEXIST) {
 			xtables_error(PARAMETER_PROBLEM,
-				      "cannot create chain "
-				      "'%s' (%s)\n", chain,
-				      strerror(errno));
+				      "cannot create chain '%s' (%s)\n",
+				      chain, strerror(errno));
 		} else if (h->family == NFPROTO_BRIDGE &&
 			   !ebt_set_user_chain_policy(h, p->curtable->name,
 						      chain, policy)) {
 			xtables_error(OTHER_PROBLEM,
-				      "Can't set policy `%s'"
-				      " on `%s' line %u: %s\n",
+				      "Can't set policy `%s' on `%s' line %u: %s\n",
 				      policy, chain, line,
 				      ops->strerror(errno));
 		}
@@ -238,8 +233,7 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		for (a = 0; a < newargc; a++)
 			DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
-		ret = cb->do_command(h, newargc, newargv,
-				    &newargv[2], true);
+		ret = cb->do_command(h, newargc, newargv, &newargv[2], true);
 		if (ret < 0) {
 			if (cb->abort)
 				ret = cb->abort(h);
@@ -247,8 +241,8 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 				ret = 0;
 
 			if (ret < 0) {
-				fprintf(stderr, "failed to abort "
-						"commit operation\n");
+				fprintf(stderr,
+					"failed to abort commit operation\n");
 			}
 			exit(1);
 		}
-- 
2.23.0

