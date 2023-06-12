Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC77C7EE2E
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jun 2023 10:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbjFLKt0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jun 2023 06:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbjFLKtO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2023 06:49:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DAE5FDC
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jun 2023 03:33:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1q8erq-0006OK-VT; Mon, 12 Jun 2023 12:33:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add test case for chain-in-use-splat
Date:   Mon, 12 Jun 2023 12:33:43 +0200
Message-Id: <20230612103343.36735-1-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

WARNING [.]: at net/netfilter/nf_tables_api.c:1885
6.3.4-201.fc38.x86_64 #1
nft_immediate_destroy+0xc1/0xd0 [nf_tables]
__nf_tables_abort+0x4b9/0xb20 [nf_tables]
nf_tables_abort+0x39/0x50 [nf_tables]
nfnetlink_rcv_batch+0x47c/0x8e0 [nfnetlink]
nfnetlink_rcv+0x179/0x1a0 [nfnetlink]
netlink_unicast+0x19e/0x290

This is because of chain->use underflow, at time destroy
function is called, ->use has wrapped back to -1.

Fixed via
"netfilter: nf_tables: fix chain binding transaction logic".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/transactions/anon_chain_loop    | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/anon_chain_loop

diff --git a/tests/shell/testcases/transactions/anon_chain_loop b/tests/shell/testcases/transactions/anon_chain_loop
new file mode 100755
index 000000000000..1820fb74485b
--- /dev/null
+++ b/tests/shell/testcases/transactions/anon_chain_loop
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+# anon chains with c1 -> c2 recursive jump, expect failure
+$NFT -f - <<EOF
+table ip t {
+ chain c2 { }
+ chain c1 { }
+}
+
+add bla c1 ip saddr 127.0.0.1 jump { jump c2; }
+add bla c2 ip saddr 127.0.0.1 jump { jump c1; }
+EOF
+
+if [ $? -eq 0 ] ; then
+        echo "E: able to load bad ruleset" >&2
+        exit 1
+fi
+
+exit 0
-- 
2.40.1

