Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4828C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 09:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EF2B2075C
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 09:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfE1Jns (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 05:43:48 -0400
Received: from a3.inai.de ([88.198.85.195]:40422 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfE1Jns (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 05:43:48 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id D011F3BACCB5; Tue, 28 May 2019 11:43:44 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id 8BC963BB6EF2;
        Tue, 28 May 2019 11:43:28 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/2] src: replace IPTABLES_VERSION by PACKAGE_VERSION
Date:   Tue, 28 May 2019 11:43:26 +0200
Message-Id: <20190528094327.20496-2-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190528094327.20496-1-jengelh@inai.de>
References: <20190528094327.20496-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The IPTABLES_VERSION C macro replicates the PACKAGE_VERSION C macro
(both have the same definition, "@PACKAGE_VERSION@"). Since
IPTABLES_VERSION, being located in internal.h, is not exposed to
downstream users in any way, it can just be replaced by
PACKAGE_VERSION, which saves a configure-time file substitution.
This goes towards eliminating unnecessary rebuilds after rerunning
./configure.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 .gitignore                                     |  1 -
 Makefile.am                                    |  2 +-
 configure.ac                                   |  2 +-
 include/iptables/{internal.h.in => internal.h} |  2 --
 iptables/ip6tables.c                           |  4 ++--
 iptables/iptables-restore.c                    |  4 ++--
 iptables/iptables-save.c                       |  3 ++-
 iptables/iptables-xml.c                        |  6 +++---
 iptables/iptables.c                            |  4 ++--
 iptables/xtables-arp.c                         |  4 ++--
 iptables/xtables-eb.c                          |  4 ++--
 iptables/xtables-monitor.c                     |  5 +++--
 iptables/xtables-restore.c                     |  4 ++--
 iptables/xtables-save.c                        |  5 +++--
 iptables/xtables-translate.c                   | 10 +++++-----
 iptables/xtables.c                             |  4 ++--
 16 files changed, 32 insertions(+), 32 deletions(-)
 rename include/iptables/{internal.h.in => internal.h} (81%)

diff --git a/.gitignore b/.gitignore
index b4fe46c0..92eb178a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -10,7 +10,6 @@ Makefile
 Makefile.in
 
 /include/xtables-version.h
-/include/iptables/internal.h
 
 /aclocal.m4
 /autom4te.cache/
diff --git a/Makefile.am b/Makefile.am
index b1ba015f..799bf8b8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -30,4 +30,4 @@ tarball:
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
 config.status: extensions/GNUmakefile.in \
-	include/xtables-version.h.in include/iptables/internal.h.in
+	include/xtables-version.h.in
diff --git a/configure.ac b/configure.ac
index 0a2802ff..c922f7a0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -245,7 +245,7 @@ AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	libiptc/Makefile libiptc/libiptc.pc
 	libiptc/libip4tc.pc libiptc/libip6tc.pc
 	libxtables/Makefile utils/Makefile
-	include/xtables-version.h include/iptables/internal.h
+	include/xtables-version.h
 	iptables/xtables-monitor.8
 	utils/nfnl_osf.8
 	utils/nfbpf_compile.8])
diff --git a/include/iptables/internal.h.in b/include/iptables/internal.h
similarity index 81%
rename from include/iptables/internal.h.in
rename to include/iptables/internal.h
index 8568e581..86ba074a 100644
--- a/include/iptables/internal.h.in
+++ b/include/iptables/internal.h
@@ -1,8 +1,6 @@
 #ifndef IPTABLES_INTERNAL_H
 #define IPTABLES_INTERNAL_H 1
 
-#define IPTABLES_VERSION "@PACKAGE_VERSION@"
-
 /**
  * Program's own name and version.
  */
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 050afa9a..57b0f9f5 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -24,7 +24,7 @@
  *	along with this program; if not, write to the Free Software
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-
+#include "config.h"
 #include <getopt.h>
 #include <string.h>
 #include <netdb.h>
