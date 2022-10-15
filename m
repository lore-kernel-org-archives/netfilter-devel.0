Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0171C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Oct 2022 11:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJOLDL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Oct 2022 07:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiJOLDK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Oct 2022 07:03:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE724F6A5
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Oct 2022 04:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qkFXmVdOsWwadp0BpU/zAMHvyziDqeFRF2bEi/5GLyU=; b=ihsi6GcOB4RY7hGIl8QU9izM6E
        /Rptgbro9HhF5vgR+abRLo0H+M+bit61jbXN6qJFdYwmShlTgTazW9/P534ckENRvmmX2Hry9qO5S
        RHByxy3lpLTAYJ9KPfc0gQRiwZyrToPCUrYDsvAA11fnCn0qU4cNBcrui+Jwjc8CJwUqK77Rv09kY
        3ICWeIAYOHrqAhPW/3WpfrNIQPigSbxOherEcY58gNFFMexpgmsC5WseQzQbhTNdP43iwO/cPUxVr
        duq8c22L5Ss1MawnbDCyv2yaXFEGs40DAKFhGBhZ4kQS9OV8umGPpn5f9QIcsoA+xNLjTmj1m3ts6
        RSEzLsKg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ojewc-00078t-K9
        for netfilter-devel@vger.kernel.org; Sat, 15 Oct 2022 13:03:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] Makefile.am: Integrate testsuites
Date:   Sat, 15 Oct 2022 13:02:56 +0200
Message-Id: <20221015110256.15921-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221015110256.15921-1-phil@nwl.cc>
References: <20221015110256.15921-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support calling 'make check' in topdir to run all three testsuites.
While updating .gitignore, also add 'configure~' my autotools create and
the tags file.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .gitignore                | 12 ++++++++++++
 Makefile.am               |  2 ++
 extensions/GNUmakefile.in |  5 ++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index a206fb4870bc8..ec4e44cad8aa7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -20,6 +20,7 @@ Makefile.in
 /build-aux/
 /config.*
 /configure
+/configure~
 /libtool
 /stamp-h1
 /iptables/iptables-apply.8
@@ -29,3 +30,14 @@ Makefile.in
 
 # vim/nano swap file
 *.swp
+
+/tags
+
+# make check results
+/test-suite.log
+/iptables-test.py.log
+/iptables-test.py.trs
+/xlate-test.py.log
+/xlate-test.py.trs
+iptables/tests/shell/run-tests.sh.log
+iptables/tests/shell/run-tests.sh.trs
diff --git a/Makefile.am b/Makefile.am
index 799bf8b81c74a..4574b55e2433d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,3 +31,5 @@ endif
 
 config.status: extensions/GNUmakefile.in \
 	include/xtables-version.h.in
+
+TESTS = xlate-test.py iptables-test.py iptables/tests/shell/run-tests.sh
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 3c68f8decd13f..f20ea4fd95eae 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -79,7 +79,7 @@ targets_install :=
 
 .SECONDARY:
 
-.PHONY: all install uninstall clean distclean FORCE
+.PHONY: all install uninstall clean distclean FORCE check
 
 all: ${targets}
 
@@ -307,3 +307,6 @@ matches.man: .initext.dd .initextb.dd .initexta.dd .initext4.dd .initext6.dd $(w
 
 targets.man: .initext.dd .initextb.dd .initexta.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pfb_build_mod} ${pfa_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
+
+# empty check target to satisfy 'make check' in topdir
+check:
-- 
2.34.1

