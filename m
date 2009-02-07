From: jamal <hadi@cyberus.ca>
Subject: RFC: introduce xtables global param struct
Date: Sat, 07 Feb 2009 14:28:31 -0500
Message-ID: <1234034911.4441.32.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-SXmgUQikqIlxo9T1CB7N"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: kaber@trash.net, Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:35050 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZBGTaW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Feb 2009 14:30:22 -0500
Received: by ewy14 with SMTP id 14so1912939ewy.13
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Feb 2009 11:30:20 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-SXmgUQikqIlxo9T1CB7N
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


I would like to introduce this new struct so as to pass 
localize the globals used and help in symbol renames. 

xtables_set_params() is intended to free xtables from depending
(as it does right now) on existence of such externally definitions
(from iptables/iptables6 etc).
 
Ive included a sample user - xtables_free_opts() to show
how i plan to use it.

Let me know what you think before i proceed since i am going
to be using this approach as a basis for other changes.

cheers,
jamal

--=-SXmgUQikqIlxo9T1CB7N
Content-Disposition: attachment; filename=rfc-p2
Content-Type: text/x-patch; name=rfc-p2; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 9e45c8b..d91d902 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -27,6 +27,15 @@
 
 struct in_addr;
 
+struct xtables_globals
+{
+	unsigned int option_offset;
+	char *program_version;
+	char *program_name;
+	struct xtables_afinfo *afinfo;
+	struct option *opts;
+};
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -165,6 +174,8 @@ extern void *xtables_malloc(size_t);
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
 
+extern void xtables_free_opts(int reset_offset,  struct option *original_opts);
+
 extern struct xtables_match *xtables_find_match(const char *name,
 	enum xtables_tryload, struct xtables_rule_match **match);
 extern struct xtables_target *xtables_find_target(const char *name,
diff --git a/xtables.c b/xtables.c
index 849dc7d..b053a48 100644
--- a/xtables.c
+++ b/xtables.c
@@ -53,6 +53,29 @@ const char *xtables_modprobe_program;
 struct xtables_match *xtables_matches;
 struct xtables_target *xtables_targets;
 
+struct xtables_globals *xt_params;
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
+void xtables_free_opts(int reset_offset, struct option *original_opts)
+{
+	if (xt_params->opts != original_opts) {
+		if (original_opts) 
+			free(xt_params->opts);
+		xt_params->opts = original_opts;
+		if (reset_offset)
+			xt_params->option_offset = 0;
+	}
+}
+
 /**
  * xtables_*alloc - wrappers that exit on failure
  */

--=-SXmgUQikqIlxo9T1CB7N--

