Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23B6C7112B
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 12:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359597AbjHRMii (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 08:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376968AbjHRMia (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 08:38:30 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE3A2D68
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 05:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P+dm+xjKXCXaULBDUltSQn3zGeRu/EgRm9wAEXa+G/A=; b=EWl3jAFNrWvOAoaTbh2QP88Z0Q
        BExCqIspK8az/b54+SxdsGLRWIKwvB6UbnGdz2g4FBR7hCVwTOvaveIM3faM4prYHLkRrPA3ZVgUM
        xuSc9nL8NocoYzssbcuSigB/I7gK7iPNi7qXQmf1/r1tyIzUxxzknOFRaXR1Y+R8EJYG44CFvpY1U
        3jfQJED/V4kkjJSiNTzSwFdvuu3oRj+dqilwHM94Ig4bbISZOyPXgQob6DX4qiJ6vI/Q7YrXBex2e
        fzz1EkfcLsueaxY6PFwxemlFmxRioCRrjyD6l2R+drSIs4FlqgbwNOzmBpDN0McyjP8AH+sCM7Hzf
        nX5RsmnQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qWykC-005x0b-2f
        for netfilter-devel@vger.kernel.org;
        Fri, 18 Aug 2023 13:38:24 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 2/5] build: replace `AM_V_silent` with `AM_V_at`
Date:   Fri, 18 Aug 2023 13:38:15 +0100
Message-Id: <20230818123818.2739947-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230818123818.2739947-1-jeremy@azazel.net>
References: <20230818123818.2739947-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`AM_V_silent` was buggy and defined in the wrong place.  Replace it with
`AM_V_at`, which is provided by automake for the same purpose.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.iptrules.in   | 3 ---
 extensions/Makefile.am | 6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/Makefile.iptrules.in b/Makefile.iptrules.in
index fcac8856283d..f2f202ada360 100644
--- a/Makefile.iptrules.in
+++ b/Makefile.iptrules.in
@@ -21,15 +21,12 @@ AM_DEFAULT_VERBOSITY = 0
 am__v_CC_0           = @echo "  CC    " $@;
 am__v_CCLD_0         = @echo "  CCLD  " $@;
 am__v_GEN_0          = @echo "  GEN   " $@;
-am__v_SILENT_0       = @
 am__v_CC_            = ${am__v_CC_${AM_DEFAULT_VERBOSITY}}
 am__v_CCLD_          = ${am__v_CCLD_${AM_DEFAULT_VERBOSITY}}
 am__v_GEN_           = ${am__v_GEN_${AM_DEFAULT_VERBOSITY}}
-am__v_SILENT_        = ${am__v_SILENT_${AM_DEFAULT_VERBOSITY}}
 AM_V_CC              = ${am__v_CC_${V}}
 AM_V_CCLD            = ${am__v_CCLD_${V}}
 AM_V_GEN             = ${am__v_GEN_${V}}
-AM_V_silent          = ${am__v_GEN_${V}}
 
 include ${XA_TOPSRCDIR}/mconfig
 -include ${XA_TOPSRCDIR}/mconfig.*
diff --git a/extensions/Makefile.am b/extensions/Makefile.am
index eebb82fd2f22..b99712dfcd38 100644
--- a/extensions/Makefile.am
+++ b/extensions/Makefile.am
@@ -12,13 +12,13 @@ _kcall = -C ${kbuilddir} M=${abs_srcdir}
 modules:
 	@echo -n "Xtables-addons ${PACKAGE_VERSION} - Linux "
 	@if [ -n "${kbuilddir}" ]; then ${MAKE} ${_kcall} --no-print-directory -s kernelrelease; fi;
-	${AM_V_silent}if [ -n "${kbuilddir}" ]; then ${MAKE} ${_kcall} modules; fi;
+	${AM_V_at}if [ -n "${kbuilddir}" ]; then ${MAKE} ${_kcall} modules; fi;
 
 modules_install:
-	${AM_V_silent}if [ -n "${kbuilddir}" ]; then ${MAKE} ${_kcall} INSTALL_MOD_PATH=${DESTDIR} ext-mod-dir='$${INSTALL_MOD_DIR}' modules_install; fi;
+	${AM_V_at}if [ -n "${kbuilddir}" ]; then ${MAKE} ${_kcall} INSTALL_MOD_PATH=${DESTDIR} ext-mod-dir='$${INSTALL_MOD_DIR}' modules_install; fi;
 
 clean_modules:
-	${AM_V_silent}if [ -n "${kbuilddir}" ]; then ${MAKE} ${_kcall} clean; fi;
+	${AM_V_at}if [ -n "${kbuilddir}" ]; then ${MAKE} ${_kcall} clean; fi;
 
 all-local: modules
 
-- 
2.40.1

