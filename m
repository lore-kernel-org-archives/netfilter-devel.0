From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Add exit_error cb to xtables_globals
Date: Mon, 09 Feb 2009 22:29:44 -0500
Message-ID: <1234236584.20903.31.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-TSUpOo2qI9VrsdXEjEmv"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:40220 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZBJDbj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:31:39 -0500
Received: by ewy14 with SMTP id 14so2903336ewy.13
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2009 19:31:37 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-TSUpOo2qI9VrsdXEjEmv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Suggestion from Jan. Building up to compiling most basic app..

cheers,
jamal

--=-TSUpOo2qI9VrsdXEjEmv
Content-Disposition: attachment; filename=iptv2-2
Content-Type: text/plain; name=iptv2-2; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 2960e6aa4e7d9429aa81eff9636ad3524c9282e2
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Mon Feb 9 16:46:18 2009 -0500

    Introduce exit_error() as part of xtables_globals structure.
    When an application registers its xtables_globals definition
    and does not specify its exit_error() it gets assigned a
    basic version
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 1d33394..3a16651 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -33,14 +33,6 @@
 
 struct in_addr;
 
-struct xtables_globals
-{
-	unsigned int option_offset;
-	char *program_version;
-	char *program_name;
-	struct option *opts;
-};
-
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -191,6 +183,15 @@ enum xtables_exittype {
 	XTF_ONE_ACTION,
 };
 
+struct xtables_globals
+{
+	unsigned int option_offset;
+	char *program_version;
+	char *program_name;
+	struct option *opts;
+	void (*exit_error)(enum xtables_exittype status, const char *msg, ...);
+};
+
 extern const char *xtables_program_name;
 extern const char *xtables_modprobe_program;
 extern struct xtables_match *xtables_matches;
diff --git a/xtables.c b/xtables.c
index 95be5f8..d0fc478 100644
--- a/xtables.c
+++ b/xtables.c
@@ -46,7 +46,20 @@
 #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
 #endif
 
-struct xtables_globals *xt_params;
+struct xtables_globals *xt_params = NULL;
+
+void basic_exit_error(enum xtables_exittype status, const char *msg, ...)
+{
+	va_list args;
+
+	va_start(args, msg);
+	fprintf(stderr, "%s v%s: ", xt_params->program_name, xt_params->program_version);
+	vfprintf(stderr, msg, args);
+	va_end(args);
+	fprintf(stderr, "\n");
+	exit(status);
+}
+
 /**
  * xtables_set_params - set the global parameters used by xtables
  * @xtp:	input xtables_globals structure
@@ -65,6 +78,10 @@ int xtables_set_params(struct xtables_globals *xtp)
 	}
 
 	xt_params = xtp;
+
+	if (!xt_params->exit_error)
+		xt_params->exit_error = basic_exit_error;
+
 	return 0;
 }
 

--=-TSUpOo2qI9VrsdXEjEmv--

