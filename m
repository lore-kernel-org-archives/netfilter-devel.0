Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17250C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA847208E4
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgEFRe4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgEFRe4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:34:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8F2C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:34:56 -0700 (PDT)
Received: from localhost ([::1]:58774 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNwd-0002nz-91; Wed, 06 May 2020 19:34:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/15] tests: shell: Implement --valgrind mode
Date:   Wed,  6 May 2020 19:33:21 +0200
Message-Id: <20200506173331.9347-6-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wrap every call to $XT_MULTI with valgrind, or actually a wrapper script
which does the valgrind wrap and stores the log if it contains something
relevant.

Carefully name the wrapper script(s) so that test cases' checks on
$XT_MULTI name stay intact.

This mode slows down testsuite execution horribly. Luckily, it's not
meant for constant use, though.

For now, ignore commands with non-zero exit status - error paths
typically hit direct exit() calls and therefore leave reachable memory
in place.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/tests/shell/run-tests.sh | 47 +++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/iptables/tests/shell/run-tests.sh b/iptables/tests/shell/run-tests.sh
index d71c13729b3ee..2125e2cb119bb 100755
--- a/iptables/tests/shell/run-tests.sh
+++ b/iptables/tests/shell/run-tests.sh
@@ -46,6 +46,10 @@ while [ -n "$1" ]; do
 		NFT_ONLY=y
 		shift
 		;;
+	-V|--valgrind)
+		VALGRIND=y
+		shift
+		;;
 	*${RETURNCODE_SEPARATOR}+([0-9]))
 		SINGLE+=" $1"
 		VERBOSE=y
@@ -67,6 +71,49 @@ else
 	XTABLES_LEGACY_MULTI="xtables-legacy-multi"
 fi
 
+printscript() { # (cmd, tmpd)
+	cat <<EOF
+#!/bin/bash
+
+CMD="$1"
+
+# note: valgrind man page warns about --log-file with --trace-children, the
+# last child executed overwrites previous reports unless %p or %q is used.
+# Since libtool wrapper calls exec but none of the iptables tools do, this is
+# perfect for us as it effectively hides bash-related errors
+
+valgrind --log-file=$2/valgrind.log --trace-children=yes \
+	 --leak-check=full --show-leak-kinds=all \$CMD "\$@"
+RC=\$?
+
+# don't keep uninteresting logs
+if grep -q 'no leaks are possible' $2/valgrind.log; then
+	rm $2/valgrind.log
+else
+	mv $2/valgrind.log $2/valgrind_\$\$.log
+fi
+
+# drop logs for failing commands for now
+[ \$RC -eq 0 ] || rm $2/valgrind_\$\$.log
+
+exit \$RC
+EOF
+}
+
+if [ "$VALGRIND" == "y" ]; then
+	tmpd=$(mktemp -d)
+	msg_info "writing valgrind logs to $tmpd"
+	chmod a+rx $tmpd
+	printscript "$XTABLES_NFT_MULTI" "$tmpd" >${tmpd}/xtables-nft-multi
+	printscript "$XTABLES_LEGACY_MULTI" "$tmpd" >${tmpd}/xtables-legacy-multi
+	trap "rm ${tmpd}/xtables-*-multi" EXIT
+	chmod a+x ${tmpd}/xtables-nft-multi ${tmpd}/xtables-legacy-multi
+
+	XTABLES_NFT_MULTI="${tmpd}/xtables-nft-multi"
+	XTABLES_LEGACY_MULTI="${tmpd}/xtables-legacy-multi"
+
+fi
+
 find_tests() {
         if [ ! -z "$SINGLE" ] ; then
                 echo $SINGLE
-- 
2.25.1

