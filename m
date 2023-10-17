Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711B5CDB482
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 08:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbjJQIwk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 04:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbjJQIwi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 04:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AC4F5
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 01:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697532707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VShFsPTZvZdCOAHWPPleUMqHQz29TIaDQQHW+ItmcqQ=;
        b=duRDXRMFHkAmCVBh7/Pqv2YjLRGieFZPmAWf13vlBtxyJP8WqrPcSPCQJM6WlnemkIT3ag
        FcIhP2rXcdaZpu+Xx8Rp0sKcF2XGlbYL06/dtsMN022mpdts+YMeYT7pjCa5ymIGuXUOq0
        vONZgFnSZMQiPj4lLikfIN6txqpX/fk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-2xAjM3D1OE6sfoJOnL0XwQ-1; Tue, 17 Oct 2023 04:51:46 -0400
X-MC-Unique: 2xAjM3D1OE6sfoJOnL0XwQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C227D81D9E2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 08:51:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41097492BF0;
        Tue, 17 Oct 2023 08:51:45 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 2/3] tests/shell: skip "table_onoff" test on older kernels
Date:   Tue, 17 Oct 2023 10:49:07 +0200
Message-ID: <20231017085133.1203402-3-thaller@redhat.com>
In-Reply-To: <20231017085133.1203402-1-thaller@redhat.com>
References: <20231017085133.1203402-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The "table_onoff" test can only pass with certain (recent) kernels.
Conditionally exit with status 77, if "eval-exit-code" determines that
we don't have a suitable kernel version.

In this case, we can find the fixes in:

 v6.6      : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c9bd26513b3a11b3adb3c2ed8a31a01a87173ff1
 v6.5.6    : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5e5754e9e77ce400d70ff3c30fea466c8dfe9a9f
 v6.1.56   : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c4b0facd5c20ceae3d07018a3417f06302fa9cd1
 v5.15.135 : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0dcc9b4097d860d9af52db5366a8755c13468d13

Fixes: bcca2d67656f ('tests: add test for dormant on/off/on bug')
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/transactions/table_onoff | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/transactions/table_onoff b/tests/shell/testcases/transactions/table_onoff
index 831d4614c1f2..0e70ad2cc3f4 100755
--- a/tests/shell/testcases/transactions/table_onoff
+++ b/tests/shell/testcases/transactions/table_onoff
@@ -11,7 +11,9 @@ delete table ip t
 EOF
 
 if [ $? -eq 0 ]; then
-	exit 1
+	echo "Command to re-awaken a dormant table did not fail. Lacking https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c9bd26513b3a11b3adb3c2ed8a31a01a87173ff1 ?"
+	"$NFT_TEST_BASEDIR/helpers/eval-exit-code" kernel  6.6  6.5.6  6.1.56  5.15.135
+	exit $?
 fi
 
 set -e
-- 
2.41.0

