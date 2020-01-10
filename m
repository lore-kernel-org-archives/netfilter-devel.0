Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5EFC33CA2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AA4220721
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgAJLLP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:11:15 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:34974 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbgAJLLP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 06:11:15 -0500
Received: from localhost ([::1]:48064 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ipsC8-0002jp-Rr; Fri, 10 Jan 2020 12:11:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/3] monitor: Do not decompose non-anonymous sets
Date:   Fri, 10 Jan 2020 12:11:12 +0100
Message-Id: <20200110111114.23952-2-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110111114.23952-1-phil@nwl.cc>
References: <20200110111114.23952-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They have been decomposed already, trying to do that again causes a
segfault. This is a similar fix as in commit 8ecb885589591 ("src:
restore --echo with anonymous sets").

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/monitor.c                          |  2 +-
 tests/monitor/testcases/set-interval.t | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 tests/monitor/testcases/set-interval.t

diff --git a/src/monitor.c b/src/monitor.c
index d586cfa34a979..84505eb914bf6 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -500,7 +500,7 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 
 static void rule_map_decompose_cb(struct set *s, void *data)
 {
-	if (s->flags & NFT_SET_INTERVAL)
+	if (s->flags & (NFT_SET_INTERVAL & NFT_SET_ANONYMOUS))
 		interval_map_decompose(s->init);
 }
 
diff --git a/tests/monitor/testcases/set-interval.t b/tests/monitor/testcases/set-interval.t
new file mode 100644
index 0000000000000..59930c58243d8
--- /dev/null
+++ b/tests/monitor/testcases/set-interval.t
@@ -0,0 +1,20 @@
+# setup first
+I add table ip t
+I add chain ip t c
+O -
+J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
+J {"add": {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}}}
+
+# add set with elements, monitor output expectedly differs
+I add set ip t s { type inet_service; flags interval; elements = { 20, 30-40 }; }
+O add set ip t s { type inet_service; flags interval; }
+O add element ip t s { 20 }
+O add element ip t s { 30-40 }
+J {"add": {"set": {"family": "ip", "name": "s", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
+J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [20]}}}}
+J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [{"range": [30, 40]}]}}}}
+
+# this would crash nft
+I add rule ip t c tcp dport @s
+O -
+J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": "@s"}}]}}}
-- 
2.24.1

