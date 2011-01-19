From: holger@eitzenberger.org
Subject: [patch 1/2] ipset: remove the unneeded argvloop
Date: Wed, 19 Jan 2011 21:26:08 +0100
Message-ID: <20110119203559.494912348@eitzenberger.org>
References: <20110119202607.532407993@eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:54710 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab1ASUgJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:36:09 -0500
Content-Disposition: inline; filename=ipset-enforce-command-order.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the inner argv[] loop.

It is not a change functionality.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ipset/src/ipset.c
===================================================================
--- ipset.orig/src/ipset.c	2011-01-19 21:14:59.000000000 +0100
+++ ipset/src/ipset.c	2011-01-19 21:17:55.000000000 +0100
@@ -425,7 +425,6 @@
 {
 	int ret = 0;
 	enum ipset_cmd cmd = IPSET_CMD_NONE;
-	int i;
 	char *arg0 = NULL, *arg1 = NULL, *c;
 	const struct ipset_envopts *opt;
 	const struct ipset_commands *command;
@@ -476,61 +475,58 @@
 
 	/* Second: parse command */
 	for (command = ipset_commands;
-	     command->cmd && cmd == IPSET_CMD_NONE;
+	     argc > 1 && command->cmd && cmd == IPSET_CMD_NONE;
 	     command++) {
-		for (i = 1; i < argc; ) {
-			if (!ipset_match_cmd(argv[1], command->name)) {
-				i++;
+		if (!ipset_match_cmd(argv[1], command->name))
 				continue;
-			}
-			if (restore_line != 0
-			    && (command->cmd == IPSET_CMD_RESTORE
-			    	|| command->cmd == IPSET_CMD_VERSION
-			    	|| command->cmd == IPSET_CMD_HELP))
-				return exit_error(PARAMETER_PROBLEM,
+
+		if (restore_line != 0
+			&& (command->cmd == IPSET_CMD_RESTORE
+				|| command->cmd == IPSET_CMD_VERSION
+				|| command->cmd == IPSET_CMD_HELP))
+			return exit_error(PARAMETER_PROBLEM,
 					"Command `%s' is invalid "
 					"in restore mode.",
 					command->name[0]);
-				if (interactive
-				    && command->cmd == IPSET_CMD_RESTORE) {
-					printf("Restore command ignored "
-					       "in interactive mode\n");
-				return 0;
-			}
+		if (interactive
+			&& command->cmd == IPSET_CMD_RESTORE) {
+			printf("Restore command ignored "
+				   "in interactive mode\n");
+			return 0;
+		}
 
-			/* Shift off matched command arg */
-			ipset_shift_argv(&argc, argv, i);
-			cmd = command->cmd;
-			switch (command->has_arg) {
-			case IPSET_MANDATORY_ARG:
-			case IPSET_MANDATORY_ARG2:
-				if (i + 1 > argc)
+		/* Shift off matched command arg */
+		ipset_shift_argv(&argc, argv, 1);
+		cmd = command->cmd;
+		switch (command->has_arg) {
+		case IPSET_MANDATORY_ARG:
+		case IPSET_MANDATORY_ARG2:
+				if (argc < 2)
 					return exit_error(PARAMETER_PROBLEM,
-						"Missing mandatory argument "
-						"to command %s",
-						command->name[0]);
+									  "Missing mandatory argument "
+									  "to command %s",
+									  command->name[0]);
 				/* Fall through */
-			case IPSET_OPTIONAL_ARG:
-				arg0 = argv[i];
-				if (i + 1 <= argc)
-					/* Shift off first arg */
-					ipset_shift_argv(&argc, argv, i);
-				break;
-			default:
-				break;
-			}
-			if (command->has_arg == IPSET_MANDATORY_ARG2) {
-				if (i + 1 > argc)
-					return exit_error(PARAMETER_PROBLEM,
-						"Missing second mandatory "
-						"argument to command %s",
-						command->name[0]);
-				arg1 = argv[i];
-				/* Shift off second arg */
-				ipset_shift_argv(&argc, argv, i);
-			}
+		case IPSET_OPTIONAL_ARG:
+			arg0 = argv[1];
+			if (argc >= 2)
+				/* Shift off first arg */
+				ipset_shift_argv(&argc, argv, 1);
+			break;
+		default:
 			break;
 		}
+		if (command->has_arg == IPSET_MANDATORY_ARG2) {
+			if (argc < 2)
+				return exit_error(PARAMETER_PROBLEM,
+								  "Missing second mandatory "
+								  "argument to command %s",
+								  command->name[0]);
+			arg1 = argv[1];
+			/* Shift off second arg */
+			ipset_shift_argv(&argc, argv, 1);
+		}
+		break;
 	}
 
 	/* Third: catch interactive mode, handle help, version */

-- 
