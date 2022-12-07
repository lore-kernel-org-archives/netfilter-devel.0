Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041BDC352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiLGRpa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiLGRpU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:45:20 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E09152145
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+N/osBc2nUEvgWSGsinRPNQupZuA5jDDdsRozTYm6+k=; b=UhCizwjYfXfubIuDC6MlRSLX7A
        Rd855uZb/V981CUke8s62mMxce92rRAE6OL5hILHuktClZwVsBPPLkvc6FeF/PpGFJq9QP3cM5G3c
        ghK0mLiBAlWINZP2fzRO9XK7D2pUJ6uL7lQrNOcZkbxiL2GiX1Av8axWVafGD22tNtCyh2lvjQ1Av
        nDNi3AvRiaLxbjPaL0rQs6+JUTtMDR3DQ/BAXtfolsK+Nb0cSrTG6GEcM7/8px4RflLKvDHZ3brj8
        W/8LJsCnuYo33lsJOyunBHH/fOqvhQs2dm1OocD66+F9IYmhp5n96+lrpBnoJ8YuO8IUNcsunH3mu
        08XQOVVA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yTs-0000hU-HW
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:45:16 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/11] tests: Adjust testsuite return codes to automake guidelines
Date:   Wed,  7 Dec 2022 18:44:29 +0100
Message-Id: <20221207174430.4335-11-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221207174430.4335-1-phil@nwl.cc>
References: <20221207174430.4335-1-phil@nwl.cc>
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

