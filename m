Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E91CEE01E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 17:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjIMRH7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 13:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjIMRHs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 13:07:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1889619BF
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 10:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694624826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nbgsravjMRQJrHA9O6u2Vz9+5HrMqDGOb95E0774IXs=;
        b=QJR+DwUIqQek1v8Fkj2Ufs8yQRSVITVrPPjEe139tsXiZboSUsmVsUdjKB8Geq5Ff2SrWF
        lXMUWOBnxRld5GGSFksoISYJpRePOURVX3dvr9sgVmaNVshF9CccGjllX3Nruy7/Gd0eXH
        7ey9+SbNNH5dPQr02Z7V5vo813/VngQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-vttAvmbiPn-aaCJe9086Kg-1; Wed, 13 Sep 2023 13:07:04 -0400
X-MC-Unique: vttAvmbiPn-aaCJe9086Kg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A51621875045
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 17:07:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23D5A40C6EA8;
        Wed, 13 Sep 2023 17:07:03 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 4/6] tests/shell: special handle base path starting with "./"
Date:   Wed, 13 Sep 2023 19:05:07 +0200
Message-ID: <20230913170649.439394-5-thaller@redhat.com>
In-Reply-To: <20230913170649.439394-1-thaller@redhat.com>
References: <20230913170649.439394-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When we auto detect the tests with `tests/shell/run-tests.sh -L`, then
commonly the NFT_TEST_BASEDIR starts with a redundant "./". That's a bit
ugly.

Instead, special handle that case and remove the prefix. The effect is
that `tests/shell/run-tests.sh -L` shows

  tests/shell/testcases/bitwise/0040mark_binop_0

instead of

  ./tests/shell/testcases/bitwise/0040mark_binop_0

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index f20a2bec9e9b..dae775bdf3dd 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -267,7 +267,9 @@ find_tests() {
 }
 
 if [ "${#TESTS[@]}" -eq 0 ] ; then
-	TESTS=( $(find_tests "$NFT_TEST_BASEDIR/testcases/") )
+	d="$NFT_TEST_BASEDIR/testcases/"
+	d="${d#./}"
+	TESTS=( $(find_tests "$d") )
 	test "${#TESTS[@]}" -gt 0 || msg_error "Could not find tests"
 fi
 
-- 
2.41.0

