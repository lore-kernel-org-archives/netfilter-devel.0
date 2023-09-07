Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93A6EB8FB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239551AbjIGWKg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238962AbjIGWKf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:10:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1695C1BD8
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wkvpMeZsoh9t6GwznWDqkUKuyzOG0O91IO2nwsaEmrU=;
        b=Q6g0jXPty6zvcVyWz7Ksq61MDWF1rcGS6VZBt3/iuJkIbGolIG1BsyG1iT96k/nt3G35PU
        7wFC4cYTbxY9kwxQRDUGyw2e+3JixtHl/5PSMxuwZ7LcY2DQTjPIHL2EsujisXRPovTDOT
        QPn9Op2ZmTl8Ksnlm0LA3BuhV0YDr9E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-3EXJGVQ7Pb6ATbDDzZVpHw-1; Thu, 07 Sep 2023 18:08:51 -0400
X-MC-Unique: 3EXJGVQ7Pb6ATbDDzZVpHw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D33E31817929
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A7117B62;
        Thu,  7 Sep 2023 22:08:50 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 08/11] tests/shell: print "kernel is tainted" separate from test result
Date:   Fri,  8 Sep 2023 00:07:20 +0200
Message-ID: <20230907220833.2435010-9-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Once the kernel is tainted, it stays until reboot. It would not be
useful to fail the entire test run based on that (and we don't do that).

But then, it seems odd to print this in the same style as the test
results, because a [FAILED] of a test counts as an overall failure.
Instead, print this warning in a different style.

Previously:

    $ ./tests/shell/run-tests.sh -- /usr/bin/true
    ...

    W: [FAILED]     kernel is tainted
    I: [OK]         /usr/bin/true

    I: results: [OK] 1 [SKIPPED] 0 [FAILED] 0 [TOTAL] 1

Now:

    $ ./tests/shell/run-tests.sh -- /usr/bin/true
    ...

    W: kernel is tainted

    I: [OK]         /usr/bin/true

    I: results: [OK] 1 [SKIPPED] 0 [FAILED] 0 [TOTAL] 1

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 4c1ab29b8536..6abb6c0c73a0 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -496,7 +496,8 @@ check_kmemleak()
 
 read kernel_tainted < /proc/sys/kernel/tainted
 if [ "$kernel_tainted" -ne 0 ] ; then
-	msg_warn "[FAILED]	kernel is tainted"
+	msg_warn "kernel is tainted"
+	echo
 fi
 
 print_test_header() {
-- 
2.41.0

