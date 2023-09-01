Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3445BCA0FE5
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 15:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240715AbjIAPKR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbjIAPKR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 11:10:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E66510CF
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693580970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t6hbqSZnGNl4qzYYKq8nZ+4WRXmAfCj9DrY5N+aBvjE=;
        b=O1GUpksoRUmuYP+R/zENYg1cOIPn4gPhjVBE/veLp5J9yV+e2xoKgihoU9HKqYzz9ayCot
        n6uIv1hPvxpM6USXpeqmka+++ICjTR6qmQaNuNpyN0ACGy6MFybPM0LYbyypiBFIDOmwU+
        LsBMi9Y3pqXq3Dw3lk7OZIC52tEoDs4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-DPF3Rd-XMFOArPT2Ip_9Yg-1; Fri, 01 Sep 2023 11:09:29 -0400
X-MC-Unique: DPF3Rd-XMFOArPT2Ip_9Yg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86F67381DC82
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 15:09:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0743B40C84A5;
        Fri,  1 Sep 2023 15:09:27 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 1/3] tests/shell: rework command line parsing in "run-tests.sh"
Date:   Fri,  1 Sep 2023 17:05:57 +0200
Message-ID: <20230901150916.183949-2-thaller@redhat.com>
In-Reply-To: <20230901150916.183949-1-thaller@redhat.com>
References: <20230901150916.183949-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Parse the arguments in a loop, so that their order does not matter.
Also, it would be easier to parse flags with parameters.

Currently this is after the is-root check and after unshare. That makes
no sense with the "--help" option. That will be addressed next.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 94 +++++++++++++++++++++++++++-------------
 1 file changed, 64 insertions(+), 30 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index b66ef4fa4d1f..2ece280a2408 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -1,10 +1,5 @@
 #!/bin/bash
 
-# Configuration
-TESTDIR="./$(dirname $0)/testcases"
-SRC_NFT="$(dirname $0)/../../src/nft"
-DIFF=$(which diff)
-
 msg_error() {
 	echo "E: $1 ..." >&2
 	exit 1
@@ -18,6 +13,28 @@ msg_info() {
 	echo "I: $1"
 }
 
+usage() {
+	echo " $0 [OPTIONS]"
+	echo
+	echo "OPTIONS:"
+	echo " \"-v\" : also VERBOSE=y"
+	echo " \"-g\" : also DUMPGEN=y"
+	echo " \"-V\" : also VALGRIND=y"
+	echo " \"-K\" : also KMEMLEAK=y"
+	echo
+	echo "VARIABLES:"
+	echo "  NFT=<PATH>   : Path to nft executable"
+	echo "  VERBOSE=*|y  : See also \"-v\" option"
+	echo "  DUMPGEN=*|y  : See also \"-g\" option"
+	echo "  VALGRIND=*|y : See also \"-V\" option"
+	echo "  KMEMLEAK=*|y : See also \"-y\" option"
+}
+
+# Configuration
+TESTDIR="./$(dirname $0)/testcases"
+SRC_NFT="$(dirname $0)/../../src/nft"
+DIFF=$(which diff)
+
 if [ "$(id -u)" != "0" ] ; then
 	msg_error "this requires root!"
 fi
@@ -31,6 +48,48 @@ if [ "${1}" != "run" ]; then
 fi
 shift
 
+VERBOSE="$VERBOSE"
+DUMPGEN="$DUMPGEN"
+VALGRIND="$VALGRIND"
+KMEMLEAK="$KMEMLEAK"
+
+TESTS=()
+
+while [ $# -gt 0 ] ; do
+	A="$1"
+	shift
+	case "$A" in
+		-v)
+			VERBOSE=y
+			;;
+		-g)
+			DUMPGEN=y
+			;;
+		-V)
+			VALGRIND=y
+			;;
+		-K)
+			KMEMLEAK=y
+			;;
+		-h|--help)
+			usage
+			exit 0
+			;;
+		--)
+			TESTS=("$@")
+			VERBOSE=y
+			shift $#
+			;;
+		*)
+			TESTS=("$A" "$@")
+			VERBOSE=y
+			shift $#
+			;;
+	esac
+done
+
+SINGLE="${TESTS[*]}"
+
 [ -z "$NFT" ] && NFT=$SRC_NFT
 ${NFT} > /dev/null 2>&1
 ret=$?
@@ -59,31 +118,6 @@ if [ ! -x "$DIFF" ] ; then
 	DIFF=true
 fi
 
-if [ "$1" == "-v" ] ; then
-	VERBOSE=y
-	shift
-fi
-
-if [ "$1" == "-g" ] ; then
-	DUMPGEN=y
-	shift
-fi
-
-if [ "$1" == "-V" ] ; then
-	VALGRIND=y
-	shift
-fi
-
-if [ "$1" == "-K" ]; then
-	KMEMLEAK=y
-	shift
-fi
-
-for arg in "$@"; do
-	SINGLE+=" $arg"
-	VERBOSE=y
-done
-
 kernel_cleanup() {
 	$NFT flush ruleset
 	$MODPROBE -raq \
-- 
2.41.0

