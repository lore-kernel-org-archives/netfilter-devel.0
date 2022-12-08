Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A97C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 15:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiLHPrO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiLHPrM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 10:47:12 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6DA63B98
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 07:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+N/osBc2nUEvgWSGsinRPNQupZuA5jDDdsRozTYm6+k=; b=mtKKP9r1M4V5+n3m/v+e6KD/b9
        XYdEry7Y5TOLGK4IlYHTMVDIgoWYT3Z0kHPEBDMIb3SBIPwaNrzZGQZu7OZJ03VknHz8AuDkPQHEM
        tFfXF72wkgnBxD+8HbjVbroehuCx5tqjQPO8VeWsUguXUV+e0SJxsjQ8FLBUMB5HVwELjF7zco1gt
        Wk1WqU4R8hJXPMU9kHeyKNFUiMELN+3V1o8EmFXNocg3TnhMtAqX/7o/l4jD5QXKvk358Bp/W35vf
        q3UzsukvMCB89QgiH0wQq5pBrnucnv7b0Ua94BbhDMcIkKAia90c6WYlC7Pd3DP/uw6OLtQ3iGcOR
        SCqWSvlQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p3J77-0005gy-WA; Thu, 08 Dec 2022 16:47:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 10/11] tests: Adjust testsuite return codes to automake guidelines
Date:   Thu,  8 Dec 2022 16:46:15 +0100
Message-Id: <20221208154616.14622-11-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221208154616.14622-1-phil@nwl.cc>
References: <20221208154616.14622-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As per the manual[1]:

"When no test protocol is in use, an exit status of 0 from a test script
will denote a success, an exit status of 77 a skipped test, an exit
status of 99 a hard error, and any other exit status will denote a
failure."

[1] https://www.gnu.org/software/automake/manual/html_node/Scripts_002dbased-Testsuites.html

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py                  | 2 +-
 iptables/tests/shell/run-tests.sh | 4 +++-
 xlate-test.py                     | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index dc031c2b60450..de1e1e95fda55 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -579,7 +579,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
 
     if os.getuid() != 0:
         print("You need to be root to run this, sorry", file=sys.stderr)
-        return
+        return 77
 
     if not args.netns and not args.no_netns and not spawn_netns():
         print("Cannot run in own namespace, connectivity might break",
diff --git a/iptables/tests/shell/run-tests.sh b/iptables/tests/shell/run-tests.sh
index 7a80af3432285..1125690583b46 100755
--- a/iptables/tests/shell/run-tests.sh
+++ b/iptables/tests/shell/run-tests.sh
@@ -21,7 +21,6 @@ EOF
 
 msg_error() {
         echo "E: $1 ..." >&2
-        exit 1
 }
 
 msg_warn() {
@@ -34,10 +33,12 @@ msg_info() {
 
 if [ "$(id -u)" != "0" ] ; then
         msg_error "this requires root!"
+        exit 77
 fi
 
 if [ ! -d "$TESTDIR" ] ; then
         msg_error "missing testdir $TESTDIR"
+        exit 99
 fi
 
 # support matching repeated pattern in SINGLE check below
@@ -76,6 +77,7 @@ while [ -n "$1" ]; do
 		;;
 	*)
 		msg_error "unknown parameter '$1'"
+		exit 99
 		;;
 	esac
 done
diff --git a/xlate-test.py b/xlate-test.py
index 4f037ef6ed96d..4cb1401b71677 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -250,7 +250,7 @@ xtables_nft_multi = 'xtables-nft-multi'
                 tests, passed, failed, errors = run_test(args.test, payload)
         except IOError:
             print(red("Error: ") + "test file does not exist", file=sys.stderr)
-            return -1
+            return 99
     else:
         files, tests, passed, failed, errors = load_test_files()
 
-- 
2.38.0

