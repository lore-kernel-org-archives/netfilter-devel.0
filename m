From: Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] conntrack: fix reporting of unknown arguments
Date: Wed, 24 Jul 2013 22:47:38 +0200
Message-ID: <1374698858-1857-1-git-send-email-fw@strlen.de>
Cc: Clemence Faure <clemence.faure@sophos.com>,
	Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33324 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751579Ab3GXUsB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:48:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Clemence Faure <clemence.faure@sophos.com>

short options were always reported as "unknown argument".
getopt(3) says:

if [it] finds an option character in argv that was not included in
optstring, or if it detects a missing option argument, it returns '?'
and sets the external variable optopt to the actual option character.
If the first character [...] of  optstring  is  a  colon  (':'),
then getopt() returns ':' instead of '?' to indicate a missing option
argument.

Signed-off-by: Clemence Faure <clemence.faure@sophos.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
Will push this one soon if noone objects.

diff --git a/src/conntrack.c b/src/conntrack.c
index af36f78..7d2a365 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -333,7 +333,7 @@ static struct option original_opts[] = {
 	{0, 0, 0, 0}
 };
 
-static const char *getopt_str = "L::I::U::D::G::E::F::hVs:d:r:q:"
+static const char *getopt_str = ":L::I::U::D::G::E::F::hVs:d:r:q:"
 				"p:t:u:e:a:z[:]:{:}:m:i:f:o:n::"
 				"g::c:b:C::Sj::w:l:";
 
@@ -2054,15 +2054,13 @@ int main(int argc, char *argv[])
 			socketbuffersize = atol(optarg);
 			options |= CT_OPT_BUFFERSIZE;
 			break;
+		case ':':
+			exit_error(PARAMETER_PROBLEM,
+				   "option `%s' requires an "
+				   "argument", argv[optind-1]);
 		case '?':
-			if (optopt)
-				exit_error(PARAMETER_PROBLEM,
-					   "option `%s' requires an "
-					   "argument", argv[optind-1]);
-			else
-				exit_error(PARAMETER_PROBLEM,
-					   "unknown option `%s'", 
-					   argv[optind-1]);
+			exit_error(PARAMETER_PROBLEM,
+				   "unknown option `%s'", argv[optind-1]);
 			break;
 		default:
 			if (h && h->parse_opts 
-- 
1.8.1.5

