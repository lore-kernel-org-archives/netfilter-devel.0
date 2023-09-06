Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02ED6EB8FB6
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbjIFMDC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237430AbjIFMDB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:03:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39125172E
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+KWIPVdPHD2QYw54cTg1x/fOmBDC7dzHQiqMdUAfhWo=;
        b=bNa6mJ56JnCfJuDCWM0Y+ty1FFapbJPklpS3q1WKbRUUPzd0C32K0EYcGW3fOmjc/P2h/D
        AkYVxgCOwvLSa/WYjwI3IrPL/Un4Zni175ZvzAJUcq/8+YMmdgavkBUFEHl5Ut5nBnXNMv
        T4DUXp22tF90X56ux+WSi6KwX/sMAjs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-696-fDbAjB-nOTO9O-8TcCVU1w-1; Wed, 06 Sep 2023 08:01:32 -0400
X-MC-Unique: fDbAjB-nOTO9O-8TcCVU1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB311803470
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B2B5C03292;
        Wed,  6 Sep 2023 12:01:31 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 15/19] tests/shell: bind mount private /var/run/netns in test container
Date:   Wed,  6 Sep 2023 13:52:18 +0200
Message-ID: <20230906120109.1773860-16-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some tests want to run `ip netns add`, which requires write permissions
to /var/run/netns. Also, /var/run/netns would be a systemwide mount
path, and shared between the tests. We would want to isolate that.

Fix that by bind mount a tmpfs inside the test wrapper, if we appear to
have a private mount namespace.

Fixes

  $ ./tests/shell/run-tests.sh -- tests/shell/testcases/netns/0001nft-f_0

Optimally, `ip netns add` would allow to specify a private
location for those bind mounts.

It seems that iproute2 is build with /var/run/netns, instead the more
common /run/netns. Hence, handle /var/run instead of /run.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 23 +++++++++++++++++++++
 tests/shell/run-tests.sh            | 32 +++++++++++++++++++++++++----
 2 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index fee55e5f9df5..b8a54ed7444d 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -9,10 +9,33 @@ TEST="$1"
 TESTBASE="$(basename "$TEST")"
 TESTDIR="$(dirname "$TEST")"
 
+CLEANUP_UMOUNT_RUN_NETNS=n
+
+cleanup() {
+	if [ "$CLEANUP_UMOUNT_RUN_NETNS" = y ] ; then
+		umount "/var/run/netns" || :
+	fi
+}
+
+trap cleanup EXIT
+
 printf '%s\n' "$TEST" > "$NFT_TEST_TESTTMPDIR/name"
 
 read tainted_before < /proc/sys/kernel/tainted
 