@@ -121,7 +121,7 @@ static struct option original_opts[] = {
 void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
-	.program_version = IPTABLES_VERSION,
+	.program_version = PACKAGE_VERSION,
 	.orig_opts = original_opts,
 	.exit_err = ip6tables_exit_error,
 	.compat_rev = xtables_compatible_revision,
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 575e619c..6e275e1c 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -4,7 +4,7 @@
  *
  * This code is distributed under the terms of GNU GPL v2
  */
-
+#include "config.h"
 #include <getopt.h>
 #include <errno.h>
 #include <stdbool.h>
@@ -125,7 +125,7 @@ ip46tables_restore_main(struct iptables_restore_cb *cb, int argc, char *argv[])
 				break;
 			case 'h':
 				print_usage(xt_params->program_name,
-					    IPTABLES_VERSION);
+					    PACKAGE_VERSION);
 				exit(0);
 			case 'n':
 				noflush = 1;
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index 826cb1e4..c7251e35 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -5,6 +5,7 @@
  * This code is distributed under the terms of GNU GPL v2
  *
  */
+#include "config.h"
 #include <getopt.h>
 #include <errno.h>
 #include <stdio.h>
@@ -90,7 +91,7 @@ static int do_output(struct iptables_save_cb *cb, const char *tablename)
 	time_t now = time(NULL);
 
 	printf("# Generated by %s v%s on %s",
-	       xt_params->program_name, IPTABLES_VERSION, ctime(&now));
+	       xt_params->program_name, PACKAGE_VERSION, ctime(&now));
 	printf("*%s\n", tablename);
 
 	/* Dump out chain names first,
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 07300efc..9d9ce6d4 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -5,7 +5,7 @@
  *
  * This code is distributed under the terms of GNU GPL v2
  */
-
+#include "config.h"
 #include <getopt.h>
 #include <errno.h>
 #include <string.h>
@@ -20,7 +20,7 @@
 
 struct xtables_globals iptables_xml_globals = {
 	.option_offset = 0,
-	.program_version = IPTABLES_VERSION,
+	.program_version = PACKAGE_VERSION,
 	.program_name = "iptables-xml",
 };
 #define prog_name iptables_xml_globals.program_name
@@ -557,7 +557,7 @@ iptables_xml_main(int argc, char *argv[])
 			verbose = 1;
 			break;
 		case 'h':
-			print_usage("iptables-xml", IPTABLES_VERSION);
+			print_usage("iptables-xml", PACKAGE_VERSION);
 			break;
 		}
 	}
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 38c4bfe8..0fbe3ec9 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -24,7 +24,7 @@
  *	along with this program; if not, write to the Free Software
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-
+#include "config.h"
 #include <getopt.h>
 #include <string.h>
 #include <netdb.h>
@@ -120,7 +120,7 @@ void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __a
 
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
-	.program_version = IPTABLES_VERSION,
+	.program_version = PACKAGE_VERSION,
 	.orig_opts = original_opts,
 	.exit_err = iptables_exit_error,
 	.compat_rev = xtables_compatible_revision,
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index d3cb9df8..35844a9b 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -27,7 +27,7 @@
   This tool is not luser-proof: you can specify an Ethernet source address
   and set hardware length to something different than 6, f.e.
 */
-
+#include "config.h"
 #include <getopt.h>
 #include <string.h>
 #include <netdb.h>
@@ -155,7 +155,7 @@ int RUNTIME_NF_ARP_NUMHOOKS = 3;
 extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals arptables_globals = {
 	.option_offset		= 0,
-	.program_version	= IPTABLES_VERSION,
+	.program_version	= PACKAGE_VERSION,
 	.orig_opts		= original_opts,
 	.exit_err		= xtables_exit_error,
 	.compat_rev		= nft_compatible_revision,
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index bc71e122..171f41b0 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -20,7 +20,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-
+#include "config.h"
 #include <ctype.h>
 #include <errno.h>
 #include <getopt.h>
@@ -273,7 +273,7 @@ struct option ebt_original_options[] =
 extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ebtables_globals = {
 	.option_offset 		= 0,
-	.program_version	= IPTABLES_VERSION,
+	.program_version	= PACKAGE_VERSION,
 	.orig_opts		= ebt_original_options,
 	.exit_err		= xtables_exit_error,
 	.compat_rev		= nft_compatible_revision,
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index f835c5e5..eb80bac8 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -10,6 +10,7 @@
  */
 
 #define _GNU_SOURCE
+#include "config.h"
 #include <stdlib.h>
 #include <time.h>
 #include <string.h>
@@ -631,10 +632,10 @@ int xtables_monitor_main(int argc, char *argv[])
 			cb_arg.nfproto = NFPROTO_IPV6;
 			break;
 		case 'V':
-			printf("xtables-monitor %s\n", IPTABLES_VERSION);
+			printf("xtables-monitor %s\n", PACKAGE_VERSION);
 			exit(0);
 		default:
-			fprintf(stderr, "xtables-monitor %s: Bad argument.\n", IPTABLES_VERSION);
+			fprintf(stderr, "xtables-monitor %s: Bad argument.\n", PACKAGE_VERSION);
 			fprintf(stderr, "Try `xtables-monitor -h' for more information.\n");
 			exit(PARAMETER_PROBLEM);
 		}
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index a6a331d3..86f6a3af 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -4,7 +4,7 @@
  *
  * This code is distributed under the terms of GNU GPL v2
  */
-
+#include "config.h"
 #include <getopt.h>
 #include <errno.h>
 #include <stdbool.h>
@@ -362,7 +362,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				break;
 			case 'h':
 				print_usage("xtables-restore",
-					    IPTABLES_VERSION);
+					    PACKAGE_VERSION);
 				exit(0);
 			case 'n':
 				h.noflush = 1;
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 2cc5a7c7..98e004af 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -6,6 +6,7 @@
  * This code is distributed under the terms of GNU GPL v2
  *
  */
