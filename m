Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9261C4708E
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLGRpA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiLGRow (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:44:52 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A6D528B4
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AEGU1j9pPE+zy/+R1UvI23tplK3wBdLVi79PgjKzYto=; b=Ty2eiO5rQdKybwCdI595o8/tlF
        8XwpZeeS5rBIvaB5GGIiIZFWPLFTXq7Z5Q1KT69yiJdK6hFtJVBzIBGZWaH5RhC0KPoMLluxaO9q2
        21DgLwnwJwCEOPRhVR1dRrGtqi2ZG1C2/Q1ZI+DTAUYiLR+HVUvkhO1NnU5bDwa4CxewFRsVuxoJc
        3EGvaFkwo5rNjula2XS0TrK+OeRUfL8d0moPSi/k8Lf1hVXQdv/GwNvVEJaQZkshc9E8l9x3fjyjI
        u2WiFSGXC2JugqmueMG6E/0TIcRtim0mRKY1Rf5/FUwzhmJVKFXILcb/GZhwZD3ZfDxutHPwlHrQt
        bkwFrdHQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yTS-0000fR-2W
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:44:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 02/11] Drop libiptc/linux_stddef.h
Date:   Wed,  7 Dec 2022 18:44:21 +0100
Message-Id: <20221207174430.4335-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221207174430.4335-1-phil@nwl.cc>
References: <20221207174430.4335-1-phil@nwl.cc>
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

