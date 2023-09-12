Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0017EE3F39
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 22:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbjILWqv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Sep 2023 18:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjILWqv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Sep 2023 18:46:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB08110F4
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2023 15:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694558761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=epXJubdFr54X4i1Sl92jYZILWwFZxLBuodMsVaQra/E=;
        b=c8h90AymQb/DKeMXyCFfaq+DbJvAM1yfP7kZm77MsUrsc57Fqp3iZQtUGOx1KCF8dna/g0
        nZhS3k99kZH4Yh2UnSgH0stYFIsq4x4tF/42EhJ6ieJTi8W7ECcOfSuPu7wCPJocJf12Rr
        2SlpTWK8agfIm/fKjMxlVlXCYMN9mIg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-9lYEm3bYP92r-sVxNod53Q-1; Tue, 12 Sep 2023 18:46:00 -0400
X-MC-Unique: 9lYEm3bYP92r-sVxNod53Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F24B929AA2D0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2023 22:45:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7078340C6EA8;
        Tue, 12 Sep 2023 22:45:59 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] tests/shell: ensure vgdb-pipe files are deleted from "nft-valgrind-wrapper.sh"
Date:   Wed, 13 Sep 2023 00:44:50 +0200
Message-ID: <20230912224501.2549359-2-thaller@redhat.com>
In-Reply-To: <20230912224501.2549359-1-thaller@redhat.com>
References: <20230912224501.2549359-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When the valgrind process gets killed, those files can be left over.
They are located in the original $TMPDIR (usually /tmp). They should be
cleaned up.

I tried to cleanup the files from withing "nft-valgrind-wrapper.sh"
itself via a `trap`, but it doesn't work. Instead, let "run-tests.sh"
delete all files with a matching pattern.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/nft-valgrind-wrapper.sh |  4 ++--
 tests/shell/run-tests.sh                    | 10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tests/shell/helpers/nft-valgrind-wrapper.sh b/tests/shell/helpers/nft-valgrind-wrapper.sh
index 6125dd0f3089..98bbdf43570e 100755
--- a/tests/shell/helpers/nft-valgrind-wrapper.sh
+++ b/tests/shell/helpers/nft-valgrind-wrapper.sh
@@ -1,6 +1,6 @@
 #!/bin/bash -e
 
-SUFFIX="$(date "+%Y%m%d-%H%M%S.%6N.$$")"
+SUFFIX="$(date "+%H%M%S.%6N").$$"
 
 rc=0
 libtool \
@@ -12,7 +12,7 @@ libtool \
 		--show-leak-kinds=all \
 		--num-callers=100 \
 		--error-exitcode=122 \
-		--vgdb-prefix="$NFT_TEST_TMPDIR_ORIG/vgdb-pipe-nft-test-$SUFFIX" \
+		--vgdb-prefix="$_NFT_TEST_VALGRIND_VGDB_PREFIX-$SUFFIX" \
 		$NFT_TEST_VALGRIND_OPTS \
 		"$NFT_REAL" \
 		"$@" \
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index cf17302fdc19..7ac6202ca43c 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -426,6 +426,8 @@ fi
 
 declare -A JOBS_PIDLIST
 
+_NFT_TEST_VALGRIND_VGDB_PREFIX=
+
 cleanup_on_exit() {
 	pids_search=''
 	for pid in "${!JOBS_PIDLIST[@]}" ; do
@@ -442,13 +444,17 @@ cleanup_on_exit() {
 	if [ "$NFT_TEST_KEEP_LOGS" != y -a -n "$NFT_TEST_TMPDIR" ] ; then
 		rm -rf "$NFT_TEST_TMPDIR"
 	fi
+	if [ -n "$_NFT_TEST_VALGRIND_VGDB_PREFIX" ] ; then
+		rm -rf "$_NFT_TEST_VALGRIND_VGDB_PREFIX"* &>/dev/null
+	fi
 }
 
 trap 'exit 130' SIGINT
 trap 'exit 143' SIGTERM
 trap 'rc=$?; cleanup_on_exit; exit $rc' EXIT
 
-NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$(date '+%Y%m%d-%H%M%S.%3N').XXXXXX")" ||
+TIMESTAMP=$(date '+%Y%m%d-%H%M%S.%3N')
+NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$TIMESTAMP.XXXXXX")" ||
 	msg_error "Failure to create temp directory in \"$_TMPDIR\""
 chmod 755 "$NFT_TEST_TMPDIR"
 
@@ -493,6 +499,8 @@ msg_info "info: NFT_TEST_TMPDIR=$(printf '%q' "$NFT_TEST_TMPDIR")"
 if [ "$VALGRIND" == "y" ]; then
 	NFT="$NFT_TEST_BASEDIR/helpers/nft-valgrind-wrapper.sh"
 	msg_info "info: NFT=$(printf '%q' "$NFT")"
+	_NFT_TEST_VALGRIND_VGDB_PREFIX="$NFT_TEST_TMPDIR_ORIG/vgdb-pipe-nft-test-$TIMESTAMP.$$.$RANDOM"
+	export _NFT_TEST_VALGRIND_VGDB_PREFIX
 fi
 
 kernel_cleanup() {
-- 
2.41.0

