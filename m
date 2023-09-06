Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FE6EB8FBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbjIFMCz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238945AbjIFMCx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2767CFD
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L76fzBSARcujw3nkNiwXECPdRLmnZdMz2+RjTi1KzTo=;
        b=AmKGDSdIlLgIR/JpbYeI8Mvlm45urqFaliX0RT6xw0jI8b451qwRwxtwKfcCjnEb0amJM5
        nxR1j2zDNCsCBdDGwtoDf/xYVtgyd+M9wDa9U5jMWOHEiOykhyUdD2lCfmvCYNALEy0t0c
        tzWrM72swxLxmVqK+jAot4MBIXir9bc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130--y0osvupNCOhAIoY69F9-Q-1; Wed, 06 Sep 2023 08:01:25 -0400
X-MC-Unique: -y0osvupNCOhAIoY69F9-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3BC11C07256
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23FB9C03292;
        Wed,  6 Sep 2023 12:01:24 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 06/19] tests/shell: print test configuration
Date:   Wed,  6 Sep 2023 13:52:09 +0200
Message-ID: <20230906120109.1773860-7-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As the script can be configured via environment variables or command
line option, it's useful to show the environment variables that we
received or set during the test setup.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 905fa0c10309..2c6eaea3636f 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -138,13 +138,13 @@ if [ "$DO_LIST_TESTS" = y ] ; then
 	exit 0
 fi
 
+_TMPDIR="${TMPDIR:-/tmp}"
+
 [ -z "$NFT" ] && NFT="$NFT_TEST_BASEDIR/../../src/nft"
 ${NFT} > /dev/null 2>&1
 ret=$?
 if [ ${ret} -eq 126 ] || [ ${ret} -eq 127 ]; then
-	msg_error "cannot execute nft command: ${NFT}"
-else
-	msg_info "using nft command: ${NFT}"
+	msg_error "cannot execute nft command: $NFT"
 fi
 
 MODPROBE="$(which modprobe)"
@@ -162,12 +162,17 @@ cleanup_on_exit() {
 }
 trap cleanup_on_exit EXIT
 
-_TMPDIR="${TMPDIR:-/tmp}"
-
 NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$(date '+%Y%m%d-%H%M%S.%3N').XXXXXX")" ||
 	msg_error "Failure to create temp directory in \"$_TMPDIR\""
 chmod 755 "$NFT_TEST_TMPDIR"
 
+msg_info "conf: NFT=$(printf '%q' "$NFT")"
+msg_info "conf: VERBOSE=$(printf '%q' "$VERBOSE")"
+msg_info "conf: DUMPGEN=$(printf '%q' "$DUMPGEN")"
+msg_info "conf: VALGRIND=$(printf '%q' "$VALGRIND")"
+msg_info "conf: KMEMLEAK=$(printf '%q' "$KMEMLEAK")"
+msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
+
 NFT_TEST_LATEST="$_TMPDIR/nft-test.latest.$USER"
 
 ln -snf "$NFT_TEST_TMPDIR" "$NFT_TEST_LATEST"
-- 
2.41.0

