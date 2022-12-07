Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9AFC352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiLGRpS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiLGRpO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:45:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34265CD04
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Yx0leTgAXTFvqyiI+jLJ6+LvVrqH5ZasJPNY8UF0Z/Q=; b=Dby03Ngff9e40LGNVy3UUvrYdk
        kwQ/7AQLUujheQ4X0P6Kbp1n5BRPRabIEbKE68pNe/ZlgEqkkUkC3faoF20N3nLp5iMnr94CNqBn+
        OqyH5ZkU6/5C1rIrj/HUb8ZBcfBcTqe9KOoOV3Y4lSY3KmKqQ6sTX6e3f+5aImZoqZPGkmvHl6trf
        3JMRyoEgzaSmfw9GIMl80lPOOuMjVLY4WodiykNDu678/5Ni6divh7j8oraE9krbLUR6X085JlepI
        47lBf6T5ggHXs2EJDyGYQ745hH58nN9fzTY3fUyFMGHD4fuOKILmrSup0QUbuZy29aI4UadtaYxJF
        WP5EnnYg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yTn-0000hQ-8e
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:45:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/11] include/Makefile: xtables-version.h is generated
Date:   Wed,  7 Dec 2022 18:44:28 +0100
Message-Id: <20221207174430.4335-10-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221207174430.4335-1-phil@nwl.cc>
References: <20221207174430.4335-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

List it in nodist_include_HEADERS so it is installed but not
distributed - configure generates it from xtables-version.h.in.

While being at it, list xtables.h in plain include_HEADERS. It doesn't
sit in a sub-dir, so the nobase prefix does not make a difference.

Fixes: df60a301bf24c ("build: separate AC variable replacements from xtables.h")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/Makefile.am | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/Makefile.am b/include/Makefile.am
index 348488a45ce84..07c88b901e808 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,13 +1,13 @@
 # -*- Makefile -*-
 
-include_HEADERS =
-nobase_include_HEADERS = xtables.h xtables-version.h
+include_HEADERS = xtables.h
+nodist_include_HEADERS = xtables-version.h
 
 if ENABLE_LIBIPQ
 include_HEADERS += libipq/libipq.h
 endif
 
-nobase_include_HEADERS += \
+nobase_include_HEADERS = \
 	libiptc/ipt_kernel_headers.h libiptc/libiptc.h \
 	libiptc/libip6tc.h libiptc/libxtc.h libiptc/xtcshared.h
 
-- 
2.38.0

