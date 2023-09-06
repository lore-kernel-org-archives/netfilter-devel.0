Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B934CEB8FB6
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbjIFMCw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjIFMCw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E82CF2
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vm/EVH9a7hNrvVDVDPKcIALHfCryVHtKFF3s/nOf1go=;
        b=B4KMAW2Blc5eqoKLEx1EYXQASWuWQNqls0vdQtX+4cGV3xAb/0wq53HUdXV9TDWg3hvzpt
        3+JSUbkvtzwvoLio3Di3T61xfqk92M+i13MxPx69AIgRv+DTaW3fRZXBZ1WakVu7h+GYWp
        Yy3Cl1sOWsHU5GZ2MAdLzFPtkfEZ7co=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-jHcFPPebNKeQqJCo1c-R4Q-1; Wed, 06 Sep 2023 08:01:24 -0400
X-MC-Unique: jHcFPPebNKeQqJCo1c-R4Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB90238149B9
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C03DC15BB8;
        Wed,  6 Sep 2023 12:01:23 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 05/19] tests/shell: normalize boolean configuration in environment variables
Date:   Wed,  6 Sep 2023 13:52:08 +0200
Message-ID: <20230906120109.1773860-6-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previously, we would honor "y" as opt-in, and all other values meant
false.

- accept alternatives to "y", like "1" or "true".

- normalize the value, to either be "y" or "n".

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 65aa041febb2..905fa0c10309 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -13,6 +13,17 @@ msg_info() {
 	echo "I: $1"
 }
 
+bool_y() {
+	case "$1" in
+		y|Y|yes|Yes|YES|1|true|True|TRUE)
+			printf y
+			;;
+		*)
+			printf n
+			;;
+	esac
+}
+
 usage() {
 	echo " $0 [OPTIONS] [TESTS...]"
 	echo
@@ -57,10 +68,10 @@ if [ "${1}" != "run" ]; then
 fi
 shift
 
-VERBOSE="$VERBOSE"
-DUMPGEN="$DUMPGEN"
-VALGRIND="$VALGRIND"
-KMEMLEAK="$KMEMLEAK"
+VERBOSE="$(bool_y "$VERBOSE")"
+DUMPGEN="$(bool_y "$DUMPGEN")"
+VALGRIND="$(bool_y "$VALGRIND")"
+KMEMLEAK="$(bool_y "$KMEMLEAK")"
 DO_LIST_TESTS=
 
 TESTS=()
-- 
2.41.0

