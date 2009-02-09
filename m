From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Introduce global params structuring
Date: Mon, 09 Feb 2009 15:57:12 -0500
Message-ID: <1234213032.20903.13.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-j3HnDTnhjK/AvU+otave"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:62140 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZBIU7F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:59:05 -0500
Received: by ewy14 with SMTP id 14so2781720ewy.13
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2009 12:59:04 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-j3HnDTnhjK/AvU+otave
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Here's the basic change.

cheers,
jamal

--=-j3HnDTnhjK/AvU+otave
Content-Disposition: attachment; filename=iptv2-0
Content-Type: text/plain; name=iptv2-0; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit bc259a1516e63a38496d568dff2d6135b925d968
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Mon Feb 9 15:20:18 2009 -0500

    introduce a new struct,xtables_globals, so as to
    localize the globals used and help in symbol renames.
    The applications must invoke xtables_set_params() before starting
    to use any iptables APIs.
    xtables_set_params() is intended to free xtables from depending
    (as it does right now) on existence of such externally definitions
    (from iptables/iptables6 etc). At the moment, xtables wont even
    compile without presence of at least one of {iptables/iptables6 etc}
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 02750fb..61dbc76 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -33,6 +33,14 @@
 
 struct in_addr;
 
+struct xtables_globals
+{
+	unsigned int option_offset;
+	char *program_version;
+	char *program_name;
+	struct option *opts;
+};
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -195,6 +203,7 @@ extern void *xtables_malloc(size_t);
 
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
+int xtables_set_params(struct xtables_globals *xtp);
 
 extern struct xtables_match *xtables_find_match(const char *name,
 	enum xtables_tryload, struct xtables_rule_match **match);
diff --git a/xtables.c b/xtables.c
index 6c95475..aad5e53 100644
--- a/xtables.c
+++ b/xtables.c
@@ -46,6 +46,28 @@
 #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
 #endif
 
+struct xtables_globals *xt_params;
+/**
+ * xtables_set_params - set the global parameters used by xtables
+ * @xtp:	input xtables_globals structure
+ *
+ * The app is expected to pass a valid xtables_globals data-filled
+ * with proper values
+ * @xtp cannot be NULL
+ *
+ * Returns -1 on failure to set and 0 on success
+ */
+int xtables_set_params(struct xtables_globals *xtp)
+{
+	if (!xtp) {
+		fprintf(stderr, "%s: Illegal global params\n",__func__);
+		return -1;
+	}
+
+	xt_params = xtp;
+	return 0;
+}
+
 /**
  * xtables_afinfo - protocol family dependent information
  * @kmod:		kernel module basename (e.g. "ip_tables")

--=-j3HnDTnhjK/AvU+otave--

