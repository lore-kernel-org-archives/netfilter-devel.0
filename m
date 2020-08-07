Return-Path: <SRS0=v7HC=BR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEC1C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Aug 2020 12:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 412702075D
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Aug 2020 12:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgHGMC3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Aug 2020 08:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgHGMC2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Aug 2020 08:02:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66067C061574
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2020 05:02:27 -0700 (PDT)
Received: from localhost ([::1]:59772 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1k414k-0004ZR-Rf; Fri, 07 Aug 2020 14:02:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 2/2] tests: shell: Merge and extend return codes test
Date:   Fri,  7 Aug 2020 14:02:14 +0200
Message-Id: <20200807120214.3762-2-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200807120214.3762-1-phil@nwl.cc>
References: <20200807120214.3762-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge scripts for iptables and ip6tables, they were widely identical.
Also extend the test by one check (removing a non-existent rule with
valid chain and target) and quote the error messages where differences
are deliberately ignored.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Check error prefix value also.
---
 .../testcases/ip6tables/0004-return-codes_0   |  39 ------
 .../testcases/iptables/0004-return-codes_0    | 113 ++++++++++--------
 2 files changed, 61 insertions(+), 91 deletions(-)
 delete mode 100755 iptables/tests/shell/testcases/ip6tables/0004-return-codes_0

diff --git a/iptables/tests/shell/testcases/ip6tables/0004-return-codes_0 b/iptables/tests/shell/testcases/ip6tables/0004-return-codes_0
deleted file mode 100755
index c583b0ebd97c3..0000000000000
--- a/iptables/tests/shell/testcases/ip6tables/0004-return-codes_0
+++ /dev/null
@@ -1,39 +0,0 @@
-#!/bin/sh
-
-# make sure error return codes are as expected useful cases
-# (e.g. commands to check ruleset state)
-
-global_rc=0
-
-cmd() { # (rc, cmd, [args ...])
-	rc_exp=$1; shift
-
-	$XT_MULTI "$@"
-	rc=$?
-
-	[ $rc -eq $rc_exp ] || {
-		echo "---> expected $rc_exp, got $rc for command '$@'"
-		global_rc=1
-	}
-}
-
-# test chain creation
-cmd 0 ip6tables -N foo
-cmd 1 ip6tables -N foo
-# iptables-nft allows this - bug or feature?
-#cmd 2 ip6tables -N "invalid name"
-
-# test rule adding
-cmd 0 ip6tables -A INPUT -j ACCEPT
-cmd 1 ip6tables -A noexist -j ACCEPT
-cmd 2 ip6tables -I INPUT -j foobar
-
-# test rule checking
-cmd 0 ip6tables -C INPUT -j ACCEPT
-cmd 1 ip6tables -C FORWARD -j ACCEPT
-cmd 1 ip6tables -C nonexist -j ACCEPT
-cmd 2 ip6tables -C INPUT -j foobar
-cmd 2 ip6tables -C INPUT -m foobar -j ACCEPT
-cmd 3 ip6tables -t foobar -C INPUT -j ACCEPT
-
-exit $global_rc
diff --git a/iptables/tests/shell/testcases/iptables/0004-return-codes_0 b/iptables/tests/shell/testcases/iptables/0004-return-codes_0
index f730bede1f612..dcd9dfd3c0806 100755
--- a/iptables/tests/shell/testcases/iptables/0004-return-codes_0
+++ b/iptables/tests/shell/testcases/iptables/0004-return-codes_0
@@ -13,75 +13,84 @@ cmd() { # (rc, msg, cmd, [args ...])
 		msg_exp="$1"; shift
 	}
 
-	msg="$($XT_MULTI "$@" 2>&1 >/dev/null)"
-	rc=$?
+	for ipt in iptables ip6tables; do
+		msg="$($XT_MULTI $ipt "$@" 2>&1 >/dev/null)"
+		rc=$?
 
-	[ $rc -eq $rc_exp ] || {
-		echo "---> expected return code $rc_exp, got $rc for command '$@'"
-		global_rc=1
-	}
+		[ $rc -eq $rc_exp ] || {
+			echo "---> expected return code $rc_exp, got $rc for command '$ipt $@'"
+			global_rc=1
+		}
 
-	[ -n "$msg_exp" ] || return
-	grep -q "$msg_exp" <<< $msg || {
-		echo "---> expected error message '$msg_exp', got '$msg' for command '$@'"
-		global_rc=1
-	}
+		[ -n "$msg_exp" ] || continue
+		msg_exp_full="${ipt}$msg_exp"
+		grep -q "$msg_exp_full" <<< $msg || {
+			echo "---> expected error message '$msg_exp_full', got '$msg' for command '$ipt $@'"
+			global_rc=1
+		}
+	done
 }
 
