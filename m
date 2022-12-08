Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CA7C4708D
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLHATf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLHATf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:19:35 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B042255CA8
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C6YXrm+NDaXLOUJoO7KklSMdS1oFVIv08lzdsxHCPBY=; b=EE1dHb5UPlJxI8TjSj5jYYyepj
        lkE/ds5dJwRlv8unP7fat5agOL76ruGG34v+YItDUWdHFdSeLvnSre0smYFenqEny/fY4jqt8YE2l
        sGOHq1jpIo/anBygYUIDJGD7SbjsxMFOKQL+ZiWo4gxe+LaaoRQ5F/jYwc1AN9CrnkejQA41yGBu/
        Cbim5nuitqzu4s6WWUrt5s1bD22o6wxVeLIyXW36qGE9N7TbeTY5pS0fdiWH+HP8jDuV5WtdqZZnS
        yzm/EY6HRZr8dbPtZ1DL9bBW5ZWwkbqeP299TDhbu2FrBZd7UBou/96i7tM+GHYx2tqy1p13AnuhY
        t5ju8/Yw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p34dB-0005Wp-KV; Thu, 08 Dec 2022 01:19:17 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Eric Leblond <eric@inl.fr>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ulogd PATCH] Makefile: Create LZMA-compressed dist-files
Date:   Thu,  8 Dec 2022 01:19:08 +0100
Message-Id: <20221208001908.27094-1-phil@nwl.cc>
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
 Makefile.in | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index 0f1845c23842b..48098e96035be 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -43,20 +43,20 @@ distclean: clean
 	make -C doc distrib
 
 .PHONY: distrib
-distrib: docbuild distclean delrelease $(RELEASE_DIR)/ulogd-$(ULOGD_VERSION).tar.bz2 diff
+distrib: docbuild distclean delrelease $(RELEASE_DIR)/ulogd-$(ULOGD_VERSION).tar.xz diff
 
 .PHONY: delrelease
 delrelease:
-	rm -f $(RELEASE_DIR)/ulogd-$(ULOGD_VERSION).tar.bz2
+	rm -f $(RELEASE_DIR)/ulogd-$(ULOGD_VERSION).tar.xz
 
-$(RELEASE_DIR)/ulogd-$(ULOGD_VERSION).tar.bz2:
-	cd .. && ln -sf ulogd ulogd-$(ULOGD_VERSION) && tar cvf - --exclude CVS --exclude .svn ulogd-$(ULOGD_VERSION)/. | bzip2 -9 > $@ && rm ulogd-$(ULOGD_VERSION)
+$(RELEASE_DIR)/ulogd-$(ULOGD_VERSION).tar.xz:
+	cd .. && ln -sf ulogd ulogd-$(ULOGD_VERSION) && tar cvf - --exclude CVS --exclude .svn ulogd-$(ULOGD_VERSION)/. | xz -9 > $@ && rm ulogd-$(ULOGD_VERSION)
 
 .PHONY: diff
-diff: $(RELEASE_DIR)/ulogd-$(ULOGD_VERSION).tar.bz2
+diff: $(RELEASE_DIR)/ulogd-$(ULOGD_VERSION).tar.xz
 	@mkdir /tmp/diffdir
-	@cd /tmp/diffdir && tar -x --bzip2 -f $(RELEASE_DIR)/ulogd-$(ULOGD_VERSION).tar.bz2
-	@set -e; cd /tmp/diffdir; tar -x --bzip2 -f $(RELEASE_DIR)/ulogd-$(OLD_ULOGD_VERSION).tar.bz2; echo Creating patch-ulogd-$(OLD_ULOGD_VERSION)-$(ULOGD_VERSION).bz2; diff -urN ulogd-$(OLD_ULOGD_VERSION) ulogd-$(ULOGD_VERSION) | bzip2 -9 > $(RELEASE_DIR)/patch-ulogd-$(OLD_ULOGD_VERSION)-$(ULOGD_VERSION).bz2
+	@cd /tmp/diffdir && tar -x --xz -f $(RELEASE_DIR)/ulogd-$(ULOGD_VERSION).tar.xz
+	@set -e; cd /tmp/diffdir; tar -x --xz -f $(RELEASE_DIR)/ulogd-$(OLD_ULOGD_VERSION).tar.xz; echo Creating patch-ulogd-$(OLD_ULOGD_VERSION)-$(ULOGD_VERSION).xz; diff -urN ulogd-$(OLD_ULOGD_VERSION) ulogd-$(ULOGD_VERSION) | xz -9 > $(RELEASE_DIR)/patch-ulogd-$(OLD_ULOGD_VERSION)-$(ULOGD_VERSION).xz
 
 recurse: 
 	@for d in $(SUBDIRS); do if ! make -C $$d; then exit 1; fi; done
-- 
2.38.0

