From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] iptables: fix error reporting for missing/wrong arguments
Date: Sun, 12 Oct 2008 21:39:32 +0200
Message-ID: <48F25274.5090107@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040601000102030403030006"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40256 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751056AbYJLTkW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:40:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040601000102030403030006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I just noticed some problems in the iptables error reporting, the patch
attached should fix them. If nobody finds any problem on it, I'll push
it to git.

Some work to improve iptables error reporting would be nice, I'll see if
I can have a look into this issue. BTW, it would be nice to have some
kind of tool to automate the testing of command line interface. Thus, we
can ensure that the tool output remains consistent. I started some tool
for the conntrack-tools but it is still very simple.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------040601000102030403030006
Content-Type: text/x-diff;
 name="x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x.patch"

[PATCH] iptables: fix error reporting for missing/wrong arguments

This patch fixes a confusing error reporting when some arguments are
missing or the option passed is unknown.

According to man getopt_long:
"If getopt() finds an option character in argv that was not
 included in optstring, or if it detects a missing option 
 argument, it returns '?' and sets the external variable
 optopt to the actual option character."

Without the patch:

% iptables -I INPUT -m state --whatever
iptables v1.4.2-rc1: Unknown arg `(null)

% iptables -I INPUT -m state --state
iptables v1.4.2-rc1: Unknown arg `(null)

With the patch:

% iptables -I INPUT -m state --whatever
iptables v1.4.2-rc1: unknown option `--whatever'
Try `iptables -h' or 'iptables --help' for more information.

% iptables -I INPUT -m state --state
iptables v1.4.2-rc1: option `--state' requires an argument
Try `iptables -h' or 'iptables --help' for more information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/ip6tables.c b/ip6tables.c
index 12298ca..9ce1074 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1888,9 +1888,26 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 					continue;
 				}
 
-				if (!m)
+				if (!m) {
+					if (c == '?') {
+						if (optopt) {
+							exit_error(
+							   PARAMETER_PROBLEM,
+							   "option `%s' "
+							   "requires an "
+							   "argument",
+							   argv[optind-1]);
+						} else {
+							exit_error(
+							   PARAMETER_PROBLEM,
+							   "unknown option "
+							   "`%s'",
+							   argv[optind-1]);
+						}
+					}
 					exit_error(PARAMETER_PROBLEM,
 						   "Unknown arg `%s'", optarg);
+				}
 			}
 		}
 		invert = FALSE;
diff --git a/iptables.c b/iptables.c
index b927a11..d2b9081 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1909,9 +1909,26 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 					optind--;
 					continue;
 				}
-				if (!m)
+				if (!m) {
+					if (c == '?') {
+						if (optopt) {
+							exit_error(
+							   PARAMETER_PROBLEM,
+							   "option `%s' "
+							   "requires an "
+							   "argument",
+							   argv[optind-1]);
+						} else {
+							exit_error(
+							   PARAMETER_PROBLEM,
+							   "unknown option "
+							   "`%s'",
+							   argv[optind-1]);
+						}
+					}
 					exit_error(PARAMETER_PROBLEM,
 						   "Unknown arg `%s'", optarg);
+				}
 			}
 		}
 		invert = FALSE;

--------------040601000102030403030006--
