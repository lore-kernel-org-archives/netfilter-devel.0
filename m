From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/9] libiptc: replace ipt_chainlabel by xt_chainlabel
Date: Sun, 11 Sep 2011 17:35:54 +0200
Message-ID: <1315755359-7012-6-git-send-email-jengelh@medozas.de>
References: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51845 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab1IKPgH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 11:36:07 -0400
In-Reply-To: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/ip6tables.h        |    6 +++---
 include/iptables.h         |    6 +++---
 include/libiptc/libip6tc.h |   38 +++++++++++++++++++-------------------
 include/libiptc/libiptc.h  |   38 +++++++++++++++++++-------------------
 iptables/ip6tables.c       |   30 +++++++++++++++---------------
 iptables/iptables.c        |   30 +++++++++++++++---------------
 libiptc/libip4tc.c         |    2 +-
 libiptc/libip6tc.c         |    2 +-
 8 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index e976361..1def393 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -10,9 +10,9 @@
 extern int do_command6(int argc, char *argv[], char **table,
 		       struct ip6tc_handle **handle);
 
-extern int for_each_chain6(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle *), int verbose, int builtinstoo, struct ip6tc_handle *handle);
-extern int flush_entries6(const ip6t_chainlabel chain, int verbose, struct ip6tc_handle *handle);
-extern int delete_chain6(const ip6t_chainlabel chain, int verbose, struct ip6tc_handle *handle);
+extern int for_each_chain6(int (*fn)(const xt_chainlabel, int, struct ip6tc_handle *), int verbose, int builtinstoo, struct ip6tc_handle *handle);
+extern int flush_entries6(const xt_chainlabel chain, int verbose, struct ip6tc_handle *handle);
+extern int delete_chain6(const xt_chainlabel chain, int verbose, struct ip6tc_handle *handle);
 void print_rule6(const struct ip6t_entry *e, struct ip6tc_handle *h, const char *chain, int counters);
 
 extern struct xtables_globals ip6tables_globals;
diff --git a/include/iptables.h b/include/iptables.h
index 89217e2..6edd369 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -9,11 +9,11 @@
 /* Your shared library should call one of these. */
 extern int do_command4(int argc, char *argv[], char **table,
 		      struct iptc_handle **handle);
