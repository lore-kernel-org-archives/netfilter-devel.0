Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A19EE01EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 17:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjIMRIL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 13:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjIMRH4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 13:07:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C4DC1BC3
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 10:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694624827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2T7VFAmM/quqKm6Za4kHtKgULpoOWD4R2z1FsfOnznY=;
        b=Rv9i2Q8tOLSXc6aG90j8rS0FuCkTks/wgTthHjyVkINWin73OTqqmHPpf+Ou+qv2LsGYaI
        jGLhPPdllcC8TAaubF+ejE7kWFLrHYq4o2r8IvvB0I30AScP/+XZD3npiBJCjyoFRNNFBx
        oF82IxrhBJH5L84rPq5ymoaDtRQtcb8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-6o3L84jFPuaJq3yk_YPy5A-1; Wed, 13 Sep 2023 13:07:04 -0400
X-MC-Unique: 6o3L84jFPuaJq3yk_YPy5A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D091803470
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 17:07:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E04FB40C6EA8;
        Wed, 13 Sep 2023 17:07:03 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 5/6] tests/shell: in find_tests() use C locale for sorting tests names
Date:   Wed, 13 Sep 2023 19:05:08 +0200
Message-ID: <20230913170649.439394-6-thaller@redhat.com>
In-Reply-To: <20230913170649.439394-1-thaller@redhat.com>
References: <20230913170649.439394-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It makes more sense, that the sort order does not depend on the user's
locale.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index dae775bdf3dd..bdca0ee1fa0b 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -263,7 +263,7 @@ while [ $# -gt 0 ] ; do
 done
 
 find_tests() {
-	find "$1" -type f -executable | sort
+	find "$1" -type f -executable | LANG=C sort
 }
 
 if [ "${#TESTS[@]}" -eq 0 ] ; then
-- 
2.41.0

