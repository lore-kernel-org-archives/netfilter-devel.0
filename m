Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC538EE0205
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 13:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbjINNTW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 09:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239052AbjINNTH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 09:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E5911FEA
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 06:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694697456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hsAb35dNA2DzM8aiAhL75pHbz60vh2sRjfXcojy+Rsw=;
        b=jWZ0cOLKSiVrvNbikDqA2Fu+AozKBwmfV/YhX5gABKeke6zqWGZp+HCP/RQX0vXSbznrHE
        60ZNDT6jIB1DK1VWQ2J+fPDPvBuGTGRL27dXAktwbVjivbryisPaKTn19I0IVsXOxI/yCQ
        VB1jMgaRqiY09wLzEhEimOdJ2jd+nYs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-yGlte0H4Nu2bFtMaPXppqg-1; Thu, 14 Sep 2023 09:17:34 -0400
X-MC-Unique: yGlte0H4Nu2bFtMaPXppqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2B93101FAAD
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 13:17:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 228432026D4B;
        Thu, 14 Sep 2023 13:17:34 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] tests/shell: honor CLICOLOR_FORCE to force coloring in run-tests.sh
Date:   Thu, 14 Sep 2023 15:16:07 +0200
Message-ID: <20230914131723.4134745-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We honor NO_COLOR= to disable coloring, let's also honor CLICOLOR_FORCE=
to enable it.

The purpose will be for `make` calling the script and redirecting to a
file, while enabling colors.

See-also: https://bixense.com/clicolors/

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index f75505f7f1b4..bf5fc382ac04 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -4,11 +4,16 @@ GREEN=""
 YELLOW=""
 RED=""
 RESET=""
-if [[ -t 1 && -z "$NO_COLOR" ]] ; then
-	GREEN=$'\e[32m'
-	YELLOW=$'\e[33m'
-	RED=$'\e[31m'
-	RESET=$'\e[0m'
+if [ -z "$NO_COLOR" ] ; then
+	if [ -n "$CLICOLOR_FORCE" ] || [[ -t 1 ]] ; then
+		# See https://bixense.com/clicolors/ . We only check isatty() on
+		# file descriptor 1, to decide whether colorizing happens (although,
+		# we might also colorize on other places/FDs).
+		GREEN=$'\e[32m'
+		YELLOW=$'\e[33m'
+		RED=$'\e[31m'
+		RESET=$'\e[0m'
+	fi
 fi
 
 array_contains() {
-- 
2.41.0

