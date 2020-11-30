Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06A1C64E90
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 13:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A542F2084C
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 13:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgK3NWc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Nov 2020 08:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgK3NWc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 08:22:32 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AD4C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2020 05:21:51 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 3CF3559BD62CB; Mon, 30 Nov 2020 14:21:50 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id A4A9759BD6294;
        Mon, 30 Nov 2020 14:21:49 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack 1/2] build: use the right automake variables
Date:   Mon, 30 Nov 2020 14:21:48 +0100
Message-Id: <20201130132149.32227-1-jengelh@inai.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

-l is a library selection and needs to go into _LDADD/_LIBADD.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 examples/Makefile.am | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git examples/Makefile.am examples/Makefile.am
index a366390..c3373db 100644
--- examples/Makefile.am
+++ examples/Makefile.am
@@ -12,41 +12,41 @@ check_PROGRAMS = nfct-mnl-create	\
 		 nfexp-mnl-event
 
 nfct_mnl_create_SOURCES = nfct-mnl-create.c
-nfct_mnl_create_LDADD = ../src/libnetfilter_conntrack.la
-nfct_mnl_create_LDFLAGS = -dynamic -ldl -lmnl
+nfct_mnl_create_LDADD = ../src/libnetfilter_conntrack.la -ldl ${LIBMNL_LIBS}
+nfct_mnl_create_LDFLAGS = -dynamic
 
 nfct_mnl_del_SOURCES = nfct-mnl-del.c
-nfct_mnl_del_LDADD = ../src/libnetfilter_conntrack.la
-nfct_mnl_del_LDFLAGS = -dynamic -ldl -lmnl
+nfct_mnl_del_LDADD = ../src/libnetfilter_conntrack.la -ldl ${LIBMNL_LIBS}
+nfct_mnl_del_LDFLAGS = -dynamic
 
 nfct_mnl_dump_SOURCES = nfct-mnl-dump.c
-nfct_mnl_dump_LDADD = ../src/libnetfilter_conntrack.la
-nfct_mnl_dump_LDFLAGS = -dynamic -ldl -lmnl
+nfct_mnl_dump_LDADD = ../src/libnetfilter_conntrack.la -ldl ${LIBMNL_LIBS}
+nfct_mnl_dump_LDFLAGS = -dynamic
 
 nfct_mnl_dump_labels_SOURCES = nfct-mnl-dump-labels.c
-nfct_mnl_dump_labels_LDADD = ../src/libnetfilter_conntrack.la
-nfct_mnl_dump_labels_LDFLAGS = -dynamic -ldl -lmnl
+nfct_mnl_dump_labels_LDADD = ../src/libnetfilter_conntrack.la -ldl ${LIBMNL_LIBS}
+nfct_mnl_dump_labels_LDFLAGS = -dynamic
 
 nfct_mnl_set_label_SOURCES = nfct-mnl-set-label.c
-nfct_mnl_set_label_LDADD = ../src/libnetfilter_conntrack.la
-nfct_mnl_set_label_LDFLAGS = -dynamic -ldl -lmnl
+nfct_mnl_set_label_LDADD = ../src/libnetfilter_conntrack.la -ldl ${LIBMNL_LIBS}
+nfct_mnl_set_label_LDFLAGS = -dynamic
 
 nfct_mnl_event_SOURCES = nfct-mnl-event.c
-nfct_mnl_event_LDADD = ../src/libnetfilter_conntrack.la
-nfct_mnl_event_LDFLAGS = -dynamic -ldl -lmnl
+nfct_mnl_event_LDADD = ../src/libnetfilter_conntrack.la -ldl ${LIBMNL_LIBS}
+nfct_mnl_event_LDFLAGS = -dynamic
 
 nfct_mnl_flush_SOURCES = nfct-mnl-flush.c
-nfct_mnl_flush_LDADD = ../src/libnetfilter_conntrack.la
-nfct_mnl_flush_LDFLAGS = -dynamic -ldl -lmnl
+nfct_mnl_flush_LDADD = ../src/libnetfilter_conntrack.la -ldl ${LIBMNL_LIBS}
+nfct_mnl_flush_LDFLAGS = -dynamic
 
 nfct_mnl_get_SOURCES = nfct-mnl-get.c
-nfct_mnl_get_LDADD = ../src/libnetfilter_conntrack.la
-nfct_mnl_get_LDFLAGS = -dynamic -ldl -lmnl
+nfct_mnl_get_LDADD = ../src/libnetfilter_conntrack.la -ldl ${LIBMNL_LIBS}
+nfct_mnl_get_LDFLAGS = -dynamic
 
 nfexp_mnl_dump_SOURCES = nfexp-mnl-dump.c
-nfexp_mnl_dump_LDADD = ../src/libnetfilter_conntrack.la
-nfexp_mnl_dump_LDFLAGS = -dynamic -ldl -lmnl
+nfexp_mnl_dump_LDADD = ../src/libnetfilter_conntrack.la -ldl ${LIBMNL_LIBS}
+nfexp_mnl_dump_LDFLAGS = -dynamic
 
 nfexp_mnl_event_SOURCES = nfexp-mnl-event.c
-nfexp_mnl_event_LDADD = ../src/libnetfilter_conntrack.la
-nfexp_mnl_event_LDFLAGS = -dynamic -ldl -lmnl
+nfexp_mnl_event_LDADD = ../src/libnetfilter_conntrack.la -ldl ${LIBMNL_LIBS}
+nfexp_mnl_event_LDFLAGS = -dynamic
-- 
2.29.2

