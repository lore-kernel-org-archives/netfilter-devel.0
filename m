Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB7BC432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058B52054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfIYV0b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:26:31 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45806 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbfIYV0b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:26:31 -0400
Received: from localhost ([::1]:58896 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEnu-0005Cz-Jd; Wed, 25 Sep 2019 23:26:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 17/24] xtables-restore: Carry in_table in struct nft_xt_restore_parse
Date:   Wed, 25 Sep 2019 23:25:58 +0200
Message-Id: <20190925212605.1005-18-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a requirement for outsourcing line parsing code into a dedicated
function.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h      |  1 +
 iptables/xtables-restore.c | 17 ++++++++---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 9d62913461fa4..facad6d02a7ec 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -237,6 +237,7 @@ struct nft_xt_restore_parse {
 	int		testing;
 	const char	*tablename;
 	bool		commit;
+	bool		in_table;
 };
 
 struct nftnl_chain_list;
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 3bb901913ed58..2519005590ff1 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -91,7 +91,6 @@ void xtables_restore_parse(struct nft_handle *h,
 {
 	const struct builtin_table *curtable = NULL;
 	char buffer[10240];
-	int in_table = 0;
 	const struct xtc_ops *ops = &xtc_ops;
 
 	line = 0;
@@ -114,7 +113,7 @@ void xtables_restore_parse(struct nft_handle *h,
 			if (verbose)
 				fputs(buffer, stdout);
 			continue;
-		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
+		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (p->in_table)) {
 			if (!p->testing) {
 				/* Commit per table, although we support
 				 * global commit at once, stick by now to
@@ -128,9 +127,9 @@ void xtables_restore_parse(struct nft_handle *h,
 				if (cb->abort)
 					ret = cb->abort(h);
 			}
-			in_table = 0;
+			p->in_table = 0;
 
-		} else if ((buffer[0] == '*') && (!in_table || !p->commit)) {
+		} else if ((buffer[0] == '*') && (!p->in_table || !p->commit)) {
 			/* New table */
 			char *table;
 
@@ -158,12 +157,12 @@ void xtables_restore_parse(struct nft_handle *h,
 			}
 
 			ret = 1;
-			in_table = 1;
+			p->in_table = 1;
 
 			if (cb->table_new)
 				cb->table_new(h, table);
 
-		} else if ((buffer[0] == ':') && (in_table)) {
+		} else if ((buffer[0] == ':') && (p->in_table)) {
 			/* New chain. */
 			char *policy, *chain = NULL;
 			struct xt_counters count = {};
@@ -226,7 +225,7 @@ void xtables_restore_parse(struct nft_handle *h,
 					      ops->strerror(errno));
 			}
 			ret = 1;
-		} else if (in_table) {
+		} else if (p->in_table) {
 			int a;
 			char *pcnt = NULL;
 			char *bcnt = NULL;
@@ -281,11 +280,11 @@ void xtables_restore_parse(struct nft_handle *h,
 			exit(1);
 		}
 	}
-	if (in_table && p->commit) {
+	if (p->in_table && p->commit) {
 		fprintf(stderr, "%s: COMMIT expected at line %u\n",
 				xt_params->program_name, line + 1);
 		exit(1);
-	} else if (in_table && cb->commit && !cb->commit(h)) {
+	} else if (p->in_table && cb->commit && !cb->commit(h)) {
 		xtables_error(OTHER_PROBLEM, "%s: final implicit COMMIT failed",
 			      xt_params->program_name);
 	}
-- 
2.23.0

