Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19A0C47089
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiLGRpE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiLGRpC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:45:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383A552145
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=32jO/JhrhvUbvduNN6e5SJ9FA0mVQAAWtdNzchPrnAQ=; b=YziOmt/ufaMV1xDnX9vqvE+Z5v
        Pkitm8Tc8Yjb0qC8oY/jkAx0JT9AwvDftk+NvelDRql2b155b/bZ7xve+tvsJbirZS3/B+XGfDGW1
        oOVMwW6bXjBfug74YZbhS7/qRgKW6cw+rEhs9dgW1wBXHhGwUZcWWj9HYMMmAUbvbOTT9ZVgOherl
        qErymvpXe4RlPB+AWyAWZKWefFP/WDFSE3sJqedAqDDbsvlxio5YWWXypRxwbMzdfTRQdgqyCf1Y8
        BTIkVV9PbUhOmVvhB89RJZ4ZUeBffu8eh4eoEuZp1E0KBUDHT96MkrvpvEkfvvy293L1GVQtGHuxG
        hsg8zR3Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yTc-0000g9-Km
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:45:00 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 11/11] Makefile.am: Integrate testsuites
Date:   Wed,  7 Dec 2022 18:44:30 +0100
Message-Id: <20221207174430.4335-12-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221207174430.4335-1-phil@nwl.cc>
References: <20221207174430.4335-1-phil@nwl.cc>
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
index 4a5c6fd41e8fd..b2f4b9f599ceb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -33,3 +33,5 @@ endif
 
 config.status: extensions/GNUmakefile.in \
 	include/xtables-version.h.in
+
+TESTS = xlate-test.py iptables-test.py iptables/tests/shell/run-tests.sh
-- 
2.38.0

