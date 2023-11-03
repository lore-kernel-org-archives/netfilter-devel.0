Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D9FC0018A
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 11:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjKCLMN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 07:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjKCLMN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 07:12:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B5518B
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 04:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699009878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=96anuPFrO5gsM8CHmLpFB1X3aSARSwSEMh7SFENNt/w=;
        b=EDV7JeVHl8CEPf3/jyfAJ3CUHfwZa8aXPl2CeZGG0BLNc30zspAgrcrFGY3D9VrL1kdwFo
        TqLHtzn7MI2wZBZHMl554ei4BHYCZ/pFeCRGRnk6RTbEkD8INd7/wjxxnvd9yUe6SciBll
        EFrZ6qCVPtz4+5hXgpgy3cvVPMeuz5k=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-XxOot2TtNpKSdOE6bErrFQ-1; Fri,
 03 Nov 2023 07:11:16 -0400
X-MC-Unique: XxOot2TtNpKSdOE6bErrFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8344B1C05132
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 11:11:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 038741C060BA;
        Fri,  3 Nov 2023 11:11:15 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 4/6] build: add check for consistency of source tree
Date:   Fri,  3 Nov 2023 12:05:46 +0100
Message-ID: <20231103111102.2801624-5-thaller@redhat.com>
In-Reply-To: <20231103111102.2801624-1-thaller@redhat.com>
References: <20231103111102.2801624-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The script "tools/check-tree.sh" performs some consistency checks of the
source tree. Call it from a make target "check-tree".

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 Makefile.am | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index f39d6cdd0ca3..94c40fc3c6a2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -408,6 +408,7 @@ EXTRA_DIST += \
 EXTRA_DIST += \
 	files \
 	tests \
+	tools \
 	$(NULL)
 
 pkgconfigdir = $(libdir)/pkgconfig
@@ -429,6 +430,13 @@ check_more += check-tests-build
 
 ###############################################################################
 
+check-tree:
+	"$(srcdir)/tools/check-tree.sh"
+
+check_local += check-tree
+
+###############################################################################
+
 check-local: build-all $(check_local)
 
 .PHONY: check-local $(check_local)
-- 
2.41.0

