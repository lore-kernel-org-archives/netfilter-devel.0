Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8ABC46CA1
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 18:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjIRSrr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 14:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjIRSro (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 14:47:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EA310F
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 11:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695062812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SsXTc6jbtaaP0dr5L15TzdOQgoIIZuMcRbQB7wG8xcE=;
        b=XIbAcrUuXLEbYombt0kFrpwxlO+TtSvpSCrqZOEWK/ujD6fXCaQsskg1FNc17L5NXPhomj
        XpS4lgfSoZGeVJ+0BJqrNijmGvHBdU1ODaFIyI/64wzX8VUKLqv0UTWXaDhPrmWjvmsDDf
        4TMu2gCL8nQmeumI6GlnbZM1jkzu5CU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-9JAkWclYNgmhXJHWRvUGtA-1; Mon, 18 Sep 2023 14:46:50 -0400
X-MC-Unique: 9JAkWclYNgmhXJHWRvUGtA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B44F80D097
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 18:46:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CDD80492B16;
        Mon, 18 Sep 2023 18:46:46 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/3] tests/shell: colorize NFT_TEST_HAS_SOCKET_LIMITS
Date:   Mon, 18 Sep 2023 20:45:21 +0200
Message-ID: <20230918184634.3471832-4-thaller@redhat.com>
In-Reply-To: <20230918184634.3471832-1-thaller@redhat.com>
References: <20230918184634.3471832-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NFT_TEST_HAS_SOCKET_LIMITS= is similar to NFT_TEST_HAVE_* variables and
indicates a feature (or lack thereof), except that it's inverted.  Maybe
this should be consolidated, however, NFT_TEST_HAS_SOCKET_LIMITS= is
detected in the root namespace, unlike the shell scripts from features.
So it's unclear how to consolidate them best.

Anyway. Still highlight a lack of the capability, as it can cause tests
to be skipped and we should see that easily.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 418fab95da94..03021085e0e7 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -30,6 +30,18 @@ array_contains() {
 	return 1
 }
 
+colorize_keywords() {
+	local out_variable="$1"
+	local color="$2"
+	local val="$3"
+	local val2
+	shift 3
+
+	printf -v val2 '%q' "$val"
+	array_contains "$val" "$@" && val2="$color$val2$RESET"
+	printf -v "$out_variable" '%s' "$val2"
+}
+
 strtonum() {
 	local s="$1"
 	local n
@@ -571,7 +583,8 @@ msg_info "conf: DUMPGEN=$(printf '%q' "$DUMPGEN")"
 msg_info "conf: VALGRIND=$(printf '%q' "$VALGRIND")"
 msg_info "conf: KMEMLEAK=$(printf '%q' "$KMEMLEAK")"
 msg_info "conf: NFT_TEST_HAS_REALROOT=$(printf '%q' "$NFT_TEST_HAS_REALROOT")"
-msg_info "conf: NFT_TEST_HAS_SOCKET_LIMITS=$(printf '%q' "$NFT_TEST_HAS_SOCKET_LIMITS")"
+colorize_keywords value "$YELLOW" "$NFT_TEST_HAS_SOCKET_LIMITS" y
+msg_info "conf: NFT_TEST_HAS_SOCKET_LIMITS=$value"
 msg_info "conf: NFT_TEST_UNSHARE_CMD=$(printf '%q' "$NFT_TEST_UNSHARE_CMD")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED_MOUNT=$(printf '%q' "$NFT_TEST_HAS_UNSHARED_MOUNT")"
@@ -582,19 +595,13 @@ msg_info "conf: NFT_TEST_SHUFFLE_TESTS=$NFT_TEST_SHUFFLE_TESTS"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 echo
 for KEY in $(compgen -v | grep '^NFT_TEST_SKIP_' | sort) ; do
-	v="${!KEY}"
-	if [ "$v" = y ] ; then
-		v="$YELLOW$v$RESET"
-	fi
-	msg_info "conf: $KEY=$v"
+	colorize_keywords value "$YELLOW" "${!KEY}" y
+	msg_info "conf: $KEY=$value"
 	export "$KEY"
 done
 for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_' | sort) ; do
-	v="${!KEY}"
-	if [ "$v" = n ] ; then
-		v="$YELLOW$v$RESET"
-	fi
-	msg_info "conf: $KEY=$v"
+	colorize_keywords value "$YELLOW" "${!KEY}" n
+	msg_info "conf: $KEY=$value"
 	export "$KEY"
 done
 
-- 
2.41.0

