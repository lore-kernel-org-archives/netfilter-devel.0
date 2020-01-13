Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089C3C33CAD
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 13:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA0EC207FD
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 13:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAMN7M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 08:59:12 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:42764 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728767AbgAMN7L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 08:59:11 -0500
Received: from localhost ([::1]:55854 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ir0FK-0003Qq-FS; Mon, 13 Jan 2020 14:59:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] monitor: Fix output for ranges in anonymous sets
Date:   Mon, 13 Jan 2020 14:59:11 +0100
Message-Id: <20200113135911.22740-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previous fix for named interval sets was simply wrong: Instead of
limiting decomposing to anonymous interval sets, it effectively disabled
it entirely.

Since code needs to check for both interval and anonymous bits
separately, introduce set_is_interval() helper to keep the code
readable.

Also extend test case to assert ranges in anonymous sets are correctly
printed by echo or monitor modes. Without this fix, range boundaries are
printed as individual set elements.

Fixes: 5d57fa3e99bb9 ("monitor: Do not decompose non-anonymous sets")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/rule.h                         | 5 +++++
 src/monitor.c                          | 2 +-
 tests/monitor/testcases/set-interval.t | 5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 6301fe35b591e..d5b31765612ec 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -363,6 +363,11 @@ static inline bool set_is_meter(uint32_t set_flags)
 	return set_is_anonymous(set_flags) && (set_flags & NFT_SET_EVAL);
 }
 
+static inline bool set_is_interval(uint32_t set_flags)
+{
+	return set_flags & NFT_SET_INTERVAL;
+}
+
 #include <statement.h>
 
 struct counter {
diff --git a/src/monitor.c b/src/monitor.c
index 53a8bcd4641d1..142cc929664fa 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -501,7 +501,7 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 
 static void rule_map_decompose_cb(struct set *s, void *data)
 {
-	if (s->flags & (NFT_SET_INTERVAL & NFT_SET_ANONYMOUS))
+	if (set_is_interval(s->flags) && set_is_anonymous(s->flags))
 		interval_map_decompose(s->init);
 }
 
diff --git a/tests/monitor/testcases/set-interval.t b/tests/monitor/testcases/set-interval.t
index 59930c58243d8..1fbcfe222a2b0 100644
--- a/tests/monitor/testcases/set-interval.t
+++ b/tests/monitor/testcases/set-interval.t
@@ -18,3 +18,8 @@ J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set"
 I add rule ip t c tcp dport @s
 O -
 J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": "@s"}}]}}}
+
+# test anonymous interval sets as well
+I add rule ip t c tcp dport { 20, 30-40 }
+O -
+J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": {"set": [20, {"range": [30, 40]}]}}}]}}}
-- 
2.24.1

