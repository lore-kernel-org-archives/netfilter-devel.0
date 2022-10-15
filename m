Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17F1C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Oct 2022 11:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJOLDQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Oct 2022 07:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiJOLDQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Oct 2022 07:03:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972464F6A7
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Oct 2022 04:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mjsM4VEoCNGGbjKrq37QNrLk4gbaUfZGHx9G8mESysc=; b=CiYDj36XHsPrP3Izt5NOaMQwRm
        WRfZpayLwVfQHBbJjoOv44TX3rAB3WpLYwlm7R5tZA4RsvePxiu2wFEeHqbaG2aWJojNG0uA90FU0
        VUNP1YJMgu9JZGI17Za/z8XnT2q7Qy0bNIuUQ1lUEwlXfdnmeh09FE8iB+08qNebr/yDOsre4VPNB
        fMuc6k+BMcS264+lDjCp5BBy0dEH6PDJQ2wnJcwwgGKQZWyhXi2IsGLhsaO+1eAAzfcRW8J8seVbV
        9tdzrwfFrmgclwJsf4vl1x21DD0+OGI46w+4OSe7aqWLdcD7IOoM4PYX3yyHchGLFYR8zzLW+PfBn
        sQp9wwwg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ojewi-000791-Vm
        for netfilter-devel@vger.kernel.org; Sat, 15 Oct 2022 13:03:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] tests: Adjust testsuite return codes to automake guidelines
Date:   Sat, 15 Oct 2022 13:02:55 +0200
Message-Id: <20221015110256.15921-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
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
index 7878760fdcc4d..e89f642c516d0 100755
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
index 03bef7e2e5934..9c590f7ebf05e 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -110,7 +110,7 @@ xtables_nft_multi = 'xtables-nft-multi'
                 tests, passed, failed, errors = run_test(args.test, payload)
         except IOError:
             print(red("Error: ") + "test file does not exist", file=sys.stderr)
-            return -1
+            return 99
     else:
         files, tests, passed, failed, errors = load_test_files()
 
-- 
2.34.1