-extern int delete_chain4(const ipt_chainlabel chain, int verbose,
+extern int delete_chain4(const xt_chainlabel chain, int verbose,
 			struct iptc_handle *handle);
-extern int flush_entries4(const ipt_chainlabel chain, int verbose, 
+extern int flush_entries4(const xt_chainlabel chain, int verbose, 
 			struct iptc_handle *handle);
-extern int for_each_chain4(int (*fn)(const ipt_chainlabel, int, struct iptc_handle *),
+extern int for_each_chain4(int (*fn)(const xt_chainlabel, int, struct iptc_handle *),
 		int verbose, int builtinstoo, struct iptc_handle *handle);
 extern void print_rule4(const struct ipt_entry *e,
 		struct iptc_handle *handle, const char *chain, int counters);
diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 55e0bfc..6332073 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -59,89 +59,89 @@ const char *ip6tc_get_policy(const char *chain,
 /* Rule numbers start at 1 for the first rule. */
 
 /* Insert the entry `fw' in chain `chain' into position `rulenum'. */
-int ip6tc_insert_entry(const ip6t_chainlabel chain,
+int ip6tc_insert_entry(const xt_chainlabel chain,
 		       const struct ip6t_entry *e,
 		       unsigned int rulenum,
 		       struct ip6tc_handle *handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `fw'. */
-int ip6tc_replace_entry(const ip6t_chainlabel chain,
+int ip6tc_replace_entry(const xt_chainlabel chain,
 			const struct ip6t_entry *e,
 			unsigned int rulenum,
 			struct ip6tc_handle *handle);
 
 /* Append entry `fw' to chain `chain'. Equivalent to insert with
    rulenum = length of chain. */
-int ip6tc_append_entry(const ip6t_chainlabel chain,
+int ip6tc_append_entry(const xt_chainlabel chain,
 		       const struct ip6t_entry *e,
 		       struct ip6tc_handle *handle);
 
 /* Check whether a matching rule exists */
-int ip6tc_check_entry(const ip6t_chainlabel chain,
+int ip6tc_check_entry(const xt_chainlabel chain,
 		       const struct ip6t_entry *origfw,
 		       unsigned char *matchmask,
 		       struct ip6tc_handle *handle);
 
 /* Delete the first rule in `chain' which matches `fw'. */
-int ip6tc_delete_entry(const ip6t_chainlabel chain,
+int ip6tc_delete_entry(const xt_chainlabel chain,
 		       const struct ip6t_entry *origfw,
 		       unsigned char *matchmask,
 		       struct ip6tc_handle *handle);
 
 /* Delete the rule in position `rulenum' in `chain'. */
-int ip6tc_delete_num_entry(const ip6t_chainlabel chain,
+int ip6tc_delete_num_entry(const xt_chainlabel chain,
 			   unsigned int rulenum,
 			   struct ip6tc_handle *handle);
 
 /* Check the packet `fw' on chain `chain'. Returns the verdict, or
    NULL and sets errno. */
-const char *ip6tc_check_packet(const ip6t_chainlabel chain,
+const char *ip6tc_check_packet(const xt_chainlabel chain,
 			       struct ip6t_entry *,
 			       struct ip6tc_handle *handle);
 
 /* Flushes the entries in the given chain (ie. empties chain). */
-int ip6tc_flush_entries(const ip6t_chainlabel chain,
+int ip6tc_flush_entries(const xt_chainlabel chain,
 			struct ip6tc_handle *handle);
 
 /* Zeroes the counters in a chain. */
-int ip6tc_zero_entries(const ip6t_chainlabel chain,
+int ip6tc_zero_entries(const xt_chainlabel chain,
 		       struct ip6tc_handle *handle);
 
 /* Creates a new chain. */
-int ip6tc_create_chain(const ip6t_chainlabel chain,
+int ip6tc_create_chain(const xt_chainlabel chain,
 		       struct ip6tc_handle *handle);
 
 /* Deletes a chain. */
-int ip6tc_delete_chain(const ip6t_chainlabel chain,
+int ip6tc_delete_chain(const xt_chainlabel chain,
 		       struct ip6tc_handle *handle);
 
 /* Renames a chain. */
-int ip6tc_rename_chain(const ip6t_chainlabel oldname,
-		       const ip6t_chainlabel newname,
+int ip6tc_rename_chain(const xt_chainlabel oldname,
+		       const xt_chainlabel newname,
 		       struct ip6tc_handle *handle);
 
 /* Sets the policy on a built-in chain. */
-int ip6tc_set_policy(const ip6t_chainlabel chain,
-		     const ip6t_chainlabel policy,
+int ip6tc_set_policy(const xt_chainlabel chain,
+		     const xt_chainlabel policy,
 		     struct ip6t_counters *counters,
 		     struct ip6tc_handle *handle);
 
 /* Get the number of references to this chain */
-int ip6tc_get_references(unsigned int *ref, const ip6t_chainlabel chain,
+int ip6tc_get_references(unsigned int *ref, const xt_chainlabel chain,
 			 struct ip6tc_handle *handle);
 
 /* read packet and byte counters for a specific rule */
-struct ip6t_counters *ip6tc_read_counter(const ip6t_chainlabel chain,
+struct ip6t_counters *ip6tc_read_counter(const xt_chainlabel chain,
 					unsigned int rulenum,
 					struct ip6tc_handle *handle);
 
 /* zero packet and byte counters for a specific rule */
-int ip6tc_zero_counter(const ip6t_chainlabel chain,
+int ip6tc_zero_counter(const xt_chainlabel chain,
 		       unsigned int rulenum,
 		       struct ip6tc_handle *handle);
 
 /* set packet and byte counters for a specific rule */
-int ip6tc_set_counter(const ip6t_chainlabel chain,
+int ip6tc_set_counter(const xt_chainlabel chain,
 		      unsigned int rulenum,
 		      struct ip6t_counters *counters,
 		      struct ip6tc_handle *handle);
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index ccbf6bf..ded4d97 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -63,91 +63,91 @@ const char *iptc_get_policy(const char *chain,
 /* Rule numbers start at 1 for the first rule. */
 
 /* Insert the entry `e' in chain `chain' into position `rulenum'. */
-int iptc_insert_entry(const ipt_chainlabel chain,
+int iptc_insert_entry(const xt_chainlabel chain,
 		      const struct ipt_entry *e,
 		      unsigned int rulenum,
 		      struct iptc_handle *handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `e'. */
-int iptc_replace_entry(const ipt_chainlabel chain,
+int iptc_replace_entry(const xt_chainlabel chain,
 		       const struct ipt_entry *e,
 		       unsigned int rulenum,
 		       struct iptc_handle *handle);
 
 /* Append entry `e' to chain `chain'.  Equivalent to insert with
    rulenum = length of chain. */
-int iptc_append_entry(const ipt_chainlabel chain,
+int iptc_append_entry(const xt_chainlabel chain,
 		      const struct ipt_entry *e,
 		      struct iptc_handle *handle);
 
 /* Check whether a mathching rule exists */
-int iptc_check_entry(const ipt_chainlabel chain,
+int iptc_check_entry(const xt_chainlabel chain,
 		      const struct ipt_entry *origfw,
 		      unsigned char *matchmask,
 		      struct iptc_handle *handle);
 
 /* Delete the first rule in `chain' which matches `e', subject to
    matchmask (array of length == origfw) */
-int iptc_delete_entry(const ipt_chainlabel chain,
+int iptc_delete_entry(const xt_chainlabel chain,
 		      const struct ipt_entry *origfw,
 		      unsigned char *matchmask,
 		      struct iptc_handle *handle);
 
 /* Delete the rule in position `rulenum' in `chain'. */
-int iptc_delete_num_entry(const ipt_chainlabel chain,
+int iptc_delete_num_entry(const xt_chainlabel chain,
 			  unsigned int rulenum,
 			  struct iptc_handle *handle);
 
 /* Check the packet `e' on chain `chain'.  Returns the verdict, or
    NULL and sets errno. */
-const char *iptc_check_packet(const ipt_chainlabel chain,
+const char *iptc_check_packet(const xt_chainlabel chain,
 			      struct ipt_entry *entry,
 			      struct iptc_handle *handle);
 
 /* Flushes the entries in the given chain (ie. empties chain). */
-int iptc_flush_entries(const ipt_chainlabel chain,
+int iptc_flush_entries(const xt_chainlabel chain,
 		       struct iptc_handle *handle);
 
 /* Zeroes the counters in a chain. */
-int iptc_zero_entries(const ipt_chainlabel chain,
+int iptc_zero_entries(const xt_chainlabel chain,
 		      struct iptc_handle *handle);
 
 /* Creates a new chain. */
-int iptc_create_chain(const ipt_chainlabel chain,
+int iptc_create_chain(const xt_chainlabel chain,
 		      struct iptc_handle *handle);
 
 /* Deletes a chain. */
-int iptc_delete_chain(const ipt_chainlabel chain,
+int iptc_delete_chain(const xt_chainlabel chain,
 		      struct iptc_handle *handle);
 
 /* Renames a chain. */
-int iptc_rename_chain(const ipt_chainlabel oldname,
-		      const ipt_chainlabel newname,
+int iptc_rename_chain(const xt_chainlabel oldname,
+		      const xt_chainlabel newname,
 		      struct iptc_handle *handle);
 
 /* Sets the policy on a built-in chain. */
-int iptc_set_policy(const ipt_chainlabel chain,
-		    const ipt_chainlabel policy,
+int iptc_set_policy(const xt_chainlabel chain,
+		    const xt_chainlabel policy,
 		    struct ipt_counters *counters,
 		    struct iptc_handle *handle);
 
 /* Get the number of references to this chain */
 int iptc_get_references(unsigned int *ref,
-			const ipt_chainlabel chain,
+			const xt_chainlabel chain,
 			struct iptc_handle *handle);
 
 /* read packet and byte counters for a specific rule */
-struct ipt_counters *iptc_read_counter(const ipt_chainlabel chain,
+struct ipt_counters *iptc_read_counter(const xt_chainlabel chain,
 				       unsigned int rulenum,
 				       struct iptc_handle *handle);
 
 /* zero packet and byte counters for a specific rule */
-int iptc_zero_counter(const ipt_chainlabel chain,
+int iptc_zero_counter(const xt_chainlabel chain,
 		      unsigned int rulenum,
 		      struct iptc_handle *handle);
 
 /* set packet and byte counters for a specific rule */
-int iptc_set_counter(const ipt_chainlabel chain,
+int iptc_set_counter(const xt_chainlabel chain,
 		     unsigned int rulenum,
 		     struct ipt_counters *counters,
 		     struct iptc_handle *handle);
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 04e5224..c5d2a0b 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -676,7 +676,7 @@ print_firewall_line(const struct ip6t_entry *fw,
 }
 
 static int
-append_entry(const ip6t_chainlabel chain,
+append_entry(const xt_chainlabel chain,
 	     struct ip6t_entry *fw,
 	     unsigned int nsaddrs,
 	     const struct in6_addr saddrs[],
@@ -706,7 +706,7 @@ append_entry(const ip6t_chainlabel chain,
 }
 
 static int
-replace_entry(const ip6t_chainlabel chain,
+replace_entry(const xt_chainlabel chain,
 	      struct ip6t_entry *fw,
 	      unsigned int rulenum,
 	      const struct in6_addr *saddr, const struct in6_addr *smask,
@@ -725,7 +725,7 @@ replace_entry(const ip6t_chainlabel chain,
 }
 
 static int
-insert_entry(const ip6t_chainlabel chain,
+insert_entry(const xt_chainlabel chain,
 	     struct ip6t_entry *fw,
 	     unsigned int rulenum,
 	     unsigned int nsaddrs,
@@ -790,7 +790,7 @@ make_delete_mask(const struct xtables_rule_match *matches,
 }
 
 static int
-delete_entry(const ip6t_chainlabel chain,
+delete_entry(const xt_chainlabel chain,
 	     struct ip6t_entry *fw,
 	     unsigned int nsaddrs,
 	     const struct in6_addr saddrs[],
@@ -825,7 +825,7 @@ delete_entry(const ip6t_chainlabel chain,
 }
 
 static int
-check_entry(const ip6t_chainlabel chain, struct ip6t_entry *fw,
+check_entry(const xt_chainlabel chain, struct ip6t_entry *fw,
 	    unsigned int nsaddrs, const struct in6_addr *saddrs,
 	    const struct in6_addr *smasks, unsigned int ndaddrs,
 	    const struct in6_addr *daddrs, const struct in6_addr *dmasks,
@@ -855,7 +855,7 @@ check_entry(const ip6t_chainlabel chain, struct ip6t_entry *fw,
 }
 
 int
-for_each_chain6(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle *),
+for_each_chain6(int (*fn)(const xt_chainlabel, int, struct ip6tc_handle *),
 	       int verbose, int builtinstoo, struct ip6tc_handle *handle)
 {
 	int ret = 1;
@@ -869,21 +869,21 @@ for_each_chain6(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle *),
 		chain = ip6tc_next_chain(handle);
 	}
 
-	chains = xtables_malloc(sizeof(ip6t_chainlabel) * chaincount);
+	chains = xtables_malloc(sizeof(xt_chainlabel) * chaincount);
 	i = 0;
 	chain = ip6tc_first_chain(handle);
 	while (chain) {
-		strcpy(chains + i*sizeof(ip6t_chainlabel), chain);
+		strcpy(chains + i*sizeof(xt_chainlabel), chain);
 		i++;
 		chain = ip6tc_next_chain(handle);
 	}
 
 	for (i = 0; i < chaincount; i++) {
 		if (!builtinstoo
-		    && ip6tc_builtin(chains + i*sizeof(ip6t_chainlabel),
+		    && ip6tc_builtin(chains + i*sizeof(xt_chainlabel),
 				    handle) == 1)
 			continue;
-		ret &= fn(chains + i*sizeof(ip6t_chainlabel), verbose, handle);
+		ret &= fn(chains + i*sizeof(xt_chainlabel), verbose, handle);
 	}
 
 	free(chains);
@@ -891,7 +891,7 @@ for_each_chain6(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle *),
 }
 
 int
-flush_entries6(const ip6t_chainlabel chain, int verbose,
+flush_entries6(const xt_chainlabel chain, int verbose,
 	      struct ip6tc_handle *handle)
 {
 	if (!chain)
@@ -903,7 +903,7 @@ flush_entries6(const ip6t_chainlabel chain, int verbose,
 }
 
 static int
-zero_entries(const ip6t_chainlabel chain, int verbose,
+zero_entries(const xt_chainlabel chain, int verbose,
 	     struct ip6tc_handle *handle)
 {
 	if (!chain)
@@ -915,7 +915,7 @@ zero_entries(const ip6t_chainlabel chain, int verbose,
 }
 
 int
-delete_chain6(const ip6t_chainlabel chain, int verbose,
+delete_chain6(const xt_chainlabel chain, int verbose,
 	     struct ip6tc_handle *handle)
 {
 	if (!chain)
@@ -927,7 +927,7 @@ delete_chain6(const ip6t_chainlabel chain, int verbose,
 }
 
 static int
-list_entries(const ip6t_chainlabel chain, int rulenum, int verbose, int numeric,
+list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 	     int expanded, int linenumbers, struct ip6tc_handle *handle)
 {
 	int found = 0;
@@ -1169,7 +1169,7 @@ void print_rule6(const struct ip6t_entry *e,
 }
 
 static int
-list_rules(const ip6t_chainlabel chain, int rulenum, int counters,
+list_rules(const xt_chainlabel chain, int rulenum, int counters,
 	     struct ip6tc_handle *handle)
 {
 	const char *this = NULL;
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 830ddbc..f5f47fa 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -678,7 +678,7 @@ print_firewall_line(const struct ipt_entry *fw,
 }
 
 static int
-append_entry(const ipt_chainlabel chain,
+append_entry(const xt_chainlabel chain,
 	     struct ipt_entry *fw,
 	     unsigned int nsaddrs,
 	     const struct in_addr saddrs[],
@@ -708,7 +708,7 @@ append_entry(const ipt_chainlabel chain,
 }
 
 static int
-replace_entry(const ipt_chainlabel chain,
+replace_entry(const xt_chainlabel chain,
 	      struct ipt_entry *fw,
 	      unsigned int rulenum,
 	      const struct in_addr *saddr, const struct in_addr *smask,
@@ -727,7 +727,7 @@ replace_entry(const ipt_chainlabel chain,
 }
 
 static int
-insert_entry(const ipt_chainlabel chain,
+insert_entry(const xt_chainlabel chain,
 	     struct ipt_entry *fw,
 	     unsigned int rulenum,
 	     unsigned int nsaddrs,
@@ -792,7 +792,7 @@ make_delete_mask(const struct xtables_rule_match *matches,
 }
 
 static int
-delete_entry(const ipt_chainlabel chain,
+delete_entry(const xt_chainlabel chain,
 	     struct ipt_entry *fw,
 	     unsigned int nsaddrs,
 	     const struct in_addr saddrs[],
@@ -827,7 +827,7 @@ delete_entry(const ipt_chainlabel chain,
 }
 
 static int
-check_entry(const ipt_chainlabel chain, struct ipt_entry *fw,
+check_entry(const xt_chainlabel chain, struct ipt_entry *fw,
 	    unsigned int nsaddrs, const struct in_addr *saddrs,
 	    const struct in_addr *smasks, unsigned int ndaddrs,
 	    const struct in_addr *daddrs, const struct in_addr *dmasks,
@@ -857,7 +857,7 @@ check_entry(const ipt_chainlabel chain, struct ipt_entry *fw,
 }
 
 int
-for_each_chain4(int (*fn)(const ipt_chainlabel, int, struct iptc_handle *),
+for_each_chain4(int (*fn)(const xt_chainlabel, int, struct iptc_handle *),
 	       int verbose, int builtinstoo, struct iptc_handle *handle)
 {
         int ret = 1;
@@ -871,21 +871,21 @@ for_each_chain4(int (*fn)(const ipt_chainlabel, int, struct iptc_handle *),
 		chain = iptc_next_chain(handle);
         }
 
-	chains = xtables_malloc(sizeof(ipt_chainlabel) * chaincount);
+	chains = xtables_malloc(sizeof(xt_chainlabel) * chaincount);
 	i = 0;
 	chain = iptc_first_chain(handle);
 	while (chain) {
-		strcpy(chains + i*sizeof(ipt_chainlabel), chain);
+		strcpy(chains + i*sizeof(xt_chainlabel), chain);
 		i++;
 		chain = iptc_next_chain(handle);
         }
 
 	for (i = 0; i < chaincount; i++) {
 		if (!builtinstoo
-		    && iptc_builtin(chains + i*sizeof(ipt_chainlabel),
+		    && iptc_builtin(chains + i*sizeof(xt_chainlabel),
 				    handle) == 1)
 			continue;
-	        ret &= fn(chains + i*sizeof(ipt_chainlabel), verbose, handle);
+	        ret &= fn(chains + i*sizeof(xt_chainlabel), verbose, handle);
 	}
 
 	free(chains);
@@ -893,7 +893,7 @@ for_each_chain4(int (*fn)(const ipt_chainlabel, int, struct iptc_handle *),
 }
 
 int
-flush_entries4(const ipt_chainlabel chain, int verbose,
+flush_entries4(const xt_chainlabel chain, int verbose,
 	      struct iptc_handle *handle)
 {
 	if (!chain)
@@ -905,7 +905,7 @@ flush_entries4(const ipt_chainlabel chain, int verbose,
 }
 
 static int
-zero_entries(const ipt_chainlabel chain, int verbose,
+zero_entries(const xt_chainlabel chain, int verbose,
 	     struct iptc_handle *handle)
 {
 	if (!chain)
@@ -917,7 +917,7 @@ zero_entries(const ipt_chainlabel chain, int verbose,
 }
 
 int
-delete_chain4(const ipt_chainlabel chain, int verbose,
+delete_chain4(const xt_chainlabel chain, int verbose,
 	     struct iptc_handle *handle)
 {
 	if (!chain)
@@ -929,7 +929,7 @@ delete_chain4(const ipt_chainlabel chain, int verbose,
 }
 
 static int
-list_entries(const ipt_chainlabel chain, int rulenum, int verbose, int numeric,
+list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 	     int expanded, int linenumbers, struct iptc_handle *handle)
 {
 	int found = 0;
@@ -1177,7 +1177,7 @@ void print_rule4(const struct ipt_entry *e,
 }
 
 static int
-list_rules(const ipt_chainlabel chain, int rulenum, int counters,
+list_rules(const xt_chainlabel chain, int rulenum, int counters,
 	     struct iptc_handle *handle)
 {
 	const char *this = NULL;
diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index 3b0c15a..b9e50c5 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -59,7 +59,7 @@ typedef unsigned int socklen_t;
 #define ERROR_TARGET		IPT_ERROR_TARGET
 #define NUMHOOKS		NF_IP_NUMHOOKS
 
-#define IPT_CHAINLABEL		ipt_chainlabel
+#define IPT_CHAINLABEL		xt_chainlabel
 
 #define TC_DUMP_ENTRIES		dump_entries
 #define TC_IS_CHAIN		iptc_is_chain
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index 0f8a889..93366e2 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -57,7 +57,7 @@ typedef unsigned int socklen_t;
 #define ERROR_TARGET		IP6T_ERROR_TARGET
 #define NUMHOOKS		NF_IP6_NUMHOOKS
 
-#define IPT_CHAINLABEL		ip6t_chainlabel
+#define IPT_CHAINLABEL		xt_chainlabel
 
 #define TC_DUMP_ENTRIES		dump_entries6
 #define TC_IS_CHAIN		ip6tc_is_chain
-- 
1.7.3.4

