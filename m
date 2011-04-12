From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/28] libxt_esp: use guided option parser
Date: Tue, 12 Apr 2011 16:23:22 +0200
Message-ID: <1302618224-9449-8-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51101 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1DLOXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:53 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_esp.c |   95 ++++++++----------------------------------------
 1 files changed, 16 insertions(+), 79 deletions(-)

diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 1769868..e9d7990 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -1,16 +1,11 @@
-/* Shared library add-on to iptables to add ESP support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <errno.h>
-#include <limits.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_esp.h>
 
+enum {
+	O_ESPSPI = 0,
+};
+
 static void esp_help(void)
 {
 	printf(
@@ -19,56 +14,13 @@ static void esp_help(void)
 "				match spi (range)\n");
 }
 
-static const struct option esp_opts[] = {
-	{.name = "espspi", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry esp_opts[] = {
+	{.name = "espspi", .id = O_ESPSPI, .type = XTTYPE_UINT32RC,
+	 .flags = XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(struct xt_esp, spis)},
+	XTOPT_TABLEEND,
 };
 
-static uint32_t
-parse_esp_spi(const char *spistr)
-{
-	unsigned long int spi;
-	char* ep;
-
-	spi =  strtoul(spistr,&ep,0) ;
-
-	if ( spistr == ep ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "ESP no valid digits in spi `%s'", spistr);
-	}
-	if ( spi == ULONG_MAX  && errno == ERANGE ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "spi `%s' specified too big: would overflow", spistr);
-	}	
-	if ( *spistr != '\0'  && *ep != '\0' ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "ESP error parsing spi `%s'", spistr);
-	}
-	return spi;
-}
-
-static void
-parse_esp_spis(const char *spistring, uint32_t *spis)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(spistring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		spis[0] = spis[1] = parse_esp_spi(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		spis[0] = buffer[0] ? parse_esp_spi(buffer) : 0;
-		spis[1] = cp[0] ? parse_esp_spi(cp) : 0xFFFFFFFF;
-		if (spis[0] > spis[1])
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid ESP spi range: %s", spistring);
-	}
-	free(buffer);
-}
-
 static void esp_init(struct xt_entry_match *m)
 {
 	struct xt_esp *espinfo = (struct xt_esp *)m->data;
@@ -76,28 +28,13 @@ static void esp_init(struct xt_entry_match *m)
 	espinfo->spis[1] = 0xFFFFFFFF;
 }
 
-#define ESP_SPI 0x01
-
-static int
-esp_parse(int c, char **argv, int invert, unsigned int *flags,
-          const void *entry, struct xt_entry_match **match)
+static void esp_parse(struct xt_option_call *cb)
 {
-	struct xt_esp *espinfo = (struct xt_esp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & ESP_SPI)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--espspi' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_esp_spis(optarg, espinfo->spis);
-		if (invert)
-			espinfo->invflags |= XT_ESP_INV_SPI;
-		*flags |= ESP_SPI;
-		break;
-	}
+	struct xt_esp *espinfo = cb->data;
 
-	return 1;
+	xtables_option_parse(cb);
+	if (cb->invert)
+		espinfo->invflags |= XT_ESP_INV_SPI;
 }
 
 static void
@@ -155,10 +92,10 @@ static struct xtables_match esp_match = {
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_esp)),
 	.help		= esp_help,
 	.init		= esp_init,
-	.parse		= esp_parse,
 	.print		= esp_print,
 	.save		= esp_save,
-	.extra_opts	= esp_opts,
+	.x6_parse	= esp_parse,
+	.x6_options	= esp_opts,
 };
 
 void
-- 
1.7.1

