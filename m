Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C7AEC875D
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjIGWKf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbjIGWKe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:10:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C531BDC
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YeS+cw9GRyeHvD7gpqPCu9ZofWdnkynaCj0lhD1IbS4=;
        b=AmvcvhYDQ7To2p5wYJzFdjHkrYJxqo9ICVDcN7xKSyQIECIMZvQpkfE7+GGJKEhNI3gsts
        zfSEelO6m8htaQz0nbleEZ4hYvC7gtEfvB8laisRlwZYL6y04f/p+9to0VZlvnGJXj2vr2
        Fo2t9b23p2QN6yy4M2lKsRWDGQiOuSw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-WmQzQEMkObOsfkMH6r8ZAA-1; Thu, 07 Sep 2023 18:08:53 -0400
X-MC-Unique: WmQzQEMkObOsfkMH6r8ZAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69B8E3802AD1
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D0FB463F6C;
        Thu,  7 Sep 2023 22:08:52 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 11/11] tests/shell: set NFT_TEST_JOBS based on $(nproc)
Date:   Fri,  8 Sep 2023 00:07:23 +0200
Message-ID: <20230907220833.2435010-12-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Choose 150% of $(nproc) for the default vlaue of NFT_TEST_JOBS
(rounded up). The minimal value chosen by default is 2.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 35621bac569d..c622c1509500 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -154,7 +154,7 @@ usage() {
 	echo "                 mount namespace."
 	echo "                 This is only honored when \$NFT_TEST_UNSHARE_CMD= is set. Otherwise it's detected."
 	echo " NFT_TEST_KEEP_LOGS=*|y: Keep the temp directory. On success, it will be deleted by default."
-	echo " NFT_TEST_JOBS=<NUM}>: number of jobs for parallel execution. Defaults to \"12\" for parallel run."
+	echo " NFT_TEST_JOBS=<NUM}>: number of jobs for parallel execution. Defaults to \"\$(nproc)*1.5\" for parallel run."
 	echo "                 Setting this to \"0\" or \"1\", means to run jobs sequentially."
 	echo "                 Setting this to \"0\" means also to perform global cleanups between tests (remove"
 	echo "                 kernel modules)."
@@ -167,13 +167,17 @@ NFT_TEST_BASEDIR="$(dirname "$0")"
 # Export the base directory. It may be used by tests.
 export NFT_TEST_BASEDIR
 
+_NFT_TEST_JOBS_DEFAULT="$(nproc)"
+[ "$_NFT_TEST_JOBS_DEFAULT" -gt 0 ] 2>/dev/null || _NFT_TEST_JOBS_DEFAULT=1
+_NFT_TEST_JOBS_DEFAULT="$(( _NFT_TEST_JOBS_DEFAULT + (_NFT_TEST_JOBS_DEFAULT + 1) / 2 ))"
+
 VERBOSE="$(bool_y "$VERBOSE")"
 DUMPGEN="$(bool_y "$DUMPGEN")"
 VALGRIND="$(bool_y "$VALGRIND")"
 KMEMLEAK="$(bool_y "$KMEMLEAK")"
 NFT_TEST_KEEP_LOGS="$(bool_y "$NFT_TEST_KEEP_LOGS")"
 NFT_TEST_HAS_REALROOT="$NFT_TEST_HAS_REALROOT"
-NFT_TEST_JOBS="${NFT_TEST_JOBS:-12}"
+NFT_TEST_JOBS="${NFT_TEST_JOBS:-$_NFT_TEST_JOBS_DEFAULT}"
 DO_LIST_TESTS=
 
 TESTS=()
@@ -345,7 +349,7 @@ export NFT_TEST_HAS_UNSHARED_MOUNT
 
 # normalize the jobs number to be an integer.
 case "$NFT_TEST_JOBS" in
-	''|*[!0-9]*) NFT_TEST_JOBS=12 ;;
+	''|*[!0-9]*) NFT_TEST_JOBS=_NFT_TEST_JOBS_DEFAULT ;;
 esac
 if [ -z "$NFT_TEST_UNSHARE_CMD" -a "$NFT_TEST_JOBS" -gt 1 ] ; then
 	NFT_TEST_JOBS=1
-- 
2.41.0

