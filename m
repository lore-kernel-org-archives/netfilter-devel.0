Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A69BC7EE2D
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Mar 2023 11:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjCALFI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Mar 2023 06:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCALFH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2023 06:05:07 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C619B16314
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2023 03:05:05 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 2/2] tests: shell: use bash in 0011reset_0
Date:   Wed,  1 Mar 2023 12:05:01 +0100
Message-Id: <20230301110501.79700-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230301110501.79700-1-pablo@netfilter.org>
References: <20230301110501.79700-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

One of my boxes does not use bash as /bin/sh, update this test to
explicitly use bash, otherwise I hit:

  testcases/rule_management/0011reset_0: 71: Syntax error: "(" unexpected

Fixes: 1694df2de79f ("Implement 'reset rule' and 'reset rules' commands")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/rule_management/0011reset_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/rule_management/0011reset_0 b/tests/shell/testcases/rule_management/0011reset_0
index 1a28b49fa8a7..8d2307964c37 100755
--- a/tests/shell/testcases/rule_management/0011reset_0
+++ b/tests/shell/testcases/rule_management/0011reset_0
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 set -e
 
-- 
2.30.2

