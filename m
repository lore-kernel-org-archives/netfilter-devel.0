Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2C6C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 15:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiLHPrS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiLHPrR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 10:47:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E3D5B84E
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 07:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=br+idYhXLrqePbFJ5j2WBpC+2jWg+ABKdRC9iRKr/40=; b=lRLCnhjnYBBdyprNDxBI+n5IOt
        TZ5DrjgBNBy0heBtCZ/hHjwLaLkdUlK07GHWICNsUm5jfFEO7es8HbK2inzNAuxm1I1jePU8ETrcd
        JzS8aalBOr5BHK7dGlQIEKxpepsFyiBm0keOxjJ+Mn0vfKAXvCFR3kC4+M/aYW901GWsLwkL3JiaS
        yURrLH4CaXwZbj3SXzggti2iVyKnX7bYn/WAsE/m9tDfzR1ToR8wfjc6Ssteb3x5Zcuwp1PPa/gCG
        h/V/U3ILjMeLcEhw02ufFYGYPOwoklHh/qzhzRmwtuAbY57Xa+lcp9YgeLQIXHVs71n8artpBDaO+
        qwaQ3W+Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p3J7D-0005hG-AI; Thu, 08 Dec 2022 16:47:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 11/11] Makefile.am: Integrate testsuites
Date:   Thu,  8 Dec 2022 16:46:16 +0100
Message-Id: <20221208154616.14622-12-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221208154616.14622-1-phil@nwl.cc>
References: <20221208154616.14622-1-phil@nwl.cc>
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
 .gitignore  | 12 ++++++++++++
 Makefile.am |  2 ++
 2 files changed, 14 insertions(+)

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
index dc3552067a67f..4ba0392610622 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -33,3 +33,5 @@ endif
 
 config.status: extensions/GNUmakefile.in \
 	include/xtables-version.h.in
+
+TESTS = xlate-test.py iptables-test.py iptables/tests/shell/run-tests.sh
-- 
2.38.0

