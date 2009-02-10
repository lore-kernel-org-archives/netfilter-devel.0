From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables:  convert iptables and and ip6tables use
	xtables_free_opts()
Date: Tue, 10 Feb 2009 16:31:28 -0500
Message-ID: <1234301488.20903.76.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ZQWG3kvnuuvn36yms2t4"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:32876 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbZBJVdW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:33:22 -0500
Received: by ewy14 with SMTP id 14so76502ewy.13
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2009 13:33:20 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-ZQWG3kvnuuvn36yms2t4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

More of a janitorial cleanup than anything else.

cheers,
jamal

--=-ZQWG3kvnuuvn36yms2t4
Content-Disposition: attachment; filename=iptv2-7
Content-Type: text/plain; name=iptv2-7; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 64a88234b9f4da9188c5cad3c6f9f267afcb9536
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Tue Feb 10 15:40:34 2009 -0500

    Make iptables and ip6tables use xtables_free_opts()
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/ip6tables.c b/ip6tables.c
index 2ac3a1d..b1de41b 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -225,16 +225,6 @@ proto_to_name(u_int8_t proto, int nolookup)
 	return NULL;
 }
 
-static void free_opts(int reset_offset)
-{
-	if (opts != original_opts) {
-		free(opts);
-		opts = original_opts;
-		if (reset_offset)
-			global_option_offset = 0;
-	}
-}
-
 static void
 exit_tryhelp(int status)
 {
@@ -242,7 +232,7 @@ exit_tryhelp(int status)
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
-	free_opts(1);
+	xtables_free_opts(1);
 	exit(status);
 }
 
@@ -352,7 +342,7 @@ ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...)
 		fprintf(stderr,
 			"Perhaps ip6tables or your kernel needs to be upgraded.\n");
 	/* On error paths, make sure that we don't leak memory */
-	free_opts(1);
+	xtables_free_opts(1);
 	exit(status);
 }
 
@@ -2029,7 +2019,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	for (i = 0; i < ndaddrs; i++)
 		free(&daddrs[i]);
 
-	free_opts(1);
+	xtables_free_opts(1);
 
 	return ret;
 }
diff --git a/iptables.c b/iptables.c
index d079125..dfc1937 100644
--- a/iptables.c
+++ b/iptables.c
@@ -238,16 +238,6 @@ enum {
 	IPT_DOTTED_MASK
 };
 
-static void free_opts(int reset_offset)
-{
-	if (opts != original_opts) {
-		free(opts);
-		opts = original_opts;
-		if (reset_offset)
-			global_option_offset = 0;
-	}
-}
-
 static void
 exit_tryhelp(int status)
 {
@@ -255,7 +245,7 @@ exit_tryhelp(int status)
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
-	free_opts(1);
+	xtables_free_opts(1);
 	exit(status);
 }
 
@@ -365,7 +355,7 @@ iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
 		fprintf(stderr,
 			"Perhaps iptables or your kernel needs to be upgraded.\n");
 	/* On error paths, make sure that we don't leak memory */
-	free_opts(1);
+	xtables_free_opts(1);
 	exit(status);
 }
 
@@ -1321,7 +1311,7 @@ get_kernel_version(void) {
 
 	if (uname(&uts) == -1) {
 		fprintf(stderr, "Unable to retrieve kernel version.\n");
-		free_opts(1);
+		xtables_free_opts(1);
 		exit(1);
 	}
 
@@ -2066,7 +2056,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	free(saddrs);
 	free(daddrs);
-	free_opts(1);
+	xtables_free_opts(1);
 
 	return ret;
 }

--=-ZQWG3kvnuuvn36yms2t4--

