From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/21] Common error messages
Date: Sat, 5 Jan 2008 15:43:06 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801051542520.14194@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37227 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbYAEOnI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:43:08 -0500
In-Reply-To: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Error messages vary wildly among modules, and there is a lot of
reundance in it too. Introduce a helper function that does all of
the parameter checking boilerplate and gives unique messages.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/xtables.h |    7 ++++++-
 xtables.c         |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)

Index: iptables-modules/include/xtables.h
===================================================================
--- iptables-modules.orig/include/xtables.h
+++ iptables-modules/include/xtables.h
@@ -220,7 +220,11 @@ enum exittype {
 	OTHER_PROBLEM = 1,
 	PARAMETER_PROBLEM,
 	VERSION_PROBLEM,
-	RESOURCE_PROBLEM
+	RESOURCE_PROBLEM,
+	P_ONLY_ONCE,
+	P_NO_INVERT,
+	P_BAD_VALUE,
+	P_ONE_ACTION,
 };
 
 /* this is a special 64bit data type that is 8-byte aligned */
@@ -229,6 +233,7 @@ enum exittype {
 int check_inverse(const char option[], int *invert, int *optind, int argc);
 void exit_error(enum exittype, const char *, ...)__attribute__((noreturn,
 							  format(printf,2,3)));
+extern void param_act(unsigned int, const char *, ...);
 extern const char *program_name, *program_version;
 
 #define _init __attribute__((constructor)) my_init
Index: iptables-modules/xtables.c
===================================================================
--- iptables-modules.orig/xtables.c
+++ iptables-modules/xtables.c
@@ -19,6 +19,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <netdb.h>
+#include <stdarg.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -639,3 +640,51 @@ void xtables_register_target(struct xtab
 	me->t = NULL;
 	me->tflags = 0;
 }
+
+void param_act(unsigned int status, const char *p1, ...)
+{
+	const char *p2, *p3;
+	va_list args;
+	bool b;
+
+	va_start(args, p1);
+
+	switch (status) {
+	case P_ONLY_ONCE:
+		p2 = va_arg(args, const char *);
+		b  = va_arg(args, unsigned int);
+		if (!b)
+			return;
+		exit_error(PARAMETER_PROBLEM,
+		           "%s: \"%s\" option may only be specified once",
+		           p1, p2);
+		break;
+	case P_NO_INVERT:
+		p2 = va_arg(args, const char *);
+		b  = va_arg(args, unsigned int);
+		if (!b)
+			return;
+		exit_error(PARAMETER_PROBLEM,
+		           "%s: Unexpected \"!\" after \"%s\" option", p1, p2);
+		break;
+	case P_BAD_VALUE:
+		p2 = va_arg(args, const char *);
+		p3 = va_arg(args, const char *);
+		exit_error(PARAMETER_PROBLEM,
+		           "%s: Bad value for \"%s\" option: \"%s\"",
+		           p1, p2, p3);
+		break;
+	case P_ONE_ACTION:
+		b = va_arg(args, unsigned int);
+		if (!b)
+			return;
+		exit_error(PARAMETER_PROBLEM,
+		           "%s: At most one action is possible", p1);
+		break;
+	default:
+		exit_error(status, p1, args);
+		break;
+	}
+
+	va_end(args);
+}
