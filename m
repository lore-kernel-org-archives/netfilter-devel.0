Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA54C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Nov 2022 10:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbiKKKJa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 05:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiKKKJU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 05:09:20 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A89977225
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 02:09:17 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] monitor: missing cache and set handle initialization
Date:   Fri, 11 Nov 2022 11:09:10 +0100
Message-Id: <20221111100910.15735-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This leads to a crash when adding stateful expressions to sets:

netlink.c:928:38: runtime error: member access within null pointer of type 'struct nft_ctx'
AddressSanitizer:DEADLYSIGNAL
=================================================================
==13781==ERROR: AddressSanitizer: SEGV on unknown address 0x0000000000d0 (pc 0x7fc96fc2b6b2 bp 0x7ffc0e26b080 sp 0x7ffc0e26b020 T0)
==13781==The signal is caused by a READ memory access.
==13781==Hint: address points to the zero page.
    #0 0x7fc96fc2b6b2 in table_cache_find /home/pablo/devel/scm/git-netfilter/nftables/src/cache.c:456
    #1 0x7fc96fd244d4 in netlink_parse_set_expr /home/pablo/devel/scm/git-netfilter/nftables/src/netlink_delinearize.c:1857
    #2 0x7fc96fcf1b4d in netlink_delinearize_set /home/pablo/devel/scm/git-netfilter/nftables/src/netlink.c:928
    #3 0x7fc96fd41966 in netlink_events_cache_addset /home/pablo/devel/scm/git-netfilter/nftables/src/monitor.c:649

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/monitor.c                      | 2 ++
 tests/monitor/testcases/map-expr.t | 6 ++++++
 2 files changed, 8 insertions(+)
 create mode 100644 tests/monitor/testcases/map-expr.t

diff --git a/src/monitor.c b/src/monitor.c
index a6b30a18cfd2..4b55872b5388 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -428,6 +428,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 	 * used by named sets, so use a dummy set.
 	 */
 	dummyset = set_alloc(monh->loc);
+	handle_merge(&dummyset->handle, &set->handle);
 	dummyset->key = expr_clone(set->key);
 	if (set->data)
 		dummyset->data = expr_clone(set->data);
@@ -643,6 +644,7 @@ static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
 	memset(&set_tmpctx, 0, sizeof(set_tmpctx));
 	init_list_head(&set_tmpctx.list);
 	init_list_head(&msgs);
+	set_tmpctx.nft = monh->ctx->nft;
 	set_tmpctx.msgs = &msgs;
 
 	nls = netlink_set_alloc(nlh);
diff --git a/tests/monitor/testcases/map-expr.t b/tests/monitor/testcases/map-expr.t
new file mode 100644
index 000000000000..8729c0b44ee2
--- /dev/null
+++ b/tests/monitor/testcases/map-expr.t
@@ -0,0 +1,6 @@
+# first the setup
+I add table ip t
+I add map ip t m { typeof meta day . meta hour : verdict; flags interval; counter; }
+O -
+J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
+J {"add": {"map": {"family": "ip", "name": "m", "table": "t", "type": ["day", "hour"], "handle": 0, "map": "verdict", "flags": ["interval"], "stmt": [{"counter": null}]}}}
-- 
2.30.2

