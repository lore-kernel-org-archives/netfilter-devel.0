Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C93EB8FB9
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237430AbjIFMDC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbjIFMDB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:03:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B471732
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NLcmHuFsU0aXBqTWOE1vfNSg4PARhD/Oez0rpI2lUCc=;
        b=XI3WXLnGYBlgUH84i3FqNT6cEKQXcLzCIGxThxoXnrANDzOWcqRwq1oKyHQmXntK1bwpmD
        b76zj4p5byK55QQRpk436kpMOaGCMJNwoit6rv9AB4uBjx62uODk9ajIUI2I3jzAIg+21z
        we1iLrhKcgEQHLZwk8nQP0xCpBFCE3c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-856rxoWJNyeFLu2ajJw-2w-1; Wed, 06 Sep 2023 08:01:34 -0400
X-MC-Unique: 856rxoWJNyeFLu2ajJw-2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 338C3805BFB
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A807FC15BB8;
        Wed,  6 Sep 2023 12:01:33 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 18/19] tests/shell: fix "0003includepath_0" for different TMPDIR
Date:   Wed,  6 Sep 2023 13:52:21 +0200
Message-ID: <20230906120109.1773860-19-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We are going to set $TMPDIR to another location. The previous code made
assumptions that the generated path would always be in /tmp. Fix that.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/include/0003includepath_0 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/include/0003includepath_0 b/tests/shell/testcases/include/0003includepath_0
index ba722068b363..20037a8f0279 100755
--- a/tests/shell/testcases/include/0003includepath_0
+++ b/tests/shell/testcases/include/0003includepath_0
@@ -8,7 +8,7 @@ if [ ! -w $tmpfile1 ] ; then
         exit 0
 fi
 
-tmpfile3=$(echo "$tmpfile1" | cut -d'/' -f 3)
+tmpfile3="$(basename "$tmpfile1")"
 
 tmpfile2=$(mktemp)
 if [ ! -w $tmpfile2 ] ; then
@@ -24,7 +24,7 @@ RULESET2="include \"$tmpfile3\""
 echo "$RULESET1" > $tmpfile1
 echo "$RULESET2" > $tmpfile2
 
-$NFT -I /tmp -f $tmpfile2
+$NFT -I "$(dirname "$tmpfile1")" -f $tmpfile2
 if [ $? -ne 0 ] ; then
 	echo "E: unable to load good ruleset" >&2
 	exit 1
-- 
2.41.0

