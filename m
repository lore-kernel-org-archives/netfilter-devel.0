Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04742C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 10:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241564AbiATKRC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 05:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbiATKRC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 05:17:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED30C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 02:17:02 -0800 (PST)
Received: from localhost ([::1]:59144 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nAUV1-0002P6-0x; Thu, 20 Jan 2022 11:16:59 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xshared: Fix response to unprivileged users
Date:   Thu, 20 Jan 2022 11:16:53 +0100
Message-Id: <20220120101653.28280-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Expected behaviour in both variants is:

* Print help without error, append extension help if -m and/or -j
  options are present
* Indicate lack of permissions in an error message for anything else

With iptables-nft, this was broken basically from day 1. Shared use of
do_parse() then somewhat broke legacy: it started complaining about
inability to create a lock file.

Fix this by making iptables-nft assume extension revision 0 is present
if permissions don't allow to verify. This is consistent with legacy.

Second part is to exit directly after printing help - this avoids having
to make the following code "nop-aware" to prevent privileged actions.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                                |  5 ++
 .../testcases/iptables/0008-unprivileged_0    | 60 +++++++++++++++++++
 iptables/xshared.c                            |  3 +-
 3 files changed, 66 insertions(+), 2 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/iptables/0008-unprivileged_0

diff --git a/iptables/nft.c b/iptables/nft.c
index 72f7cf1315661..b5de687c5c4cd 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3312,6 +3312,11 @@ int nft_compatible_revision(const char *name, uint8_t rev, int opt)
 err:
 	mnl_socket_close(nl);
 
+	/* pretend revision 0 is valid if not permitted to check -
+	 * this is required for printing extension help texts as user */
+	if (ret < 0 && errno == EPERM && rev == 0)
+		return 1;
+
 	return ret < 0 ? 0 : 1;
 }
 
diff --git a/iptables/tests/shell/testcases/iptables/0008-unprivileged_0 b/iptables/tests/shell/testcases/iptables/0008-unprivileged_0
new file mode 100755
index 0000000000000..43e3bc8721dbd
--- /dev/null
+++ b/iptables/tests/shell/testcases/iptables/0008-unprivileged_0
@@ -0,0 +1,60 @@
+#!/bin/bash
+
+# iptables may print match/target specific help texts
+# help output should work for unprivileged users
+
+run() {
+	echo "running: $*" >&2
+	runuser -u nobody -- "$@"
+}
+
+grep_or_rc() {
+	declare -g rc
+	grep -q "$*" && return 0
+	echo "missing in output: $*" >&2
+	return 1
+}
+
+out=$(run $XT_MULTI iptables --help)
+let "rc+=$?"
+grep_or_rc "iptables -h (print this help information)" <<< "$out"
+let "rc+=$?"
+
+out=$(run $XT_MULTI iptables -m limit --help)
+let "rc+=$?"
+grep_or_rc "limit match options:" <<< "$out"
+let "rc+=$?"
+
+out=$(run $XT_MULTI iptables -p tcp --help)
+let "rc+=$?"
+grep_or_rc "tcp match options:" <<< "$out"
+let "rc+=$?"
+
+out=$(run $XT_MULTI iptables -j DNAT --help)
+let "rc+=$?"
+grep_or_rc "DNAT target options:" <<< "$out"
+let "rc+=$?"
+
+out=$(run $XT_MULTI iptables -p tcp -j DNAT --help)
+let "rc+=$?"
+grep_or_rc "tcp match options:" <<< "$out"
+let "rc+=$?"
+out=$(run $XT_MULTI iptables -p tcp -j DNAT --help)
+let "rc+=$?"
+grep_or_rc "DNAT target options:" <<< "$out"
+let "rc+=$?"
+
+
+run $XT_MULTI iptables -L 2>&1 | \
+	grep_or_rc "Permission denied"
+let "rc+=$?"
+
+run $XT_MULTI iptables -A FORWARD -p tcp --dport 123 2>&1 | \
+	grep_or_rc "Permission denied"
+let "rc+=$?"
+
+run $XT_MULTI iptables -A FORWARD -j DNAT --to-destination 1.2.3.4 2>&1 | \
+	grep_or_rc "Permission denied"
+let "rc+=$?"
+
+exit $rc
diff --git a/iptables/xshared.c b/iptables/xshared.c
index c5a93290be427..1fd7acc953ed7 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1473,8 +1473,7 @@ void do_parse(int argc, char *argv[],
 					XTF_TRY_LOAD, &cs->matches);
 
 			xt_params->print_help(cs->matches);
-			p->command = CMD_NONE;
-			return;
+			exit(0);
 
 			/*
 			 * Option selection
-- 
2.34.1

