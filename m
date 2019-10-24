Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B01CA9EBC
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5E2321929
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503478AbfJXQhc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:37:32 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:58912 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503426AbfJXQhc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 12:37:32 -0400
Received: from localhost ([::1]:43770 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iNg79-0005Cc-AC; Thu, 24 Oct 2019 18:37:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 4/7] xtables-restore: Remove some pointless linebreaks
Date:   Thu, 24 Oct 2019 18:37:09 +0200
Message-Id: <20191024163712.22405-5-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191024163712.22405-1-phil@nwl.cc>
References: <20191024163712.22405-1-phil@nwl.cc>
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
 iptables/xtables-restore.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index d21e9730805a8..83e05102769a7 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -125,8 +125,7 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 			return;
 
 		if (h->noflush == 0) {
-			DEBUGP("Cleaning all chains of table '%s'\n",
-				table);
+			DEBUGP("Cleaning all chains of table '%s'\n", table);
 			if (cb->table_flush)
 				cb->table_flush(h, table);
 		}
@@ -151,8 +150,7 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 
 		if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid chain name `%s' "
-				   "(%u chars max)",
+				   "Invalid chain name `%s' (%u chars max)",
 				   chain, XT_EXTENSION_MAXNAMELEN - 1);
 
 		policy = strtok(NULL, " \t\n");
@@ -169,16 +167,15 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 
 				if (!ctrs || !parse_counters(ctrs, &count))
 					xtables_error(PARAMETER_PROBLEM,
-						   "invalid policy counters "
-						   "for chain '%s'\n", chain);
+						   "invalid policy counters for chain '%s'\n",
+						   chain);
 
 			}
 			if (cb->chain_set &&
 			    cb->chain_set(h, state->curtable->name,
 					  chain, policy, &count) < 0) {
 				xtables_error(OTHER_PROBLEM,
-					      "Can't set policy `%s'"
-					      " on `%s' line %u: %s\n",
+					      "Can't set policy `%s' on `%s' line %u: %s\n",
 					      policy, chain, line,
 					      strerror(errno));
 			}
@@ -187,15 +184,13 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		} else if (cb->chain_restore(h, chain, state->curtable->name) < 0 &&
 			   errno != EEXIST) {
 			xtables_error(PARAMETER_PROBLEM,
-				      "cannot create chain "
-				      "'%s' (%s)\n", chain,
-				      strerror(errno));
+				      "cannot create chain '%s' (%s)\n",
+				      chain, strerror(errno));
 		} else if (h->family == NFPROTO_BRIDGE &&
 			   !ebt_set_user_chain_policy(h, state->curtable->name,
 						      chain, policy)) {
 			xtables_error(OTHER_PROBLEM,
-				      "Can't set policy `%s'"
-				      " on `%s' line %u: %s\n",
+				      "Can't set policy `%s' on `%s' line %u: %s\n",
 				      policy, chain, line,
 				      strerror(errno));
 		}
@@ -232,8 +227,8 @@ static void xtables_restore_parse_line(struct nft_handle *h,
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

