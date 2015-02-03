From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH] ebtables-compat: call extensions final
 checks
Date: Tue, 03 Feb 2015 16:26:39 +0100
Message-ID: <20150203152639.24667.28068.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:45166 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965550AbbBCP0u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Feb 2015 10:26:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's call extensions final checks.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/libebt_802_3.c  |    2 ++
 extensions/libebt_ip.c     |    2 ++
 extensions/libebt_mark_m.c |    2 ++
 iptables/xtables-eb.c      |   50 +++++++++++++++-----------------------------
 4 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/extensions/libebt_802_3.c b/extensions/libebt_802_3.c
index e19c21d..3c4a1c3 100644
--- a/extensions/libebt_802_3.c
+++ b/extensions/libebt_802_3.c
@@ -79,6 +79,8 @@ br802_3_parse(int c, char **argv, int invert, unsigned int *flags,
 	default:
 		return 0;
 	}
+
+	*flags |= info->bitmask;
 	return 1;
 }
 
diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index a85810b..8b62876 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -214,6 +214,8 @@ brip_parse(int c, char **argv, int invert, unsigned int *flags,
 	default:
 		return 0;
 	}
+
+	*flags |= info->bitmask;
 	return 1;
 }
 
diff --git a/extensions/libebt_mark_m.c b/extensions/libebt_mark_m.c
index d806c65..ef9eb6a 100644
--- a/extensions/libebt_mark_m.c
+++ b/extensions/libebt_mark_m.c
@@ -69,6 +69,8 @@ brmark_m_parse(int c, char **argv, int invert, unsigned int *flags,
 	default:
 		return 0;
 	}
+
+	*flags |= info->bitmask;
 	return 1;
 }
 
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 0ac39d0..c30a2e5 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -647,16 +647,22 @@ static void ebt_add_match(struct xtables_match *m,
 			  struct xtables_rule_match **rule_matches)
 {
 	struct xtables_rule_match *i;
+	struct xtables_match *newm;
 
 	/* match already in rule_matches, skip inclusion */
 	for (i = *rule_matches; i; i = i->next) {
-		if (strcmp(m->name, i->match->name) == 0)
+		if (strcmp(m->name, i->match->name) == 0) {
+			i->match->mflags |= m->mflags;
 			return;
+		}
 	}
 
-	if (xtables_find_match(m->name, XTF_LOAD_MUST_SUCCEED, rule_matches) == NULL)
+	newm = xtables_find_match(m->name, XTF_LOAD_MUST_SUCCEED, rule_matches);
+	if (newm == NULL)
 		xtables_error(OTHER_PROBLEM,
 			      "Unable to add match %s", m->name);
+
+	newm->mflags = m->mflags;
 }
 
 /* We use exec_style instead of #ifdef's because ebtables.so is a shared object. */
@@ -678,6 +684,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 	const char *policy = NULL;
 	int exec_style = EXEC_STYLE_PRG;
 	int selected_chain = -1;
+	struct xtables_rule_match *xtrm_i;
 
 	memset(&cs, 0, sizeof(cs));
 	cs.argv = argv;
@@ -1227,37 +1234,14 @@ check_extension:
 	}
 
 	/* Do the final checks */
-	/*if (replace->command == 'A' || replace->command == 'I' ||
-	   replace->command == 'D' || replace->command == 'C') {*/
-		/* This will put the hook_mask right for the chains */
-		/*ebt_check_for_loops(replace);
-		if (ebt_errormsg[0] != '\0')
-			return -1;
-		entries = ebt_to_chain(replace);
-		m_l = new_entry->m_list;
-		w_l = new_entry->w_list;
-		t = (struct ebt_u_target *)new_entry->t;
-		while (m_l) {
-			m = (struct ebt_u_match *)(m_l->m);
-			m->final_check(new_entry, m->m, replace->name,
-			   entries->hook_mask, 0);
-			if (ebt_errormsg[0] != '\0')
-				return -1;
-			m_l = m_l->next;
-		}
-		while (w_l) {
-			w = (struct ebt_u_watcher *)(w_l->w);
-			w->final_check(new_entry, w->w, replace->name,
-			   entries->hook_mask, 0);
-			if (ebt_errormsg[0] != '\0')
-				return -1;
-			w_l = w_l->next;
-		}
-		t->final_check(new_entry, t->t, replace->name,
-		   entries->hook_mask, 0);
-		if (ebt_errormsg[0] != '\0')
-			return -1;
-	}*/
+	if (command == 'A' || command == 'I' ||
+	    command == 'D' || command == 'C') {
+		for (xtrm_i = cs.matches; xtrm_i; xtrm_i = xtrm_i->next)
+			xtables_option_mfcall(xtrm_i->match);
+
+		if (cs.target != NULL)
+			xtables_option_tfcall(cs.target);
+	}
 	/* So, the extensions can work with the host endian.
 	 * The kernel does not have to do this of course */
 	cs.fw.ethproto = htons(cs.fw.ethproto);

