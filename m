From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] conntrack: Rename option --protonum to --proto.
Date: Tue,  5 Apr 2016 23:31:58 +0200
Message-ID: <1459891918-2283-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at02-1.mx.upcmail.net ([62.179.121.148]:36563 "EHLO
	vie01a-dmta-at02-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbcDEVc3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Apr 2016 17:32:29 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-pe01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1anYaH-0002H8-4U
	for netfilter-devel@vger.kernel.org; Tue, 05 Apr 2016 23:32:25 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Usage shows --protonum, while the man page talks about --proto.
Should be --proto in usage too. --protonum remains valid,
but is marked deprecated in source.

Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 src/conntrack.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 076d8a3..7a286eb 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -286,7 +286,7 @@ static const char *optflags[NUMBER_OF_OPT] = {
 	[CT_OPT_ORIG_DST_BIT]	= "orig-dst",
 	[CT_OPT_REPL_SRC_BIT]	= "reply-src",
 	[CT_OPT_REPL_DST_BIT]	= "reply-dst",
-	[CT_OPT_PROTO_BIT]	= "protonum",
+	[CT_OPT_PROTO_BIT]	= "proto",
 	[CT_OPT_TIMEOUT_BIT]	= "timeout",
 	[CT_OPT_STATUS_BIT]	= "status",
 	[CT_OPT_ZERO_BIT]	= "zero",
@@ -331,7 +331,8 @@ static struct option original_opts[] = {
 	{"dst", 1, 0, 'd'},
 	{"reply-src", 1, 0, 'r'},
 	{"reply-dst", 1, 0, 'q'},
-	{"protonum", 1, 0, 'p'},
+	{"proto", 1, 0, 'p'},
+	{"protonum", 1, 0, 'p'},	/* deprecated */
 	{"timeout", 1, 0, 't'},
 	{"status", 1, 0, 'u'},
 	{"zero", 0, 0, 'z'},
@@ -551,7 +552,7 @@ static const char usage_parameters[] =
 	"  -d, --orig-dst ip\t\tDestination address from original direction\n"
 	"  -r, --reply-src ip\t\tSource addres from reply direction\n"
 	"  -q, --reply-dst ip\t\tDestination address from reply direction\n"
-	"  -p, --protonum proto\t\tLayer 4 Protocol, eg. 'tcp'\n"
+	"  -p, --proto proto\t\tLayer 4 Protocol, eg. 'tcp'\n"
 	"  -f, --family proto\t\tLayer 3 Protocol, eg. 'ipv6'\n"
 	"  -t, --timeout timeout\t\tSet timeout\n"
 	"  -u, --status status\t\tSet status, eg. ASSURED\n"
-- 
1.7.2.5

