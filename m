Return-Path: <SRS0=6+Vk=V4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359B0C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 16:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A5A9206A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 16:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfGaQjZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:39:25 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40898 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbfGaQjZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 12:39:25 -0400
Received: from localhost ([::1]:53988 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hsrdL-0005ip-Qw; Wed, 31 Jul 2019 18:39:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/5] xtables-monitor: Add family-specific aliases
Date:   Wed, 31 Jul 2019 18:39:15 +0200
Message-Id: <20190731163915.22232-6-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731163915.22232-1-phil@nwl.cc>
References: <20190731163915.22232-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow for more intuitive xtables-monitor use, e.g. 'ebtables-monitor'
instead of 'xtables-monitor --bridge'. This needs separate main
functions to call from xtables-nft-multi.c and in turn allows to
properly initialize for each family. The latter is required to correctly
print e.g. rules using ebtables extensions.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/Makefile.am          | 13 ++++--
 iptables/xtables-monitor.8.in | 14 ++++++
 iptables/xtables-monitor.c    | 88 ++++++++++++++++++++++++++++-------
 iptables/xtables-multi.h      |  4 ++
 iptables/xtables-nft-multi.c  |  4 ++
 5 files changed, 104 insertions(+), 19 deletions(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index da07b9a4b5a2f..0af9f8dc7738e 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -49,6 +49,8 @@ endif
 
 XTABLES_XLATE_8_LINKS = iptables-translate.8 ip6tables-translate.8 \
 			iptables-restore-translate.8 ip6tables-restore-translate.8
+XTABLES_MONITOR_8_LINKS = iptables-monitor.8 ip6tables-monitor.8 \
+			  arptables-monitor.8 ebtables-monitor.8
 
 sbin_PROGRAMS    = xtables-legacy-multi
 if ENABLE_NFTABLES
@@ -60,12 +62,13 @@ man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
 if ENABLE_NFTABLES
 man_MANS	+= xtables-nft.8 xtables-translate.8 xtables-legacy.8 \
                    ${XTABLES_XLATE_8_LINKS} \
-                   xtables-monitor.8 \
+                   xtables-monitor.8 ${XTABLES_MONITOR_8_LINKS} \
                    arptables-nft.8 arptables-nft-restore.8 arptables-nft-save.8 \
                    ebtables-nft.8
 endif
 CLEANFILES       = iptables.8 xtables-monitor.8 \
-		   ${XTABLES_XLATE_8_LINKS}
+		   ${XTABLES_XLATE_8_LINKS} \
+		   ${XTABLES_MONITOR_8_LINKS}
 
 vx_bin_links   = iptables-xml
 if ENABLE_IPV4
@@ -87,7 +90,8 @@ x_sbin_links  = iptables-nft iptables-nft-restore iptables-nft-save \
 		ebtables-nft ebtables \
 		ebtables-nft-restore ebtables-restore \
 		ebtables-nft-save ebtables-save \
-		xtables-monitor
+		xtables-monitor arptables-monitor ebtables-monitor \
+		iptables-monitor ip6tables-monitor
 endif
 
 iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../extensions/targets.man
@@ -98,6 +102,9 @@ iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../e
 ${XTABLES_XLATE_8_LINKS}:
 	${AM_VERBOSE_GEN} echo '.so man8/xtables-translate.8' >$@
 
+${XTABLES_MONITOR_8_LINKS}:
+	${AM_VERBOSE_GEN} echo '.so man8/xtables-monitor.8' >$@
+
 pkgconfig_DATA = xtables.pc
 
 # Using if..fi avoids an ugly "error (ignored)" message :)
diff --git a/iptables/xtables-monitor.8.in b/iptables/xtables-monitor.8.in
index 6bde54fa4a359..b91b81489d1b9 100644
--- a/iptables/xtables-monitor.8.in
+++ b/iptables/xtables-monitor.8.in
@@ -3,6 +3,14 @@
 xtables-monitor \(em show changes to rule set and trace-events
 .SH SYNOPSIS
 \fBxtables\-monitor\fP [\fB\-t\fP] [\fB\-e\fP] [\fB\-0\fP|\fB-1\fP|\fB\-4\fP|\fB\-6\fP]
+.br
+\fBiptables-monitor\fP [\fB\-t\fP] [\fB\-e\fP]
+.br
+\fBip6tables-monitor\fP [\fB\-t\fP] [\fB\-e\fP]
+.br
+\fBarptables-monitor\fP [\fB\-t\fP] [\fB\-e\fP]
+.br
+\fBebtables-monitor\fP [\fB\-t\fP] [\fB\-e\fP]
 .PP
 \
 .SH DESCRIPTION
@@ -12,6 +20,12 @@ is used to monitor changes to the ruleset or to show rule evaluation events
 for packets tagged using the TRACE target.
 .B xtables-monitor
 will run until the user aborts execution, typically by using CTRL-C.
+.PP
+.BR iptables-monitor ", " ip6tables-monitor ", "
+.BR arptables-monitor " and " ebtables-monitor
+are aliases to calling
+.B xtables-monitor
+with a family filtering flag.
 .RE
 .SH OPTIONS
 .TP
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 9be8ce9de6b5f..71e9de45a34a3 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -37,6 +37,7 @@
 #include "xtables-multi.h"
 #include "nft.h"
 #include "nft-arp.h"
+#include "nft-bridge.h"
 
 struct cb_arg {
 	uint32_t nfproto;
@@ -611,28 +612,16 @@ static void set_nfproto(struct cb_arg *arg, uint32_t val)
 	arg->nfproto = val;
 }
 
-int xtables_monitor_main(int argc, char *argv[])
+static int __xtables_monitor_main(uint32_t family, int argc, char *argv[])
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint32_t nfgroup = 0;
-	struct cb_arg cb_arg = {};
+	struct cb_arg cb_arg = {
+		.nfproto = family,
+	};
 	int ret, c;
 
-	xtables_globals.program_name = "xtables-monitor";
-	/* XXX xtables_init_all does several things we don't want */
-	c = xtables_init_all(&xtables_globals, NFPROTO_IPV4);
-	if (c < 0) {
-		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
-				xtables_globals.program_name,
-				xtables_globals.program_version);
-		exit(1);
-	}
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
-	init_extensions4();
-#endif
-
 	opterr = 0;
 	while ((c = getopt_long(argc, argv, "ceht0146V", options, NULL)) != -1) {
 		switch (c) {
@@ -708,3 +697,70 @@ int xtables_monitor_main(int argc, char *argv[])
 	return EXIT_SUCCESS;
 }
 
+static void common_xtables_init(const char *argv0, uint8_t family)
+{
+	xtables_globals.program_name = basename(argv0);
+
+	/* XXX xtables_init_all does several things we don't want */
+	if (xtables_init_all(&xtables_globals, family) < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				xtables_globals.program_name,
+				xtables_globals.program_version);
+		exit(1);
+	}
+}
+
+int xtables_monitor_main(int argc, char *argv[])
+{
+	/* Can't pass NFPROTO_UNSPEC, xtables_set_nfproto() would complain. */
+	common_xtables_init(argv[0], NFPROTO_IPV4);
+
+	return __xtables_monitor_main(NFPROTO_UNSPEC, argc, argv);
+}
+
+int iptables_monitor_main(int argc, char *argv[])
+{
+	common_xtables_init(argv[0], NFPROTO_IPV4);
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
+	init_extensions4();
+#endif
+
+	return __xtables_monitor_main(NFPROTO_IPV4, argc, argv);
+}
+
+int ip6tables_monitor_main(int argc, char *argv[])
+{
+	common_xtables_init(argv[0], NFPROTO_IPV6);
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
+	init_extensions4();
+#endif
+
+	return __xtables_monitor_main(NFPROTO_IPV6, argc, argv);
+}
+
+int arptables_monitor_main(int argc, char *argv[])
+{
+	common_xtables_init(argv[0], NFPROTO_ARP);
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensionsa();
+#endif
+
+	return __xtables_monitor_main(NFPROTO_ARP, argc, argv);
+}
+
+int ebtables_monitor_main(int argc, char *argv[])
+{
+	common_xtables_init(argv[0], NFPROTO_BRIDGE);
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensionsb();
+#endif
+	/* manually registering ebt matches, given the original ebtables parser
+	 * don't use '-m matchname' and the match can't be loaded dynamically when
+	 * the user calls it.
+	 */
+	ebt_load_match_extensions();
+
+	return __xtables_monitor_main(NFPROTO_BRIDGE, argc, argv);
+}
diff --git a/iptables/xtables-multi.h b/iptables/xtables-multi.h
index 0fedb430e1a28..11364ba5b731e 100644
--- a/iptables/xtables-multi.h
+++ b/iptables/xtables-multi.h
@@ -22,6 +22,10 @@ extern int xtables_eb_restore_main(int, char **);
 extern int xtables_eb_save_main(int, char **);
 extern int xtables_config_main(int, char **);
 extern int xtables_monitor_main(int, char **);
+extern int iptables_monitor_main(int, char **);
+extern int ip6tables_monitor_main(int, char **);
+extern int arptables_monitor_main(int, char **);
+extern int ebtables_monitor_main(int, char **);
 #endif
 
 #endif /* _XTABLES_MULTI_H */
diff --git a/iptables/xtables-nft-multi.c b/iptables/xtables-nft-multi.c
index e2b7c641f85dd..3b13d89dffcb3 100644
--- a/iptables/xtables-nft-multi.c
+++ b/iptables/xtables-nft-multi.c
@@ -44,6 +44,10 @@ static const struct subcommand multi_subcommands[] = {
 	{"ebtables-nft-restore",	xtables_eb_restore_main},
 	{"ebtables-nft-save",		xtables_eb_save_main},
 	{"xtables-monitor",		xtables_monitor_main},
+	{"iptables-monitor",		iptables_monitor_main},
+	{"ip6tables-monitor",		ip6tables_monitor_main},
+	{"arptables-monitor",		arptables_monitor_main},
+	{"ebtables-monitor",		ebtables_monitor_main},
 	{NULL},
 };
 
-- 
2.22.0

