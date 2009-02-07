From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Introduce xtables_afinfo
Date: Sat, 07 Feb 2009 12:05:39 -0500
Message-ID: <1234026339.4441.24.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-i0dvTMv6iJW+71/4ZqwH"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: kaber@trash.net, Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:2269 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZBGRHb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:07:31 -0500
Received: by ey-out-2122.google.com with SMTP id 25so350259eya.37
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Feb 2009 09:07:29 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-i0dvTMv6iJW+71/4ZqwH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


I am going to incrementally send these changes over a period of time
until i resolve all my issues; i hope this is fine with your process.

cheers,
jamal

--=-i0dvTMv6iJW+71/4ZqwH
Content-Disposition: attachment; filename=ipxt01
Content-Type: text/plain; name=ipxt01; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 74350de063cc4bc1f57b5db89ae035cde7fe895b
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Sat Feb 7 11:54:09 2009 -0500

    This change allows me to compile the following
    little program.
    Otherwise  we get symbol failures with afinfo
    
    -----
     #include "./include/xtables.h"
     #include <stdlib.h>
    
     /*
      * gcc simp-ipt.c -L /lib/xtables -lxtables -ldl
     */
     char *lib_dir;
     unsigned int global_option_offset = 0;
     const char *program_version = XTABLES_VERSION;
     const char *program_name = "tc-ipt";
     struct xtables_afinfo afinfo = {
            .libprefix      = "libxt_",
     };
    
     void exit_error(enum exittype status, const char *msg, ...)
     {
    	exit(status);
     }
    
     int main(int argc, char **argv) {
    
            return 0;
     }
    -----

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 02a832d..9e45c8b 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -249,6 +249,28 @@ extern void save_string(const char *value);
 /* Present in both iptables.c and ip6tables.c */
 extern u_int16_t parse_protocol(const char *s);
 
+
+/* protocol family dependent informations */
+struct xtables_afinfo {
+	/* protocol family */
+	int family;
+
+	/* prefix of library name (ex "libipt_" */
+	char *libprefix;
+
+	/* used by setsockopt (ex IPPROTO_IP */
+	int ipproto;
+
+	/* kernel module (ex "ip_tables" */
+	char *kmod;
+
+	/* optname to check revision support of match */
+	int so_rev_match;
+
+	/* optname to check revision support of match */
+	int so_rev_target;
+};
+
 #ifdef XTABLES_INTERNAL
 #	include <xtables/internal.h>
 #endif

--=-i0dvTMv6iJW+71/4ZqwH--

