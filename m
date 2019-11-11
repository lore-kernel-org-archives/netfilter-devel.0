Return-Path: <SRS0=qfGK=ZD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85DFC43331
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 17:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46E620656
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 17:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfKKRT2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:19:28 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:45916 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfKKRT2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 12:19:28 -0500
Received: from localhost ([::1]:59004 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iUDLa-0007rY-1J; Mon, 11 Nov 2019 18:19:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [conntrack-tools PATCH] Makefile.am: Use ${} instead of @...@
Date:   Mon, 11 Nov 2019 18:19:21 +0100
Message-Id: <20191111171921.14120-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Referencing to variables using @...@ means they will be replaced by
configure. This is not needed and may cause problems later.

Suggested-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am             | 2 +-
 src/Makefile.am         | 2 +-
 src/helpers/Makefile.am | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index f64d60438d411..df4c0cbf71664 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -7,7 +7,7 @@ EXTRA_DIST = $(man_MANS) Make_global.am doc m4 tests
 
 SUBDIRS   = extensions src
 DIST_SUBDIRS = include src extensions
-LIBS = @LIBNETFILTER_CONNTRACK_LIBS@
+LIBS = $(LIBNETFILTER_CONNTRACK_LIBS)
 
 dist-hook:
 	rm -rf `find $(distdir)/doc -name *.orig`
diff --git a/src/Makefile.am b/src/Makefile.am
index c4393119f54a3..2e66ee96b7095 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -35,7 +35,7 @@ if HAVE_CTHELPER
 nfct_LDADD += ${LIBNETFILTER_CTHELPER_LIBS}
 endif
 
-nfct_LDFLAGS = -export-dynamic @LAZY_LDFLAGS@
+nfct_LDFLAGS = -export-dynamic ${LAZY_LDFLAGS}
 
 conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c queue_tx.c rbtree.c \
 		    local.c log.c mcast.c udp.c netlink.c vector.c \
diff --git a/src/helpers/Makefile.am b/src/helpers/Makefile.am
index 58c9ad00e67bc..e4f10c974bb0f 100644
--- a/src/helpers/Makefile.am
+++ b/src/helpers/Makefile.am
@@ -11,7 +11,7 @@ pkglib_LTLIBRARIES = ct_helper_amanda.la \
 		     ct_helper_slp.la	\
 		     ct_helper_ssdp.la
 
-HELPER_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS) @LAZY_LDFLAGS@
+HELPER_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS) $(LAZY_LDFLAGS)
 HELPER_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
 
 ct_helper_amanda_la_SOURCES = amanda.c
@@ -32,7 +32,7 @@ ct_helper_mdns_la_CFLAGS = $(HELPER_CFLAGS)
 
 ct_helper_rpc_la_SOURCES = rpc.c
 ct_helper_rpc_la_LDFLAGS = $(HELPER_LDFLAGS)
-ct_helper_rpc_la_CFLAGS = $(HELPER_CFLAGS) @LIBTIRPC_CFLAGS@
+ct_helper_rpc_la_CFLAGS = $(HELPER_CFLAGS) $(LIBTIRPC_CFLAGS)
 
 ct_helper_tftp_la_SOURCES = tftp.c
 ct_helper_tftp_la_LDFLAGS = $(HELPER_LDFLAGS)
-- 
2.24.0

