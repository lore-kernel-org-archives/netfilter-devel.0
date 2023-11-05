Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD497C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 15:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjKEPLC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 10:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjKEPK7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 10:10:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89543D8
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 07:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699197009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lIYLwPbit+JO5bFgl5z5kC4/uaHpzXOp7HyoDFeb8PU=;
        b=Ze652NMZBdXTcdvU6CmfT/b/AHhQwEtzfai4tV0KWdUIBvtf6j2blpfOm+RNt0ggLTc/rW
        TCB2Pw6zbuu8HcxlmXfKlN8ht2IsKBwe2tweWm//EPB/Pr2cgVVTgVfCl60IM3yKA2aMHY
        nk98lnnj4ovkdfgN9AJ/UolArHaq3M0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-Cn3ZMKjpOOmUCKLrNoRMkg-1; Sun, 05 Nov 2023 10:10:07 -0500
X-MC-Unique: Cn3ZMKjpOOmUCKLrNoRMkg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F5C585A58A
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 15:10:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F108E492BFA;
        Sun,  5 Nov 2023 15:10:06 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 1/5] build: add basic "check-{local,more,all}" and "build-all" make targets
Date:   Sun,  5 Nov 2023 16:08:37 +0100
Message-ID: <20231105150955.349966-2-thaller@redhat.com>
In-Reply-To: <20231105150955.349966-1-thaller@redhat.com>
References: <20231105150955.349966-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add targets "check-local" and "check-more", which later will hook
up additional tests. For now, they are empty targets.

- with autotools, `make distcheck` implies `make check`.
- with autotools, `make check` implies `make check-local` and `make
  check-TESTS`.

Most tests should of course hook via `check-local` or via `TESTS=`
(`check-TESTS`). There is a small place for additional tests, in
particular "tests/build/run-tests.sh", which itself runs `make
distcheck`. So `make check-more` contains additional tests not run by
`make check`.

And `make check-all` just means `make check check-more`.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index 0ed831a19e95..93bd47970077 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,8 +31,11 @@ lib_LTLIBRARIES =
 noinst_LTLIBRARIES =
 sbin_PROGRAMS =
 check_PROGRAMS =
+check_LTLIBRARIES =
 dist_man_MANS =
 CLEANFILES =
+check_local =
+check_more =
 
 ###############################################################################
 
@@ -409,3 +412,23 @@ EXTRA_DIST += \
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnftables.pc
+
+###############################################################################
+
+build-all: all $(check_PROGRAMS) $(check_LTLIBRARIES)
+
+.PHONY: build-all
+
+###############################################################################
+
+check-local: build-all $(check_local)
+
+.PHONY: check-local $(check_local)
+
+check-more: build-all $(check_more)
+
+.PHONY: check-more $(check_more)
+
+check-all: check check-more
+
+.PHONY: check-all
-- 
2.41.0

