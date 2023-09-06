Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B40EB8FB8
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbjIFMDB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237430AbjIFMDA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE1C1733
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VAbQ6x9sr5F40gxbF4EMmFJlfV43OhZOD8rHIQR1cDM=;
        b=QeGZyzGtLvfukwEwWvEI6TDZQSlpkPqzC837WpARw8UHzO6HCCsSrjByeNwotBGkHGYAe4
        4yQnoOZ/3yoJH9b4rLWb8Bdy7/VZ9gTAO9uU7PRue27D3YViwqtYTLwZi0jgRZ1TMBHi7E
        IASyNIpiaPBnuE2ye8x3NRbI5b26k+A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-3Kk4riT7O9KwY214N8tiQA-1; Wed, 06 Sep 2023 08:01:35 -0400
X-MC-Unique: 3Kk4riT7O9KwY214N8tiQA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F122C89F4FD
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 70C7BC15BB8;
        Wed,  6 Sep 2023 12:01:34 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 19/19] tests/shell: set TMPDIR for tests in "test-wrapper.sh"
Date:   Wed,  6 Sep 2023 13:52:22 +0200
Message-ID: <20230906120109.1773860-20-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Various tests create additional temporary files. They really should just
use "$NFT_TEST_TESTTMPDIR" for that. However, they mostly use `mktemp`.

The scripts are supposed to cleanup those files afterwards. However,
often that does not work correctly and /tmp gets full of left over
temporary files.

Export "TMPDIR" so that they use the test-specific temporary directory.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index e745df85a08d..43b3aa09ef26 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -11,6 +11,8 @@ TESTDIR="$(dirname "$TEST")"
 
 START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
 
+export TMPDIR="$NFT_TEST_TESTTMPDIR"
+
 CLEANUP_UMOUNT_RUN_NETNS=n
 
 cleanup() {
-- 
2.41.0

