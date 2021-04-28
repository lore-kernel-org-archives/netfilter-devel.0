Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC81C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E79561444
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242246AbhD1RiL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242228AbhD1RiC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 13:38:02 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF5EC061573
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 10:37:15 -0700 (PDT)
Received: from localhost ([::1]:34730 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lbo7d-0007AL-Lf; Wed, 28 Apr 2021 19:37:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/5] xshared: Merge invflags handling code
Date:   Wed, 28 Apr 2021 19:36:54 +0200
Message-Id: <20210428173656.16851-4-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210428173656.16851-1-phil@nwl.cc>
References: <20210428173656.16851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Join invflags handling between iptables, ip6tables, xtables and
arptables. Ebtables still has its own code which differs quite a bit.

In order to use a shared set_option() routine, iptables and ip6tables
need to provide a local 'invflags' variable which is 16bits wide.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c   | 73 ++++++++++--------------------------------
 iptables/iptables.c    | 72 ++++++++++-------------------------------
 iptables/nft-arp.h     |  7 ----
 iptables/xshared.c     | 43 +++++++++++++++++++++++++
 iptables/xshared.h     | 11 +++++++
 iptables/xtables-arp.c | 44 -------------------------
 iptables/xtables.c     | 37 ---------------------
 7 files changed, 88 insertions(+), 199 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 60db11b7131e5..044d9a33a0266 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -96,21 +96,6 @@ struct xtables_globals ip6tables_globals = {
 	.compat_rev = xtables_compatible_revision,
 };
 
-static const unsigned int inverse_for_options[NUMBER_OF_OPT] =
-{
-/* -n */ 0,
-/* -s */ IP6T_INV_SRCIP,
-/* -d */ IP6T_INV_DSTIP,
-/* -p */ XT_INV_PROTO,
-/* -j */ 0,
-/* -v */ 0,
-/* -x */ 0,
-/* -i */ IP6T_INV_VIA_IN,
-/* -o */ IP6T_INV_VIA_OUT,
-/*--line*/ 0,
-/* -c */ 0,
-};
-
 #define opts ip6tables_globals.opts
 #define prog_name ip6tables_globals.program_name
 #define prog_vers ip6tables_globals.program_version
@@ -274,28 +259,6 @@ parse_chain(const char *chainname)
 				   "Invalid chain name `%s'", chainname);
 }
 
