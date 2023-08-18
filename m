Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF951C71145
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 12:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359616AbjHRMik (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 08:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376969AbjHRMib (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 08:38:31 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3500A35AD
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 05:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qOssS47vHqBZp3ok358wBx4rvqg2lSQCcXbfE2RnPAw=; b=Yd1PCuFeG3lubFsnydfSDdjGvF
        ICgrN1RKXnhS8f+sMYddXS7YMCggkc+pv7S7BC9wjkFi2n+DJsv/9KnT+YD3qEokM5jJprMLhZNkJ
        wnzMSGATPAplScRHF8T4Y2ICaIjh46WNnco5h3UnTkJRJHff7z6U/XFVkX/CwOE2DeYJDO2z0iYGm
        fWFZca5IZ2PEbYyUHcU6P1EIbBDpzGxuRiIyJE7a8AL7WUUiCxvivmTwJ3OP/jGDf2/zyLVSX01F0
        iRpo7+SRnF+nkRHbIaPGFRh2gQD8lVpdxWeL3RYnMjTR/PIpUFXyhxQ9h9cFj0gtUpSE1Bp0YBoEg
        VumUdzqg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qWykC-005x0b-2x
        for netfilter-devel@vger.kernel.org;
        Fri, 18 Aug 2023 13:38:24 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 4/5] build: don't hard-code `AM_DEFAULT_VERBOSITY` in Makefile.iptrules
Date:   Fri, 18 Aug 2023 13:38:17 +0100
Message-Id: <20230818123818.2739947-5-jeremy@azazel.net>
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

Currently it is set to zero, which means that the default in
Makefile.iptrules is not consistent with that in the other Makefiles,
and passing `--disable-silent-rules` to configure cannot be used to
change it.

Set it to `@AM_DEFAULT_VERBOSITY@` instead, which will be expanded to the
appropriate default value.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.iptrules.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile.iptrules.in b/Makefile.iptrules.in
index 28feeb477e35..b0588d45f026 100644
--- a/Makefile.iptrules.in
+++ b/Makefile.iptrules.in
@@ -15,9 +15,9 @@ LDFLAGS         = @LDFLAGS@
 
 libxtables_CFLAGS = @libxtables_CFLAGS@
 libxtables_LIBS   = @libxtables_LIBS@
-AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
+AM_DEPFLAGS       = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 
-AM_DEFAULT_VERBOSITY = 0
+AM_DEFAULT_VERBOSITY = @AM_DEFAULT_VERBOSITY@
 am__v_CC_0           = @echo "  CC      " $@;
 am__v_CCLD_0         = @echo "  CCLD    " $@;
 am__v_GEN_0          = @echo "  GEN     " $@;
-- 
2.40.1

