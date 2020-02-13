Return-Path: <SRS0=+t1+=4B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D804C2BA83
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 12:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B0C92168B
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 12:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgBMMG0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Feb 2020 07:06:26 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47740 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbgBMMG0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 07:06:26 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j2DGC-0004eq-Lt; Thu, 13 Feb 2020 13:06:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Serguei Bezverkhi <sbezverk@gmail.com>
Subject: [PATCH nft] src: maps: update data expression dtype based on set
Date:   Thu, 13 Feb 2020 13:06:17 +0100
Message-Id: <20200213120617.145154-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

What we want:
-               update @sticky-set-svc-M53CN2XYVUHRQ7UB { ip saddr : 0x00000002 }
what we got:
+               update @sticky-set-svc-M53CN2XYVUHRQ7UB { ip saddr : 0x2000000 [invalid type] }

Reported-by: Serguei Bezverkhi <sbezverk@gmail.com>
Close: https://bugzilla.netfilter.org/show_bug.cgi?id=1405
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c                     |  1 +
 .../maps/dumps/typeof_maps_update_0.nft       | 21 ++++++++++++++
 .../shell/testcases/maps/typeof_maps_update_0 | 28 +++++++++++++++++++
 3 files changed, 50 insertions(+)
 create mode 100644 tests/shell/testcases/maps/dumps/typeof_maps_update_0.nft
 create mode 100755 tests/shell/testcases/maps/typeof_maps_update_0

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7d9c764625c5..4f774fb9f150 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1424,6 +1424,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	}
 
 	if (expr_data != NULL) {
+		expr_set_type(expr_data, set->data->dtype, set->data->byteorder);
 		stmt = map_stmt_alloc(loc);
 		stmt->map.set	= set_ref_expr_alloc(loc, set);
 		stmt->map.key	= expr;
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_update_0.nft b/tests/shell/testcases/maps/dumps/typeof_maps_update_0.nft
new file mode 100644
index 000000000000..698219cb5460
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_update_0.nft
@@ -0,0 +1,21 @@
+table ip kube-nfproxy-v4 {
+	map sticky-set-svc-M53CN2XYVUHRQ7UB {
+		type ipv4_addr : mark
+		size 65535
+		timeout 6m
+	}
+
+	map sticky-set-svc-153CN2XYVUHRQ7UB {
+		typeof ip daddr : meta mark
+		size 65535
+		timeout 1m
+	}
+
+	chain k8s-nfproxy-sep-TMVEFT7EX55F4T62 {
+		update @sticky-set-svc-M53CN2XYVUHRQ7UB { ip saddr : 0x00000002 }
+	}
+
+	chain k8s-nfproxy-sep-GMVEFT7EX55F4T62 {
+		update @sticky-set-svc-153CN2XYVUHRQ7UB { ip saddr : 0x00000003 }
+	}
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_update_0 b/tests/shell/testcases/maps/typeof_maps_update_0
new file mode 100755
index 000000000000..c233b13ffc8d
--- /dev/null
+++ b/tests/shell/testcases/maps/typeof_maps_update_0
@@ -0,0 +1,28 @@
+#!/bin/bash
+
+# check update statement doesn't print "invalid dtype" on the data element.
+
+EXPECTED="table ip kube-nfproxy-v4 {
+ map sticky-set-svc-M53CN2XYVUHRQ7UB {
+  type ipv4_addr : mark
+  size 65535
+  timeout 6m
+ }
+
+ map sticky-set-svc-153CN2XYVUHRQ7UB {
+  typeof ip daddr : meta mark
+  size 65535
+  timeout 1m
+ }
+
+ chain k8s-nfproxy-sep-TMVEFT7EX55F4T62 {
+  update @sticky-set-svc-M53CN2XYVUHRQ7UB { ip saddr : 0x2 }
+ }
+ chain k8s-nfproxy-sep-GMVEFT7EX55F4T62 {
+  update @sticky-set-svc-153CN2XYVUHRQ7UB { ip saddr : 0x3 }
+ }
+}"
+
+set -e
+$NFT -f - <<< $EXPECTED
+
-- 
2.24.1

