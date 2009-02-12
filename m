From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Set proper name of application.
Date: Thu, 12 Feb 2009 11:40:23 -0500
Message-ID: <1234456823.3271.16.camel@dogo.mojatatu.com>
References: <1234448241.3271.4.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-vjDTpbokLWlOB7BZwbc2"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:39681 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbZBLQmU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:42:20 -0500
Received: by ewy14 with SMTP id 14so664301ewy.13
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2009 08:42:18 -0800 (PST)
In-Reply-To: <1234448241.3271.4.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-vjDTpbokLWlOB7BZwbc2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This is a resend.

cheers,
jamal

--=-vjDTpbokLWlOB7BZwbc2
Content-Disposition: attachment; filename=iptv2-fix02
Content-Type: text/plain; name=iptv2-fix02; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 10b0261ab18d3f9a8beb541b6e93a4c72e483e39
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Wed Feb 11 16:28:31 2009 -0500

    Set proper name of application.
    Thanks to Jan Engelhardt <jengelh@medozas.de> for
    catching this.
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 1956cf0..05a963e 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -14,6 +14,7 @@
 #define ip6t_tryload		xt_tryload
 
 extern int line;
+extern struct xtables_globals ip6tables_globals;
 
 /* Your shared library should call one of these. */
 extern int do_command6(int argc, char *argv[], char **table,
diff --git a/include/iptables.h b/include/iptables.h
index f7ae0cc..5c48699 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -14,6 +14,7 @@
 #define ipt_tryload		xt_tryload
 
 extern int line;
+extern struct xtables_globals iptables_globals;
 
 /* Your shared library should call one of these. */
 extern int do_command(int argc, char *argv[], char **table,
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index acaf97b..3d535de 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -133,6 +133,7 @@ int main(int argc, char *argv[])
 	xtables_program_name = program_name;
 	xtables_init();
 	xtables_set_nfproto(NFPROTO_IPV6);
+	ip6tables_globals.program_name = "ip6tables-restore";
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 32b5992..3af81ab 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -142,6 +142,7 @@ int main(int argc, char *argv[])
 	xtables_program_name = program_name;
 	xtables_init();
 	xtables_set_nfproto(NFPROTO_IPV6);
+	ip6tables_globals.program_name = "ip6tables-save";
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index cea4818..ab77065 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -55,6 +55,7 @@ main(int argc, char *argv[])
 	xtables_program_name = program_name;
 	xtables_init();
 	xtables_set_nfproto(NFPROTO_IPV6);
+	ip6tables_globals.program_name = "ip6tables";
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables.c b/ip6tables.c
index 9262b14..541c1a9 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -149,7 +149,6 @@ void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
-	.program_name = "ip6tables",
 	.opts = original_opts,
 	.exit_err = ip6tables_exit_error,
 };
diff --git a/iptables-restore.c b/iptables-restore.c
index 810806f..0103016 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -135,6 +135,7 @@ main(int argc, char *argv[])
 	xtables_program_name = program_name;
 	xtables_init();
 	xtables_set_nfproto(NFPROTO_IPV4);
+	iptables_globals.program_name = "iptables-restore";
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-save.c b/iptables-save.c
index c4306fd..396406f 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -142,6 +142,7 @@ main(int argc, char *argv[])
 	xtables_program_name = program_name;
 	xtables_init();
 	xtables_set_nfproto(NFPROTO_IPV4);
+	iptables_globals.program_name = "iptables-save";
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-standalone.c b/iptables-standalone.c
index ece7cf4..007f2c2 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -56,6 +56,7 @@ main(int argc, char *argv[])
 	xtables_program_name = program_name;
 	xtables_init();
 	xtables_set_nfproto(NFPROTO_IPV4);
+	iptables_globals.program_name = "iptables";
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables.c b/iptables.c
index fe28e50..f8ccad7 100644
--- a/iptables.c
+++ b/iptables.c
@@ -150,7 +150,6 @@ void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __a
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
-	.program_name = "iptables",
 	.opts = original_opts,
 	.exit_err = iptables_exit_error,
 };

--=-vjDTpbokLWlOB7BZwbc2--

