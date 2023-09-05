Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115CBCA0FFA
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351896AbjIEQ0Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354484AbjIEMAk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:00:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8451AE
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 04:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dyJyzrJXTP//klorTIxVGxp4e2fPM814O5Kd1nVIANk=;
        b=ey/wTuluXdzdix2bdKmaHw+MR4GUxgMY4PIhcUDFUt/maabxBhCRKeae92akJTPPwRfQes
        O4+q4C8nDf8tNyokumBfCpdIRAF07NU8y3vl9cPILPKroHbppSJR1DEpGumJAszEx0v9OL
        s+oZ6w2quI9kOuYninhEUOkKM5/RVBg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-zbaHd-cnPFeMR_SQNtar_g-1; Tue, 05 Sep 2023 07:59:48 -0400
X-MC-Unique: zbaHd-cnPFeMR_SQNtar_g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B29AC928A42
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3348A1121314;
        Tue,  5 Sep 2023 11:59:47 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 01/17] tests/shell: rework command line parsing in "run-tests.sh"
Date:   Tue,  5 Sep 2023 13:58:30 +0200
Message-ID: <20230905115936.607599-2-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Parse the arguments in a loop, so that their order does not matter.
Also, soon more command line arguments will be added, and this way of
parsing seems more maintainable and flexible.

Currently this is still after the is-root check and after unshare. That
will be addressed later.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 95 +++++++++++++++++++++++++++-------------
 1 file changed, 65 insertions(+), 30 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index b66ef4fa4d1f..ae8c6d934dcf 100755
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
@@ -18,6 +13,29 @@ msg_info() {
 	echo "I: $1"
 }
 
+usage() {
+	echo " $0 [OPTIONS]"
+	echo
+	echo "OPTIONS:"
+	echo " -h|--help : print usage"
+	echo " -v        : sets VERBOSE=y"
+	echo " -g        : sets DUMPGEN=y"
+	echo " -V        : sets VALGRIND=y"
+	echo " -K        : sets KMEMLEAK=y"
+	echo
+	echo "ENVIRONMENT VARIABLES:"
+	echo " NFT=<PATH>   : Path to nft executable"
+	echo " VERBOSE=*|y  : Enable verbose output"
+	echo " DUMPGEN=*|y  : Regenerate dump files"
+	echo " VALGRIND=*|y : Run \$NFT in valgrind"
+	echo " KMEMLEAK=*|y : Check for kernel memleaks"
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
@@ -31,6 +49,48 @@ if [ "${1}" != "run" ]; then
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
+			TESTS+=( "$@" )
+			shift $#
+			;;
+		*)
+			# Any unrecognized option is treated as a test name, and also
+			# enable verbose tests.
+			TESTS+=( "$A" )
+			VERBOSE=y
+			;;
+	esac
+done
+
+SINGLE="${TESTS[*]}"
+
 [ -z "$NFT" ] && NFT=$SRC_NFT
 ${NFT} > /dev/null 2>&1
 ret=$?
@@ -59,31 +119,6 @@ if [ ! -x "$DIFF" ] ; then
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

