Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A762C77B61
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 May 2023 16:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbjEAQv3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 May 2023 12:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbjEAQv2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2023 12:51:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7029FE73
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2023 09:51:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ptWkG-0006Fo-Uq; Mon, 01 May 2023 18:51:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink: restore typeof interval map data type
Date:   Mon,  1 May 2023 18:51:19 +0200
Message-Id: <20230501165119.396357-1-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When "typeof ... : interval ..." gets used, existing logic
failed to validate the expressions.

"interval" means that kernel reserves twice the size,
so consider this when validating and restoring.

Also fix up the dump file of the existing test
case to be symmetrical.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c                                              | 7 ++++++-
 .../testcases/sets/dumps/0067nat_concat_interval_0.nft     | 4 ++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index f1452d48f424..3352ad0abb61 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1024,10 +1024,15 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	list_splice_tail(&set_parse_ctx.stmt_list, &set->stmt_list);
 
 	if (datatype) {
+		uint32_t dlen;
+
 		dtype = set_datatype_alloc(datatype, databyteorder);
 		klen = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN) * BITS_PER_BYTE;
 
-		if (set_udata_key_valid(typeof_expr_data, klen)) {
+		dlen = data_interval ?  klen / 2 : klen;
+
+		if (set_udata_key_valid(typeof_expr_data, dlen)) {
+			typeof_expr_data->len = klen;
 			datatype_free(datatype_get(dtype));
 			set->data = typeof_expr_data;
 		} else {
diff --git a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
index 6af47c6682ce..0215691e28ee 100644
--- a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
+++ b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
@@ -18,14 +18,14 @@ table ip nat {
 	}
 
 	map ipportmap4 {
-		type ifname . ipv4_addr : interval ipv4_addr
+		typeof iifname . ip saddr : interval ip daddr
 		flags interval
 		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69/32,
 			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
 	}
 
 	map ipportmap5 {
-		type ifname . ipv4_addr : interval ipv4_addr . inet_service
+		typeof iifname . ip saddr : interval ip daddr . tcp dport
 		flags interval
 		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22,
 			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
-- 
2.40.1

