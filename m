From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/4] build: remove unused LDFLAGS
Date: Sun, 20 May 2012 00:08:09 +0200
Message-ID: <1337465292-28924-2-git-send-email-jengelh@inai.de>
References: <1337465292-28924-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38051 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab2ESWIT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 May 2012 18:08:19 -0400
In-Reply-To: <1337465292-28924-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

"-ldl" is not needed since the programs themselves never use functions
from libdl. Also, -dynamic is not required at all.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 qa/Makefile.am    |    4 ----
 utils/Makefile.am |   20 --------------------
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/qa/Makefile.am b/qa/Makefile.am
index cb49aa4..b4daf92 100644
--- a/qa/Makefile.am
+++ b/qa/Makefile.am
@@ -4,16 +4,12 @@ check_PROGRAMS = test_api test_filter ct_stress ct_events_reliable
 
 test_api_SOURCES = test_api.c
 test_api_LDADD = ../src/libnetfilter_conntrack.la
-test_api_LDFLAGS = -dynamic -ldl
 
 test_filter_SOURCES = test_filter.c
 test_filter_LDADD = ../src/libnetfilter_conntrack.la
-test_filter_LDFLAGS = -dynamic -ldl
 
 ct_stress_SOURCES = ct_stress.c
 ct_stress_LDADD = ../src/libnetfilter_conntrack.la
-ct_stress_LDFLAGS = -dynamic -ldl
 
 ct_events_reliable_SOURCES = ct_events_reliable.c
 ct_events_reliable_LDADD = ../src/libnetfilter_conntrack.la
-ct_events_reliable_LDFLAGS = -dynamic -ldl
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 35a7e0a..2fe5ea7 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -12,80 +12,60 @@ check_PROGRAMS = expect_dump expect_create expect_get expect_delete \
 
 conntrack_grp_create_SOURCES = conntrack_grp_create.c
 conntrack_grp_create_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_grp_create_LDFLAGS = -dynamic -ldl
 
 conntrack_create_SOURCES = conntrack_create.c
 conntrack_create_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_create_LDFLAGS = -dynamic -ldl
 
 conntrack_get_SOURCES = conntrack_get.c
 conntrack_get_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_get_LDFLAGS = -dynamic -ldl
 
 conntrack_create_nat_SOURCES = conntrack_create_nat.c
 conntrack_create_nat_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_create_nat_LDFLAGS = -dynamic -ldl
 
 conntrack_update_SOURCES = conntrack_update.c
 conntrack_update_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_update_LDFLAGS = -dynamic -ldl
 
 conntrack_delete_SOURCES = conntrack_delete.c
 conntrack_delete_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_delete_LDFLAGS = -dynamic -ldl
 
 conntrack_dump_SOURCES = conntrack_dump.c
 conntrack_dump_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_dump_LDFLAGS = -dynamic -ldl
 
 conntrack_dump_filter_SOURCES = conntrack_dump_filter.c
 conntrack_dump_filter_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_dump_filter_LDFLAGS = -dynamic -ldl
 
 conntrack_flush_SOURCES = conntrack_flush.c
 conntrack_flush_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_flush_LDFLAGS = -dynamic -ldl
 
 conntrack_events_SOURCES = conntrack_events.c
 conntrack_events_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_events_LDFLAGS = -dynamic -ldl
 
 conntrack_filter_SOURCES = conntrack_filter.c
 conntrack_filter_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_filter_LDFLAGS = -dynamic -ldl
 
 conntrack_master_SOURCES = conntrack_master.c
 conntrack_master_LDADD = ../src/libnetfilter_conntrack.la
-conntrack_master_LDFLAGS = -dynamic -ldl
 
 expect_dump_SOURCES = expect_dump.c
 expect_dump_LDADD = ../src/libnetfilter_conntrack.la
-expect_dump_LDFLAGS = -dynamic -ldl
 
 expect_create_SOURCES = expect_create.c
 expect_create_LDADD = ../src/libnetfilter_conntrack.la
-expect_create_LDFLAGS = -dynamic -ldl
 
 expect_create_userspace_SOURCES = expect_create_userspace.c
 expect_create_userspace_LDADD = ../src/libnetfilter_conntrack.la
-expect_create_userspace_LDFLAGS = -dynamic -ldl
 
 expect_get_SOURCES = expect_get.c
 expect_get_LDADD = ../src/libnetfilter_conntrack.la
-expect_get_LDFLAGS = -dynamic -ldl
 
 expect_delete_SOURCES = expect_delete.c
 expect_delete_LDADD = ../src/libnetfilter_conntrack.la
-expect_delete_LDFLAGS = -dynamic -ldl
 
 expect_flush_SOURCES = expect_flush.c
 expect_flush_LDADD = ../src/libnetfilter_conntrack.la
-expect_flush_LDFLAGS = -dynamic -ldl
 
 expect_events_SOURCES = expect_events.c
 expect_events_LDADD = ../src/libnetfilter_conntrack.la
-expect_events_LDFLAGS = -dynamic -ldl
 
 ctexp_events_SOURCES = ctexp_events.c
 ctexp_events_LDADD = ../src/libnetfilter_conntrack.la
-ctexp_events_LDFLAGS = -dynamic -ldl
-- 
1.7.7

