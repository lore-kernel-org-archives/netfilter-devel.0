Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9ABC33CA2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A3DD20721
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgAJLLZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:11:25 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:34986 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbgAJLLZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 06:11:25 -0500
Received: from localhost ([::1]:48076 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ipsCJ-0002kb-Fe; Fri, 10 Jan 2020 12:11:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/3] tests: monitor: Support running individual test cases
Date:   Fri, 10 Jan 2020 12:11:14 +0100
Message-Id: <20200110111114.23952-4-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110111114.23952-1-phil@nwl.cc>
References: <20200110111114.23952-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recognize testcase paths on command line and limit testing on those
only.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 0478cf60c0dfe..efacdaaab952b 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -108,6 +108,7 @@ echo_run_test() {
 	touch $output_file
 }
 
+testcases=""
 while [ -n "$1" ]; do
 	case "$1" in
 	-d|--debug)
@@ -118,11 +119,15 @@ while [ -n "$1" ]; do
 		test_json=true
 		shift
 		;;
+	testcases/*.t)
+		testcases+=" $1"
+		shift
+		;;
 	*)
 		echo "unknown option '$1'"
 		;&
 	-h|--help)
-		echo "Usage: $(basename $0) [-j|--json] [-d|--debug]"
+		echo "Usage: $(basename $0) [-j|--json] [-d|--debug] [testcase ...]"
 		exit 1
 		;;
 	esac
@@ -138,7 +143,7 @@ for variant in $variants; do
 	run_test=${variant}_run_test
 	output_append=${variant}_output_append
 
-	for testcase in testcases/*.t; do
+	for testcase in ${testcases:-testcases/*.t}; do
 		echo "$variant: running tests from file $(basename $testcase)"
 		# files are like this:
 		#
-- 
2.24.1

