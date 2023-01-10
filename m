Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF41C54EBC
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Jan 2023 16:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjAJQgB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Jan 2023 11:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239155AbjAJQfU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Jan 2023 11:35:20 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E898B536
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jan 2023 08:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3d1Gn1miLA50qN9jCokSYySv58Akd8PJmluKOfd+W1s=; b=F55lWx+Nl1NbaukZZ85LWaPWs5
        wW94ZMhzGm5+17hfyibAo1YBTZe6n5WIqDIBoIJhm3fTOAhrrSjHl9hep7LBqiYxA0MxUGa6k2oKS
        1tX4nIINosp/PoTEFOZIxa/t8vz7F7NN5bBTLaUICUKm+APWugguhPrYCMm8bb1Zg5n+hdSNU0v28
        g7Ow1TJbC/vCatQ1rIcx1z5nCcenGrtUhFftCzbV9+gCZ5MlNpygNqGevmSnESzIUqlHilPpG1lj3
        l8SSv00YtnJ6mEwaIFfLOSYZvX1SCZTi/DSli1rCka+4C6mOChh5aKhDduXRtpQ9At97jiqXJZ3CM
        7BUnwb/g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pFHab-0003Qh-Pd; Tue, 10 Jan 2023 17:35:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH] Makefile: Replace brace expansion
Date:   Tue, 10 Jan 2023 17:35:02 +0100
Message-Id: <20230110163502.11238-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

According to bash(1), it is not supported by "historical versions of
sh". Dash seems to be such a historical version.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 3822a992bc277 ("Makefile: Fix for 'make distcheck'")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/GNUmakefile.in | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index c37e4619f91f9..e289adf06547f 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -106,7 +106,8 @@ install: ${targets_install} ${symlinks_install}
 	}
 
 clean:
-	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initextb.c initexta.c;
+	rm -f *.o *.oo *.so *.a matches.man targets.man
+	rm -f initext.c initext4.c initext6.c initextb.c initexta.c
 	rm -f .*.d .*.dd;
 
 distclean: clean
@@ -243,7 +244,7 @@ dist_sources = $(filter-out ${dist_initext_src},$(wildcard $(srcdir)/*.[ch]))
 	mkdir -p $(distdir)
 	cp -p ${dist_sources} $(distdir)/
 	cp -p $(wildcard ${srcdir}/lib*.man) $(distdir)/
-	cp -p $(srcdir)/*.{t,txlate} $(distdir)/
+	cp -p $(wildcard ${srcdir}/*.t ${srcdir}/*.txlate) $(distdir)/
 
 dvi:
 check: all
-- 
2.38.0

