Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E005EC4167D
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Nov 2023 16:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbjKNQJY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Nov 2023 11:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbjKNQJX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Nov 2023 11:09:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E21ECA
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 08:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699978159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ae7jZslnIZWSMwz8fG8821b9hauoGOxH+m7tyDnTXIA=;
        b=cP/Yp0dBr7c1NSJlCMvLv4BLxuiXryti3k+AICVVqXeG8Uq6XbRHB1nEG8k6wFsujVoFEq
        6e65/Gn0z7aa3CHNmnT7AxRGWR6u92SL/ZH5nmXIsvDdmz26t304IFJ5LPizjJKAGbp8NY
        RnJNObCb9zIcyTsHmywd+S17y11ixms=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-1inRKT00NVmY-zAd3ZTaHw-1; Tue, 14 Nov 2023 11:09:18 -0500
X-MC-Unique: 1inRKT00NVmY-zAd3ZTaHw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C04E3811E7D
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 16:09:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 411A15028;
        Tue, 14 Nov 2023 16:09:17 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 4/6] tools: simplify error handling in "check-tree.sh" by adding msg_err()/msg_warn()
Date:   Tue, 14 Nov 2023 17:08:29 +0100
Message-ID: <20231114160903.409552-3-thaller@redhat.com>
In-Reply-To: <20231114160903.409552-1-thaller@redhat.com>
References: <20231114153150.406334-1-thaller@redhat.com>
 <20231114160903.409552-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

msg_err() also sets EXIT_CODE=, so we don't have to duplicate this.

Also add msg_warn() to print non-fatal warnings. Will be used in the
future. As "check-tree.sh" tests the consistency of the source tree, a
warning only makes sense to point something out that really should be
fixed, but is not yet.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tools/check-tree.sh | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/tools/check-tree.sh b/tools/check-tree.sh
index e3ddf8bdea58..b16d37c4651b 100755
--- a/tools/check-tree.sh
+++ b/tools/check-tree.sh
@@ -25,6 +25,15 @@ cd "$(dirname "$0")/.."
 
 EXIT_CODE=0
 
+msg_err() {
+	printf "ERR:  %s\n" "$*"
+	EXIT_CODE=1
+}
+
+msg_warn() {
+	printf "WARN: %s\n" "$*"
+}
+
 ##############################################################################
 
 check_shell_dumps() {
@@ -37,8 +46,7 @@ check_shell_dumps() {
 	local nodump_name
 
 	if [ ! -d "$dir/dumps/" ] ; then
-		echo "\"$TEST\" has no \"$dir/dumps/\" directory"
-		EXIT_CODE=1
+		msg_err "\"$TEST\" has no \"$dir/dumps/\" directory"
 		return 0
 	fi
 
@@ -49,34 +57,31 @@ check_shell_dumps() {
 	[ -f "$nodump_name" ] && has_nodump=1
 
 	if [ "$has_nft" != 1 -a "$has_nodump" != 1 ] ; then
-		echo "\"$TEST\" has no \"$dir/dumps/$base.{nft,nodump}\" file"
-		EXIT_CODE=1
+		msg_err "\"$TEST\" has no \"$dir/dumps/$base.{nft,nodump}\" file"
 	elif [ "$has_nft" == 1 -a "$has_nodump" == 1 ] ; then
-		echo "\"$TEST\" has both \"$dir/dumps/$base.{nft,nodump}\" files"
-		EXIT_CODE=1
+		msg_err "\"$TEST\" has both \"$dir/dumps/$base.{nft,nodump}\" files"
 	elif [ "$has_nodump" == 1 -a -s "$nodump_name" ] ; then
-		echo "\"$TEST\" has a non-empty \"$dir/dumps/$base.nodump\" file"
-		EXIT_CODE=1
+		msg_err "\"$TEST\" has a non-empty \"$dir/dumps/$base.nodump\" file"
 	fi
 }
 
 SHELL_TESTS=( $(find "tests/shell/testcases/" -type f -executable | sort) )
 
 if [ "${#SHELL_TESTS[@]}" -eq 0 ] ; then
-	echo "No executable tests under \"tests/shell/testcases/\" found"
-	EXIT_CODE=1
+	msg_err "No executable tests under \"tests/shell/testcases/\" found"
 fi
 for t in "${SHELL_TESTS[@]}" ; do
 	check_shell_dumps "$t"
-	head -n 1 "$t" |grep -q  '^#!/bin/sh' && echo "$t uses sh instead of bash" && EXIT_CODE=1
+	if head -n 1 "$t" |grep -q  '^#!/bin/sh' ; then
+		msg_err "$t uses #!/bin/sh instead of /bin/bash"
+	fi
 done
 
 ##############################################################################
 
 SHELL_TESTS2=( $(./tests/shell/run-tests.sh --list-tests) )
 if [ "${SHELL_TESTS[*]}" != "${SHELL_TESTS2[*]}" ] ; then
-	echo "\`./tests/shell/run-tests.sh --list-tests\` does not list the expected tests"
-	EXIT_CODE=1
+	msg_err "\`./tests/shell/run-tests.sh --list-tests\` does not list the expected tests"
 fi
 
 ##############################################################################
@@ -85,8 +90,7 @@ F=( $(find tests/shell/testcases/ -type f | grep '^tests/shell/testcases/[^/]\+/
 IGNORED_FILES=( tests/shell/testcases/bogons/nft-f/* )
 for f in "${F[@]}" ; do
 	if ! array_contains "$f" "${SHELL_TESTS[@]}" "${IGNORED_FILES[@]}" ; then
-		echo "Unexpected file \"$f\""
-		EXIT_CODE=1
+		msg_err "Unexpected file \"$f\""
 	fi
 done
 
@@ -97,8 +101,7 @@ FILES=( $(find "tests/shell/testcases/" -type f | sed -n 's#\(tests/shell/testca
 for f in "${FILES[@]}" ; do
 	f2="$(echo "$f" | sed -n 's#\(tests/shell/testcases\(/.*\)\?/\)dumps/\(.*\)\.\(nft\|nodump\)$#\1\3#p')"
 	if ! array_contains "$f2" "${SHELL_TESTS[@]}" ; then
-		echo "\"$f\" has no test \"$f2\""
-		EXIT_CODE=1
+		msg_err "\"$f\" has no test \"$f2\""
 	fi
 done
 
-- 
2.41.0

