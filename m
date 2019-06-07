Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC62C2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 17:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1542207E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 17:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfFGRZw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 13:25:52 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35996 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbfFGRZw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 13:25:52 -0400
Received: from localhost ([::1]:49086 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hZIch-0006yo-0P; Fri, 07 Jun 2019 19:25:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/4] tests/shell: Fix warning from awk call
Date:   Fri,  7 Jun 2019 19:25:26 +0200
Message-Id: <20190607172527.22177-4-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607172527.22177-1-phil@nwl.cc>
References: <20190607172527.22177-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Syntax passed to awk in that one testcase caused a warning, fix the
syntax.

Fixes: e0a9aad024809 ("tests: shell: fix tests for deletion via handle attribute")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/sets/0028delete_handle_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/sets/0028delete_handle_0 b/tests/shell/testcases/sets/0028delete_handle_0
index 626d51bc2cbb2..4e8b3228f6052 100755
--- a/tests/shell/testcases/sets/0028delete_handle_0
+++ b/tests/shell/testcases/sets/0028delete_handle_0
@@ -7,7 +7,7 @@ $NFT add set test-ip y { type inet_service \; timeout 3h45s \;}
 $NFT add set test-ip z { type ipv4_addr\; flags constant , interval\;}
 $NFT add set test-ip c {type ipv4_addr \; flags timeout \; elements={192.168.1.1 timeout 10s, 192.168.1.2 timeout 30s} \;}
 
-set_handle=$($NFT list ruleset -a | awk '/set\ c/{print $NF}')
+set_handle=$($NFT list ruleset -a | awk '/set c/{print $NF}')
 $NFT delete set test-ip handle $set_handle
 
 EXPECTED="table ip test-ip {
-- 
2.21.0