+if [ "$NFT_TEST_HAS_UNSHARED_MOUNT" = y ] ; then
+	# We have a private mount namespace. We will mount /run/netns as a tmpfs,
+	# this is useful because `ip netns add` wants to add files there.
+	#
+	# When running as rootless, this is necessary to get such tests to
+	# pass.  When running rootful, it's still useful to not touch the
+	# "real" /var/run/netns of the system.
+	mkdir -p /var/run/netns
+	if mount -t tmpfs --make-private "/var/run/netns" ; then
+		CLEANUP_UMOUNT_RUN_NETNS=y
+	fi
+fi
+
 rc_test=0
 "$TEST" &> "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=$?
 
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 1af1c0f3013f..97c82991befd 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -84,11 +84,14 @@ usage() {
 	echo "                 By default it is unset, in which case it's autodetected as"
 	echo "                 \`unshare -f -p\` (for root) or as \`unshare -f -p --mount-proc -U --map-root-user -n\`"
 	echo "                 for non-root."
-	echo "                 When setting this, you may also want to set NFT_TEST_HAS_UNSHARED="
-	echo "                 and NFT_TEST_HAS_REALROOT= accordingly."
+	echo "                 When setting this, you may also want to set NFT_TEST_HAS_UNSHARED=,"
+	echo "                 NFT_TEST_HAS_REALROOT= and NFT_TEST_HAS_UNSHARED_MOUNT= accordingly."
 	echo " NFT_TEST_HAS_UNSHARED=*|y : To indicate to the test whether the test run will be unshared."
 	echo "                 Test may consider this."
 	echo "                 This is only honored when \$NFT_TEST_UNSHARE_CMD= is set. Otherwise it's detected."
+	echo " NFT_TEST_HAS_UNSHARED_MOUNT=*|y : To indicate to the test whether the test run will have a private"
+	echo "                 mount namespace."
+	echo "                 This is only honored when \$NFT_TEST_UNSHARE_CMD= is set. Otherwise it's detected."
 	echo " NFT_TEST_KEEP_LOGS=*|y: Keep the temp directory. On success, it will be deleted by default."
 	echo " NFT_TEST_JOBS=<NUM}>: number of jobs for parallel execution. Defaults to \"12\" for parallel run."
 	echo "                 Setting this to \"0\" or \"1\", means to run jobs sequentially."
@@ -223,20 +226,39 @@ if [ -n "${NFT_TEST_UNSHARE_CMD+x}" ] ; then
 	else
 		NFT_TEST_HAS_UNSHARED="$(bool_y "$NFT_TEST_HAS_UNSHARED")"
 	fi
+	if [ -z "${NFT_TEST_HAS_UNSHARED_MOUNT+x}" ] ; then
+		NFT_TEST_HAS_UNSHARED_MOUNT=n
+		if [ "$NFT_TEST_HAS_UNSHARED" == y ] ; then
+			case "$NFT_TEST_UNSHARE_CMD" in
+				unshare*-m*|unshare*--mount-proc*)
+					NFT_TEST_HAS_UNSHARED_MOUNT=y
+					;;
+			esac
+		fi
+	else
+		NFT_TEST_HAS_UNSHARED_MOUNT="$(bool_y "$NFT_TEST_HAS_UNSHARED_MOUNT")"
+	fi
 else
+	NFT_TEST_HAS_UNSHARED_MOUNT=n
 	if [ "$NFT_TEST_HAS_REALROOT" = y ] ; then
 		# We appear to have real root. So try to unshare
 		# without a separate USERNS. CLONE_NEWUSER will break
 		# tests that are limited by
 		# /proc/sys/net/core/{wmem_max,rmem_max}. With real
 		# root, we want to test that.
-		detect_unshare "unshare -f -n -m" ||
+		if detect_unshare "unshare -f -n -m" ; then
+			NFT_TEST_HAS_UNSHARED_MOUNT=y
+		else
 			detect_unshare "unshare -f -n" ||
 			detect_unshare "unshare -f -p -m --mount-proc -U --map-root-user -n" ||
 			detect_unshare "unshare -f -U --map-root-user -n"
+		fi
 	else
-		detect_unshare "unshare -f -p -m --mount-proc -U --map-root-user -n" ||
+		if detect_unshare "unshare -f -p -m --mount-proc -U --map-root-user -n" ; then
+			NFT_TEST_HAS_UNSHARED_MOUNT=y
+		else
 			detect_unshare "unshare -f -U --map-root-user -n"
+		fi
 	fi
 	if [ -z "$NFT_TEST_UNSHARE_CMD" ] ; then
 		msg_error "Unshare does not work. Run as root with -U/--no-unshare or set NFT_TEST_UNSHARE_CMD"
@@ -245,6 +267,7 @@ else
 fi
 # If tests wish, they can know whether they are unshared via this variable.
 export NFT_TEST_HAS_UNSHARED
+export NFT_TEST_HAS_UNSHARED_MOUNT
 
 # normalize the jobs number to be an integer.
 case "$NFT_TEST_JOBS" in
@@ -295,6 +318,7 @@ msg_info "conf: KMEMLEAK=$(printf '%q' "$KMEMLEAK")"
 msg_info "conf: NFT_TEST_HAS_REALROOT=$(printf '%q' "$NFT_TEST_HAS_REALROOT")"
 msg_info "conf: NFT_TEST_UNSHARE_CMD=$(printf '%q' "$NFT_TEST_UNSHARE_CMD")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
+msg_info "conf: NFT_TEST_HAS_UNSHARED_MOUNT=$(printf '%q' "$NFT_TEST_HAS_UNSHARED_MOUNT")"
 msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
 msg_info "conf: NFT_TEST_JOBS=$NFT_TEST_JOBS"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
-- 
2.41.0