-EEXIST_F="File exists."
-EEXIST="Chain already exists."
-ENOENT="No chain/target/match by that name."
-E2BIG_I="Index of insertion too big."
-E2BIG_D="Index of deletion too big."
-E2BIG_R="Index of replacement too big."
-EBADRULE="Bad rule (does a matching rule exist in that chain?)."
-ENOTGT="Couldn't load target \`foobar':No such file or directory"
-ENOMTH="Couldn't load match \`foobar':No such file or directory"
-ENOTBL="can't initialize iptables table \`foobar': Table does not exist"
+EEXIST_F=": File exists."
+EEXIST=": Chain already exists."
+ENOENT=": No chain/target/match by that name."
+E2BIG_I=": Index of insertion too big."
+E2BIG_D=": Index of deletion too big."
+E2BIG_R=": Index of replacement too big."
+EBADRULE=": Bad rule (does a matching rule exist in that chain?)."
+#ENOTGT=" v[0-9\.]* [^ ]*: Couldn't load target \`foobar':No such file or directory"
+ENOMTH=" v[0-9\.]* [^ ]*: Couldn't load match \`foobar':No such file or directory"
+ENOTBL=": can't initialize iptables table \`foobar': Table does not exist"
 
 # test chain creation
-cmd 0 iptables -N foo
-cmd 1 "$EEXIST" iptables -N foo
+cmd 0 -N foo
+cmd 1 "$EEXIST" -N foo
 # iptables-nft allows this - bug or feature?
-#cmd 2 iptables -N "invalid name"
+#cmd 2 -N "invalid name"
 
 # test chain flushing/zeroing
-cmd 0 iptables -F foo
-cmd 0 iptables -Z foo
-cmd 1 "$ENOENT" iptables -F bar
-cmd 1 "$ENOENT" iptables -Z bar
+cmd 0 -F foo
+cmd 0 -Z foo
+cmd 1 "$ENOENT" -F bar
+cmd 1 "$ENOENT" -Z bar
 
 # test chain rename
-cmd 0 iptables -E foo bar
-cmd 1 "$EEXIST_F" iptables -E foo bar
-cmd 1 "$ENOENT" iptables -E foo bar2
-cmd 0 iptables -N foo2
-cmd 1 "$EEXIST_F" iptables -E foo2 bar
+cmd 0 -E foo bar
+cmd 1 "$EEXIST_F" -E foo bar
+cmd 1 "$ENOENT" -E foo bar2
+cmd 0 -N foo2
+cmd 1 "$EEXIST_F" -E foo2 bar
 
 # test rule adding
-cmd 0 iptables -A INPUT -j ACCEPT
-cmd 1 "$ENOENT" iptables -A noexist -j ACCEPT
-cmd 2 "" iptables -I INPUT -j foobar
-cmd 2 "" iptables -R INPUT 1 -j foobar
-cmd 2 "" iptables -D INPUT -j foobar
+cmd 0 -A INPUT -j ACCEPT
+cmd 1 "$ENOENT" -A noexist -j ACCEPT
+# next three differ:
+# legacy: Couldn't load target `foobar':No such file or directory
+# nft:    Chain 'foobar' does not exist
+cmd 2 "" -I INPUT -j foobar
+cmd 2 "" -R INPUT 1 -j foobar
+cmd 2 "" -D INPUT -j foobar
+cmd 1 "$EBADRULE" -D INPUT -p tcp --dport 22 -j ACCEPT
 
 # test rulenum commands
-cmd 1 "$E2BIG_I" iptables -I INPUT 23 -j ACCEPT
-cmd 1 "$E2BIG_D" iptables -D INPUT 23
-cmd 1 "$E2BIG_R" iptables -R INPUT 23 -j ACCEPT
-cmd 1 "$ENOENT" iptables -I nonexist 23 -j ACCEPT
-cmd 1 "$ENOENT" iptables -D nonexist 23
-cmd 1 "$ENOENT" iptables -R nonexist 23 -j ACCEPT
+cmd 1 "$E2BIG_I" -I INPUT 23 -j ACCEPT
+cmd 1 "$E2BIG_D" -D INPUT 23
+cmd 1 "$E2BIG_R" -R INPUT 23 -j ACCEPT
+cmd 1 "$ENOENT" -I nonexist 23 -j ACCEPT
+cmd 1 "$ENOENT" -D nonexist 23
+cmd 1 "$ENOENT" -R nonexist 23 -j ACCEPT
 
 # test rule checking
-cmd 0 iptables -C INPUT -j ACCEPT
-cmd 1 "$EBADRULE" iptables -C FORWARD -j ACCEPT
-cmd 1 "$BADRULE" iptables -C nonexist -j ACCEPT
-cmd 2 "$ENOMTH" iptables -C INPUT -m foobar -j ACCEPT
+cmd 0 -C INPUT -j ACCEPT
+cmd 1 "$EBADRULE" -C FORWARD -j ACCEPT
+cmd 1 "$BADRULE" -C nonexist -j ACCEPT
+cmd 2 "$ENOMTH" -C INPUT -m foobar -j ACCEPT
 # messages of those don't match, but iptables-nft ones are actually nicer.
-#cmd 2 "$ENOTGT" iptables -C INPUT -j foobar
-#cmd 3 "$ENOTBL" iptables -t foobar -C INPUT -j ACCEPT
-cmd 2 "" iptables -C INPUT -j foobar
-cmd 3 "" iptables -t foobar -C INPUT -j ACCEPT
+# legacy: Couldn't load target `foobar':No such file or directory
+# nft:    Chain 'foobar' does not exist
+cmd 2 "" -C INPUT -j foobar
+# legacy: can't initialize ip6tables table `foobar': Table does not exist (do you need to insmod?)
+# nft:    table 'foobar' does not exist
+cmd 3 "" -t foobar -C INPUT -j ACCEPT
 
 exit $global_rc
-- 
2.27.0

