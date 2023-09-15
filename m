Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1776AEED615
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Sep 2023 15:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjIOPgo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Sep 2023 11:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbjIOPgR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2023 11:36:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23E48E50
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 08:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694792130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idDuo/kZPWVN+2oI5PADmm+G+oezu3yOQLKQQ5OvAJo=;
        b=GM0jQVPStsx/ZBb1g0ExjgfB8zZJNnLKUEKD9O7MCYZeWX87DsLvoc9JVtLUl3DwhweJwk
        qqJS1+GUSo60GoDEez4cqcXJR2oC7CZn14UTJN+HmBKlYaAfZUyClbKF2lgGkSod9Si2y2
        nIz10gwOSQEYZ1wt2R6+EpCYfXQtmGg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-IlnedXYJMz6q43NnDFQ_kg-1; Fri, 15 Sep 2023 11:35:28 -0400
X-MC-Unique: IlnedXYJMz6q43NnDFQ_kg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71340949A01
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 15:35:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2E922026D4B;
        Fri, 15 Sep 2023 15:35:27 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] tests/shell: colorize NFT_TEST_SKIP_/NFT_TEST_HAVE_ in test output
Date:   Fri, 15 Sep 2023 17:32:36 +0200
Message-ID: <20230915153515.1315886-3-thaller@redhat.com>
In-Reply-To: <20230915153515.1315886-1-thaller@redhat.com>
References: <20230915153515.1315886-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Having a "SKIP" option as "y" or a "HAVE" option as "n", is note worthy
because tests may be skipped based on that.

Colorize, to make it easier to see in the test output.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 01a312d0ee2c..1527b2a6455c 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -571,11 +571,19 @@ msg_info "conf: NFT_TEST_SHUFFLE_TESTS=$NFT_TEST_SHUFFLE_TESTS"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 echo
 for KEY in $(compgen -v | grep '^NFT_TEST_SKIP_' | sort) ; do
-	msg_info "conf: $KEY=$(printf '%q' "${!KEY}")"
+	v="${!KEY}"
+	if [ "$v" = y ] ; then
+		v="$YELLOW$v$RESET"
+	fi
+	msg_info "conf: $KEY=$v"
 	export "$KEY"
 done
 for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_' | sort) ; do
-	msg_info "conf: $KEY=$(printf '%q' "${!KEY}")"
+	v="${!KEY}"
+	if [ "$v" = n ] ; then
+		v="$YELLOW$v$RESET"
+	fi
+	msg_info "conf: $KEY=$v"
 	export "$KEY"
 done
 
-- 
2.41.0

