Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EAECA553E
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 13:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbjINNPb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 09:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbjINNPb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 09:15:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BE051FD5
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 06:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694697280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rJibnSYOx8CSgDDpYg9Wzogd2TaKzNYtuMlbIv8vNsE=;
        b=XxExX6pkaJ08PCdmdf4L3q1ljR+6lQi0LgKw/OhAWeHDOAG/Ia55C6zVHgXK7B5ygPoc0a
        +oyjE1XEizOqB23sljFTVoH/Ja8U/Zs08J05HzL+XrHe0B76XaVKBhjQ0FA2UXZnivsgag
        6MhAc/qz/xEOlJX2qPhs1zkNC4BU0SU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-ekd9TXbKNPe4Ydb0Tls2lA-1; Thu, 14 Sep 2023 09:14:38 -0400
X-MC-Unique: ekd9TXbKNPe4Ydb0Tls2lA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A605E805B29
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 13:14:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2595121B2413;
        Thu, 14 Sep 2023 13:14:38 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] tests/build: capture more output from "tests/build/run-tests.sh" script
Date:   Thu, 14 Sep 2023 15:14:02 +0200
Message-ID: <20230914131427.4134576-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dropping stdout for various build tests makes it hard to understand what
happens, when a build fails. Redirect both stdout and stderr to the log
files for easier debugging.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/build/run-tests.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
index 6d1f61463029..0a33f0a72d27 100755
--- a/tests/build/run-tests.sh
+++ b/tests/build/run-tests.sh
@@ -20,21 +20,21 @@ fi
 # working, no need to also run the extensive tests here.
 export NFT_TEST_SKIP_CHECK_LOCAL_SHELL=y
 
-git clone "$dir" "$tmpdir" >/dev/null 2>>"$log_file"
+git clone "$dir" "$tmpdir" &>>"$log_file"
 cd "$tmpdir" || exit
 
-if ! autoreconf -fi >"$log_file" 2>>"$log_file" ; then
+if ! autoreconf -fi &>>"$log_file" ; then
 	echo "Something went wrong. Check the log '${log_file}' for details."
 	exit 1
 fi
 
-if ! ./configure >"$log_file" 2>>"$log_file" ; then
+if ! ./configure &>>"$log_file" ; then
 	echo "Something went wrong. Check the log '${log_file}' for details."
 	exit 1
 fi
 
 echo  "Testing build with distcheck"
-if ! make distcheck >/dev/null 2>>"$log_file" ; then
+if ! make distcheck &>>"$log_file" ; then
 	echo "Something went wrong. Check the log '${log_file}' for details."
 	exit 1
 fi
@@ -44,8 +44,8 @@ echo "Build works. Now, testing compile options"
 
 for var in "${argument[@]}" ; do
 	echo "[EXECUTING] Testing compile option $var"
-	./configure "$var" >/dev/null 2>>"$log_file"
-	make -j 8 >/dev/null 2>>"$log_file"
+	./configure "$var" &>>"$log_file"
+	make -j 8 &>>"$log_file"
 	rt=$?
 	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 
-- 
2.41.0

