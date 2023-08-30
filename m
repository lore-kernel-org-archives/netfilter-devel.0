Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D13C83F1E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238777AbjH3SjK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243704AbjH3Lc5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 07:32:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4065E132
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 04:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693395127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rvu27TlrAc1rcNAwhQbfj9o/8n+6467T3Dg8V7XpsZ0=;
        b=JoHDDBKTAsPgxhXMaZfoy/JHaQoCwhwc3biW2qUVI++ujSbHLgLU1sPlEqBeZhHG6tqRQP
        MPsCQoCKn9aVQwhW2xXvcYsoMk9aQDu8F1JLF/YSRw3S8hB5/KIhwerrKk+rIOuS1l6taX
        FLC8UQGk/kLep7pCANkneANNEy/TEBw=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-FXmzS_71MA6giDEjE0mDjA-1; Wed, 30 Aug 2023 07:32:05 -0400
X-MC-Unique: FXmzS_71MA6giDEjE0mDjA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 657383C0FC95
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 11:32:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D41DD6466B;
        Wed, 30 Aug 2023 11:32:04 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft] tests/shell: allow running tests as non-root users
Date:   Wed, 30 Aug 2023 13:31:48 +0200
Message-ID: <20230830113153.877968-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow to opt-out from the have-real-root check via

  NFT_TEST_ROOTLESS=1 ./run-tests.sh

For that to be useful, we must also unshare the PID and user namespace
and map the root user inside that namespace.

With that, inside the namespace we look like root. Including having
CAP_NET_ADMIN for the new net namespace. This allows to run the tests as
rootless and most tests will pass.

Note that some tests will fail as rootless. For example, the socket
buffers are limited by /proc/sys/net/core/{wmem_max,rmem_max}, which is
not namespaced. When running as real-root, nftables can raise them
beyond those limits and the tests will pass. Rootless cannot do that and
the test may fail.

Test that don't work without real root should check for
[ "$NFT_TEST_HAVE_REALROOT" != 1 ] and skip gracefully.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 57 +++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 12 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index b66ef4fa4d1f..96dd0b0c2fd6 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -1,9 +1,18 @@
 #!/bin/bash
 
-# Configuration
-TESTDIR="./$(dirname $0)/testcases"
-SRC_NFT="$(dirname $0)/../../src/nft"
-DIFF=$(which diff)
+# Environment variables for the user:
+# NFT=<path>                   Path to the nft executable.
+# NFT_TEST_ROOTLESS=0|1:       Whether the test allows to run as rootless. Usually the test
+#                              will require real root permissions. You can set NFT_TEST_ROOTLESS=1
+#                              to run rootless in a separate namespace.
+# NFT_TEST_HAVE_REALROOT=0|1:  To indicate whether the test has real root permissions.
+#                              Usually, you don't need this and it gets autodetected.
+#                              Note that without real root, certain tests may not work.
+#                              For example, due to limited /proc/sys/net/core/{wmem_max,rmem_max}.
+#                              Such test should check for [ "$NFT_TEST_HAVE_REALROOT" != 1 ] and
+#                              skip (not fail) in such an environment.
+# NFT_TEST_NO_UNSHARE=0|1:     Usually, the test will run in a separate namespace.
+#                              You can opt-out from that by setting NFT_TEST_NO_UNSHARE=1.
 
 msg_error() {
 	echo "E: $1 ..." >&2
@@ -18,18 +27,42 @@ msg_info() {
 	echo "I: $1"
 }
 
-if [ "$(id -u)" != "0" ] ; then
+if [ "$NFT_TEST_HAVE_REALROOT" = "" ] ; then
+	# The caller can set NFT_TEST_HAVE_REALROOT to indicate us whether we
+	# have real root. They usually don't need, and we detect it now based
+	# on `id -u`. Note that we may unshare below, so the check inside the
+	# new namespace won't be conclusive. We thus only detect once and export
+	# the result.
+	export NFT_TEST_HAVE_REALROOT="$(test "$(id -u)" = "0" && echo 1 || echo 0)"
+fi
+
+if [ "$NFT_TEST_HAVE_REALROOT" != 1 -a "$NFT_TEST_ROOTLESS" != 1 ] ; then
+	# By default, we require real-root, unless the user explicitly opts-in
+	# to proceed via NFT_TEST_ROOTLESS=1.
 	msg_error "this requires root!"
 fi
 
-if [ "${1}" != "run" ]; then
-	if unshare -f -n true; then
-		unshare -n "${0}" run $@
-		exit $?
-	fi
-	msg_warn "cannot run in own namespace, connectivity might break"
+if [ "$NFT_TEST_NO_UNSHARE" = 1 ]; then
+	# The user opts-out from unshare. Proceed without.
+	:
+elif [ "$_NFT_TEST_IS_UNSHARED" = 1 ]; then
+	# We are inside the unshared environment. Don't unshare again.
+	# Continue.
+	:
+else
+	# Unshare. This works both as rootless and with real root. Inside
+	# the user namespace we will map the root user, so we appear to have
+	# root. Check for [ "$NFT_TEST_HAVE_REALROOT" != 1 ] to know when
+	# not having real root.
+	export _NFT_TEST_IS_UNSHARED=1
+	unshare -f --map-root-user -U -p -n "$0" "$@"
+	exit $?
 fi
-shift
+
+# Configuration
+TESTDIR="./$(dirname $0)/testcases"
+SRC_NFT="$(dirname $0)/../../src/nft"
+DIFF=$(which diff)
 
 [ -z "$NFT" ] && NFT=$SRC_NFT
 ${NFT} > /dev/null 2>&1
-- 
2.41.0

