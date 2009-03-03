From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] iptables: fix broken options-merging during libxtables rework
Date: Tue, 03 Mar 2009 17:49:09 +0100
Message-ID: <20090303164909.15156.82748.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, hadi@cyberus.ca
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59044 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751791AbZCCQzz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:55:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes options-merging that was broken somewhere
during the libxtables rework. Before this patch, two pointers
were used to keep the current options, however, the options field
in xt_params was not appropritely updated. Thus, xtables_free_opts()
was not restoring the original options.

This patch fixes iptables-restore and ip6tables-restore that
stopped working in my personal firewall.

% iptables-restore
*filter
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables-restore v1.4.3-rc1: Unknown arg `ESTABLISHED,RELATED'
Error occurred at line: 4
Try `iptables-restore -h' or 'iptables-restore --help' for more information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 ip6tables.c |    2 +-
 iptables.c  |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 87663ef..54366b0 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -141,7 +141,6 @@ static struct option original_opts[] = {
  * magic number of -1 */
 int line = -1;
 
-static struct option *opts = original_opts;
 void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
@@ -194,6 +193,7 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 /* -c */ 0,
 };
 
+#define opts ip6tables_globals.opts
 #define prog_name ip6tables_globals.program_name
 #define prog_vers ip6tables_globals.program_version
 /* A few hardcoded protocols for 'all' and in case the user has no
diff --git a/iptables.c b/iptables.c
index bd177c7..8e37bee 100644
--- a/iptables.c
+++ b/iptables.c
@@ -140,8 +140,6 @@ static struct option original_opts[] = {
  * magic number of -1 */
 int line = -1;
 
-static struct option *opts = original_opts;
-
 void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 
 struct xtables_globals iptables_globals = {
@@ -196,6 +194,7 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 /* -c */ 0,
 };
 
+#define opts iptables_globals.opts
 #define prog_name iptables_globals.program_name
 #define prog_vers iptables_globals.program_version
 

