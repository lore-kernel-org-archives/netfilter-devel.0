Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E35C83F3E
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352402AbjIEQ1V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354497AbjIEMB0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:01:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8AFCDC
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 05:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PslTnT6JBxjSznUJeHUO8C/SSpw43jbULYlHMYdW50U=;
        b=BnbgPX3tfA0LSp5Ip+UONi6EINJmkA3E+cOMiWmWfOKlzN675uyna3MrAhub4DYPNQNwJa
        bcu0l8wjYm/k84FnHvGvO95IZP+8wW1puhlvyN5nHapiDjtlZNUdX7lS/SM7mgW4RMmWQU
        +zzf/Rm77WIldeKEvY6LMz1QkO/LyQ8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-oAeSKwYnNl2z_udnyVl8LQ-1; Tue, 05 Sep 2023 07:59:58 -0400
X-MC-Unique: oAeSKwYnNl2z_udnyVl8LQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D001328EA6F7
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50E041121314;
        Tue,  5 Sep 2023 11:59:57 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 14/17] tests/shell: bind mount private /var/run/netns in test container
Date:   Tue,  5 Sep 2023 13:58:43 +0200
Message-ID: <20230905115936.607599-15-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
index 1390985c7f32..58cf48172fc0 100755
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
index d157f14eb9a5..8564d9a08bcb 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -83,11 +83,14 @@ usage() {
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
 	echo " NFT_TEST_JOBS=<NUM}>: by default, run test sequentially. Set to an integer > 1 to"
 	echo "                 run jobs in parallel. Leaving this unset or at zero means to run jobs sequentially"
@@ -225,9 +228,22 @@ if [ -n "${NFT_TEST_UNSHARE_CMD+x}" ] ; then
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
 	NFT_TEST_UNSHARE_CMD=""
 	NFT_TEST_HAS_UNSHARED="n"
+	NFT_TEST_HAS_UNSHARED_MOUNT=n
 	if [ "$NFT_TEST_NO_UNSHARE" != y ] ; then
 		if [ "$NFT_TEST_HAS_REALROOT" = y ] ; then
 			# We appear to have real root. So try to unshare
@@ -235,13 +251,19 @@ else
 			# tests that are limited by
 			# /proc/sys/net/core/{wmem_max,rmem_max}. With real
 			# root, we want to test that.
-			detect_unshare "unshare -f -n -m" ||
+			if detect_unshare "unshare -f -n -m" ; then
+				NFT_TEST_HAS_UNSHARED_MOUNT=y
+			else
 				detect_unshare "unshare -f -n" ||
 				detect_unshare "unshare -f -p -m --mount-proc -U --map-root-user -n" ||
 				detect_unshare "unshare -f -U --map-root-user -n"
+			fi
 		else
-			detect_unshare "unshare -f -p -m --mount-proc -U --map-root-user -n" ||
+			if detect_unshare "unshare -f -p -m --mount-proc -U --map-root-user -n" ; then
+				NFT_TEST_HAS_UNSHARED_MOUNT=y
+			else
 				detect_unshare "unshare -f -U --map-root-user -n"
+			fi
 		fi
 		if [ -z "$NFT_TEST_UNSHARE_CMD" ] ; then
 			msg_error "Unshare does not work. Run as root with -U/--no-unshare/NFT_TEST_NO_UNSHARE=y or set NFT_TEST_UNSHARE_CMD"
@@ -251,6 +273,7 @@ else
 fi
 # If tests wish, they can know whether they are unshared via this variable.
 export NFT_TEST_HAS_UNSHARED
+export NFT_TEST_HAS_UNSHARED_MOUNT
 
 # normalize the jobs number to be an integer.
 case "$NFT_TEST_JOBS" in
@@ -274,6 +297,7 @@ msg_info "conf: KMEMLEAK=$(printf '%q' "$KMEMLEAK")"
 msg_info "conf: NFT_TEST_HAS_REALROOT=$(printf '%q' "$NFT_TEST_HAS_REALROOT")"
 msg_info "conf: NFT_TEST_UNSHARE_CMD=$(printf '%q' "$NFT_TEST_UNSHARE_CMD")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
+msg_info "conf: NFT_TEST_HAS_UNSHARED_MOUNT=$(printf '%q' "$NFT_TEST_HAS_UNSHARED_MOUNT")"
 msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
 msg_info "conf: NFT_TEST_JOBS=$NFT_TEST_JOBS"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
-- 
2.41.0

