Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE141EE01F0
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 17:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjIMRMM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 13:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjIMRML (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 13:12:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A741DC1
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 10:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694625081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tzhiiQKnLAx2m8uAj/ylx3yX5yRaZ/J/sfo3vy6B03A=;
        b=OQRgtTfRIMR4QjLlQTzfvt5VJ74kB6kHbrbSXEc3SnXxySbBVOBq1Vu49zot6b1QrAyUrf
        Ue/b0i0LD1HtZelZ3Na+U7aYbIWmmew7S2QLILKrEtmGNomKuwmQM+6cjbnBm6k26eFt25
        fq+sTq9XpOs+OJuB6e/yaMfKgx38dm8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-d_3IeKvqMGehXSyTLXuvgQ-1; Wed, 13 Sep 2023 13:11:19 -0400
X-MC-Unique: d_3IeKvqMGehXSyTLXuvgQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E873681D88C
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 17:11:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 676022027047;
        Wed, 13 Sep 2023 17:11:18 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] tests/shell: accept $NFT_TEST_TMPDIR_TAG for the result directory
Date:   Wed, 13 Sep 2023 19:11:02 +0200
Message-ID: <20230913171107.439983-2-thaller@redhat.com>
In-Reply-To: <20230913171107.439983-1-thaller@redhat.com>
References: <20230913171107.439983-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We allow the user to set "$TMPDIR" to affect where the "nft-test.*"
directory is created. However, we don't allow the user to specify the
exact location, so the user doesn't really know which directory was
created.

One remedy is that the test will also create the symlink
"$TMPDIR/nft-test.latest.$USER" to point to the last test result.
However, if you run multiple tests in parallel, that is not reliable to
find the test results.

Accept $NFT_TEST_TMPDIR_TAG and use it as part of the generated
filename. That way, the caller can set it to a unique tag, and find the
directory later based on that. For example

  export TMPDIR=/tmp
  export NFT_TEST_TMPDIR_TAG=".$(uuidgen)"
  ./tests/shell/run-tests.sh
  ls -lad "$TMPDIR/nft-test."*"$NFT_TEST_TMPDIR_TAG"*/

will work reliably -- as long as the tag is chosen uniquely.

The reason to not allow the user to specify the directory name directly,
is because we want that tests results follow the well-known pattern
"/tmp/nft-test*".

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 188ac89ca1de..f75505f7f1b4 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -433,7 +433,7 @@ cleanup_on_exit() {
 }
 trap cleanup_on_exit EXIT
 
-NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$(date '+%Y%m%d-%H%M%S.%3N').XXXXXX")" ||
+NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$(date '+%Y%m%d-%H%M%S.%3N')$NFT_TEST_TMPDIR_TAG.XXXXXX")" ||
 	msg_error "Failure to create temp directory in \"$_TMPDIR\""
 chmod 755 "$NFT_TEST_TMPDIR"
 
-- 
2.41.0

