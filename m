Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC19EC875F
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbjIGWKc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjIGWKc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:10:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640451BD7
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SD8Q7oHO7IVT5bZSApzfZPV/CLTK+NLOyeYYDsbTj08=;
        b=H5Q4Ox5wd+qEG1gq4uGdp4zvm0nv2J40J0LNSaRjyDFU+yTJ9+6yMCHmGh5dSNs5EkEA88
        xdqrcC9MXWxqtizwqksiF3o26Po+Wxz1w72OU1/cCGR6Q9Wkn8QMx+Z8Ao8uLOuw3HdNKl
        QM5AhDJVJPTjKCnNFY6oQOraKr2Qbao=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-GuZ1i-jfPce3JE9IF2HwKg-1; Thu, 07 Sep 2023 18:08:50 -0400
X-MC-Unique: GuZ1i-jfPce3JE9IF2HwKg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DA98181792A
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B0777B62;
        Thu,  7 Sep 2023 22:08:49 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 07/11] tests/shell: redirect output of test script to file too
Date:   Fri,  8 Sep 2023 00:07:19 +0200
Message-ID: <20230907220833.2435010-8-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's useful to keep around for later. Redirect to the temporary
directory.

Note that the file content may be colorized too. `less -R` helps with
that.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index e4efbb2de540..4c1ab29b8536 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -382,6 +382,8 @@ NFT_TEST_TMPDIR="$(mktemp --tmpdir="$_TMPDIR" -d "nft-test.$(date '+%Y%m%d-%H%M%
 	msg_error "Failure to create temp directory in \"$_TMPDIR\""
 chmod 755 "$NFT_TEST_TMPDIR"
 
+exec &> >(tee "$NFT_TEST_TMPDIR/test.log")
+
 NFT_REAL="${NFT_REAL-$NFT}"
 
 msg_info "conf: NFT=$(printf '%q' "$NFT")"
-- 
2.41.0

