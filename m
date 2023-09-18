Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5154BCD37B0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 20:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjIRUAg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 16:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjIRUAf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 16:00:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E148F
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 12:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695067187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YvF8ZcUSJrmKQA2SnZMY98hRu7Hf93cjO0OCTjQvw1U=;
        b=F5RyRARQIjixY3QuUw/UcT93CwkuuZ4mti2Pb9XMSyBZli+0ypqnNZmm5JWtTnUzcTeZLT
        FR7jfz4OQU8n6im1CvPErptRjRi61DQ88bTpRAUMzPbMvPlx5BZqVl7ARzdNPrKPKHpC8f
        MzPpJRKEG67tYhFkaWglRbDdPSw1rJE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-oKwmlW3CNey1L6I70JdYWw-1; Mon, 18 Sep 2023 15:59:45 -0400
X-MC-Unique: oKwmlW3CNey1L6I70JdYWw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B218811E86
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 19:59:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DCC261005E28;
        Mon, 18 Sep 2023 19:59:44 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/3] tests/shell: fix preserving ruleset diff after test
Date:   Mon, 18 Sep 2023 21:59:22 +0200
Message-ID: <20230918195933.318893-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We want to delete the file in the case when there was no diff (and we
expect the file to be empty). The condition was wrong.

Fixes: 55fe071cd193 ('tests/shell: cleanup result handling in "test-wrapper.sh"')

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index cd8f480504ad..ad6a71031506 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -125,6 +125,7 @@ if [ "$rc_test" -ne 77 -a -f "$DUMPFILE" ] ; then
 	if [ "$dump_written" != y ] ; then
 		if ! $DIFF -u "$DUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff" ; then
 			rc_dump=124
+		else
 			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff"
 		fi
 	fi
-- 
2.41.0

