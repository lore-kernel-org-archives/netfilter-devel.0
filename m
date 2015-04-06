From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] ebtables-compat: fix misplaced function attribute
 on ebt_print_error()
Date: Mon, 06 Apr 2015 16:05:28 +0200
Message-ID: <20150406140528.30059.48340.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:51960 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753328AbbDFOFi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 10:05:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <aborrero@nfdev2.cica.es>

xtables-eb.c:305:1: warning: empty declaration
 } __attribute__((noreturn, format(printf,2,3)));
 ^
xtables-eb.c:311:2: warning: initialization makes '__attribute__((noreturn))' qualified function pointer from unqualified
  .exit_err  = ebt_print_error,
  ^

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/xtables-eb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index ddef14a..c8b5d4f 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -292,7 +292,7 @@ static struct option ebt_original_options[] =
 	{ 0 }
 };
 
-static void
+static void __attribute__((__noreturn__,format(printf,2,3)))
 ebt_print_error(enum xtables_exittype status, const char *format, ...)
 {
 	va_list l;
@@ -302,7 +302,7 @@ ebt_print_error(enum xtables_exittype status, const char *format, ...)
 	fprintf(stderr, ".\n");
 	va_end(l);
 	exit(-1);
-} __attribute__((noreturn, format(printf,2,3)));
+}
 
 struct xtables_globals ebtables_globals = {
 	.option_offset 		= 0,

