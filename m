From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/10] extensions: remove empty help and parse functions
Date: Fri, 26 Jun 2009 21:19:48 +0200
Message-ID: <1246043992-379-7-git-send-email-jengelh@medozas.de>
References: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39672 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761317AbZFZTUL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:20:11 -0400
In-Reply-To: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_eui64.c  |   26 --------------------------
 extensions/libipt_MIRROR.c  |   20 --------------------
 extensions/libipt_unclean.c |   16 ----------------
 extensions/libxt_NOTRACK.c  |   20 --------------------
 extensions/libxt_TRACE.c    |   13 -------------
 extensions/libxt_socket.c   |   20 --------------------
 extensions/libxt_standard.c |   12 ------------
 7 files changed, 0 insertions(+), 127 deletions(-)

diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index c92c868..607bf86 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -1,38 +1,12 @@
 /* Shared library add-on to ip6tables to add EUI64 address checking support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#if defined(__GLIBC__) && __GLIBC__ == 2
-#include <net/ethernet.h>
-#else
-#include <linux/if_ether.h>
-#endif
 #include <xtables.h>
 
-static void eui64_help(void)
-{
-	printf(
-"eui64 match options:\n"
-" This module hasn't got any option\n"
-" This module checks for EUI64 IPv6 addresses\n");
-}
-
-static int eui64_parse(int c, char **argv, int invert, unsigned int *flags,
-                       const void *entry, struct xt_entry_match **match)
-{
-	return 0;
-}
-
 static struct xtables_match eui64_mt6_reg = {
 	.name 		= "eui64",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(int)),
 	.userspacesize	= XT_ALIGN(sizeof(int)),
-	.help		= eui64_help,
-	.parse		= eui64_parse,
 };
 
 void _init(void)
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index 81964dd..fb78751 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -1,32 +1,12 @@
 /* Shared library add-on to iptables to add MIRROR target support. */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 
-static void MIRROR_help(void)
-{
-	printf("MIRROR target takes no options\n");
-}
-
-static int MIRROR_parse(int c, char **argv, int invert, unsigned int *flags,
-                        const void *entry, struct xt_entry_target **target)
-{
-	return 0;
-}
-
 static struct xtables_target mirror_tg_reg = {
 	.name		= "MIRROR",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
- 	.help		= MIRROR_help,
- 	.parse		= MIRROR_parse,
-	.print		= NULL,
-	.save		= NULL,
 };
 
 void _init(void)
diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
index 93d9013..bc4a4a0 100644
--- a/extensions/libipt_unclean.c
+++ b/extensions/libipt_unclean.c
@@ -1,28 +1,12 @@
 /* Shared library add-on to iptables for unclean. */
-#include <stdio.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 
-static void unclean_help(void)
-{
-	printf("unclean match takes no options\n");
-}
-
-static int unclean_parse(int c, char **argv, int invert, unsigned int *flags,
-                         const void *entry, struct xt_entry_match **match)
-{
-	return 0;
-}
-
 static struct xtables_match unclean_mt_reg = {
 	.name		= "unclean",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
-	.help		= unclean_help,
-	.parse		= unclean_parse,
 };
 
 void _init(void)
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
index d997d84..ca58700 100644
--- a/extensions/libxt_NOTRACK.c
+++ b/extensions/libxt_NOTRACK.c
@@ -1,23 +1,5 @@
 /* Shared library add-on to iptables to add NOTRACK target support. */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
-#include <linux/netfilter/x_tables.h>
-
-static void NOTRACK_help(void)
-{
-	printf("NOTRACK target takes no options\n");
-}
-
-static int
-NOTRACK_parse(int c, char **argv, int invert, unsigned int *flags,
-              const void *entry, struct xt_entry_target **target)
-{
-	return 0;
-}
 
 static struct xtables_target notrack_target = {
 	.family		= NFPROTO_UNSPEC,
@@ -25,8 +7,6 @@ static struct xtables_target notrack_target = {
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
-	.help		= NOTRACK_help,
-	.parse		= NOTRACK_parse,
 };
 
 void _init(void)
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index 344b80d..0282e6f 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -7,25 +7,12 @@
 #include <xtables.h>
 #include <linux/netfilter/x_tables.h>
 
-static void TRACE_help(void)
-{
-	printf("TRACE target takes no options\n");
-}
-
-static int TRACE_parse(int c, char **argv, int invert, unsigned int *flags,
-                       const void *entry, struct xt_entry_target **target)
-{
-	return 0;
-}
-
 static struct xtables_target trace_target = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "TRACE",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
-	.help		= TRACE_help,
-	.parse		= TRACE_parse,
 };
 
 void _init(void)
diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index eebc7c5..1490473 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -3,34 +3,14 @@
  *
  * Copyright (C) 2007 BalaBit IT Ltd.
  */
-#include <stdio.h>
-#include <getopt.h>
 #include <xtables.h>
 
-static void socket_mt_help(void)
-{
-	printf("socket v%s has no options\n\n", XTABLES_VERSION);
-}
-
-static int socket_mt_parse(int c, char **argv, int invert, unsigned int *flags,
-			const void *entry, struct xt_entry_match **match)
-{
-	return 0;
-}
-
-static void socket_mt_check(unsigned int flags)
-{
-}
-
 static struct xtables_match socket_mt_reg = {
 	.name	       = "socket",
 	.version       = XTABLES_VERSION,
 	.family	       = NFPROTO_IPV4,
 	.size	       = XT_ALIGN(0),
 	.userspacesize = XT_ALIGN(0),
-	.parse	       = socket_mt_parse,
-	.final_check   = socket_mt_check,
-	.help	       = socket_mt_help,
 };
 
 void _init(void)
diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
index 56dc2d2..c64ba29 100644
--- a/extensions/libxt_standard.c
+++ b/extensions/libxt_standard.c
@@ -1,10 +1,5 @@
 /* Shared library add-on to iptables for standard target support. */
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <limits.h>
-#include <getopt.h>
 #include <xtables.h>
 
 static void standard_help(void)
@@ -14,12 +9,6 @@ static void standard_help(void)
 "(If target is DROP, ACCEPT, RETURN or nothing)\n");
 }
 
-static int standard_parse(int c, char **argv, int invert, unsigned int *flags,
-                          const void *entry, struct xt_entry_target **target)
-{
-	return 0;
-}
-
 static struct xtables_target standard_target = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "standard",
@@ -27,7 +16,6 @@ static struct xtables_target standard_target = {
 	.size		= XT_ALIGN(sizeof(int)),
 	.userspacesize	= XT_ALIGN(sizeof(int)),
 	.help		= standard_help,
-	.parse		= standard_parse,
 };
 
 void _init(void)
-- 
1.6.3.2