-static void
-set_option(unsigned int *options, unsigned int option, uint8_t *invflg,
-	   int invert)
-{
-	if (*options & option)
-		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
-			   opt2char(option));
-	*options |= option;
-
-	if (invert) {
-		unsigned int i;
-		for (i = 0; 1 << i != option; i++);
-
-		if (!inverse_for_options[i])
-			xtables_error(PARAMETER_PROBLEM,
-				   "cannot have ! before -%c",
-				   opt2char(option));
-		*invflg |= inverse_for_options[i];
-	}
-}
-
-
 static void
 print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 {
@@ -1083,6 +1046,7 @@ int do_command6(int argc, char *argv[], char **table,
 	struct xtables_target *t;
 	unsigned long long cnt;
 	bool table_set = false;
+	uint16_t invflags = 0;
 	bool invert = false;
 
 	/* re-set optind to 0 in case do_command6 gets called
@@ -1242,7 +1206,7 @@ int do_command6(int argc, char *argv[], char **table,
 			 * Option selection
 			 */
 		case 'p':
-			set_option(&cs.options, OPT_PROTOCOL, &cs.fw6.ipv6.invflags,
+			set_option(&cs.options, OPT_PROTOCOL, &invflags,
 				   invert);
 
 			/* Canonicalize into lower case */
@@ -1253,13 +1217,12 @@ int do_command6(int argc, char *argv[], char **table,
 			cs.fw6.ipv6.proto = xtables_parse_protocol(cs.protocol);
 			cs.fw6.ipv6.flags |= IP6T_F_PROTO;
 
-			if (cs.fw6.ipv6.proto == 0
-			    && (cs.fw6.ipv6.invflags & XT_INV_PROTO))
+			if (cs.fw6.ipv6.proto == 0 && (invflags & XT_INV_PROTO))
 				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 
 			if (is_exthdr(cs.fw6.ipv6.proto)
-			    && (cs.fw6.ipv6.invflags & XT_INV_PROTO) == 0)
+			    && (invflags & XT_INV_PROTO) == 0)
 				fprintf(stderr,
 					"Warning: never matched protocol: %s. "
 					"use extension match instead.\n",
@@ -1267,29 +1230,26 @@ int do_command6(int argc, char *argv[], char **table,
 			break;
 
 		case 's':
-			set_option(&cs.options, OPT_SOURCE, &cs.fw6.ipv6.invflags,
-				   invert);
+			set_option(&cs.options, OPT_SOURCE, &invflags, invert);
 			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
-			set_option(&cs.options, OPT_DESTINATION, &cs.fw6.ipv6.invflags,
+			set_option(&cs.options, OPT_DESTINATION, &invflags,
 				   invert);
 			dhostnetworkmask = optarg;
 			break;
 
 #ifdef IP6T_F_GOTO
 		case 'g':
-			set_option(&cs.options, OPT_JUMP, &cs.fw6.ipv6.invflags,
-					invert);
+			set_option(&cs.options, OPT_JUMP, &invflags, invert);
 			cs.fw6.ipv6.flags |= IP6T_F_GOTO;
 			cs.jumpto = xt_parse_target(optarg);
 			break;
 #endif
 
 		case 'j':
-			set_option(&cs.options, OPT_JUMP, &cs.fw6.ipv6.invflags,
-					invert);
+			set_option(&cs.options, OPT_JUMP, &invflags, invert);
 			command_jump(&cs, optarg);
 			break;
 
@@ -1299,7 +1259,7 @@ int do_command6(int argc, char *argv[], char **table,
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw6.ipv6.invflags,
+			set_option(&cs.options, OPT_VIANAMEIN, &invflags,
 				   invert);
 			xtables_parse_interface(optarg,
 					cs.fw6.ipv6.iniface,
@@ -1311,7 +1271,7 @@ int do_command6(int argc, char *argv[], char **table,
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw6.ipv6.invflags,
+			set_option(&cs.options, OPT_VIANAMEOUT, &invflags,
 				   invert);
 			xtables_parse_interface(optarg,
 					cs.fw6.ipv6.outiface,
@@ -1321,7 +1281,7 @@ int do_command6(int argc, char *argv[], char **table,
 		case 'v':
 			if (!verbose)
 				set_option(&cs.options, OPT_VERBOSE,
-					   &cs.fw6.ipv6.invflags, invert);
+					   &invflags, invert);
 			verbose++;
 			break;
 
@@ -1349,8 +1309,7 @@ int do_command6(int argc, char *argv[], char **table,
 			break;
 
 		case 'n':
-			set_option(&cs.options, OPT_NUMERIC, &cs.fw6.ipv6.invflags,
-				   invert);
+			set_option(&cs.options, OPT_NUMERIC, &invflags, invert);
 			break;
 
 		case 't':
@@ -1366,7 +1325,7 @@ int do_command6(int argc, char *argv[], char **table,
 			break;
 
 		case 'x':
-			set_option(&cs.options, OPT_EXPANDED, &cs.fw6.ipv6.invflags,
+			set_option(&cs.options, OPT_EXPANDED, &invflags,
 				   invert);
 			break;
 
@@ -1379,7 +1338,7 @@ int do_command6(int argc, char *argv[], char **table,
 			exit(0);
 
 		case '0':
-			set_option(&cs.options, OPT_LINENUMBERS, &cs.fw6.ipv6.invflags,
+			set_option(&cs.options, OPT_LINENUMBERS, &invflags,
 				   invert);
 			break;
 
@@ -1389,7 +1348,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 'c':
 
-			set_option(&cs.options, OPT_COUNTERS, &cs.fw6.ipv6.invflags,
+			set_option(&cs.options, OPT_COUNTERS, &invflags,
 				   invert);
 			pcnt = optarg;
 			bcnt = strchr(pcnt + 1, ',');
@@ -1479,6 +1438,8 @@ int do_command6(int argc, char *argv[], char **table,
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
+	cs.fw6.ipv6.invflags = invflags;
+
 	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
 		if (!(cs.options & OPT_DESTINATION))
 			dhostnetworkmask = "::0/0";
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 0976017383b4d..da67dd2e1e997 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -94,22 +94,6 @@ struct xtables_globals iptables_globals = {
 	.compat_rev = xtables_compatible_revision,
 };
 
-static const int inverse_for_options[NUMBER_OF_OPT] =
-{
-/* -n */ 0,
-/* -s */ IPT_INV_SRCIP,
-/* -d */ IPT_INV_DSTIP,
-/* -p */ XT_INV_PROTO,
-/* -j */ 0,
-/* -v */ 0,
-/* -x */ 0,
-/* -i */ IPT_INV_VIA_IN,
-/* -o */ IPT_INV_VIA_OUT,
-/*--line*/ 0,
-/* -c */ 0,
-/* -f */ IPT_INV_FRAG,
-};
-
 #define opts iptables_globals.opts
 #define prog_name iptables_globals.program_name
 #define prog_vers iptables_globals.program_version
@@ -265,27 +249,6 @@ parse_chain(const char *chainname)
 				   "Invalid chain name `%s'", chainname);
 }
 
-static void
-set_option(unsigned int *options, unsigned int option, uint8_t *invflg,
-	   int invert)
-{
-	if (*options & option)
-		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
-			   opt2char(option));
-	*options |= option;
-
-	if (invert) {
-		unsigned int i;
-		for (i = 0; 1 << i != option; i++);
-
-		if (!inverse_for_options[i])
-			xtables_error(PARAMETER_PROBLEM,
-				   "cannot have ! before -%c",
-				   opt2char(option));
-		*invflg |= inverse_for_options[i];
-	}
-}
-
 static void
 print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 {
@@ -1078,6 +1041,7 @@ int do_command4(int argc, char *argv[], char **table,
 	struct xtables_target *t;
 	unsigned long long cnt;
 	bool table_set = false;
+	uint16_t invflags = 0;
 	bool invert = false;
 
 	/* re-set optind to 0 in case do_command4 gets called
@@ -1236,7 +1200,7 @@ int do_command4(int argc, char *argv[], char **table,
 			 * Option selection
 			 */
 		case 'p':
-			set_option(&cs.options, OPT_PROTOCOL, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_PROTOCOL, &invflags,
 				   invert);
 
 			/* Canonicalize into lower case */
@@ -1246,36 +1210,32 @@ int do_command4(int argc, char *argv[], char **table,
 			cs.protocol = optarg;
 			cs.fw.ip.proto = xtables_parse_protocol(cs.protocol);
 
-			if (cs.fw.ip.proto == 0
-			    && (cs.fw.ip.invflags & XT_INV_PROTO))
+			if (cs.fw.ip.proto == 0 && (invflags & XT_INV_PROTO))
 				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 			break;
 
 		case 's':
-			set_option(&cs.options, OPT_SOURCE, &cs.fw.ip.invflags,
-				   invert);
+			set_option(&cs.options, OPT_SOURCE, &invflags, invert);
 			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
-			set_option(&cs.options, OPT_DESTINATION, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_DESTINATION, &invflags,
 				   invert);
 			dhostnetworkmask = optarg;
 			break;
 
 #ifdef IPT_F_GOTO
 		case 'g':
-			set_option(&cs.options, OPT_JUMP, &cs.fw.ip.invflags,
-				   invert);
+			set_option(&cs.options, OPT_JUMP, &invflags, invert);
 			cs.fw.ip.flags |= IPT_F_GOTO;
 			cs.jumpto = xt_parse_target(optarg);
 			break;
 #endif
 
 		case 'j':
-			set_option(&cs.options, OPT_JUMP, &cs.fw.ip.invflags,
-				   invert);
+			set_option(&cs.options, OPT_JUMP, &invflags, invert);
 			command_jump(&cs, optarg);
 			break;
 
@@ -1285,7 +1245,7 @@ int do_command4(int argc, char *argv[], char **table,
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_VIANAMEIN, &invflags,
 				   invert);
 			xtables_parse_interface(optarg,
 					cs.fw.ip.iniface,
@@ -1297,7 +1257,7 @@ int do_command4(int argc, char *argv[], char **table,
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_VIANAMEOUT, &invflags,
 				   invert);
 			xtables_parse_interface(optarg,
 					cs.fw.ip.outiface,
@@ -1305,7 +1265,7 @@ int do_command4(int argc, char *argv[], char **table,
 			break;
 
 		case 'f':
-			set_option(&cs.options, OPT_FRAGMENT, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_FRAGMENT, &invflags,
 				   invert);
 			cs.fw.ip.flags |= IPT_F_FRAG;
 			break;
@@ -1313,7 +1273,7 @@ int do_command4(int argc, char *argv[], char **table,
 		case 'v':
 			if (!verbose)
 				set_option(&cs.options, OPT_VERBOSE,
-					   &cs.fw.ip.invflags, invert);
+					   &invflags, invert);
 			verbose++;
 			break;
 
@@ -1341,7 +1301,7 @@ int do_command4(int argc, char *argv[], char **table,
 			break;
 
 		case 'n':
-			set_option(&cs.options, OPT_NUMERIC, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_NUMERIC, &invflags,
 				   invert);
 			break;
 
@@ -1358,7 +1318,7 @@ int do_command4(int argc, char *argv[], char **table,
 			break;
 
 		case 'x':
-			set_option(&cs.options, OPT_EXPANDED, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_EXPANDED, &invflags,
 				   invert);
 			break;
 
@@ -1371,7 +1331,7 @@ int do_command4(int argc, char *argv[], char **table,
 			exit(0);
 
 		case '0':
-			set_option(&cs.options, OPT_LINENUMBERS, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_LINENUMBERS, &invflags,
 				   invert);
 			break;
 
@@ -1381,7 +1341,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 'c':
 
-			set_option(&cs.options, OPT_COUNTERS, &cs.fw.ip.invflags,
+			set_option(&cs.options, OPT_COUNTERS, &invflags,
 				   invert);
 			pcnt = optarg;
 			bcnt = strchr(pcnt + 1, ',');
@@ -1467,6 +1427,8 @@ int do_command4(int argc, char *argv[], char **table,
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
+	cs.fw.ip.invflags = invflags;
+
 	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
 		if (!(cs.options & OPT_DESTINATION))
 			dhostnetworkmask = "0.0.0.0/0";
diff --git a/iptables/nft-arp.h b/iptables/nft-arp.h
index 0d93a31f563b1..3411fc3d7c7b3 100644
--- a/iptables/nft-arp.h
+++ b/iptables/nft-arp.h
@@ -4,11 +4,4 @@
 extern char *arp_opcodes[];
 #define NUMOPCODES 9
 
-/* define invflags which won't collide with IPT ones */
-#define IPT_INV_SRCDEVADDR	0x0080
-#define IPT_INV_TGTDEVADDR	0x0100
-#define IPT_INV_ARPHLN		0x0200
-#define IPT_INV_ARPOP		0x0400
-#define IPT_INV_ARPHRD		0x0800
-
 #endif
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 18d8735f3211c..5e3a6aeb343a6 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -853,3 +853,46 @@ char opt2char(int option)
 
 	return *ptr;
 }
+
+static const int inverse_for_options[NUMBER_OF_OPT] =
+{
+/* -n */ 0,
+/* -s */ IPT_INV_SRCIP,
+/* -d */ IPT_INV_DSTIP,
+/* -p */ XT_INV_PROTO,
+/* -j */ 0,
+/* -v */ 0,
+/* -x */ 0,
+/* -i */ IPT_INV_VIA_IN,
+/* -o */ IPT_INV_VIA_OUT,
+/*--line*/ 0,
+/* -c */ 0,
+/* -f */ IPT_INV_FRAG,
+/* 2 */ IPT_INV_SRCDEVADDR,
+/* 3 */ IPT_INV_TGTDEVADDR,
+/* -l */ IPT_INV_ARPHLN,
+/* 4 */ IPT_INV_ARPOP,
+/* 5 */ IPT_INV_ARPHRD,
+/* 6 */ IPT_INV_PROTO,
+};
+
+void
+set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
+	   bool invert)
+{
+	if (*options & option)
+		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
+			   opt2char(option));
+	*options |= option;
+
+	if (invert) {
+		unsigned int i;
+		for (i = 0; 1 << i != option; i++);
+
+		if (!inverse_for_options[i])
+			xtables_error(PARAMETER_PROBLEM,
+				   "cannot have ! before -%c",
+				   opt2char(option));
+		*invflg |= inverse_for_options[i];
+	}
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index c2ecb4aed641b..c4de0292f4d8e 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -68,6 +68,17 @@ struct xtables_globals;
 struct xtables_rule_match;
 struct xtables_target;
 
+/* define invflags which won't collide with IPT ones */
+#define IPT_INV_SRCDEVADDR	0x0080
+#define IPT_INV_TGTDEVADDR	0x0100
+#define IPT_INV_ARPHLN		0x0200
+#define IPT_INV_ARPOP		0x0400
+#define IPT_INV_ARPHRD		0x0800
+
+void
+set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
+	   bool invert);
+
 /**
  * xtables_afinfo - protocol family dependent information
  * @kmod:		kernel module basename (e.g. "ip_tables")
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 4a89ae9507051..4a351f0cab4a7 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -105,29 +105,6 @@ struct xtables_globals arptables_globals = {
 	.compat_rev		= nft_compatible_revision,
 };
 
-/* index relates to bit of each OPT_* value */
-static int inverse_for_options[] =
-{
-/* -n */ 0,
-/* -s */ IPT_INV_SRCIP,
-/* -d */ IPT_INV_DSTIP,
-/* -p */ 0,
-/* -j */ 0,
-/* -v */ 0,
-/* -x */ 0,
-/* -i */ IPT_INV_VIA_IN,
-/* -o */ IPT_INV_VIA_OUT,
-/*--line*/ 0,
-/* -c */ 0,
-/* -f */ 0,
-/* 2 */ IPT_INV_SRCDEVADDR,
-/* 3 */ IPT_INV_TGTDEVADDR,
-/* -l */ IPT_INV_ARPHLN,
-/* 4 */ IPT_INV_ARPOP,
-/* 5 */ IPT_INV_ARPHRD,
-/* 6 */ IPT_INV_PROTO,
-};
-
 /***********************************************/
 /* ARPTABLES SPECIFIC NEW FUNCTIONS ADDED HERE */
 /***********************************************/
@@ -298,27 +275,6 @@ check_inverse(const char option[], int *invert, int *optidx, int argc)
 	return false;
 }
 
-static void
-set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
-	   int invert)
-{
-	if (*options & option)
-		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
-			      opt2char(option));
-	*options |= option;
-
-	if (invert) {
-		unsigned int i;
-		for (i = 0; 1 << i != option; i++);
-
-		if (!inverse_for_options[i])
-			xtables_error(PARAMETER_PROBLEM,
-				      "cannot have ! before -%c",
-				      opt2char(option));
-		*invflg |= inverse_for_options[i];
-	}
-}
-
 static int
 list_entries(struct nft_handle *h, const char *chain, const char *table,
 	     int rulenum, int verbose, int numeric, int expanded,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 73531ca88b517..daa9b137b5fa4 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -94,22 +94,6 @@ struct xtables_globals xtables_globals = {
 	.compat_rev = nft_compatible_revision,
 };
 
-static const int inverse_for_options[NUMBER_OF_OPT] =
-{
-/* -n */ 0,
-/* -s */ IPT_INV_SRCIP,
-/* -d */ IPT_INV_DSTIP,
-/* -p */ XT_INV_PROTO,
-/* -j */ 0,
-/* -v */ 0,
-/* -x */ 0,
-/* -i */ IPT_INV_VIA_IN,
-/* -o */ IPT_INV_VIA_OUT,
-/*--line*/ 0,
-/* -c */ 0,
-/* -f */ IPT_INV_FRAG,
-};
-
 #define opts xt_params->opts
 #define prog_name xt_params->program_name
 #define prog_vers xt_params->program_version
@@ -238,27 +222,6 @@ xtables_exit_error(enum xtables_exittype status, const char *msg, ...)
 
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 
-static void
-set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
-	   bool invert)
-{
-	if (*options & option)
-		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
-			   opt2char(option));
-	*options |= option;
-
-	if (invert) {
-		unsigned int i;
-		for (i = 0; 1 << i != option; i++);
-
-		if (!inverse_for_options[i])
-			xtables_error(PARAMETER_PROBLEM,
-				   "cannot have ! before -%c",
-				   opt2char(option));
-		*invflg |= inverse_for_options[i];
-	}
-}
-
 static int
 add_entry(const char *chain,
 	  const char *table,
-- 
2.31.0

