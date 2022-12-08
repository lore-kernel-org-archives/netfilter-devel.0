Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79076C63703
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 15:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLHPqa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiLHPq3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 10:46:29 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C236742F77
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 07:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AEGU1j9pPE+zy/+R1UvI23tplK3wBdLVi79PgjKzYto=; b=aslKgHy2WhKAOvYK388mkoNfCh
        5P4UB4smu1GO/gGTZxs8DVXjJsIWCdDUu3LPtraMHmYoEdTZF1G0uBAoaebL5xC1rjHAS/4pnd337
        dt9bGF+muo/n1SACgAXLWPG88AXTYyCuPmF+99OzdhMMHwFzSQ5SIztFw//hKBEIASK4QWonuW1Fb
        /u5LXFhhRkQSrjQ6AfHdwY677gI/N4LTCK4l1+HhsAqXAWdZPDEUVDgME53b5+ibFcYj4y2NsW/al
        3KXnMGao/kvn7o7IOoz/ay1qq8SB9V6SkYklcQEIX0a09kOhTozYkSWsyAxO2wUw99f67o1LneUh7
        QfNW0yHA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p3J6O-0005ec-UF; Thu, 08 Dec 2022 16:46:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 02/11] Drop libiptc/linux_stddef.h
Date:   Thu,  8 Dec 2022 16:46:07 +0100
Message-Id: <20221208154616.14622-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221208154616.14622-1-phil@nwl.cc>
References: <20221208154616.14622-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This header was never included anywhere.

Fixes: aae69bed01982 ("complete libiptc rewrite.  Time to load 10k rules goes down from 2.20 minutes to 1.255 seconds (!).  Might still contain bugs, use with caution.")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libiptc/linux_stddef.h | 39 ---------------------------------------
 1 file changed, 39 deletions(-)
 delete mode 100644 libiptc/linux_stddef.h

diff --git a/libiptc/linux_stddef.h b/libiptc/linux_stddef.h
deleted file mode 100644
index 56416f104ecfc..0000000000000
--- a/libiptc/linux_stddef.h
+++ /dev/null
@@ -1,39 +0,0 @@
-#ifndef _LINUX_STDDEF_H
-#define _LINUX_STDDEF_H
-
-#undef NULL
-#if defined(__cplusplus)
-#define NULL 0
-#else
-#define NULL ((void *)0)
-#endif
-
-#undef offsetof
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
-
-
-/**
- * container_of - cast a member of a structure out to the containing structure
- *
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({			\
-        const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-        (type *)( (char *)__mptr - offsetof(type,member) );})
-
-/*
- * Check at compile time that something is of a particular type.
- * Always evaluates to 1 so you may use it easily in comparisons.
- */
-#define typecheck(type,x) \
-({	type __dummy; \
-	typeof(x) __dummy2; \
-	(void)(&__dummy == &__dummy2); \
-	1; \
-})
-
-
-#endif
-- 
2.38.0

