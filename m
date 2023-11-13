Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83306C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 13:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjKMNpB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 08:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjKMNpA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 08:45:00 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61A5DD51
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 05:44:57 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: expand create commands
Date:   Mon, 13 Nov 2023 14:44:53 +0100
Message-Id: <20231113134453.121975-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

create commands also need to be expanded, otherwise elements are never
evaluated:

 # cat ruleset.nft
 define ip-block-4 = { 1.1.1.1 }
 create set netdev filter ip-block-4-test {
        type ipv4_addr
	flags interval
	auto-merge
	elements = $ip-block-4
 }
 # nft -f ruleset.nft
 BUG: unhandled expression type 0
 nft: src/intervals.c:211: interval_expr_key: Assertion `0' failed.
 Aborted

Same applies to chains in the form of:

 create chain x y {
	counter
 }

which is also accepted by the parser.

Fixes: 56c90a2dd2eb ("evaluate: expand sets and maps before evaluation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I will post a v2 includes tests.

 src/libnftables.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index ec902009e002..0dee1bacb0db 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -532,7 +532,8 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 		collapsed = true;
 
 	list_for_each_entry(cmd, cmds, list) {
-		if (cmd->op != CMD_ADD)
+		if (cmd->op != CMD_ADD &&
+		    cmd->op != CMD_CREATE)
 			continue;
 
 		nft_cmd_expand(cmd);
-- 
2.30.2

