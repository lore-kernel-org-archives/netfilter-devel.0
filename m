Return-Path: <SRS0=0JUI=4J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4046C35647
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 14:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A254320679
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 14:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgBUODj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:03:39 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:57000 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbgBUODj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 09:03:39 -0500
Received: from localhost ([::1]:41858 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j58u2-0000gJ-5H; Fri, 21 Feb 2020 15:03:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] xtables: Align effect of -4/-6 options with legacy
Date:   Fri, 21 Feb 2020 15:03:22 +0100
Message-Id: <20200221140324.21082-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Legacy iptables doesn't accept -4 or -6 if they don't match the
symlink's native family. The only exception to that is iptables-restore
which simply ignores the lines introduced by non-matching options, which
is useful to create combined dump files for feeding into both
iptables-restore and ip6tables-restore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/iptables/0006-46-args_0   | 88 +++++++++++++++++++
 iptables/xtables.c                            | 21 ++---
 2 files changed, 96 insertions(+), 13 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/iptables/0006-46-args_0

diff --git a/iptables/tests/shell/testcases/iptables/0006-46-args_0 b/iptables/tests/shell/testcases/iptables/0006-46-args_0
new file mode 100755
index 0000000000000..17a0a01829df5
--- /dev/null
+++ b/iptables/tests/shell/testcases/iptables/0006-46-args_0
@@ -0,0 +1,88 @@
+#!/bin/bash
+
+RC=0
+
+$XT_MULTI iptables -6 -A FORWARD -j ACCEPT
+rc=$?
+if [[ $rc -ne 2 ]]; then
+	echo "'iptables -6' returned $rc instead of 2"
+	RC=1
+fi
+
+$XT_MULTI ip6tables -4 -A FORWARD -j ACCEPT
+rc=$?
+if [[ $rc -ne 2 ]]; then
+	echo "'ip6tables -4' returned $rc instead of 2"
+	RC=1
+fi
+
+RULESET='*filter
+-4 -A FORWARD -d 10.0.0.1 -j ACCEPT
+-6 -A FORWARD -d fec0:10::1 -j ACCEPT
+COMMIT
+'
+EXPECT4='-P FORWARD ACCEPT
+-A FORWARD -d 10.0.0.1/32 -j ACCEPT'
+EXPECT6='-P FORWARD ACCEPT
+-A FORWARD -d fec0:10::1/128 -j ACCEPT'
+EXPECT_EMPTY='-P FORWARD ACCEPT'
+
+echo "$RULESET" | $XT_MULTI iptables-restore || {
+	echo "iptables-restore failed!"
+	RC=1
+}
+diff -u -Z <(echo -e "$EXPECT4") <($XT_MULTI iptables -S FORWARD) || {
+	echo "unexpected iptables ruleset"
+	RC=1
+}
+diff -u -Z <(echo -e "$EXPECT_EMPTY") <($XT_MULTI ip6tables -S FORWARD) || {
+	echo "unexpected non-empty ip6tables ruleset"
+	RC=1
+}
+
+$XT_MULTI iptables -F FORWARD
+
+echo "$RULESET" | $XT_MULTI ip6tables-restore || {
+	echo "ip6tables-restore failed!"
+	RC=1
+}
+diff -u -Z <(echo -e "$EXPECT6") <($XT_MULTI ip6tables -S FORWARD) || {
+	echo "unexpected ip6tables ruleset"
+	RC=1
+}
+diff -u -Z <(echo -e "$EXPECT_EMPTY") <($XT_MULTI iptables -S FORWARD) || {
+	echo "unexpected non-empty iptables ruleset"
+	RC=1
+}
+
+$XT_MULTI ip6tables -F FORWARD
+
+$XT_MULTI iptables -4 -A FORWARD -d 10.0.0.1 -j ACCEPT || {
+	echo "iptables failed!"
+	RC=1
+}
+diff -u -Z <(echo -e "$EXPECT4") <($XT_MULTI iptables -S FORWARD) || {
+	echo "unexpected iptables ruleset"
+	RC=1
+}
+diff -u -Z <(echo -e "$EXPECT_EMPTY") <($XT_MULTI ip6tables -S FORWARD) || {
+	echo "unexpected non-empty ip6tables ruleset"
+	RC=1
+}
+
+$XT_MULTI iptables -F FORWARD
+
+$XT_MULTI ip6tables -6 -A FORWARD -d fec0:10::1 -j ACCEPT || {
+	echo "ip6tables failed!"
+	RC=1
+}
+diff -u -Z <(echo -e "$EXPECT6") <($XT_MULTI ip6tables -S FORWARD) || {
+	echo "unexpected ip6tables ruleset"
+	RC=1
+}
+diff -u -Z <(echo -e "$EXPECT_EMPTY") <($XT_MULTI iptables -S FORWARD) || {
+	echo "unexpected non-empty iptables ruleset"
+	RC=1
+}
+
+exit $RC
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 8f9dc628d0029..3d75a1ddacae2 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -917,27 +917,22 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case '4':
+			if (args->family == AF_INET)
+				break;
+
 			if (p->restore && args->family == AF_INET6)
 				return;
 
-			if (args->family != AF_INET)
-				exit_tryhelp(2);
-
-			h->ops = nft_family_ops_lookup(args->family);
-			break;
+			exit_tryhelp(2);
 
 		case '6':
+			if (args->family == AF_INET6)
+				break;
+
 			if (p->restore && args->family == AF_INET)
 				return;
 
-			args->family = AF_INET6;
-			xtables_set_nfproto(AF_INET6);
-
-			h->ops = nft_family_ops_lookup(args->family);
-			if (h->ops == NULL)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Unknown family");
-			break;
+			exit_tryhelp(2);
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
-- 
2.25.1

