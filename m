Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9487C0018A
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 15:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjKEPLC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 10:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjKEPK7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 10:10:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E6CE1
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 07:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699197012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pFdaC3e0mGs/f1xtc58o2gIDTFWj/uB7Jz6U47uRiDY=;
        b=K0/0NTe3OVo17FDTTXnkMY6IrzIzFJc9wvTZgGzM5siRQBu7m3azIYD2NZQozu2fJIUx9n
        r7Rw5TBGI25Df3dSnZkPBc+2JPE7hOTCe2cLoCDp+/U/pvYi/ZTwIEXCMPf2eAWBdb75GP
        thfpVaHwhyk1Fl8KgNEAuVOD/ul1m/M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-oldow4ndNEeoh0QNJzV52g-1; Sun,
 05 Nov 2023 10:10:09 -0500
X-MC-Unique: oldow4ndNEeoh0QNJzV52g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 140B629ABA11
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 15:10:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 851FF492BFA;
        Sun,  5 Nov 2023 15:10:08 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 3/5] build: add `make check-tree` to check consistency of source tree
Date:   Sun,  5 Nov 2023 16:08:39 +0100
Message-ID: <20231105150955.349966-4-thaller@redhat.com>
In-Reply-To: <20231105150955.349966-1-thaller@redhat.com>
References: <20231105150955.349966-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The script "tools/check-tree.sh" performs some consistency checks of the
source tree. Call it from a make target "check-tree".

Note that `make check-tree` is hooked into `make check-local`, which in
turn is hooked into `make check` and `make distcheck`.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index 6a0b04641afc..48d138636d2f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -408,6 +408,7 @@ EXTRA_DIST += \
 EXTRA_DIST += \
 	files \
 	tests \
+	tools \
 	$(NULL)
 
 pkgconfigdir = $(libdir)/pkgconfig
@@ -421,6 +422,13 @@ build-all: all $(check_PROGRAMS) $(check_LTLIBRARIES)
 
 ###############################################################################
 
+check-tree:
+	"$(srcdir)/tools/check-tree.sh"
+
+check_local += check-tree
+
+###############################################################################
+
 check-build: build-all
 	cd "$(srcdir)/tests/build/" ; \
 	CC="$(CC)" CFLAGS='-Werror' ./run-tests.sh
-- 
2.41.0

