Return-Path: <SRS0=I0Q5=UL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A43C31E46
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 17:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17627206E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 17:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407943AbfFLR1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 13:27:41 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48792 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407690AbfFLR1l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 13:27:41 -0400
Received: from localhost ([::1]:33650 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hb72C-0003dl-9O; Wed, 12 Jun 2019 19:27:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] monitor: Accept -j flag
Date:   Wed, 12 Jun 2019 19:27:37 +0200
Message-Id: <20190612172737.26214-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make 'nft -j monitor' equal to 'nft monitor json' and change
documentation to use only the first variant since that is more intuitive
and also consistent with other commands.

While being at it, drop references to XML from monitor section - it was
never supported.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt | 9 ++-------
 src/rule.c  | 3 +++
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 4fca5c918b747..3f1074b8c36e9 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -713,7 +713,7 @@ MONITOR
 ~~~~~~~~
 The monitor command allows you to listen to Netlink events produced by the
 nf_tables subsystem, related to creation and deletion of objects. When they
-occur, nft will print to stdout the monitored events in either XML, JSON or
+occur, nft will print to stdout the monitored events in either JSON or
 native nft format. +
 
 To filter events related to a concrete object, use one of the keywords 'tables', 'chains', 'sets', 'rules', 'elements', 'ruleset'. +
@@ -727,14 +727,9 @@ Hit ^C to finish the monitor operation.
 % nft monitor
 --------------------------------------------------
 
-.Listen to added tables, report in XML format
---------------------------------------------
-% nft monitor new tables xml
---------------------------------------------
-
 .Listen to deleted rules, report in JSON format
 -----------------------------------------------
-% nft monitor destroy rules json
+% nft -j monitor destroy rules
 -----------------------------------------------
 
 .Listen to both new and destroyed chains, in native nft format
diff --git a/src/rule.c b/src/rule.c
index ad549b1eee8ac..69a120347afb2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2435,6 +2435,9 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 		.debug_mask	= ctx->nft->debug_mask,
 	};
 
+	if (nft_output_json(&ctx->nft->output))
+		monhandler.format = NFTNL_OUTPUT_JSON;
+
 	monhandler.cache_needed = need_cache(cmd);
 	if (monhandler.cache_needed) {
 		struct rule *rule, *nrule;
-- 
2.21.0

