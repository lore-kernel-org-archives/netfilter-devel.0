From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH 1/2] ebtables-compat: add a bridge-specific
 exit_error function
Date: Wed, 11 Mar 2015 18:54:57 +0100
Message-ID: <20150311175457.30898.35962.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45827 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750858AbbCKRzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2015 13:55:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Previous to this patch, error reporting in ebtables-compat was like:

% ebtables-compat xxx
(null) v1.4.21: Bad argument : 'xxx'
Try `(null) -h' or '(null) --help' for more information.

While the original ebtables was:

% ebtables xxx
Bad argument : 'xxx'.

With this patch, we switch to:

% ebtables-compat xxx
Bad argument : 'xxx'.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/xtables-eb.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index efbb3cd..355d027 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -27,6 +27,7 @@
 #include <string.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdarg.h>
 #include <inttypes.h>
 #include <signal.h>
 #include <net/if.h>
@@ -291,13 +292,23 @@ static struct option ebt_original_options[] =
 	{ 0 }
 };
 
-void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
+static void
+ebt_print_error(enum xtables_exittype status, const char *format, ...)
+{
+	va_list l;
+
+	va_start(l, format);
+	vfprintf(stderr, format, l);
+	fprintf(stderr, ".\n");
+	va_end(l);
+	exit(-1);
+} __attribute__((noreturn, format(printf,2,3)));
 
 struct xtables_globals ebtables_globals = {
 	.option_offset 		= 0,
 	.program_version	= IPTABLES_VERSION,
 	.orig_opts		= ebt_original_options,
-	.exit_err		= xtables_exit_error,
+	.exit_err		= ebt_print_error,
 	.compat_rev		= nft_compatible_revision,
 };
 

