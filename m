Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD5BEE4993
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Aug 2023 16:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbjHWQb5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Aug 2023 12:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237603AbjHWQb5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2023 12:31:57 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEECCEE
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2023 09:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kve3jiz7eTiQd5PGrrRji6k1s+Byd8fmEOe/O312CjI=; b=KbtPgSYE67HZpEhW5+0zMC1nFS
        hlsWqnfsHHZMFMumBuuPPTkQMxtSQaKOmuiKBcv3/2Ys6uJ9yHnaf5jZL2gviegdb5CGABr/x+08C
        UUOgFsU5vuVAAzpMiZKv9wUPAUiagjeqS8/9GKwBtVQq128OuZH9XwZPgRLhhIUb5TOW5p68UMRWu
        QL42uZup1VtPjttZllWJ7XBBbyIF8Pp+pUR22y4c+6Rb2Z97arfkIkITwmIj6fL5oTmO2HLVEDOQ+
        kyDkahxgwa3464aQrN0tK9+rt5t61VW2ltz3AeZ4XItKUHABgrbZ73N2ghos6Dz2Ur29pYG9TR27v
        aCDkqwrQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qYqlm-0006mM-TH; Wed, 23 Aug 2023 18:31:46 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Stabilize sets/0043concatenated_ranges_0 test
Date:   Wed, 23 Aug 2023 18:33:15 +0200
Message-ID: <20230823163315.4049-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On a slow system, one of the 'delete element' commands would
occasionally fail. Assuming it can only happen if the 2s timeout passes
"too quickly", work around it by adding elements with a 2m timeout
instead and when wanting to test the element expiry just drop and add
the element again with a short timeout.

Fixes: 6231d3fa4af1e ("tests: shell: Fix for unstable sets/0043concatenated_ranges_0")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/sets/0043concatenated_ranges_0 | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_0 b/tests/shell/testcases/sets/0043concatenated_ranges_0
index 6e8f4000aa4ef..8d3dacf6e38ad 100755
--- a/tests/shell/testcases/sets/0043concatenated_ranges_0
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_0
@@ -147,7 +147,7 @@ for ta in ${TYPES}; do
 			eval add_b=\$ADD_${tb}
 			eval add_c=\$ADD_${tc}
 			${NFT} add element inet filter test \
-				"{ ${add_a} . ${add_b} . ${add_c} timeout 2s${mapv}}"
+				"{ ${add_a} . ${add_b} . ${add_c} timeout 2m${mapv}}"
 			[ $(${NFT} list ${setmap} inet filter test |	\
 			   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 1 ]
 
@@ -180,7 +180,11 @@ for ta in ${TYPES}; do
 				continue
 			fi
 
-			sleep 2
+			${NFT} delete element inet filter test \
+				"{ ${add_a} . ${add_b} . ${add_c} ${mapv}}"
+			${NFT} add element inet filter test \
+				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s${mapv}}"
+			sleep 1
 			[ $(${NFT} list ${setmap} inet filter test |		\
 			   grep -c "${add_a} . ${add_b} . ${add_c} ${mapv}") -eq 0 ]
 			timeout_tested=1
-- 
2.41.0

