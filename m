Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7D0EE01F1
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 17:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjIMRIP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 13:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjIMRH4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 13:07:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 922FA19A7
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 10:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694624824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gmf+M1CJW7TNCbnPrZRjEh3YgXzAhP/ImBQdgPA7Snw=;
        b=G5dYPylAeCfiR10mj8mpy7sMTo774O20eaOf1lPyUpCPufW2RPdX5KTqCvH9dWWd8FwHUQ
        nMGVbqZQemN5PNGJMmundOSv+RfdhZOYJV4+Q3iD7vdcJCTu+oZDKW3Y+1DDULi6pO58AH
        dYWnXFO43WkibygdhurX2/PiZlPou5Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-bKsDCaGzMsq98fAHOuoo5g-1; Wed, 13 Sep 2023 13:07:02 -0400
X-MC-Unique: bKsDCaGzMsq98fAHOuoo5g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 214F18032FE
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 17:07:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 945AB40C6EA8;
        Wed, 13 Sep 2023 17:07:01 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/6] tests/shell: drop unstable dump for "transactions/0051map_0" test
Date:   Wed, 13 Sep 2023 19:05:05 +0200
Message-ID: <20230913170649.439394-3-thaller@redhat.com>
In-Reply-To: <20230913170649.439394-1-thaller@redhat.com>
References: <20230913170649.439394-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The file "tests/shell/testcases/transactions/dumps/0051map_0.nft" gets
generated differently on Fedora 38 (6.4.14-200.fc38.x86_64) and
CentOS-Stream-9 (5.14.0-354.el9.x86_64). It's not stable.

    diff --git c/tests/shell/testcases/transactions/dumps/0051map_0.nft w/tests/shell/testcases/transactions/dumps/0051map_0.nft
    index 59d69df70e61..fa7df9f93757 100644
    --- c/tests/shell/testcases/transactions/dumps/0051map_0.nft
    +++ w/tests/shell/testcases/transactions/dumps/0051map_0.nft
    @@ -1,7 +1,11 @@
     table ip x {
    +    chain w {
    +    }
    +
         chain m {
         }

         chain y {
    +         ip saddr vmap { 1.1.1.1 : jump w, 2.2.2.2 : accept, 3.3.3.3 : goto m }
         }
     }

Drop it.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/transactions/dumps/0051map_0.nft    | 7 -------
 tests/shell/testcases/transactions/dumps/0051map_0.nodump | 0
 2 files changed, 7 deletions(-)
 delete mode 100644 tests/shell/testcases/transactions/dumps/0051map_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0051map_0.nodump

diff --git a/tests/shell/testcases/transactions/dumps/0051map_0.nft b/tests/shell/testcases/transactions/dumps/0051map_0.nft
deleted file mode 100644
index 59d69df70e61..000000000000
--- a/tests/shell/testcases/transactions/dumps/0051map_0.nft
+++ /dev/null
@@ -1,7 +0,0 @@
-table ip x {
-	chain m {
-	}
-
-	chain y {
-	}
-}
diff --git a/tests/shell/testcases/transactions/dumps/0051map_0.nodump b/tests/shell/testcases/transactions/dumps/0051map_0.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.41.0

