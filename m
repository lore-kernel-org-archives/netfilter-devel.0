From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft-compat) PATCH 4/8] xtables: Add backward compatibility with -w option
Date: Tue, 11 Feb 2014 12:46:44 +0200
Message-ID: <1392115608-6733-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16550 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbaBKKrG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:47:06 -0500
In-Reply-To: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just to keep aligned with iptables legacy tool.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.h                |  2 +-
 iptables/xtables-restore.c    |  3 ++-
 iptables/xtables-standalone.c |  2 +-
 iptables/xtables.c            | 11 ++++++++++-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.h b/iptables/nft.h
index 26b60b9..22af66e 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -135,7 +135,7 @@ int nft_compatible_revision(const char *name, uint8_t rev, int opt);
 const char *nft_strerror(int err);
 
 /* For xtables.c */
-int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table);
+int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table, bool restore);
 /* For xtables-arptables.c */
 int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table);
 
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 80bd724..50d2935 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -442,7 +442,8 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 			for (a = 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
-			ret = do_commandx(&h, newargc, newargv, &newargv[2]);
+			ret = do_commandx(&h, newargc, newargv,
+					  &newargv[2], true);
 			if (ret < 0) {
 				ret = nft_abort(&h);
 				if (ret < 0) {
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index eb13980..355a446 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -70,7 +70,7 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	ret = do_commandx(&h, argc, argv, &table);
+	ret = do_commandx(&h, argc, argv, &table, false);
 	if (ret)
 		ret = nft_commit(&h);
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index c49b4a2..7a8ace3 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -678,7 +678,8 @@ static void command_match(struct iptables_command_state *cs)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 }
 
-int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
+int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
+		bool restore)
 {
 	struct iptables_command_state cs;
 	int verbose = 0;
@@ -1001,6 +1002,14 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 				       prog_name, prog_vers);
 			exit(0);
 
+		case 'w':
+			if (restore) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "You cannot use `-w' from "
+					      "iptables-restore");
+			}
+			break;
+
 		case '0':
 			set_option(&cs.options, OPT_LINENUMBERS,
 				   &args.invflags, cs.invert);
-- 
1.8.3.2

