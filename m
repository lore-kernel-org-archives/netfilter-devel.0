Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09AFC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 11:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjKCLMP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 07:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjKCLMO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 07:12:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6A6D43
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 04:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699009877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DMh26LiZ3YqlGuQUvIUrKY5srmaBAnvMPvKz0tXDook=;
        b=SLTSmRWI470337MfQKIMU/BfK+7gGQGanFb2NGfkp9/9uYPRzoT1ew0UVboKsbCXIR27W1
        N8FRW8IrlIVkmz6xvN/b75oS2fUvlpZ6uJNBpGye8zScqmuITz3yUi5/oExAd0EK/3FhO7
        0w2kIghlVpgVnMRK4Lk45SlZ8AvBlyg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-UzgojzXrPRKa3AcFKbvnLw-1; Fri, 03 Nov 2023 07:11:15 -0400
X-MC-Unique: UzgojzXrPRKa3AcFKbvnLw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0073481B161
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 11:11:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74D671C060BA;
        Fri,  3 Nov 2023 11:11:14 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/6] build: add basic "check-{local,more,all}" and "build-all" make targets
Date:   Fri,  3 Nov 2023 12:05:44 +0100
Message-ID: <20231103111102.2801624-3-thaller@redhat.com>
In-Reply-To: <20231103111102.2801624-1-thaller@redhat.com>
References: <20231103111102.2801624-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add targets "check-local" and "check-more", which later will hook
up additional tests. For now, they are empty targets.

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

