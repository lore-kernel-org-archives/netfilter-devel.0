From: holger@eitzenberger.org
Subject: [patch 2/2] ipset: remove unneeded argvloop
Date: Wed, 19 Jan 2011 21:26:09 +0100
Message-ID: <20110119203559.985967421@eitzenberger.org>
References: <20110119202607.532407993@eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab1ASUgD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:36:03 -0500
Content-Disposition: inline; filename=ipset-enforce-command-argument-order.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is not a change of functionality.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ipset/src/ipset.c
===================================================================
--- ipset.orig/src/ipset.c	2011-01-19 12:11:34.000000000 +0100
+++ ipset/src/ipset.c	2011-01-19 14:05:10.000000000 +0100
@@ -206,61 +206,56 @@
 static int
 call_parser(int *argc, char *argv[], const struct ipset_arg *args)
 {
-	int i = 1, ret = 0;
+	int ret = 0;
 	const struct ipset_arg *arg;
 	const char *optstr;
 	
 	/* Currently CREATE and ADT may have got additional arguments */
 	if (!args)
 		goto done;
-	for (arg = args; arg->opt; arg++) {
-		for (i = 1; i < *argc; ) {
-			D("argc: %u, i: %u: %s vs %s",
-			  *argc, i, argv[i], arg->name[0]);
-			if (!(ipset_match_option(argv[i], arg->name))) {
-				i++;
-				continue;
-			}
-			optstr = argv[i];
-			/* Shift off matched option */
-			D("match %s", arg->name[0]);
-			ipset_shift_argv(argc, argv, i);
-			D("argc: %u, i: %u", *argc, i);
-			switch (arg->has_arg) {
-			case IPSET_MANDATORY_ARG:
-				if (i + 1 > *argc)
-					return exit_error(PARAMETER_PROBLEM,
-						"Missing mandatory argument "
-						"of option `%s'",
-						arg->name[0]);
-				/* Fall through */
-			case IPSET_OPTIONAL_ARG:
-				if (i + 1 <= *argc) {
-					ret = ipset_call_parser(session,
-							arg->parse,
-							optstr, arg->opt,
-							argv[i]);
-					if (ret < 0)
-						return ret;
-					ipset_shift_argv(argc, argv, i);
-					break;
-				}
-				/* Fall through */
-			default:
+	for (arg = args; *argc > 1 && arg->opt; arg++) {
+		D("argc: %u: %s vs %s", *argc, argv[1], arg->name[0]);
+		if (!(ipset_match_option(argv[1], arg->name)))
+			continue;
+
+		optstr = argv[1];
+		/* Shift off matched option */
+		D("match %s", arg->name[0]);
+		ipset_shift_argv(argc, argv, 1);
+		D("argc: %u", *argc);
+		switch (arg->has_arg) {
+		case IPSET_MANDATORY_ARG:
+			if (*argc < 2)
+				return exit_error(PARAMETER_PROBLEM,
+								  "Missing mandatory argument "
+								  "of option `%s'",
+								  arg->name[0]);
+			/* Fall through */
+		case IPSET_OPTIONAL_ARG:
+			if (*argc >= 2) {
 				ret = ipset_call_parser(session,
-							arg->parse,
-							optstr, arg->opt,
-							optstr);
+										arg->parse,
+										optstr, arg->opt,
+										argv[1]);
 				if (ret < 0)
 					return ret;
+				ipset_shift_argv(argc, argv, 1);
+				break;
 			}
+			/* Fall through */
+		default:
+			ret = ipset_call_parser(session,
+									arg->parse,
+									optstr, arg->opt,
+									optstr);
+			if (ret < 0)
+				return ret;
 		}
 	}
 done:
-	if (i < *argc)
-		return exit_error(PARAMETER_PROBLEM,
-				  "Unknown argument: `%s'",
-				  argv[i]);
+	if (*argc > 1)
+		return exit_error(PARAMETER_PROBLEM, "Unknown argument: `%s'",
+						  argv[1]);
 	return ret;
 }
 

-- 
