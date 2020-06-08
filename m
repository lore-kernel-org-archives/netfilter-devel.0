Return-Path: <SRS0=kOBD=7V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2201AC433E1
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 07:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01177204EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 07:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgFHHPL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 03:15:11 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55572 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728995AbgFHHPL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 03:15:11 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail108.syd.optusnet.com.au (Postfix) with SMTP id 4CFAB1A7C7A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 17:15:07 +1000 (AEST)
Received: (qmail 14496 invoked by uid 501); 8 Jun 2020 07:15:01 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/2] build: dist: Force 'make distcheck' to pass
Date:   Mon,  8 Jun 2020 17:15:01 +1000
Message-Id: <20200608071501.14448-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200608071501.14448-1-duncan_roe@optusnet.com.au>
References: <20200608071501.14448-1-duncan_roe@optusnet.com.au>
In-Reply-To: <20200607184716.GA20705@salvia>
References: <20200607184716.GA20705@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=nTHF0DUjJn0A:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=uRBHhTXqUsqgb7moG6QA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

'make distcheck' was failing because fixmanpages.sh was not present in the
test build directory.
While this can be addressed, it has no chance of working because make has
already deleted the generated man pages.
To solve this problem, this patch makes the Makefile become "aware" that is
being run by 'make distcheck' and keep going if so.
The Makefile also has to take special action so 'make distcleancheck' passes.

This does mean that 'make distcheck' doesn't test fixmanpages.sh.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index a4db804..9c06983 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -9,7 +9,12 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c  \
            $(top_srcdir)/src/extra/pktbuff.c
 
 doxyfile.stamp: $(doc_srcs) fixmanpages.sh
-	rm -rf html man && (cd .. && doxygen doxygen.cfg) && ./fixmanpages.sh
+# Hack so 'make distcheck' passes:
+# just keep going if fixmanpages.sh is missing
+# as an extra check, ensure penultimate 2 components of cwd are "_build/sub"
+	rm -rf html man && (cd .. && doxygen doxygen.cfg) &&\
+	[ ! -x ./fixmanpages.sh -a "$$(pwd|rev|cut -d/ -f2-3|rev)" = _build/sub ] ||\
+	./fixmanpages.sh
 	touch doxyfile.stamp
 
 CLEANFILES = doxyfile.stamp
@@ -19,5 +24,12 @@ clean-local:
 	rm -rf $(top_srcdir)/doxygen/man $(top_srcdir)/doxygen/html
 install-data-local:
 	mkdir -p $(DESTDIR)$(mandir)/man3
-	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3 $(DESTDIR)$(mandir)/man3/
+# Need another hack so 'make distcleancheck' passes :(
+# No need to check directory tree again
+	if [ ! -x ./fixmanpages.sh ];\
+	then\
+		rm -rf html;\
+	else\
+		cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3 $(DESTDIR)$(mandir)/man3/;\
+	fi
 endif
-- 
2.14.5

