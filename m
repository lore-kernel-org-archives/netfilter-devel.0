Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8472FC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbiKWQo7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239110AbiKWQot (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:49 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7656A90386
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2M8deBPSvhp1v9lBZb2pX8GtjDn79jy6VKN6ktGBIvY=; b=qT2W98Cru1kUCMwG3o+YL6FkFn
        DE3Qgh3WMj4wmPU89LDeZeojMh9CAZzYfArkRcgYKIwkJJK8i7rbT56KO25ZW3qTgk8q0gHemGtqH
        Tt7uT4XaXGssASseKxZACHz4l36zl4lZNLK9HTTOSH3rwaLDmDf/waNws6V+iaC3GSJNFo6/oYC0k
        +NbVas2nPCqxLLidilqJPukHjXs/LTqFNtFqZlNlHkqf0WIJpyqt5y6ye2HTVbjLp8r7FJrKqJ31M
        nkFuR2VGLDZURfH7iEwswq4DjosowgopS6ROX384qaZ/r0k5id3iVmWpDtMep5aifjikAF2ptOy9L
        hO76Hirg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsre-0003z7-ST
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 13/13] extensions: ipcomp: Add comment to clarify xlate callback
Date:   Wed, 23 Nov 2022 17:43:50 +0100
Message-Id: <20221123164350.10502-14-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel ignores 'hdrres' field, this matching on reserved field value was
never effective.

While being at it, drop its description from man page. Continue to parse
and print it for compatibility reasons, but avoid attracting new users.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_ipcomp.c     | 2 ++
 extensions/libxt_ipcomp.c.man | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_ipcomp.c b/extensions/libxt_ipcomp.c
index b5c43128466fb..4171c4a1c4eb7 100644
--- a/extensions/libxt_ipcomp.c
+++ b/extensions/libxt_ipcomp.c
@@ -101,6 +101,8 @@ static int comp_xlate(struct xt_xlate *xl,
 	const struct xt_ipcomp *compinfo =
 		(struct xt_ipcomp *)params->match->data;
 
+	/* ignore compinfo->hdrres like kernel's xt_ipcomp.c does */
+
 	xt_xlate_add(xl, "comp cpi %s",
 		     compinfo->invflags & XT_IPCOMP_INV_SPI ? "!= " : "");
 	if (compinfo->spis[0] != compinfo->spis[1])
diff --git a/extensions/libxt_ipcomp.c.man b/extensions/libxt_ipcomp.c.man
index f3b17d2167697..824f5b3d9dbb4 100644
--- a/extensions/libxt_ipcomp.c.man
+++ b/extensions/libxt_ipcomp.c.man
@@ -2,6 +2,3 @@ This module matches the parameters in IPcomp header of IPsec packets.
 .TP
 [\fB!\fP] \fB\-\-ipcompspi\fP \fIspi\fP[\fB:\fP\fIspi\fP]
 Matches IPcomp header CPI value.
-.TP
-\fB\-\-compres\fP
-Matches if the reserved field is filled with zero.
-- 
2.38.0

