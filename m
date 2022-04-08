Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E37AC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 13:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbiDHNuD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 09:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiDHNuD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 09:50:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AFBF1ADC
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 06:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7t4AhXCrsI7xc4ocpLWkEvzBZK4MUyn9vegYZV2R/rs=; b=JtAqU5hEvbxUnLlF97pU85p3+3
        lacFJg1MsZza5caqQYdy7rU/NWbbYQtPiX6LtOIJwZmpBS4qZd/bNGSXFJBzEi4Q0JdWqDP/5u/O6
        XNlAkWsdFSp0sC0f3tcEdRROJXar1SolfHY3IzC0ZbMOXs2pcBC2qTdX4fbv6OP9HoDQxDh12mSHJ
        sThMTut8wfJaOtUU1x4mFlICsSsW1CtKDAgFT59gULGa+/dE7Tb62Ll5/YqTaprxl2AkaSoW3T0kT
        A+tUSM2MCMNXy7Z6bdiYxS+R26gWAgUGS1P3KTStddqgdaNzjKhhoeHVqqg9TITVchPyURVx/mJ43
        MIhaaLLg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ncoxy-0003Eq-56; Fri, 08 Apr 2022 15:47:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: monitor: Hide temporary file names from error output
Date:   Fri,  8 Apr 2022 15:47:54 +0200
Message-Id: <20220408134754.25158-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make error output deterministic by passing input to nft via stdin. This
way error messages will contain "/dev/stdin" instead of the temporary
file name.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index ff00450b19c23..b5ca47d9838e4 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -74,7 +74,7 @@ monitor_run_test() {
 		echo "command file:"
 		cat $command_file
 	}
-	$nft -f $command_file || {
+	$nft -f - <$command_file || {
 		err "nft command failed!"
 		rc=1
 	}
@@ -103,7 +103,7 @@ echo_run_test() {
 		echo "command file:"
 		cat $command_file
 	}
-	$nft -nn -e -f $command_file >$echo_output || {
+	$nft -nn -e -f - <$command_file >$echo_output || {
 		err "nft command failed!"
 		rc=1
 	}
-- 
2.34.1

