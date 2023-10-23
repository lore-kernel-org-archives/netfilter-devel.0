Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13FECDB474
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 13:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjJWNjb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 09:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjJWNjb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 09:39:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F60E5
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 06:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698068322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uAoILJT97qAV8w66bXG5GMO0y9hjgEBNw4mj3D5CNC8=;
        b=XawrrCauFw3pItCteBL5woEHXk+215hdVqw+tzKFDXncGTWgJv8aP51Iw5Vz6KAxmu1ktW
        LJLBbxEiW/GFLN9E5YfkEG2d7VagKidvlWSEIaCAJ8fM5je2aftribeHxQCoAreVwYftti
        qkRsQhCPlyNs9fjie9zRExWUTrd18hg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-1T-mPaVJO8elMuvYvqrBcQ-1; Mon, 23 Oct 2023 09:38:36 -0400
X-MC-Unique: 1T-mPaVJO8elMuvYvqrBcQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D41133C14912
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 13:38:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.226])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 53981492BE2;
        Mon, 23 Oct 2023 13:38:35 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] tests/shell: test for maximum length of "comment" in "comments_objects_0"
Date:   Mon, 23 Oct 2023 15:38:18 +0200
Message-ID: <20231023133823.243464-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The comment length is limited to NFTNL_UDATA_COMMENT_MAXLEN. Test for
that.

Adjust an existing test for that.

Also rename $EXPECTED to $RULESET. We don't compare the value of
$EXPECTED against the actually configured rules. It also wouldn't work,
because the input is not normalized and wouldn't match. It also isn't
necessary, because there is a .nft dump file.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 .../testcases/optionals/comments_objects_0    | 22 ++++++++++++++-----
 .../optionals/dumps/comments_objects_0.nft    |  7 +++++-
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/tests/shell/testcases/optionals/comments_objects_0 b/tests/shell/testcases/optionals/comments_objects_0
index 7437c77beb0b..301f5518fb80 100755
--- a/tests/shell/testcases/optionals/comments_objects_0
+++ b/tests/shell/testcases/optionals/comments_objects_0
@@ -1,9 +1,23 @@
 #!/bin/bash
 
-EXPECTED='table ip filter {
+set -e
+
+COMMENT128="12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678"
+
+# test for pass with comment that is 128 bytes long.
+rc=0
+$NFT add table ip filter \{ quota foo1 \{ comment "\"${COMMENT128}\"" \}\; \}\; || rc="$?"
+test "$rc" = 0
+
+# test for failure with comment that is 128+1 bytes long.
+rc=0
+$NFT add table ip filter \{ quota foo2 \{ comment "\"${COMMENT128}x\"" \}\; \}\; || rc="$?"
+test "$rc" = 1
+
+RULESET='table ip filter {
 	quota q {
 		over 1200 bytes
-		comment "test1"
+		comment "'"$COMMENT128"'"
 	}
 
 	counter c {
@@ -39,6 +53,4 @@ EXPECTED='table ip filter {
 }
 '
 
-set -e
-
-$NFT -f - <<< "$EXPECTED"
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/optionals/dumps/comments_objects_0.nft b/tests/shell/testcases/optionals/dumps/comments_objects_0.nft
index b760ced60424..13822209ebab 100644
--- a/tests/shell/testcases/optionals/dumps/comments_objects_0.nft
+++ b/tests/shell/testcases/optionals/dumps/comments_objects_0.nft
@@ -1,6 +1,11 @@
 table ip filter {
+	quota foo1 {
+		comment "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678"
+		0 bytes
+	}
+
 	quota q {
-		comment "test1"
+		comment "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678"
 		over 1200 bytes
 	}
 
-- 
2.41.0

