From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables-restore: fix segmentation fault with -tanything
Date: Sun, 3 Aug 2008 15:02:43 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808031501080.27230@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54381 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbYHCTCp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Aug 2008 15:02:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit e075edd231346496d9e93477704a74c9c664bfc7
Author: Michael Spang <mspang@uwaterloo.ca>
Date:   Sun Aug 3 15:00:26 2008 -0400

iptables-restore: fix segmentation fault with -tanything

Reference: Debian bug #458042

iptables-restore must not pass a table into do_command. It checks for
"-t arg" and "--table arg", but not "-targ". (On a related note,
using -targ does not work as expected).

This should fail gracefully, but crashes:

	iptables-restore <(echo -e '*filter\n-A INPUT -tx\nCOMMIT')

And this should use table "filter", or perhaps raise an error, but
instead sets the table to (literally) "-tfilter":

	iptables -tfilter -A INPUT

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-restore.c |    2 +-
 ip6tables.c         |    5 ++---
 iptables-restore.c  |    2 +-
 iptables.c          |    5 ++---
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index cd6dd03..f51e38f 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -406,7 +406,7 @@ int main(int argc, char *argv[])
 					param_buffer[param_len] = '\0';
 
 					/* check if table name specified */
-					if (!strncmp(param_buffer, "-t", 3)
+					if (!strncmp(param_buffer, "-t", 2)
                                             || !strncmp(param_buffer, "--table", 8)) {
 						exit_error(PARAMETER_PROBLEM,
 						   "Line %u seems to have a "
diff --git a/ip6tables.c b/ip6tables.c
index 2b05392..283a1c2 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1747,7 +1747,7 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 			if (invert)
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
-			*table = argv[optind-1];
+			*table = optarg;
 			break;
 
 		case 'x':
@@ -1890,8 +1890,7 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 
 				if (!m)
 					exit_error(PARAMETER_PROBLEM,
-						   "Unknown arg `%s'",
-						   argv[optind-1]);
+						   "Unknown arg `%s'", optarg);
 			}
 		}
 		invert = FALSE;
diff --git a/iptables-restore.c b/iptables-restore.c
index 4b199d9..dcbed14 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -412,7 +412,7 @@ main(int argc, char *argv[])
 					param_buffer[param_len] = '\0';
 
 					/* check if table name specified */
-					if (!strncmp(param_buffer, "-t", 3)
+					if (!strncmp(param_buffer, "-t", 2)
 					    || !strncmp(param_buffer, "--table", 8)) {
 						exit_error(PARAMETER_PROBLEM,
 						   "Line %u seems to have a "
diff --git a/iptables.c b/iptables.c
index bf3cbca..41e1836 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1764,7 +1764,7 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 			if (invert)
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
-			*table = argv[optind-1];
+			*table = optarg;
 			break;
 
 		case 'x':
@@ -1911,8 +1911,7 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 				}
 				if (!m)
 					exit_error(PARAMETER_PROBLEM,
-						   "Unknown arg `%s'",
-						   argv[optind-1]);
+						   "Unknown arg `%s'", optarg);
 			}
 		}
 		invert = FALSE;

