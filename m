Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17E1C4167B
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 11:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjKCLMM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 07:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjKCLML (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 07:12:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7128A1BF
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 04:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699009877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knrR0jUrzRdrVY2OqFasxlya4annWwkL6Gg9dhcAOwA=;
        b=ihZs/bbLIXHivcZ1x4VsSzAPEqUYpuOZ5tyblHLZrVKCGiVgVDLHaK2vnEokxMndRfetTl
        2PJUoWJ1LWdZ9hGvtXXS4sylaE9WJmZmVbEJl9y+AmSq4SjBMri2MNOsc0gYerPLQaOGQd
        8ahRWF4BUc3MNEYJujduMdBApSvYFyI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-G3_dutjEP-aJ-FxZevpiQw-1; Fri, 03 Nov 2023 07:11:16 -0400
X-MC-Unique: G3_dutjEP-aJ-FxZevpiQw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC983185A780
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 11:11:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C46B1C060BA;
        Fri,  3 Nov 2023 11:11:15 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/6] build: add `make check-tests-build` to add build test
Date:   Fri,  3 Nov 2023 12:05:45 +0100
Message-ID: <20231103111102.2801624-4-thaller@redhat.com>
In-Reply-To: <20231103111102.2801624-1-thaller@redhat.com>
References: <20231103111102.2801624-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call "./tests/build/run-tests.sh" from a new make target
"check-tests-build". This script performs the build check.

As this script takes a rather long time, it's not hooked with
"check-local", and consequently not run by `make check`. Instead, it is
a dependency of `make check-more`.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index 93bd47970077..f39d6cdd0ca3 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -421,6 +421,14 @@ build-all: all $(check_PROGRAMS) $(check_LTLIBRARIES)
 
 ###############################################################################
 
+check-tests-build: build-all
+	cd "$(srcdir)/tests/build/" ; \
+	CC="$(CC)" CFLAGS='-Werror' ./run-tests.sh
+
+check_more += check-tests-build
+
+###############################################################################
+
 check-local: build-all $(check_local)
 
 .PHONY: check-local $(check_local)
-- 
2.41.0

