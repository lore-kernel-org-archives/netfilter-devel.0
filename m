From: "Holger Eitzenberger" <holger@eitzenberger.org>
Subject: [patch 4/6] ipset: avoid the unnecessary argv[] loop
Date: Mon, 24 Jan 2011 22:36:35 +0100
Message-ID: <20110124214013.302960629@jonathan.eitzenberger.org>
References: <20110124213631.195499507@jonathan.eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:56886 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1AXVkP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:40:15 -0500
Content-Disposition: inline; filename=ipset-remove-unnecessary-argv-loop.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After stripping off the global options there simply has to follow
a command name, there is no other syntax possible.  Therefore the
argv[] loop is unnecessary.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ipset/src/ipset.c
===================================================================
--- ipset.orig/src/ipset.c
+++ ipset/src/ipset.c
@@ -468,61 +468,57 @@ parse_commandline(int argc, char *argv[]
 
 	/* Second: parse command */
 	for (command = ipset_commands;
-	     command->cmd && cmd == IPSET_CMD_NONE;
+		 argc > 1 && command->cmd && cmd == IPSET_CMD_NONE;
 	     command++) {
-		for (i = 1; i < argc; ) {
-			if (!ipset_match_cmd(argv[1], command->name)) {
-				i++;
-				continue;
-			}
-			if (restore_line != 0
-			    && (command->cmd == IPSET_CMD_RESTORE
-			    	|| command->cmd == IPSET_CMD_VERSION
-			    	|| command->cmd == IPSET_CMD_HELP))
+		if (!ipset_match_cmd(argv[1], command->name))
+			continue;
+
+		if (restore_line != 0
+		    && (command->cmd == IPSET_CMD_RESTORE
+		    	|| command->cmd == IPSET_CMD_VERSION
+		    	|| command->cmd == IPSET_CMD_HELP))
+			return exit_error(PARAMETER_PROBLEM,
+				"Command `%s' is invalid "
+				"in restore mode.",
+				command->name[0]);
+		if (interactive && command->cmd == IPSET_CMD_RESTORE) {
+			printf("Restore command ignored "
+			       "in interactive mode\n");
+			return 0;
+		}
+
+		/* Shift off matched command arg */
+		ipset_shift_argv(&argc, argv, 1);
+		cmd = command->cmd;
+		switch (command->has_arg) {
+		case IPSET_MANDATORY_ARG:
+		case IPSET_MANDATORY_ARG2:
+			if (argc < 2)
 				return exit_error(PARAMETER_PROBLEM,
-					"Command `%s' is invalid "
-					"in restore mode.",
+					"Missing mandatory argument "
+					"to command %s",
 					command->name[0]);
-				if (interactive
-				    && command->cmd == IPSET_CMD_RESTORE) {
-					printf("Restore command ignored "
-					       "in interactive mode\n");
-				return 0;
-			}
-
-			/* Shift off matched command arg */
-			ipset_shift_argv(&argc, argv, i);
-			cmd = command->cmd;
-			switch (command->has_arg) {
-			case IPSET_MANDATORY_ARG:
-			case IPSET_MANDATORY_ARG2:
-				if (i + 1 > argc)
-					return exit_error(PARAMETER_PROBLEM,
-						"Missing mandatory argument "
-						"to command %s",
-						command->name[0]);
-				/* Fall through */
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
+			/* Fall through */
+		case IPSET_OPTIONAL_ARG:
+			arg0 = argv[1];
+			if (argc >= 2)
+				/* Shift off first arg */
+				ipset_shift_argv(&argc, argv, 1);
 			break;
+		default:
+			break;
+		}
+		if (command->has_arg == IPSET_MANDATORY_ARG2) {
+			if (argc < 2)
+				return exit_error(PARAMETER_PROBLEM,
+					"Missing second mandatory "
+					"argument to command %s",
+					command->name[0]);
+			arg1 = argv[1];
+			/* Shift off second arg */
+			ipset_shift_argv(&argc, argv, 1);
 		}
+		break;
 	}
 
 	/* Third: catch interactive mode, handle help, version */

