Return-Path: <SRS0=8SyO=UH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BE8C28CC5
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jun 2019 17:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 096B42146E
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jun 2019 17:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfFHReW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jun 2019 13:34:22 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:38586 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbfFHReW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jun 2019 13:34:22 -0400
Received: from localhost ([::1]:51676 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hZfER-0003n6-Mn; Sat, 08 Jun 2019 19:34:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables-restore: Fix program names in help texts
Date:   Sat,  8 Jun 2019 19:34:13 +0200
Message-Id: <20190608173413.25509-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Avoid referring to wrong or even non-existent commands:

* When calling xtables_restore_main(), pass the actual program name
  taken from argv[0].
* Use 'prog_name' in unknown parameter and help output instead of
  'xtables-restore' which probably doesn't exist.
* While being at it, fix false whitespace in help text.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-restore.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 86f6a3af971f0..2ef42fabc6f45 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -7,6 +7,7 @@
 #include "config.h"
 #include <getopt.h>
 #include <errno.h>
+#include <libgen.h>
 #include <stdbool.h>
 #include <string.h>
 #include <stdio.h>
@@ -51,7 +52,7 @@ static void print_usage(const char *name, const char *version)
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
 			"	   [ --table=<TABLE> ]\n"
-			"          [ --modprobe=<command> ]\n"
+			"	   [ --modprobe=<command> ]\n"
 			"	   [ --ipv4 ]\n"
 			"	   [ --ipv6 ]\n", name);
 }
@@ -361,8 +362,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				p.testing = 1;
 				break;
 			case 'h':
-				print_usage("xtables-restore",
-					    PACKAGE_VERSION);
+				print_usage(prog_name, PACKAGE_VERSION);
 				exit(0);
 			case 'n':
 				h.noflush = 1;
@@ -387,7 +387,8 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				break;
 			default:
 				fprintf(stderr,
-					"Try `xtables-restore -h' for more information.\n");
+					"Try `%s -h' for more information.\n",
+					prog_name);
 				exit(1);
 		}
 	}
@@ -443,13 +444,13 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 
 int xtables_ip4_restore_main(int argc, char *argv[])
 {
-	return xtables_restore_main(NFPROTO_IPV4, "iptables-restore",
+	return xtables_restore_main(NFPROTO_IPV4, basename(*argv),
 				    argc, argv);
 }
 
 int xtables_ip6_restore_main(int argc, char *argv[])
 {
-	return xtables_restore_main(NFPROTO_IPV6, "ip6tables-restore",
+	return xtables_restore_main(NFPROTO_IPV6, basename(*argv),
 				    argc, argv);
 }
 
-- 
2.21.0

