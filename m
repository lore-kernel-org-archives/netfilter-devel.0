Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21207C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 15:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjKEPLA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 10:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjKEPK7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 10:10:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073F4D9
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 07:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699197010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBqvhMUqWTfrVsi8m2wo7qGXb9pvTeAKTMdaPqZT7UI=;
        b=hkAVz/4ah/E4MfOyp98Fno2Hzf7p4PgKKcWCiYUgKXjb8Jf65kQvm8Mf6+b7aW0ugzrrAK
        /GCFMTaQZT+aMe3HN9EXEBvTLk2hxA3JxLP2U9GdOihoDuSOraz+c0S9UmZofWN+gTirV5
        /tWtcMyKyBqc2JBV1Q/aKUWPry8IN+A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-HbBa_BWeP3GA7a4YXW6oxA-1; Sun, 05 Nov 2023 10:10:08 -0500
X-MC-Unique: HbBa_BWeP3GA7a4YXW6oxA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49319810FC1
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 15:10:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB5E6492BFA;
        Sun,  5 Nov 2023 15:10:07 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 2/5] build: add `make check-build` to run `./tests/build/run-tests.sh`
Date:   Sun,  5 Nov 2023 16:08:38 +0100
Message-ID: <20231105150955.349966-3-thaller@redhat.com>
In-Reply-To: <20231105150955.349966-1-thaller@redhat.com>
References: <20231105150955.349966-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`./tests/build/run-tests.sh` performs a build check. Integrate it in
make as `make check-build` target.

`make check-build` is hooked into `make check-more`, which in turn is
hooked as `make check-all`.

Note that this is intentionally not part of `make check`, because `make
check` is run by `make distcheck`, and the build test itself calls `make
distcheck`. Even if that cycle would be resolved, doing a build check
several times during `make check` seems wrong and would add another
minute to the test runtime.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index 93bd47970077..6a0b04641afc 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -421,6 +421,14 @@ build-all: all $(check_PROGRAMS) $(check_LTLIBRARIES)
 
 ###############################################################################
 
+check-build: build-all
+	cd "$(srcdir)/tests/build/" ; \
+	CC="$(CC)" CFLAGS='-Werror' ./run-tests.sh
+
+check_more += check-build
+
+###############################################################################
+
 check-local: build-all $(check_local)
 
 .PHONY: check-local $(check_local)
-- 
2.41.0

