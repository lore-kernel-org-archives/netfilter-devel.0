Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576EEC83F2C
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352152AbjIEQ0d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354487AbjIEMBT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:01:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D271AD
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 04:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wWEonDPBuQbsbd3f7uY3ICDBxehDxTzezF05b3hqxUU=;
        b=HEr4Sm9C9k62hUGh1vqwkq6FmwqyU4AsGXCSk1fN19WD3lP0Vk6H/30uVykQvsemvE851X
        D1ePjnDM6ektD22McAje2+V0jkroPb82hR1TZqaHNzPQDluMwPs2l3TF1Uhdt3FwYoHSYd
        k/0EHqEg4gIsKlUJzS2trd8HPnkRwN0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-FogjuI8LNISLB4K1LE9K1g-1; Tue, 05 Sep 2023 07:59:51 -0400
X-MC-Unique: FogjuI8LNISLB4K1LE9K1g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4FC228EA6F7
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 454A61121314;
        Tue,  5 Sep 2023 11:59:50 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 05/17] tests/shell: normalize boolean configuration in environment variables
Date:   Tue,  5 Sep 2023 13:58:34 +0200
Message-ID: <20230905115936.607599-6-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previously, we would honor "y" as opt-in, and all other values meant
false.

- accept alternatives to "y", like "1" or "true".

- normalize the value, to either be "y" or "n".

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 03b4cd4f5805..84975a65243f 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -13,6 +13,24 @@ msg_info() {
 	echo "I: $1"
 }
 
+bool_y() {
+	case "$1" in
+		y|Y|yes|Yes|YES|1|true)
+			printf y
+			;;
+		'')
+			if [ $# -ge 2 ] ; then
+				printf "%s" "$2"
+			else
+				printf n
+			fi
+			;;
+		*)
+			printf n
+			;;
+	esac
+}
+
 usage() {
 	echo " $0 [OPTIONS]"
 	echo
@@ -51,10 +69,10 @@ if [ "${1}" != "run" ]; then
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

