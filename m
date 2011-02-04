From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/8] iptables: reduce indentation of parse loop (2/3)
Date: Fri,  4 Feb 2011 14:08:48 +0100
Message-ID: <1296824935-4606-3-git-send-email-jengelh@medozas.de>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36766 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1BDNI7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:08:59 -0500
In-Reply-To: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The stop flag is temporary (see next patch). By using such early
break, less clauses can be removed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   50 ++++++++++++++++++++++++++------------------------
 iptables.c  |   49 ++++++++++++++++++++++++++-----------------------
 2 files changed, 52 insertions(+), 47 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index d453868..f581509 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1702,7 +1702,9 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			fprintf(stderr, "Bad argument `%s'\n", optarg);
 			exit_tryhelp(2);
 
-		default:
+		default: {
+			bool stop = false;
+
 			if (target != NULL && target->parse != NULL &&
 			    c >= target->option_offset &&
 			    c < target->option_offset + XT_OPTION_OFFSET_SCALE &&
@@ -1722,10 +1724,13 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					     argv, invert,
 					     &matchp->match->mflags,
 					     &fw,
-					     &matchp->match->m))
+					     &matchp->match->m)) {
+					stop = true;
 					break;
+				}
 			}
-			m = matchp ? matchp->match : NULL;
+			if (stop)
+				break;
 
 			/* If you listen carefully, you can
 			   actually hear this code suck. */
@@ -1750,8 +1755,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			 * - the protocol extension can be successively
 			 *   loaded
 			 */
-			if (m == NULL
-			    && protocol
+			if (protocol != NULL
 			    && (!find_proto(protocol, XTF_DONT_LOAD,
 					   options&OPT_NUMERIC, NULL)
 				|| (find_proto(protocol, XTF_DONT_LOAD,
@@ -1781,27 +1785,25 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				optind--;
 				continue;
 			}
-
-			if (!m) {
-				if (c == '?') {
-					if (optopt) {
-						xtables_error(
-						   PARAMETER_PROBLEM,
-						   "option `%s' "
-						   "requires an "
-						   "argument",
-						   argv[optind-1]);
-					} else {
-						xtables_error(
-						   PARAMETER_PROBLEM,
-						   "unknown option "
-						   "`%s'",
-						   argv[optind-1]);
-					}
+			if (c == '?') {
+				if (optopt) {
+					xtables_error(
+					   PARAMETER_PROBLEM,
+					   "option `%s' "
+					   "requires an "
+					   "argument",
+					   argv[optind-1]);
+				} else {
+					xtables_error(
+					   PARAMETER_PROBLEM,
+					   "unknown option "
+					   "`%s'",
+					   argv[optind-1]);
 				}
-				xtables_error(PARAMETER_PROBLEM,
-					   "Unknown arg `%s'", optarg);
 			}
+			xtables_error(PARAMETER_PROBLEM,
+				   "Unknown arg `%s'", optarg);
+		} /* default */
 		}
 		invert = FALSE;
 	}
diff --git a/iptables.c b/iptables.c
index eb7ac8e..b957e66 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1734,7 +1734,9 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			fprintf(stderr, "Bad argument `%s'\n", optarg);
 			exit_tryhelp(2);
 
-		default:
+		default: {
+			bool stop = false;
+
 			if (target != NULL && target->parse != NULL &&
 			    c >= target->option_offset &&
 			    c < target->option_offset + XT_OPTION_OFFSET_SCALE &&
@@ -1754,10 +1756,13 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					     argv, invert,
 					     &matchp->match->mflags,
 					     &fw,
-					     &matchp->match->m))
+					     &matchp->match->m)) {
+					stop = true;
 					break;
+				}
 			}
-			m = matchp ? matchp->match : NULL;
+			if (stop)
+				break;
 
 			/* If you listen carefully, you can
 			   actually hear this code suck. */
@@ -1782,8 +1787,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			 * - the protocol extension can be successively
 			 *   loaded
 			 */
-			if (m == NULL
-			    && protocol
+			if (protocol != NULL
 			    && (!find_proto(protocol, XTF_DONT_LOAD,
 					   options&OPT_NUMERIC, NULL)
 				|| (find_proto(protocol, XTF_DONT_LOAD,
@@ -1819,26 +1823,25 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				optind--;
 				continue;
 			}
-			if (!m) {
-				if (c == '?') {
-					if (optopt) {
-						xtables_error(
-						   PARAMETER_PROBLEM,
-						   "option `%s' "
-						   "requires an "
-						   "argument",
-						   argv[optind-1]);
-					} else {
-						xtables_error(
-						   PARAMETER_PROBLEM,
-						   "unknown option "
-						   "`%s'",
-						   argv[optind-1]);
-					}
+			if (c == '?') {
+				if (optopt) {
+					xtables_error(
+					   PARAMETER_PROBLEM,
+					   "option `%s' "
+					   "requires an "
+					   "argument",
+					   argv[optind-1]);
+				} else {
+					xtables_error(
+					   PARAMETER_PROBLEM,
+					   "unknown option "
+					   "`%s'",
+					   argv[optind-1]);
 				}
-				xtables_error(PARAMETER_PROBLEM,
-					   "Unknown arg `%s'", optarg);
 			}
+			xtables_error(PARAMETER_PROBLEM,
+				   "Unknown arg `%s'", optarg);
+		} /* default */
 		}
 		invert = FALSE;
 	}
-- 
1.7.1

