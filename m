From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] conntrack: Replace remaining occurances of --src, --dst options with --orig-src, --orig-dst
Date: Tue,  5 Apr 2016 08:44:52 +0200
Message-ID: <1459838692-17303-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-1.mx.upcmail.net ([62.179.121.145]:12276 "EHLO
	vie01a-dmta-at01-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbcDEGpG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Apr 2016 02:45:06 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1anKjV-0003Ai-Op
	for netfilter-devel@vger.kernel.org; Tue, 05 Apr 2016 08:45:01 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The old options --src and --dst were still defined at two places.
Replaced with according --orig-src and --orig-dst entry.

Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 src/conntrack.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index b384e07..076d8a3 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -282,8 +282,8 @@ enum ct_options {
 		       CT_OPT_ORIG_ZONE | CT_OPT_REPL_ZONE)
 
 static const char *optflags[NUMBER_OF_OPT] = {
-	[CT_OPT_ORIG_SRC_BIT] 	= "src",
-	[CT_OPT_ORIG_DST_BIT]	= "dst",
+	[CT_OPT_ORIG_SRC_BIT] 	= "orig-src",
+	[CT_OPT_ORIG_DST_BIT]	= "orig-dst",
 	[CT_OPT_REPL_SRC_BIT]	= "reply-src",
 	[CT_OPT_REPL_DST_BIT]	= "reply-dst",
 	[CT_OPT_PROTO_BIT]	= "protonum",
@@ -2468,7 +2468,7 @@ int main(int argc, char *argv[])
 		case -1:
 		case 0:
 			exit_error(PARAMETER_PROBLEM, "you have to specify "
-						      "`--src' and `--dst'");
+						      "`--orig-src' and `--orig-dst'");
 			break;
 		case 1:
 			exit_error(PARAMETER_PROBLEM, "you have to specify "
-- 
1.7.2.5

