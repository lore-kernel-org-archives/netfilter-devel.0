Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DF1C63703
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiLHANZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLHANX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:13:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399CE8BD2B
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670458349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nebgbwWBcUeMzPdcCMltYB4FRwR9IqecRxZu52AQurA=;
        b=ffvZXSoxWhk8kreCeGFCGhqJyuHa4t7amQom8FSgP6cspQ4o02ICl7Pcho9ppO4WG/1SL2
        BOfjnr1zdREbRxHKRvIwUCnAs8m86ujqT8dVMJzlKY0ZUvJfjlUT8wyR9lPDh1iEsjEqcO
        DjEjWfQYYNP1pAxbVkZMWa12ng4xZNg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-TnyrEhwBMJCNPBqCOW1-tA-1; Wed, 07 Dec 2022 19:12:28 -0500
X-MC-Unique: TnyrEhwBMJCNPBqCOW1-tA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B16663813F3F;
        Thu,  8 Dec 2022 00:12:27 +0000 (UTC)
Received: from xic (unknown [10.39.192.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 416212027061;
        Thu,  8 Dec 2022 00:12:26 +0000 (UTC)
From:   Phil Sutter <psutter@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [libnetfilter_cthelper PATCH] Makefile: Create LZMA-compressed dist-files
Date:   Thu,  8 Dec 2022 01:12:19 +0100
Message-Id: <20221208001219.20219-1-psutter@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use a more modern alternative to bzip2.

Suggested-by: Jan Engelhardt <jengelh@inai.de>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <psutter@redhat.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 809842fe0c93b..333b2280ad389 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,7 +6,7 @@ AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADERS([config.h])
 
-AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2
+AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-xz
 	1.6 subdir-objects])
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
-- 
2.38.0

