Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB209C04A94
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Aug 2023 10:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjHFKW6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Aug 2023 06:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjHFKWz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Aug 2023 06:22:55 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF191BD4
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Aug 2023 03:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=soOSsrF+vMQmEwevdfqLoZwPEELl/NhBSKRp3X89oy8=; b=j06IsS59CXDitMKRoejXElNwIE
        e10gO8e9H02ef/NxfcJ0C6a2c8tNMEwTZlhsfelpLNhr81BzzZO/RdPCaihlGHw7HNI9Z9t1NS5mb
        J5JyO1rnj7qmOzz1iaBMq7DEfgiPGl5zMLvQ0KaAtebL+7e1+RuMQgliVWh4eUQ6vIJys3UdzKXu+
        UV14RTnEXwfw0akdfdcOBC3QiHv4ve5i5Vlr1U02eR0Eq7Pvb6ortDKcOx8bXXnxf3H5JopnzDd8a
        Y34VO89AgFyVT13QVbVDpHcaHFEjNNDb0gRo3j+fyJZJXPvZhWJq9twtEptpiZ+Jt19Wecz5b3nvn
        N34NSYxA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qSauR-005mug-1O
        for netfilter-devel@vger.kernel.org;
        Sun, 06 Aug 2023 11:22:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 1/2] doc: move man-pages to `dist_man_MANS`
Date:   Sun,  6 Aug 2023 11:22:47 +0100
Message-Id: <20230806102248.3517776-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230806102248.3517776-1-jeremy@azazel.net>
References: <20230806102248.3517776-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Removes the need to add them to `EXTRA_DIST`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/Makefile.am | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/doc/Makefile.am b/doc/Makefile.am
index 21482320e418..5a64e39b48cf 100644
--- a/doc/Makefile.am
+++ b/doc/Makefile.am
@@ -1,5 +1,5 @@
 if BUILD_MAN
-man_MANS = nft.8 libnftables-json.5 libnftables.3
+dist_man_MANS = nft.8 libnftables-json.5 libnftables.3
 
 A2X_OPTS_MANPAGE = -L --doctype manpage --format manpage -D ${builddir}
 
@@ -12,7 +12,7 @@ ASCIIDOC_INCLUDES = \
        statements.txt
 ASCIIDOCS = ${ASCIIDOC_MAIN} ${ASCIIDOC_INCLUDES}
 
-EXTRA_DIST = ${ASCIIDOCS} ${man_MANS} libnftables-json.adoc libnftables.adoc
+EXTRA_DIST = ${ASCIIDOCS} libnftables-json.adoc libnftables.adoc
 
 CLEANFILES = \
 	*~
@@ -26,5 +26,5 @@ nft.8: ${ASCIIDOCS}
 .adoc.5:
 	${AM_V_GEN}${A2X} ${A2X_OPTS_MANPAGE} $<
 
-CLEANFILES += ${man_MANS}
+CLEANFILES += ${dist_man_MANS}
 endif
-- 
2.40.1

