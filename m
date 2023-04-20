Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC0AC77B72
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 15:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjDTPr2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 11:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbjDTPr0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 11:47:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B5AC2
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2023 08:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=enIJQcepjHsodURuBxhQofAY/blIJ0RXh3LU76v2aMI=; b=omoFwq0XJvFKLKvZUtSroGQ6OU
        nCRB3E68Nf8ACo5g1G8w9FqQd1NEQBwvR8imdLw0x8U/6N8c22LyiqjAvFp+i4RJyiZa8ru0LnQgG
        4WRaFVm2/bR+XeoMGleFHX1h0qnyV3D734bWM1cEPSDRLPYLK7mSP8QSZTFY2T2iWoyXiCF1Yl7H2
        0Z9m9LVqdwBQXJsnH7jb1M+OI4JKAAPURbmFejThCniOMb7gwZzV3KLa0oIt67qpiS09SWj2Kqv0F
        2m104qsVlCfaJHwtJVptQqzX5lcAtFqKYB1fznhT5Jp7d2ExJCulLHsB5Gbc8v0LedgeHZyk3sgfA
        4ruXMuAg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ppWVC-0001Z9-IB; Thu, 20 Apr 2023 17:47:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>
Subject: [nft PATCH] tests: shell: Fix for unstable sets/0043concatenated_ranges_0
Date:   Thu, 20 Apr 2023 17:47:23 +0200
Message-Id: <20230420154723.27089-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On my (slow?) testing VM, The test tends to fail when doing a full run
(i.e., calling run-test.sh without arguments) and tends to pass when run
individually.

The problem seems to be the 1s element timeout which in some cases may
pass before element deletion occurs. Simply fix this by doubling the
timeout. It has to pass just once, so shouldn't hurt too much.

Fixes: 618393c6b3f25 ("tests: Introduce test for set with concatenated ranges")
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/sets/0043concatenated_ranges_0 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_0 b/tests/shell/testcases/sets/0043concatenated_ranges_0
index 11767373bcd22..6e8f4000aa4ef 100755
--- a/tests/shell/testcases/sets/0043concatenated_ranges_0
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_0
@@ -147,7 +147,7 @@ for ta in ${TYPES}; do
 			eval add_b=\$ADD_${tb}
 			eval add_c=\$ADD_${tc}
 			${NFT} add element inet filter test \
-				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s${mapv}}"
+				"{ ${add_a} . ${add_b} . ${add_c} timeout 2s${mapv}}"
 			[ $(${NFT} list ${setmap} inet filter test |	\
 			   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 1 ]
 
@@ -180,7 +180,7 @@ for ta in ${TYPES}; do
 				continue
 			fi
 
-			sleep 1
+			sleep 2
 			[ $(${NFT} list ${setmap} inet filter test |		\
 			   grep -c "${add_a} . ${add_b} . ${add_c} ${mapv}") -eq 0 ]
 			timeout_tested=1
-- 
2.40.0

