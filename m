From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/28] libip[6]t_ah: use guided option parser
Date: Tue, 12 Apr 2011 16:23:20 +0200
Message-ID: <1302618224-9449-6-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51093 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1DLOXw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:52 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ah.c |  112 +++++++++++-----------------------------------
 extensions/libipt_ah.c  |   89 +++++++------------------------------
 2 files changed, 43 insertions(+), 158 deletions(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 2922047..d30ddfa 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -1,14 +1,13 @@
-/* Shared library add-on to ip6tables to add AH support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <errno.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_ah.h>
 
+enum {
+	O_AHSPI = 0,
+	O_AHLEN,
+	O_AHRES,
+};
+
 static void ah_help(void)
 {
 	printf(
@@ -18,55 +17,16 @@ static void ah_help(void)
 " --ahres                       check the reserved field too\n");
 }
 
-static const struct option ah_opts[] = {
-	{.name = "ahspi", .has_arg = true,  .val = '1'},
-	{.name = "ahlen", .has_arg = true,  .val = '2'},
-	{.name = "ahres", .has_arg = false, .val = '3'},
-	XT_GETOPT_TABLEEND,
+#define s struct ip6t_ah
+static const struct xt_option_entry ah_opts[] = {
+	{.name = "ahspi", .id = O_AHSPI, .type = XTTYPE_UINT32RC,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, spis)},
+	{.name = "ahlen", .id = O_AHLEN, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hdrlen)},
+	{.name = "ahres", .id = O_AHRES, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
-
-static uint32_t
-parse_ah_spi(const char *spistr, const char *typestr)
-{
-	unsigned long int spi;
-	char* ep;
-
-	spi = strtoul(spistr, &ep, 0);
-
-	if ( spistr == ep )
-		xtables_error(PARAMETER_PROBLEM,
-			   "AH no valid digits in %s `%s'", typestr, spistr);
-
-	if ( spi == ULONG_MAX  && errno == ERANGE )
-		xtables_error(PARAMETER_PROBLEM,
-			   "%s `%s' specified too big: would overflow",
-			   typestr, spistr);
-
-	if ( *spistr != '\0'  && *ep != '\0' )
-		xtables_error(PARAMETER_PROBLEM,
-			   "AH error parsing %s `%s'", typestr, spistr);
-
-	return spi;
-}
-
-static void
-parse_ah_spis(const char *spistring, uint32_t *spis)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(spistring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		spis[0] = spis[1] = parse_ah_spi(buffer, "spi");
-	else {
-		*cp = '\0';
-		cp++;
-
-		spis[0] = buffer[0] ? parse_ah_spi(buffer, "spi") : 0;
-		spis[1] = cp[0] ? parse_ah_spi(cp, "spi") : 0xFFFFFFFF;
-	}
-	free(buffer);
-}
+#undef s
 
 static void ah_init(struct xt_entry_match *m)
 {
@@ -75,42 +35,24 @@ static void ah_init(struct xt_entry_match *m)
 	ahinfo->spis[1] = 0xFFFFFFFF;
 }
 
-static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
-                    const void *entry, struct xt_entry_match **match)
+static void ah_parse(struct xt_option_call *cb)
 {
-	struct ip6t_ah *ahinfo = (struct ip6t_ah *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & IP6T_AH_SPI)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--ahspi' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_ah_spis(optarg, ahinfo->spis);
-		if (invert)
+	struct ip6t_ah *ahinfo = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_AHSPI:
+		if (cb->invert)
 			ahinfo->invflags |= IP6T_AH_INV_SPI;
-		*flags |= IP6T_AH_SPI;
 		break;
-	case '2':
-		if (*flags & IP6T_AH_LEN)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--ahlen' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		ahinfo->hdrlen = parse_ah_spi(optarg, "length");
-		if (invert)
+	case O_AHLEN:
+		if (cb->invert)
 			ahinfo->invflags |= IP6T_AH_INV_LEN;
-		*flags |= IP6T_AH_LEN;
 		break;
-	case '3':
-		if (*flags & IP6T_AH_RES)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--ahres' allowed");
+	case O_AHRES:
 		ahinfo->hdrres = 1;
-		*flags |= IP6T_AH_RES;
 		break;
 	}
-
-	return 1;
 }
 
 static void
@@ -191,10 +133,10 @@ static struct xtables_match ah_mt6_reg = {
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_ah)),
 	.help          = ah_help,
 	.init          = ah_init,
-	.parse         = ah_parse,
 	.print         = ah_print,
 	.save          = ah_save,
-	.extra_opts    = ah_opts,
+	.x6_parse      = ah_parse,
+	.x6_options    = ah_opts,
 };
 
 void
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index c50eecc..53adfd8 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -1,14 +1,11 @@
-/* Shared library add-on to iptables to add AH support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <errno.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_ah.h>
 
+enum {
+	O_AHSPI = 0,
+};
+
 static void ah_help(void)
 {
 	printf(
@@ -17,53 +14,13 @@ static void ah_help(void)
 "				match spi (range)\n");
 }
 
-static const struct option ah_opts[] = {
-	{.name = "ahspi", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry ah_opts[] = {
+	{.name = "ahspi", .id = O_AHSPI, .type = XTTYPE_UINT32RC,
+	 .flags = XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(struct ipt_ah, spis)},
+	XTOPT_TABLEEND,
 };
 
-static uint32_t
-parse_ah_spi(const char *spistr)
-{
-	unsigned long int spi;
-	char* ep;
-
-	spi =  strtoul(spistr,&ep,0) ;
-
-	if ( spistr == ep ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "AH no valid digits in spi `%s'", spistr);
-	}
-	if ( spi == ULONG_MAX  && errno == ERANGE ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "spi `%s' specified too big: would overflow", spistr);
-	}	
-	if ( *spistr != '\0'  && *ep != '\0' ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "AH error parsing spi `%s'", spistr);
-	}
-	return spi;
-}
-
-static void
-parse_ah_spis(const char *spistring, uint32_t *spis)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(spistring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		spis[0] = spis[1] = parse_ah_spi(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		spis[0] = buffer[0] ? parse_ah_spi(buffer) : 0;
-		spis[1] = cp[0] ? parse_ah_spi(cp) : 0xFFFFFFFF;
-	}
-	free(buffer);
-}
-
 static void ah_init(struct xt_entry_match *m)
 {
 	struct ipt_ah *ahinfo = (struct ipt_ah *)m->data;
@@ -71,27 +28,13 @@ static void ah_init(struct xt_entry_match *m)
 	ahinfo->spis[1] = 0xFFFFFFFF;
 }
 
-#define AH_SPI 0x01
-
-static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
-                    const void *entry, struct xt_entry_match **match)
+static void ah_parse(struct xt_option_call *cb)
 {
-	struct ipt_ah *ahinfo = (struct ipt_ah *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & AH_SPI)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--ahspi' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_ah_spis(optarg, ahinfo->spis);
-		if (invert)
-			ahinfo->invflags |= IPT_AH_INV_SPI;
-		*flags |= AH_SPI;
-		break;
-	}
+	struct ipt_ah *ahinfo = cb->data;
 
-	return 1;
+	xtables_option_parse(cb);
+	if (cb->invert)
+		ahinfo->invflags |= IPT_AH_INV_SPI;
 }
 
 static void
@@ -155,10 +98,10 @@ static struct xtables_match ah_mt_reg = {
 	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_ah)),
 	.help 		= ah_help,
 	.init 		= ah_init,
-	.parse 		= ah_parse,
 	.print 		= ah_print,
 	.save 		= ah_save,
-	.extra_opts 	= ah_opts,
+	.x6_parse	= ah_parse,
+	.x6_options	= ah_opts,
 };
 
 void
-- 
1.7.1

