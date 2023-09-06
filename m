Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F14EB8FB8
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbjIFMCx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237482AbjIFMCw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F60A171C
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PGB/K+C2d64egT6NuCepohOwy8me2B5hLXUQZTGGOiQ=;
        b=Vg359wxJ/Vy3jsYwe7Af8yWnBPSh+0Mvqe0NslPrU6rpdU/y9+BOsKA/sf0kf0eYiyAiuT
        zhkk9KoSzn7VNr9plBE0UKDAXSuJEb12JsyM6/qhXHqMqEmp1R439TLOuus/J8N4Ij23EL
        1IEHbQoH8qn/kVIuX/uZp7MzvkTcqKk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-ogbjb16zMHGVV042RAfwSA-1; Wed, 06 Sep 2023 08:01:30 -0400
X-MC-Unique: ogbjb16zMHGVV042RAfwSA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35D48800969
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9F89C15BB8;
        Wed,  6 Sep 2023 12:01:29 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 13/19] tests/shell: move valgrind wrapper script to separate script
Date:   Wed,  6 Sep 2023 13:52:16 +0200
Message-ID: <20230906120109.1773860-14-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previously, in valgrind mode we would generate one script, which had
"$NFT" variable and the temp directory hard coded.

Soon, we will run jobs in parallel, so they would need at least
different temp directories. Also, we want to put the valgrind results
are inside "$NFT_TEST_TESTTMPDIR", along the test data.

Extract the wrapper script to a separate script. It does not need to be
generated ad-hoc, instead it uses the environment variables "$NFT_REAL" and
"$NFT_TEST_TESTTMPDIR", as "run-tests.sh" prepares them.

Also, add a "$NFT_REAL" variable for the actual NFT binary. We wrap the
"$NFT" variable with VALGRIND=y or the user may pass "NFT='valgrind
nft'". We should have access to the real binary. That might be useful
for example to call `ldd "$NFT_REAL" | grep libjansson` to check for
JSON support.

Also, we use libtool. So quite possible the nft binary is actually a
shell script. Calling valgrind on that script results in a lot of leak
reports from shell (and slows down the command). Instead, use `libtool
--mode=execute`.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/nft-valgrind-wrapper.sh | 17 +++++++++
 tests/shell/run-tests.sh                    | 41 ++++-----------------
 2 files changed, 24 insertions(+), 34 deletions(-)
 create mode 100755 tests/shell/helpers/nft-valgrind-wrapper.sh

diff --git a/tests/shell/helpers/nft-valgrind-wrapper.sh b/tests/shell/helpers/nft-valgrind-wrapper.sh
new file mode 100755
index 000000000000..9da50d4d9d1d
--- /dev/null
+++ b/tests/shell/helpers/nft-valgrind-wrapper.sh
@@ -0,0 +1,17 @@
+#!/bin/bash -e
+
+SUFFIX="$(date '+%Y%m%d-%H%M%S.%6N')"
+
+rc=0
+libtool \
+	--mode=execute \
+	valgrind \
+		--log-file="$NFT_TEST_TESTTMPDIR/valgrind.$SUFFIX.%p.log" \
+		--trace-children=yes \
+		--leak-check=full \
+		--show-leak-kinds=all \
+		"$NFT_REAL" \
+		"$@" \
+	|| rc=$?
+
+exit $rc
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 92c63e354b96..b49877fe473e 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -61,6 +61,8 @@ usage() {
 	echo "                 it can be a command with parameters. Note that in this mode quoting"
 	echo "                 does not work, so the usage is limited and the command cannot contain"
 	echo "                 spaces."
+	echo " NFT_REAL=<CMD> : Real nft comand. Usually this is just the same as \$NFT,"
+	echo "                 however, you may set NFT='valgrind nft' and NFT_REAL to the real command."
 	echo " VERBOSE=*|y   : Enable verbose output."
 	echo " DUMPGEN=*|y   : Regenerate dump files. Dump files are only recreated if the"
 	echo "                 test completes successfully and the \"dumps\" directory for the"
@@ -262,7 +264,10 @@ NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$(date '+%Y%m%d-%H%M%
 	msg_error "Failure to create temp directory in \"$_TMPDIR\""
 chmod 755 "$NFT_TEST_TMPDIR"
 
+NFT_REAL="${NFT_REAL-$NFT}"
+
 msg_info "conf: NFT=$(printf '%q' "$NFT")"
+msg_info "conf: NFT_REAL=$(printf '%q' "$NFT_REAL")"
 msg_info "conf: VERBOSE=$(printf '%q' "$VERBOSE")"
 msg_info "conf: DUMPGEN=$(printf '%q' "$DUMPGEN")"
 msg_info "conf: VALGRIND=$(printf '%q' "$VALGRIND")"
@@ -311,40 +316,8 @@ kernel_cleanup() {
 	nft_xfrm
 }
 
-printscript() { # (cmd, tmpd)
-	cat <<EOF
-#!/bin/bash
-
-CMD="$1"
-
-# note: valgrind man page warns about --log-file with --trace-children, the
-# last child executed overwrites previous reports unless %p or %q is used.
-# Since libtool wrapper calls exec but none of the iptables tools do, this is
-# perfect for us as it effectively hides bash-related errors
-
-valgrind --log-file=$2/valgrind.log --trace-children=yes \
-	 --leak-check=full --show-leak-kinds=all \$CMD "\$@"
-RC=\$?
-
-# don't keep uninteresting logs
-if grep -q 'no leaks are possible' $2/valgrind.log; then
-	rm $2/valgrind.log
-else
-	mv $2/valgrind.log $2/valgrind_\$\$.log
-fi
-
-# drop logs for failing commands for now
-[ \$RC -eq 0 ] || rm $2/valgrind_\$\$.log
-
-exit \$RC
-EOF
-}
-
 if [ "$VALGRIND" == "y" ]; then
-	msg_info "writing valgrind logs to $NFT_TEST_TMPDIR"
-	printscript "$NFT" "$NFT_TEST_TMPDIR" > "$NFT_TEST_TMPDIR/nft"
-	chmod a+x "$NFT_TEST_TMPDIR/nft"
-	NFT="$NFT_TEST_TMPDIR/nft"
+	NFT="$NFT_TEST_BASEDIR/helpers/nft-valgrind-wrapper.sh"
 fi
 
 echo ""
@@ -468,7 +441,7 @@ for testfile in "${TESTS[@]}" ; do
 	export NFT_TEST_TESTTMPDIR
 
 	print_test_header I "$testfile" "EXECUTING" ""
-	NFT="$NFT" DIFF="$DIFF" DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
+	NFT="$NFT" NFT_REAL="$NFT_REAL" DIFF="$DIFF" DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
 	rc_got=$?
 	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 
-- 
2.41.0

