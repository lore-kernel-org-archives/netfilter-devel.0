Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9060C71143
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 12:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359605AbjHRMii (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 08:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376967AbjHRMia (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 08:38:30 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3515C35B8
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 05:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1M8yCF0H0CM5LGdhWtskvLY0bB1nDoh/VISRJGE1AfU=; b=RQLsxyADGZlJJuRoMHZOKJF7qd
        OzJTloaeZeFIHxU1jcNaXPo9TRx2fx7CsdUmMxMWydgLkqqo7asoY15dhN7zmEMDYsDrRQ1p4K6lp
        KXLOZPC9apertodARe9kkh2FtVcriCijsvGoYB49ryFcJXM0GtHnPosf1CZ8wIK0R4MgRgS/ryBRW
        sePNPsPTQlh39whOK2qHTj5mibYeIOw/D8mezFTqhek1ijnUN5kHvelgQNvjBFA1603Q+xWgQsbPw
        CRXyJnL5l/SElXnb2/Fwxe6JVci7GLhzlcExj7lR2ikKEbphe1XWOW1UkSVACa2N0bPyazTF5+PAi
        oNGv2org==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qWykC-005x0b-35
        for netfilter-devel@vger.kernel.org;
        Fri, 18 Aug 2023 13:38:24 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 5/5] build: define `AM_V_GEN` where it is needed
Date:   Fri, 18 Aug 2023 13:38:18 +0100
Message-Id: <20230818123818.2739947-6-jeremy@azazel.net>
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

`AM_V_GEN` is used when generating the man-pages.  Defining it in
Makefile.iptrules is of no use.  Move the definition to the appropriate
Makefile.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.iptrules.in | 3 ---
 Makefile.mans.in     | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile.iptrules.in b/Makefile.iptrules.in
index b0588d45f026..7e5816451736 100644
--- a/Makefile.iptrules.in
+++ b/Makefile.iptrules.in
@@ -20,13 +20,10 @@ AM_DEPFLAGS       = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 AM_DEFAULT_VERBOSITY = @AM_DEFAULT_VERBOSITY@
 am__v_CC_0           = @echo "  CC      " $@;
 am__v_CCLD_0         = @echo "  CCLD    " $@;
-am__v_GEN_0          = @echo "  GEN     " $@;
 am__v_CC_            = ${am__v_CC_@AM_DEFAULT_V@}
 am__v_CCLD_          = ${am__v_CCLD_@AM_DEFAULT_V@}
-am__v_GEN_           = ${am__v_GEN_@AM_DEFAULT_V@}
 AM_V_CC              = ${am__v_CC_@AM_V@}
 AM_V_CCLD            = ${am__v_CCLD_@AM_V@}
-AM_V_GEN             = ${am__v_GEN_@AM_V@}
 
 include ${XA_TOPSRCDIR}/mconfig
 -include ${XA_TOPSRCDIR}/mconfig.*
diff --git a/Makefile.mans.in b/Makefile.mans.in
index 63424f7d558a..60459cb98c83 100644
--- a/Makefile.mans.in
+++ b/Makefile.mans.in
@@ -8,6 +8,11 @@ wcman_targets := $(shell find "${srcdir}/extensions" -name 'libxt_[A-Z]*.man' -p
 wlist_matches := $(patsubst ${srcdir}/libxt_%.man,%,${wcman_matches})
 wlist_targets := $(patsubst ${srcdir}/libxt_%.man,%,${wcman_targets})
 
+AM_DEFAULT_VERBOSITY = @AM_DEFAULT_VERBOSITY@
+am__v_GEN_0          = @echo "  GEN     " $@;
+am__v_GEN_           = ${am__v_GEN_@AM_DEFAULT_V@}
+AM_V_GEN             = ${am__v_GEN_@AM_V@}
+
 .PHONY: FORCE
 
 FORCE:
-- 
2.40.1

