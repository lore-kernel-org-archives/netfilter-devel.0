From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Make ip6tables, iptables and iptables-xml use
	xtables_globals
Date: Mon, 09 Feb 2009 22:32:03 -0500
Message-ID: <1234236724.20903.34.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-veedO3N/qzYsduFa1W/R"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:55745 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZBJDd5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:33:57 -0500
Received: by nf-out-0910.google.com with SMTP id d3so320687nfc.21
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2009 19:33:55 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-veedO3N/qzYsduFa1W/R
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Next step is to get rid of exit_error from xtables.c

cheers,
jamal

--=-veedO3N/qzYsduFa1W/R
Content-Disposition: attachment; filename=iptv2-3
Content-Type: text/plain; name=iptv2-3; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 1ffb5ab094585266e072a6b3e4950b50fbf4b9b4
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Mon Feb 9 22:12:05 2009 -0500

    convert ip6tables, iptables and iptables-xml to use
    xtables_globals/xtables_set_params()
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/Makefile.am b/Makefile.am
index 0ffb978..96de1b2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -21,6 +21,7 @@ iptables_SOURCES          = iptables-standalone.c iptables.c
 iptables_LDFLAGS          = -rdynamic
 iptables_LDADD            = -ldl -lm libiptc/libiptc.a extensions/libext4.a libxtables.la
 
+iptables_xml_LDADD        = -ldl libxtables.la
 iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
                             iptables-restore.c iptables-xml.c \
                             iptables-standalone.c iptables.c
diff --git a/ip6tables.c b/ip6tables.c
index 233974f..7561353 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -145,6 +145,13 @@ int line = -1;
 
 static struct option *opts = original_opts;
 static unsigned int global_option_offset = 0;
+struct xtables_globals ip6tables_globals = {
+	.option_offset = 0,
+	.program_version = IPTABLES_VERSION,
+	.program_name = "ip6tables",
+	.opts = original_opts,
+	.exit_error = exit_error,
+};
 
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
@@ -1371,6 +1378,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
            demand-load a protocol. */
 	opterr = 0;
 
+	xtables_set_params(&ip6tables_globals);
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
diff --git a/iptables-xml.c b/iptables-xml.c
index 307845c..329c598 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -17,6 +17,7 @@
 #include "iptables.h"
 #include "libiptc/libiptc.h"
 #include "iptables-multi.h"
+#include <xtables.h>
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
@@ -629,6 +630,12 @@ do_rule(char *pcnt, char *bcnt, int argc, char *argv[], int argvattr[])
 	do_rule_part(NULL, NULL, 1, argc, argv, argvattr);
 }
 
+struct xtables_globals iptables_xml_globals = {
+	.option_offset = 0,
+	.program_version = IPTABLES_VERSION,
+	.program_name = "iptables-xml",
+	.exit_error = exit_error,
+};
 
 #ifdef IPTABLES_MULTI
 int
@@ -646,6 +653,7 @@ main(int argc, char *argv[])
 	program_version = IPTABLES_VERSION;
 	line = 0;
 
+	xtables_set_params(&iptables_xml_globals);
 	while ((c = getopt_long(argc, argv, "cvh", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
diff --git a/iptables.c b/iptables.c
index f1a5d33..e8bed87 100644
--- a/iptables.c
+++ b/iptables.c
@@ -145,6 +145,14 @@ int line = -1;
 static struct option *opts = original_opts;
 static unsigned int global_option_offset = 0;
 
+struct xtables_globals iptables_globals = {
+	.option_offset = 0,
+	.program_version = IPTABLES_VERSION,
+	.program_name = "iptables",
+	.opts = original_opts,
+	.exit_error = exit_error,
+};
+
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
  * CMD_LIST and CMD_ZERO only).
@@ -1393,6 +1401,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
            demand-load a protocol. */
 	opterr = 0;
 
+	xtables_set_params(&iptables_globals);
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {

--=-veedO3N/qzYsduFa1W/R--

