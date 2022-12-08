Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90075C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 15:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiLHPrb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiLHPr3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 10:47:29 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249FB59157
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 07:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Yx0leTgAXTFvqyiI+jLJ6+LvVrqH5ZasJPNY8UF0Z/Q=; b=FvZnYcbvbzlvtN/5GIlJ4Gb7pN
        2kg4gEHpWqglWierjPJSsT7lpSv8T5sS+y1JSaIg9+w1ewC6hiKdgR9sdufVabu+lTWkbuZ+ImqxM
        sU58wrqTsCANCLj/QfFsNo/2r8l0+veXcP2ocQCpBQHIdDbAFVdiRT07oa85UbtNM4GJTJ9fpQKD0
        llisHNiVUNUavr4K/FbbqfQCwvwsvvgbrWtc56wA9HkdH8CQCRt68h+EzBki/di+9GxN0gtanN1wz
        Mna7BHJ8KNnC+kgzEzw3eBz9lk8afFqpCTuc3hQl2yxKNAWV9cmHoFICWpjplLNlAZh1K/opv+0Bg
        UJPzeQBQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p3J7N-0005hr-Sf; Thu, 08 Dec 2022 16:47:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 09/11] include/Makefile: xtables-version.h is generated
Date:   Thu,  8 Dec 2022 16:46:14 +0100
Message-Id: <20221208154616.14622-10-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221208154616.14622-1-phil@nwl.cc>
References: <20221208154616.14622-1-phil@nwl.cc>
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

