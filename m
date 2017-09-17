From: Rafael Buchbinder <shmulik@nsof.io>
Subject: [PATCH 1/2] iptables: support match info fixup after tc_init
Date: Sun, 17 Sep 2017 14:07:50 +0300
Message-ID: <20170917110751.7923-2-rafi@rbk.ms>
References: <20170917110751.7923-1-rafi@rbk.ms>
Cc: Willem de Bruijn <willemb@google.com>, rbk@nsof.io,
        shmulik@nsof.io, Rafael Buchbinder <rafi@rbk.ms>
To: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:55955 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbdIQLIU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Sep 2017 07:08:20 -0400
Received: by mail-wr0-f175.google.com with SMTP id l39so4329547wrl.12
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Sep 2017 04:08:19 -0700 (PDT)
In-Reply-To: <20170917110751.7923-1-rafi@rbk.ms>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit introduces a framework to fixup match info,
which may be required by an extension.

Signed-off-by: Rafael Buchbinder <rafi@rbk.ms>
Signed-off-by: Shmulik Ladkani <shmulik@nsof.io>
---
 include/xtables.h    |  3 +++
 iptables/ip6tables.c | 35 +++++++++++++++++++++++++++++++++++
 iptables/iptables.c  | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/include/xtables.h b/include/xtables.h
index e9bc3b7d..687cfe9f 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -273,6 +273,9 @@ struct xtables_match {
 	/* ip is struct ipt_ip * for example */
 	void (*save)(const void *ip, const struct xt_entry_match *match);
 
+	/* Fixes the match info after init. */
+	void (*tc_init_fixup)(struct xt_entry_match *match);
+
 	/* Print match name or alias */
 	const char *(*alias)(const struct xt_entry_match *match);
 
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 49bd006f..0a6afa77 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -925,6 +925,39 @@ delete_chain6(const xt_chainlabel chain, int verbose,
 	return ip6tc_delete_chain(chain, handle);
 }
 
+
+static int
+tc_init_fixup_match(struct xt_entry_match *m)
+{
+	const struct xtables_match *match =
+		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
+
+	if (match) {
+		if (match->tc_init_fixup && m->u.user.revision == match->revision)
+			match->tc_init_fixup(m);
+	}
+
+	/* Don't stop iterating. */
+	return 0;
+}
+
+static void
+tc_init_fixup(struct xtc_handle *handle)
+{
+	const char *chain;
+
+	for (chain = ip6tc_first_chain(handle);
+	     chain;
+	     chain = ip6tc_next_chain(handle)) {
+		const struct ip6t_entry *entry = ip6tc_first_rule(chain, handle);
+
+		while (entry) {
+			IP6T_MATCH_ITERATE(entry, tc_init_fixup_match);
+			entry = ip6tc_next_rule(entry, handle);
+		}
+	}
+}
+
 static int
 list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 	     int expanded, int linenumbers, struct xtc_handle *handle)
@@ -1795,6 +1828,8 @@ int do_command6(int argc, char *argv[], char **table,
 			"can't initialize ip6tables table `%s': %s",
 			*table, ip6tc_strerror(errno));
 
+	tc_init_fixup(*handle);
+
 	if (command == CMD_APPEND
 	    || command == CMD_DELETE
 	    || command == CMD_CHECK
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 69d19fec..f220a8e4 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -909,6 +909,38 @@ delete_chain4(const xt_chainlabel chain, int verbose,
 	return iptc_delete_chain(chain, handle);
 }
 
+static int
+tc_init_fixup_match(struct xt_entry_match *m)
+{
+	const struct xtables_match *match =
+		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
+
+	if (match) {
+		if (match->tc_init_fixup && m->u.user.revision == match->revision)
+			match->tc_init_fixup(m);
+	}
+
+	/* Don't stop iterating. */
+	return 0;
+}
+
+static void
+tc_init_fixup(struct xtc_handle *handle)
+{
+	const char *chain;
+
+	for (chain = iptc_first_chain(handle);
+	     chain;
+	     chain = iptc_next_chain(handle)) {
+		const struct ipt_entry *entry = iptc_first_rule(chain, handle);
+
+		while (entry) {
+			IPT_MATCH_ITERATE(entry, tc_init_fixup_match);
+			entry = iptc_next_rule(entry, handle);
+		}
+	}
+}
+
 static int
 list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 	     int expanded, int linenumbers, struct xtc_handle *handle)
@@ -1781,6 +1813,8 @@ int do_command4(int argc, char *argv[], char **table,
 			   "can't initialize iptables table `%s': %s",
 			   *table, iptc_strerror(errno));
 
+	tc_init_fixup(*handle);
+
 	if (command == CMD_APPEND
 	    || command == CMD_DELETE
 	    || command == CMD_CHECK
-- 
2.14.1

