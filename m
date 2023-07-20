Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82487EB64DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 10:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjGTKtc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 06:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjGTKtb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 06:49:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1E61738
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2023 03:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+tkLy+CoL710MP0e5vRekomM2802R9cWE5le+/D1CE0=; b=T2u0IIyYCp5a3uIoFGs/JVBQF+
        onRhsHJomTIXn5HMGDomMpoPq4UgOaTz91ofM998uvoWFAF+wkew/HgamQ/4uRivHo0cntATAAqkD
        B+jgs/xd6DJLR2CFdVPxqtNskG45QiRh1HHSuWqKhyd4+Z1hmSRAzm+hHCsivCRFElyUdfKlWqX+O
        1lbsVwv0dkXUCVXvfnHKSxVT7zppn/8GA+iRYuYW2LoIx92/ZKPFF282SvCAMKl/NRjdf2VDM9LbJ
        X6pl2nnr4m+q3XNNCKXxtcnIbBAsHeQtHZbP3RVpveoY/iUJ4fKwyZpHuy+F8uCa/NH0OVk8pfZfl
        6Jxzoslw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qMRDr-0003jN-IL; Thu, 20 Jul 2023 12:49:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: monitor: Summarize failures per test case
Date:   Thu, 20 Jul 2023 12:49:19 +0200
Message-Id: <20230720104919.29383-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Explicitly print when tests from a file fail in addition to the diff +
"output differs" message.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index b5ca47d9838e4..f1ac790acf80c 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -161,7 +161,10 @@ for variant in $variants; do
 	output_append=${variant}_output_append
 
 	for testcase in ${testcases:-testcases/*.t}; do
-		echo "$variant: running tests from file $(basename $testcase)"
+		filename=$(basename $testcase)
+		echo "$variant: running tests from file $filename"
+		rc_start=$rc
+
 		# files are like this:
 		#
 		# I add table ip t
@@ -199,6 +202,10 @@ for variant in $variants; do
 			$run_test
 			let "rc += $?"
 		}
+
+		let "rc_diff = rc - rc_start"
+		[[ $rc_diff -ne 0 ]] && \
+			echo "$variant: $rc_diff tests from file $filename failed"
 	done
 done
 exit $rc
-- 
2.40.0

