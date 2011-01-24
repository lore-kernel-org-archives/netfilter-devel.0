From: "Holger Eitzenberger" <holger@eitzenberger.org>
Subject: [patch 5/6] ipset: improve command argument parsing
Date: Mon, 24 Jan 2011 22:36:36 +0100
Message-ID: <20110124214014.604070478@jonathan.eitzenberger.org>
References: <20110124213631.195499507@jonathan.eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:53154 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1AXVkQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:40:16 -0500
Content-Disposition: inline; filename=ipset-improve-cmd-argument-parsing.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The number of comparisons for a matching a command name can be
made smaller by just checking on argv[1].

As an example consider the following 'create' arguments 'hashsize',
'family' and 'timeout'.  When having the command
 
 create foo hash:ip timeout 60 family inet hashsize 64

it compares without this patch:

 strcmp("timeout", "hashsize")
 strcmp("64", "hashsize")
 strcmp("family", "hashsize")
 strcmp("inet", "hashsize")
 strcmp("hashsize", "hashsize")

It is worse in practice, as 'create' has more arguments than this.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ipset/src/ipset.c
===================================================================
--- ipset.orig/src/ipset.c
+++ ipset/src/ipset.c
@@ -206,38 +206,35 @@ restore(char *argv0)
 static int
 call_parser(int *argc, char *argv[], const struct ipset_arg *args)
 {
-	int i = 1, ret = 0;
+	int ret = 0;
 	const struct ipset_arg *arg;
 	
 	/* Currently CREATE and ADT may have got additional arguments */
-	if (!args)
-		goto done;
-	for (arg = args; arg->opt; arg++) {
-		for (i = 1; i < *argc; ) {
-			D("argc: %u, i: %u: %s vs %s",
-			  *argc, i, argv[i], arg->name[0]);
-			if (!(ipset_match_option(argv[i], arg->name))) {
-				i++;
+	if (!args && *argc > 1)
+		goto err_unknown;
+	while (*argc > 1) {
+		for (arg = args; arg->opt; arg++) {
+			D("argc: %u, %s vs %s", *argc, argv[1], arg->name[0]);
+			if (!(ipset_match_option(argv[1], arg->name)))
 				continue;
-			}
+
 			/* Shift off matched option */
 			D("match %s", arg->name[0]);
-			ipset_shift_argv(argc, argv, i);
-			D("argc: %u, i: %u", *argc, i);
+			ipset_shift_argv(argc, argv, 1);
 			switch (arg->has_arg) {
 			case IPSET_MANDATORY_ARG:
-				if (i + 1 > *argc)
+				if (*argc < 2)
 					return exit_error(PARAMETER_PROBLEM,
 						"Missing mandatory argument "
 						"of option `%s'",
 						arg->name[0]);
 				/* Fall through */
 			case IPSET_OPTIONAL_ARG:
-				if (i + 1 <= *argc) {
-					ret = ipset_call_parser(session, arg, argv[i]);
+				if (*argc >= 2) {
+					ret = ipset_call_parser(session, arg, argv[1]);
 					if (ret < 0)
 						return ret;
-					ipset_shift_argv(argc, argv, i);
+					ipset_shift_argv(argc, argv, 1);
 					break;
 				}
 				/* Fall through */
@@ -246,14 +243,18 @@ call_parser(int *argc, char *argv[], con
 				if (ret < 0)
 					return ret;
 			}
+
+			break;
 		}
+
+		if (!arg->opt)
+			goto err_unknown;
 	}
-done:
-	if (i < *argc)
-		return exit_error(PARAMETER_PROBLEM,
-				  "Unknown argument: `%s'",
-				  argv[i]);
+
 	return ret;
+
+err_unknown:
+	return exit_error(PARAMETER_PROBLEM, "Unknown argument: `%s'", argv[1]);
 }
 
 static enum ipset_adt

