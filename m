From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] iptables: fix error reporting with wrong/missing arguments
Date: Wed, 19 Nov 2008 00:43:12 +0100
Message-ID: <20081118234311.15750.80335.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50463 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752086AbYKRXnX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:43:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes wrong error reporting when arguments are missing:

# iptables -I INPUT -m state --state
iptables v1.4.2-rc1: Unknown arg `(null)'
Try `iptables -h' or 'iptables --help' for more information.

or wrong:

# iptables -I INPUT -m state --xyz
iptables v1.4.2-rc1: Unknown arg `(null)'
Try `iptables -h' or 'iptables --help' for more information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 ip6tables.c |   19 ++++++++++++++++++-
 iptables.c  |   19 ++++++++++++++++++-
 2 files changed, 36 insertions(+), 2 deletions(-)

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

