Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF6ECD13D2
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 18:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjIRSrm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 14:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjIRSrm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 14:47:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A105111
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 11:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695062808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xklUDUs0uMfiyDW8EkKL2TYqVDwsLBvrk4DGZOa1lQo=;
        b=hrvLxR3Cq3YD6dT2lobnIqab/tcghFLhY9cWyAc/sTqKZGqkuCAcV3Czh4l73VzubYBWBM
        w5115/ajii8RB8htURUDtZFJXlMBwCRXx2dZgnAv+f9tAm5bV+3i9Z1mIrHrzSWYgUODzQ
        NncYWtgOS4Iy9daBT14Ns0duvQwqAUk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-6Vf9riQiMIem5LrR7fHeFg-1; Mon, 18 Sep 2023 14:46:47 -0400
X-MC-Unique: 6Vf9riQiMIem5LrR7fHeFg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA3DB29ABA05
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 18:46:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48081492B16;
        Mon, 18 Sep 2023 18:46:45 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/3] tests/shell: set C locale in "run-tests.sh"
Date:   Mon, 18 Sep 2023 20:45:19 +0200
Message-ID: <20230918184634.3471832-2-thaller@redhat.com>
In-Reply-To: <20230918184634.3471832-1-thaller@redhat.com>
References: <20230918184634.3471832-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The tests should run always the same, regardless of the user's language
settings. Set LANG=C and LC_ALL=C and unset LANGUAGE. If some part wants
to test a different language, it would set it explicitly. They anyway
wouldn't want to depend on something from the user's environment.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 528646f57eca..79c818cb0f11 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -1,5 +1,9 @@
 #!/bin/bash
 
+unset LANGUAGE
+export LANG=C
+export LC_ALL=C
+
 GREEN=""
 YELLOW=""
 RED=""
@@ -235,7 +239,7 @@ for file in "${F[@]}"; do
 		msg_warn "Ignore feature file \"$file\""
 	fi
 done
-_HAVE_OPTS=( $(printf '%s\n' "${_HAVE_OPTS[@]}" | LANG=C sort) )
+_HAVE_OPTS=( $(printf '%s\n' "${_HAVE_OPTS[@]}" | sort) )
 
 for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_' | sort) ; do
 	if ! array_contains "${KEY#NFT_TEST_HAVE_}" "${_HAVE_OPTS[@]}" ; then
@@ -336,7 +340,7 @@ while [ $# -gt 0 ] ; do
 done
 
 find_tests() {
-	find "$1" -type f -executable | LANG=C sort
+	find "$1" -type f -executable | sort
 }
 
 if [ "${#TESTS[@]}" -eq 0 ] ; then
-- 
2.41.0

