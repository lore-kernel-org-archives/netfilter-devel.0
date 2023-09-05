Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B23C83F2C
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346319AbjIEQ1O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354486AbjIEMBT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:01:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB59D1B7
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 04:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oPnsdBuyMwpwSbukR5neUYBZd+84axF86Yz81Gzq+t0=;
        b=Ya9PVrAeGzZHYlTMIjyDxTqe9tfDBVq0tmesYLQZx6aK2Jdp4mGnzftt5eNjxBPXp9tJdy
        yI/0SX7zseWRY0n8I61pbAT/lveRHvh1FY8Pk1szN3epCLUCLkBei5x8Yfj5dyPG4Uy94q
        Ac4+mwG1OjdbFMHtbMNH7iAwM5Oo9LE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-1398AoxaNgazmHb1I3CbNQ-1; Tue, 05 Sep 2023 07:59:53 -0400
X-MC-Unique: 1398AoxaNgazmHb1I3CbNQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BE2C18DA723
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D0161121314;
        Tue,  5 Sep 2023 11:59:50 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 06/17] tests/shell: print test configuration
Date:   Tue,  5 Sep 2023 13:58:35 +0200
Message-ID: <20230905115936.607599-7-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As the script can be configured via environment variables or command
line option, it's useful to show the environment variables that we
received or set during the test setup.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 84975a65243f..82694e9c69d3 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -139,14 +139,20 @@ if [ "$DO_LIST_TESTS" = y ] ; then
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
+msg_info "conf: NFT=$(printf '%q' "$NFT")"
+msg_info "conf: VERBOSE=$(printf '%q' "$VERBOSE")"
+msg_info "conf: DUMPGEN=$(printf '%q' "$DUMPGEN")"
+msg_info "conf: VALGRIND=$(printf '%q' "$VALGRIND")"
+msg_info "conf: KMEMLEAK=$(printf '%q' "$KMEMLEAK")"
+msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 
 MODPROBE="$(which modprobe)"
 if [ ! -x "$MODPROBE" ] ; then
@@ -163,8 +169,6 @@ cleanup_on_exit() {
 }
 trap cleanup_on_exit EXIT
 
-_TMPDIR="${TMPDIR:-/tmp}"
-
 NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$(date '+%Y%m%d-%H%M%S.%3N').XXXXXX")" ||
 	msg_error "Failure to create temp directory in \"$_TMPDIR\""
 chmod 755 "$NFT_TEST_TMPDIR"
-- 
2.41.0

