Return-Path: <SRS0=ZDGT=EC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961D0C55178
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Oct 2020 13:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5711A21556
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Oct 2020 13:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752147AbgJ0NdE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:33:04 -0400
Received: from correo.us.es ([193.147.175.20]:55648 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752127AbgJ0NdE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Oct 2020 09:33:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 83F1C10328A
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2020 14:33:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74ABCDA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2020 14:33:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6A547DA704; Tue, 27 Oct 2020 14:33:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3DB7BDA72F;
        Tue, 27 Oct 2020 14:32:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 27 Oct 2020 14:32:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1E14B42EF9E1;
        Tue, 27 Oct 2020 14:32:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@cloud.ionos.com
Subject: [PATCH conntrack] conntrack: default to unspec family for dualstack setups
Date:   Tue, 27 Oct 2020 14:32:55 +0100
Message-Id: <20201027133255.24498-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

2bcbae4c14b2 ("conntrack: -f family filter does not work") restored the
fallback to IPv4 if -f is not specified, which was the original
behaviour.

This patch modifies the default to use the unspec family if -f is not
specified for the following ct commands:

- list
- update
- delete
- get
- flush
- event (this command does not support for -f though, but in case this
  is extended in the future to supports it).

The existing code that parses IPv4 and IPv6 addresses already infers the
family, which simplifies the introduction of this update.

The expect commands are not updated, they still require many mandatory
options for filtering.

This patch includes a few test updates too.

Based on patch from Mikhail Sennikovsky.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c                    | 22 +++++++++++++++++++---
 tests/conntrack/testsuite/01delete |  5 +++++
 tests/conntrack/testsuite/02filter |  8 ++++++++
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index a26fa60bbbc9..db35b070dadb 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -41,6 +41,7 @@
 #include "conntrack.h"
 
 #include <stdio.h>
+#include <assert.h>
 #include <getopt.h>
 #include <stdlib.h>
 #include <ctype.h>
@@ -2171,6 +2172,7 @@ nfct_filter_init(const int family)
 {
 	filter_family = family;
 	if (options & CT_OPT_MASK_SRC) {
+		assert(family != AF_UNSPEC);
 		if (!(options & CT_OPT_ORIG_SRC))
 			exit_error(PARAMETER_PROBLEM,
 			           "Can't use --mask-src without --src");
@@ -2178,6 +2180,7 @@ nfct_filter_init(const int family)
 	}
 
 	if (options & CT_OPT_MASK_DST) {
+		assert(family != AF_UNSPEC);
 		if (!(options & CT_OPT_ORIG_DST))
 			exit_error(PARAMETER_PROBLEM,
 			           "Can't use --mask-dst without --dst");
@@ -2574,9 +2577,22 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	/* default family */
-	if (family == AF_UNSPEC)
-		family = AF_INET;
+	/* default family only for the following commands */
+	if (family == AF_UNSPEC) {
+		switch (command) {
+		case CT_LIST:
+		case CT_UPDATE:
+		case CT_DELETE:
+		case CT_GET:
+		case CT_FLUSH:
+		case CT_EVENT:
+			break;
+		default:
+			family = AF_INET;
+			break;
+		}
+	}
+
 
 	/* we cannot check this combination with generic_opt_check. */
 	if (options & CT_OPT_ANY_NAT &&
diff --git a/tests/conntrack/testsuite/01delete b/tests/conntrack/testsuite/01delete
index 2755491883d5..64dbb108a41d 100644
--- a/tests/conntrack/testsuite/01delete
+++ b/tests/conntrack/testsuite/01delete
@@ -30,3 +30,8 @@
 -D -s 1.1.1.0/24 -d 2.2.2.0/24 ; OK
 # try same command again but with CIDR (no matching found)
 -D -s 1.1.1.0/24 -d 2.2.2.0/24 ; BAD
+# try to delete mismatching address family
+-D -s ::1 -d 2.2.2.2 ; BAD
+# try to delete IPv6 address without specifying IPv6 family
+-I -s ::1 -d ::2 -p tcp --sport 20 --dport 10 --state LISTEN -u SEEN_REPLY -t 40 ; OK
+-D -s ::1 ; OK
diff --git a/tests/conntrack/testsuite/02filter b/tests/conntrack/testsuite/02filter
index 91a75eb991f7..d58637fb0aba 100644
--- a/tests/conntrack/testsuite/02filter
+++ b/tests/conntrack/testsuite/02filter
@@ -23,5 +23,13 @@ conntrack -L --mark 0/0xffffffff; OK
 conntrack -L -s 1.1.1.0 --mask-src 255.255.255.0 -d 2.0.0.0 --mask-dst 255.0.0.0 ; OK
 conntrack -L -s 1.1.1.4/24 -d 2.3.4.5/8 ; OK
 conntrack -L -s 1.1.2.0/24 -d 2.3.4.5/8 ; OK
+# filter filter mismatching address family
+conntrack -L -s 2.2.2.2 -d ::1 ; BAD
+# filter by IPv6 address, it implicitly sets IPv6 family
+conntrack -L -s ::1 ; OK
+# filter by IPv6 address mask, it implicitly sets IPv6 family
+conntrack -L -s abcd:abcd:abcd:: --mask-src ffff:ffff:ffff:: ; OK
+# filter filter mismatching address family
+conntrack -L --mask-src ffff:ffff:ffff:: --mask-dst 255.0.0.0 ; BAD
 # delete dummy
 conntrack -D -d 2.2.2.2 ; OK
-- 
2.20.1

