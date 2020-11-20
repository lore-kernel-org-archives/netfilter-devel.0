Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146B6C2D0E4
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 17:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B34F02240B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 17:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbgKTR6K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 12:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbgKTR6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 12:58:10 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D711C0613CF
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2020 09:58:09 -0800 (PST)
Received: from localhost ([::1]:50292 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kgAfd-0006zr-Jm; Fri, 20 Nov 2020 18:58:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: shell: Stabilize nft-only/0009-needless-bitwise_0
Date:   Fri, 20 Nov 2020 18:57:57 +0100
Message-Id: <20201120175757.8063-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Netlink debug output varies depending on host's endianness and therefore
the test fails on Big Endian machines. Since for the sake of asserting
no needless bitwise expressions in output the actual data values are not
relevant, simply crop the output to just the expression names.

Fixes: 81a2e12851283 ("tests/shell: Add test for bitwise avoidance fixes")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../nft-only/0009-needless-bitwise_0          | 413 +++++++++---------
 1 file changed, 208 insertions(+), 205 deletions(-)

diff --git a/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0 b/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
index 41d765e537312..0254208bcf69f 100755
--- a/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
+++ b/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
@@ -1,4 +1,4 @@
-#!/bin/bash -x
+#!/bin/bash
 
 [[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
 set -e
@@ -53,287 +53,290 @@ ff:00:00:00:00:00
 ) | $XT_MULTI ebtables-restore
 
 EXPECT="ip filter OUTPUT 4
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0302010a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip filter OUTPUT 5 4
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0302010a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip filter OUTPUT 6 5
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xfcffffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0002010a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ bitwise ]
+  [ cmp ]
+  [ counter ]
 
 ip filter OUTPUT 7 6
-  [ payload load 3b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0002010a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip filter OUTPUT 8 7
-  [ payload load 2b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0000010a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip filter OUTPUT 9 8
-  [ payload load 1b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip filter OUTPUT 10 9
-  [ counter pkts 0 bytes 0 ]
+  [ counter ]
 
 ip6 filter OUTPUT 4
-  [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x0a090807 ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 5 4
-  [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x0a090807 ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 6 5
-  [ payload load 16b @ network header + 24 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0xffffffff 0xffffffff 0xf0ffffff ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x00090807 ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ bitwise ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 7 6
-  [ payload load 15b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x00090807 ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 8 7
-  [ payload load 14b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x00000807 ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 9 8
-  [ payload load 11b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x00050403 ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 10 9
-  [ payload load 10b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x00000403 ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 11 10
-  [ payload load 8b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x020100ee ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 12 11
-  [ payload load 6b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0xffc0edfe 0x000000ee ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 13 12
-  [ payload load 2b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 14 13
-  [ payload load 1b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x000000fe ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 ip6 filter OUTPUT 15 14
-  [ counter pkts 0 bytes 0 ]
+  [ counter ]
 
 arp filter OUTPUT 3
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 4b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0302010a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 4 3
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 4b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0302010a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 5 4
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 4b @ network header + 24 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xfcffffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0002010a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ bitwise ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 6 5
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 3b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0002010a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 7 6
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 2b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0000010a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 8 7
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 1b @ network header + 24 => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 9 8
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 10 9
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 6b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000eeff ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 11 10
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 6b @ network header + 18 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0x0000f0ff ) ^ 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000e0ff ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ bitwise ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 12 11
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 5b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe 0x000000ff ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 13 12
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 4b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 14 13
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 3b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 15 14
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 2b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 arp filter OUTPUT 16 15
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp eq reg 1 0x00000004 ]
-  [ payload load 1b @ network header + 18 => reg 1 ]
-  [ cmp eq reg 1 0x000000fe ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 bridge filter OUTPUT 4
-  [ payload load 6b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000eeff ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 bridge filter OUTPUT 5 4
-  [ payload load 6b @ link header + 0 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0x0000f0ff ) ^ 0x00000000 0x00000000 ]
-  [ cmp eq reg 1 0xc000edfe 0x0000e0ff ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ bitwise ]
+  [ cmp ]
+  [ counter ]
 
 bridge filter OUTPUT 6 5
-  [ payload load 5b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe 0x000000ff ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 bridge filter OUTPUT 7 6
-  [ payload load 4b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0xc000edfe ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 bridge filter OUTPUT 8 7
-  [ payload load 3b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 bridge filter OUTPUT 9 8
-  [ payload load 2b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x0000edfe ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 
 bridge filter OUTPUT 10 9
-  [ payload load 1b @ link header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x000000fe ]
-  [ counter pkts 0 bytes 0 ]
+  [ payload ]
+  [ cmp ]
+  [ counter ]
 "
 
-diff -u -Z <(echo "$EXPECT") <(nft --debug=netlink list ruleset | awk '/^table/{exit} {print}')
+diff -u -Z <(echo "$EXPECT") <(nft --debug=netlink list ruleset | awk '
+	/^table/{exit}
+	{print gensub(/\[ ([^ ]+) .* ]/,"[ \\1 ]", "g")}'
+)
-- 
2.28.0

