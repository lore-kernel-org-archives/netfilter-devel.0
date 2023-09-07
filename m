Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694C2EC875F
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbjIGWKf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjIGWKe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:10:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D481BD9
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2wDAQHWyyBKQ6JN1XwPkoxksbMSgc1OxGbmM3XvGO24=;
        b=I5Sk2SC1o9KFRRoQI2G4N+nBgUzJ6LcV7jVFjVcjJMaawMlfAYrMzHeaHPALiBu0R0p1Jf
        3a3KyqyPTZeqODt5LKjxMloPSHsW+9uAFV2fjYTW66Nn9O2F8DZ1acz4zt1YY+0EPAsWIR
        KqOWg7lGQnswWnibdqO1e0qtCV1XLr8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-B3BeGPkLPVWtYh8rUTCx5A-1; Thu, 07 Sep 2023 18:08:52 -0400
X-MC-Unique: B3BeGPkLPVWtYh8rUTCx5A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF4272820543
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F4357B62;
        Thu,  7 Sep 2023 22:08:50 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 09/11] tests/shell: no longer enable verbose output when selecting a test
Date:   Fri,  8 Sep 2023 00:07:21 +0200
Message-ID: <20230907220833.2435010-10-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previously, when selecting a test on the command line, it would also
enable verbose output (except if the "--" separator was used).

This convenience feature seems not great because the output from the
test badly clutters the "run-test.sh" output.

Now that the test results are all on disk, you can search them after the
run with great flexibility (grep).

Additionally, in previous versions, command line argument parsing was
more restrictive, requiring that "-v" always be placed first. Now, the
order does not matter, so it's easy to edit the command prompt and
append a "-v", if that is what you want. Or if you really like verbose
output, then `export VERBOSE=y`.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 6abb6c0c73a0..bb73a771dfdc 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -100,7 +100,7 @@ usage() {
 	echo "OPTIONS:"
 	echo " -h|--help       : Print usage."
 	echo " -L|--list-tests : List test names and quit."
-	echo " -v              : Sets VERBOSE=y. Specifying tests without \"--\" enables verbose mode."
+	echo " -v              : Sets VERBOSE=y."
 	echo " -g              : Sets DUMPGEN=y."
 	echo " -V              : Sets VALGRIND=y."
 	echo " -K              : Sets KMEMLEAK=y."
@@ -218,10 +218,7 @@ while [ $# -gt 0 ] ; do
 			shift $#
 			;;
 		*)
-			# Any unrecognized option is treated as a test name, and also
-			# enable verbose tests.
 			TESTS+=( "$A" )
-			VERBOSE=y
 			;;
 	esac
 done
-- 
2.41.0

