From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 8/9] libxt_udp: use guided option parser
Date: Sun,  1 May 2011 13:50:28 +0200
Message-ID: <1304250630-6150-9-git-send-email-jengelh@medozas.de>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50023 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab1EALum (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2011 07:50:42 -0400
In-Reply-To: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_udp.c |   95 +++++++++++++++---------------------------------
 1 files changed, 30 insertions(+), 65 deletions(-)

diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 505b3c8..a539edd 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -1,14 +1,15 @@
-/* Shared library add-on to iptables to add UDP support. */
-#include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <netinet/in.h>
+#include <arpa/inet.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_tcpudp.h>
 
+enum {
+	O_SOURCE_PORT = 0,
+	O_DEST_PORT,
+};
+
 static void udp_help(void)
 {
 	printf(
@@ -21,36 +22,19 @@ static void udp_help(void)
 "				match destination port(s)\n");
 }
 
-static const struct option udp_opts[] = {
-	{.name = "source-port",      .has_arg = true, .val = '1'},
-	{.name = "sport",            .has_arg = true, .val = '1'}, /* synonym */
-	{.name = "destination-port", .has_arg = true, .val = '2'},
-	{.name = "dport",            .has_arg = true, .val = '2'}, /* synonym */
-	XT_GETOPT_TABLEEND,
+#define s struct xt_udp
+static const struct xt_option_entry udp_opts[] = {
+	{.name = "source-port", .id = O_SOURCE_PORT, .type = XTTYPE_PORTRC_NE,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, spts)},
+	{.name = "sport", .id = O_SOURCE_PORT, .type = XTTYPE_PORTRC_NE,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, spts)},
+	{.name = "destination-port", .id = O_DEST_PORT, .type = XTTYPE_PORTRC_NE,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, dpts)},
+	{.name = "dport", .id = O_DEST_PORT, .type = XTTYPE_PORTRC_NE,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, dpts)},
+	XTOPT_TABLEEND,
 };
-
-static void
-parse_udp_ports(const char *portstring, uint16_t *ports)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(portstring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = xtables_parse_port(buffer, "udp");
-	else {
-		*cp = '\0';
-		cp++;
-
-		ports[0] = buffer[0] ? xtables_parse_port(buffer, "udp") : 0;
-		ports[1] = cp[0] ? xtables_parse_port(cp, "udp") : 0xFFFF;
-
-		if (ports[0] > ports[1])
-			xtables_error(PARAMETER_PROBLEM,
-				   "invalid portrange (min > max)");
-	}
-	free(buffer);
-}
+#undef s
 
 static void udp_init(struct xt_entry_match *m)
 {
@@ -59,40 +43,21 @@ static void udp_init(struct xt_entry_match *m)
 	udpinfo->spts[1] = udpinfo->dpts[1] = 0xFFFF;
 }
 
-#define UDP_SRC_PORTS 0x01
-#define UDP_DST_PORTS 0x02
-
-static int
-udp_parse(int c, char **argv, int invert, unsigned int *flags,
-          const void *entry, struct xt_entry_match **match)
+static void udp_parse(struct xt_option_call *cb)
 {
-	struct xt_udp *udpinfo = (struct xt_udp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & UDP_SRC_PORTS)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--source-port' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_udp_ports(optarg, udpinfo->spts);
-		if (invert)
+	struct xt_udp *udpinfo = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SOURCE_PORT:
+		if (cb->invert)
 			udpinfo->invflags |= XT_UDP_INV_SRCPT;
-		*flags |= UDP_SRC_PORTS;
 		break;
-
-	case '2':
-		if (*flags & UDP_DST_PORTS)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--destination-port' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_udp_ports(optarg, udpinfo->dpts);
-		if (invert)
+	case O_DEST_PORT:
+		if (cb->invert)
 			udpinfo->invflags |= XT_UDP_INV_DSTPT;
-		*flags |= UDP_DST_PORTS;
 		break;
 	}
-
-	return 1;
 }
 
 static char *
@@ -195,10 +160,10 @@ static struct xtables_match udp_match = {
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_udp)),
 	.help		= udp_help,
 	.init		= udp_init,
-	.parse		= udp_parse,
 	.print		= udp_print,
 	.save		= udp_save,
-	.extra_opts	= udp_opts,
+	.x6_parse	= udp_parse,
+	.x6_options	= udp_opts,
 };
 
 void
-- 
1.7.1

