Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8B1EC875D
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbjIGWKc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbjIGWKc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:10:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B221BD6
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WsAjjTR0dF1l/kivAtXilgwtm02gadSuwZIdMrf/k5o=;
        b=Z1GODcxHR7bmcY7xApqRZhDTPHRstDYwrtIdfenQyLhXojfBOuzersCZx5lOT7J12I2dXc
        WyhlZH5FsHXm5NWx7X0RDlc/7dfOt9LvCG6U0Ws7vMt0EAFcedRPV6wgTNlHPT1XoHBQ0L
        ASTvztX5l/wxcAiqveist1oJGPE1Igg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-FtGDooY9NxWcao-O5WkhCw-1; Thu, 07 Sep 2023 18:08:49 -0400
X-MC-Unique: FtGDooY9NxWcao-O5WkhCw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CF222820543
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AAA587B62;
        Thu,  7 Sep 2023 22:08:48 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 06/11] tests/shell: don't redirect error/warning messages to stderr
Date:   Fri,  8 Sep 2023 00:07:18 +0200
Message-ID: <20230907220833.2435010-7-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Writing some messages to stderr and some to stdout is not helpful.
Once they are written to separate streams, it's hard to be sure about
their relative order.

Use grep to filter messages.

Also, next we will redirect the entire output also to a file. There the
output is also not split in two files.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 4f0df3217b76..e4efbb2de540 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -16,9 +16,9 @@ _msg() {
 	shift
 
 	if [ "$level" = E ] ; then
-		printf '%s\n' "$RED$level$RESET: $*" >&2
+		printf '%s\n' "$RED$level$RESET: $*"
 	elif [ "$level" = W ] ; then
-		printf '%s\n' "$YELLOW$level$RESET: $*" >&2
+		printf '%s\n' "$YELLOW$level$RESET: $*"
 	else
 		printf '%s\n' "$level: $*"
 	fi
-- 
2.41.0

