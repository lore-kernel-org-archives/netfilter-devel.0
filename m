Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8E5C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Oct 2023 18:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjJaSz7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjJaSz7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Oct 2023 14:55:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864C5DF
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 11:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698778508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ae7jZslnIZWSMwz8fG8821b9hauoGOxH+m7tyDnTXIA=;
        b=fSMmxLuMhcfi8O+EDbkz35MeiFx1ZTCcLrci36AaHKGB+k8AZ4tAAIelvn3T42tTniwEG+
        hqicHSLPPOulel5jHSFNCqlYCEeoNCtwoR/Myx+M4Nrm+dYtU4MVnk7G2sHp6m1KcB29ms
        llAToJiGHQ6oU4WBF3ObxNWpYXlRB3E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-GK7xlGCcMDOQVZajxvvaSg-1; Tue, 31 Oct 2023 14:55:06 -0400
X-MC-Unique: GK7xlGCcMDOQVZajxvvaSg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AA59185A785
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 18:55:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 827E910F51;
        Tue, 31 Oct 2023 18:55:05 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 5/7] tools: simplify error handling in "check-tree.sh" by adding msg_err()/msg_warn()
Date:   Tue, 31 Oct 2023 19:53:31 +0100
Message-ID: <20231031185449.1033380-6-thaller@redhat.com>
In-Reply-To: <20231031185449.1033380-1-thaller@redhat.com>
References: <20231031185449.1033380-1-thaller@redhat.com>
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

