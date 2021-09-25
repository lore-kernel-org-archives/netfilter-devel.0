Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA8EC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 20:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C87A60FC1
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 20:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhIYUrj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 16:47:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51722 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhIYUri (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 16:47:38 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id CFB3363EB1
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 22:44:41 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/3] monitor: display rule position handle
Date:   Sat, 25 Sep 2021 22:45:57 +0200
Message-Id: <20210925204559.22699-1-pablo@netfilter.org>
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

