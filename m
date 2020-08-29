Return-Path: <SRS0=fjj5=CH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7178AC433E7
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 21:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A30D2076D
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 21:04:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="IGiWrZj8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgH2VEy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Aug 2020 17:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728445AbgH2VEw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Aug 2020 17:04:52 -0400
X-Greylist: delayed 1393 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 29 Aug 2020 14:04:51 PDT
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB3AC061573
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 14:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ugBsNDEVjMbtf0hbUimt4vl3+fzBLCgc/tuDzhNc108=; b=IGiWrZj8h8aygTYirE6exGzcYP
        OEPbd98nG3/zcf29sz6S1MdGfK0Z2sPOeXagKdhJUfzyhvEXwbcS34JIeqAG2rM/gCow9K+EwGwrF
        If1mPvhB+NZWgEl6rdhcCIF2sKL9G9eB/X95+tydrpY24HYhFEoC4cHx1Z/B69OANmNRYCMXIhTw2
        1LFYK/IXxGul0vZHC3xI7rXNsfKC+FKqFDRFlZPnVEUWIuueGGeM2hQoTfTpXmqk4KYdH+wqgy1dn
        IYCVH7Ub0M+ZUDw7biPsQ1g4Nx834k8uzZMzH06gv8l4Ox7ue4OlY/yr3gc8LhSv1sFcVZKbiaq2a
        IUdNssow==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kC7fG-0004XC-5m; Sat, 29 Aug 2020 21:41:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons] build: clean some extra build artefacts.
Date:   Sat, 29 Aug 2020 21:41:27 +0100
Message-Id: <20200829204127.2709641-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Because extensions/Makefile.am does not contain a `SUBDIRS` variable
listing extensions/ACCOUNT and extensions/pknock, when `make distclean`
is run, make does not recurse into them.  Add a `distclean-local` target
to extensions/Makefile.am to fix this.

Makefile.mans creates .manpages.lst, but does not remove it.  Add
it to the `clean` target.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.mans.in       | 2 +-
 extensions/Makefile.am | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile.mans.in b/Makefile.mans.in
index 18e82b39882d..63424f7d558a 100644
--- a/Makefile.mans.in
+++ b/Makefile.mans.in
@@ -40,4 +40,4 @@ targets.man: .manpages.lst ${wcman_targets}
 	$(call man_run,${wlist_targets})
 
 clean:
-	rm -f xtables-addons.8 matches.man targets.man
+	rm -f xtables-addons.8 matches.man targets.man .manpages.lst
diff --git a/extensions/Makefile.am b/extensions/Makefile.am
index a487fd8c141a..e7e942127e59 100644
--- a/extensions/Makefile.am
+++ b/extensions/Makefile.am
@@ -26,4 +26,8 @@ install-exec-local: modules_install
 
 clean-local: clean_modules
 
+distclean-local:
+	$(MAKE) -C ACCOUNT distclean
+	$(MAKE) -C pknock distclean
+
 include ../Makefile.extra
-- 
2.28.0