+#include "config.h"
 #include <getopt.h>
 #include <errno.h>
 #include <stdio.h>
@@ -80,7 +81,7 @@ __do_output(struct nft_handle *h, const char *tablename, bool counters)
 	time_t now = time(NULL);
 
 	printf("# Generated by xtables-save v%s on %s",
-	       IPTABLES_VERSION, ctime(&now));
+	       PACKAGE_VERSION, ctime(&now));
 	printf("*%s\n", tablename);
 
 	/* Dump out chain names first,
@@ -266,7 +267,7 @@ static int __ebt_save(struct nft_handle *h, const char *tablename, bool counters
 	if (first) {
 		now = time(NULL);
 		printf("# Generated by ebtables-save v%s on %s",
-		       IPTABLES_VERSION, ctime(&now));
+		       PACKAGE_VERSION, ctime(&now));
 		first = false;
 	}
 	printf("*%s\n", tablename);
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index eb35890a..4ae9ff57 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -6,7 +6,7 @@
  * by the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-
+#include "config.h"
 #include <time.h>
 #include "xtables-multi.h"
 #include "nft.h"
@@ -510,20 +510,20 @@ static int xtables_restore_xlate_main(int family, const char *progname,
 	while ((c = getopt_long(argc, argv, "hf:V", options, NULL)) != -1) {
 		switch (c) {
 		case 'h':
-			print_usage(argv[0], IPTABLES_VERSION);
+			print_usage(argv[0], PACKAGE_VERSION);
 			exit(0);
 		case 'f':
 			file = optarg;
 			break;
 		case 'V':
-			printf("%s v%s\n", argv[0], IPTABLES_VERSION);
+			printf("%s v%s\n", argv[0], PACKAGE_VERSION);
 			exit(0);
 		}
 	}
 
 	if (file == NULL) {
 		fprintf(stderr, "ERROR: missing file name\n");
-		print_usage(argv[0], IPTABLES_VERSION);
+		print_usage(argv[0], PACKAGE_VERSION);
 		exit(0);
 	}
 
@@ -534,7 +534,7 @@ static int xtables_restore_xlate_main(int family, const char *progname,
 	}
 
 	printf("# Translated by %s v%s on %s",
-	       argv[0], IPTABLES_VERSION, ctime(&now));
+	       argv[0], PACKAGE_VERSION, ctime(&now));
 	xtables_restore_parse(&h, &p, &cb_xlate, argc, argv);
 	printf("# Completed on %s", ctime(&now));
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 44986a37..93d9dcba 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -24,7 +24,7 @@
  *	along with this program; if not, write to the Free Software
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-
+#include "config.h"
 #include <getopt.h>
 #include <string.h>
 #include <netdb.h>
@@ -104,7 +104,7 @@ void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __at
 
 struct xtables_globals xtables_globals = {
 	.option_offset = 0,
-	.program_version = IPTABLES_VERSION,
+	.program_version = PACKAGE_VERSION,
 	.orig_opts = original_opts,
 	.exit_err = xtables_exit_error,
 	.compat_rev = nft_compatible_revision,
-- 
2.21.0

