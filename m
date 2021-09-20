Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391F2C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 22:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB4C61184
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 22:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhITW5l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 18:57:41 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39288 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbhITWzl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 18:55:41 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id E46FA6005C
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Sep 2021 00:52:54 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] monitor: display rule position handle
Date:   Tue, 21 Sep 2021 00:54:06 +0200
Message-Id: <20210920225407.1237-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allow to locate the incremental update in the ruleset.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/monitor.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/monitor.c b/src/monitor.c
index 144fe96c2898..ffaa39b67304 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -541,7 +541,10 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 			      family,
 			      r->handle.table.name,
 			      r->handle.chain.name);
-
+		if (r->handle.position.id) {
+			nft_mon_print(monh, "handle %" PRIu64" ",
+				      r->handle.position.id);
+		}
 		switch (type) {
 		case NFT_MSG_NEWRULE:
 			rule_print(r, &monh->ctx->nft->output);
-- 
2.30.2

