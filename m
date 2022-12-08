Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0864C4708D
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLHAa5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLHAa5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:30:57 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C62291
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M6K05Jk2RXS5aYYBufi2hNKPEDp6AHUns69fHuxDsHY=; b=mWaiM4F4NFNT/FjoFp9RtjgI1M
        HGRD6W7dojdcaxqLe93uGRFv/QUh+lDvdw6rk3MUzFxVyW8DPMvWdCsYsW6BQW14NYaCi0tsWFHmk
        n6udcJu9q1md3A4lFxpKx/7C3xjODvX3ExEOfeyK6oQ0oP283dFWW2EM4Oj4PZ8iiZ6djzbpAA362
        9VxsO41c2VRXWG5O7KW8g+8+Wv4kTqsrUNN3sOmHscznib+sTqJ/tcq5zfn/12jDJvp3JzEnqtCmr
        c05RWWDFV0qbu4yMymFgQojaEsGLmIzFS9lj+Tri1L47xEoKcjIEkPbN7cyPiVU0NYrVlfRrZT+P7
        2Mo4YBAQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p34oN-0005ek-TC; Thu, 08 Dec 2022 01:30:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH] Makefile: Create LZMA-compressed dist-files
Date:   Thu,  8 Dec 2022 01:30:43 +0100
Message-Id: <20221208003043.11712-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use a more modern alternative to bzip2.

Suggested-by: Jan Engelhardt <jengelh@inai.de>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 799bf8b81c74a..19a93a5586d0f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -26,7 +26,7 @@ endif
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 	pushd ${top_srcdir} && git archive --prefix=${PACKAGE_TARNAME}-${PACKAGE_VERSION}/ HEAD | tar -C /tmp -x && popd;
 	pushd /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION} && ./autogen.sh && popd;
-	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
+	tar -C /tmp -cJf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.xz --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
 config.status: extensions/GNUmakefile.in \
-- 
2.38.0

