Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8790EC4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C60423D39
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389078AbgLJNHe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 08:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389076AbgLJNHe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 08:07:34 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D5CC0617A7
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:06:51 -0800 (PST)
Received: from localhost ([::1]:40990 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1knLek-0000gh-Ge; Thu, 10 Dec 2020 14:06:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 8/9] tests: shell: Drop any dump sorting in place
Date:   Thu, 10 Dec 2020 14:06:35 +0100
Message-Id: <20201210130636.26379-9-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201210130636.26379-1-phil@nwl.cc>
References: <20201210130636.26379-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With iptables-nft-save output now sorted just like legacy one, no
sorting to unify them is needed anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../firewalld-restore/0001-firewalld_0          | 17 ++---------------
 .../testcases/ipt-restore/0007-flush-noflush_0  |  4 ++--
 .../ipt-restore/0014-verbose-restore_0          |  2 +-
 3 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/iptables/tests/shell/testcases/firewalld-restore/0001-firewalld_0 b/iptables/tests/shell/testcases/firewalld-restore/0001-firewalld_0
index 0174b03f4ebc7..4900554e7d9e6 100755
--- a/iptables/tests/shell/testcases/firewalld-restore/0001-firewalld_0
+++ b/iptables/tests/shell/testcases/firewalld-restore/0001-firewalld_0
@@ -230,21 +230,8 @@ for table in nat mangle raw filter;do
 	$XT_MULTI iptables-save -t $table | grep -v '^#' >> "$tmpfile"
 done
 
-case "$XT_MULTI" in
-*xtables-nft-multi)
-	# nft-multi displays chain names in different order, work around this for now
-	tmpfile2=$(mktemp)
-	sort "$tmpfile" > "$tmpfile2"
-	sort $(dirname "$0")/dumps/ipt-save-completed.txt > "$tmpfile"
-	diff -u $tmpfile $tmpfile2
-	RET=$?
-	rm -f "$tmpfile2"
-	;;
-*)
-	diff -u $tmpfile  $(dirname "$0")/dumps/ipt-save-completed.txt
-	RET=$?
-	;;
-esac
+diff -u $tmpfile  $(dirname "$0")/dumps/ipt-save-completed.txt
+RET=$?
 
 rm -f "$tmpfile"
 
diff --git a/iptables/tests/shell/testcases/ipt-restore/0007-flush-noflush_0 b/iptables/tests/shell/testcases/ipt-restore/0007-flush-noflush_0
index 029db2235b9a4..e705b28c87359 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0007-flush-noflush_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0007-flush-noflush_0
@@ -18,7 +18,7 @@ EXPECT="*nat
 :POSTROUTING ACCEPT [0:0]
 -A POSTROUTING -j ACCEPT
 COMMIT"
-diff -u -Z <(echo -e "$EXPECT" | sort) <($XT_MULTI iptables-save | grep -v '^#' | sort)
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables-save | grep -v '^#')
 
 $XT_MULTI iptables-restore <<EOF
 *filter
@@ -39,4 +39,4 @@ COMMIT
 :POSTROUTING ACCEPT [0:0]
 -A POSTROUTING -j ACCEPT
 COMMIT"
-diff -u -Z <(echo -e "$EXPECT" | sort) <($XT_MULTI iptables-save | grep -v '^#' | sort)
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables-save | grep -v '^#')
diff --git a/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0 b/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
index 94bed0ec29c6b..fc8559c5bac9e 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
@@ -59,7 +59,7 @@ Flushing chain \`secfoo'
 Deleting chain \`secfoo'"
 
 for ipt in iptables-restore ip6tables-restore; do
-	diff -u -Z <(sort <<< "$EXPECT") <($XT_MULTI $ipt -v <<< "$DUMP" | sort)
+	diff -u -Z <(echo "$EXPECT") <($XT_MULTI $ipt -v <<< "$DUMP")
 done
 
 DUMP="*filter
-- 
2.28.0

