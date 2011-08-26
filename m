From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] src: remove unused IPTABLES_MULTI define
Date: Fri, 26 Aug 2011 15:15:13 +0200
Message-ID: <1314364516-7875-4-git-send-email-jengelh@medozas.de>
References: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41488 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1HZNR5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:17:57 -0400
In-Reply-To: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This dead code has been lingering around since commit v1.4.5~7.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/Makefile.am            |    2 +-
 iptables/ip6tables-restore.c    |    4 ----
 iptables/ip6tables-save.c       |    4 ----
 iptables/ip6tables-standalone.c |    5 -----
 iptables/iptables-restore.c     |    5 -----
 iptables/iptables-save.c        |    5 -----
 iptables/iptables-standalone.c  |    5 -----
 iptables/iptables-xml.c         |    9 ---------
 8 files changed, 1 insertions(+), 38 deletions(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index a068278..addb159 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -15,7 +15,7 @@ libxtables_la_LIBADD  =
 endif
 
 xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
-xtables_multi_CFLAGS   = ${AM_CFLAGS} -DIPTABLES_MULTI
+xtables_multi_CFLAGS   = ${AM_CFLAGS}
 xtables_multi_LDFLAGS  = -rdynamic
 xtables_multi_LDADD    = ../extensions/libext.a
 if ENABLE_STATIC
diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index ae147d5..985744d 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -113,11 +113,7 @@ static void free_argv(void) {
 		free(newargv[i]);
 }
 
-#ifdef IPTABLES_MULTI
 int ip6tables_restore_main(int argc, char *argv[])
-#else
-int main(int argc, char *argv[])
-#endif
 {
 	struct ip6tc_handle *handle = NULL;
 	char buffer[10240];
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index 39a3325..ad0e70f 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -131,11 +131,7 @@ static int do_output(const char *tablename)
  * :Chain name POLICY packets bytes
  * rule
  */
-#ifdef IPTABLES_MULTI
 int ip6tables_save_main(int argc, char *argv[])
-#else
-int main(int argc, char *argv[])
-#endif
 {
 	const char *tablename = NULL;
 	int c;
diff --git a/iptables/ip6tables-standalone.c b/iptables/ip6tables-standalone.c
index 9d8d5a0..6b82935 100644
--- a/iptables/ip6tables-standalone.c
+++ b/iptables/ip6tables-standalone.c
@@ -37,13 +37,8 @@
 #include <ip6tables.h>
 #include "ip6tables-multi.h"
 
-#ifdef IPTABLES_MULTI
 int
 ip6tables_main(int argc, char *argv[])
-#else
-int
-main(int argc, char *argv[])
-#endif
 {
 	int ret;
 	char *table = "filter";
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 1cb833c..d0bd79a 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -113,13 +113,8 @@ static void free_argv(void) {
 		free(newargv[i]);
 }
 
-#ifdef IPTABLES_MULTI
 int
 iptables_restore_main(int argc, char *argv[])
-#else
-int
-main(int argc, char *argv[])
-#endif
 {
 	struct iptc_handle *handle = NULL;
 	char buffer[10240];
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index 7542bdc..73fba12 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -129,13 +129,8 @@ static int do_output(const char *tablename)
  * :Chain name POLICY packets bytes
  * rule
  */
-#ifdef IPTABLES_MULTI
 int
 iptables_save_main(int argc, char *argv[])
-#else
-int
-main(int argc, char *argv[])
-#endif
 {
 	const char *tablename = NULL;
 	int c;
diff --git a/iptables/iptables-standalone.c b/iptables/iptables-standalone.c
index 87f1d31..1ebec33 100644
--- a/iptables/iptables-standalone.c
+++ b/iptables/iptables-standalone.c
@@ -38,13 +38,8 @@
 #include <iptables.h>
 #include "iptables-multi.h"
 
-#ifdef IPTABLES_MULTI
 int
 iptables_main(int argc, char *argv[])
-#else
-int
-main(int argc, char *argv[])
-#endif
 {
 	int ret;
 	char *table = "filter";
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 502b2d9..4ecddcb 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -23,10 +23,6 @@
 #define DEBUGP(x, args...)
 #endif
 
-#ifndef IPTABLES_MULTI
-int line = 0;
-#endif
-
 struct xtables_globals iptables_xml_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
@@ -617,13 +613,8 @@ do_rule(char *pcnt, char *bcnt, int argc, char *argv[], int argvattr[])
 	do_rule_part(NULL, NULL, 1, argc, argv, argvattr);
 }
 
-#ifdef IPTABLES_MULTI
 int
 iptables_xml_main(int argc, char *argv[])
-#else
-int
-main(int argc, char *argv[])
-#endif
 {
 	char buffer[10240];
 	int c;
-- 
1.7.3.4

