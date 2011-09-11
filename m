From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/9] libiptc: combine common types: _handle
Date: Sun, 11 Sep 2011 17:35:55 +0200
Message-ID: <1315755359-7012-7-git-send-email-jengelh@medozas.de>
References: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51846 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab1IKPgI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 11:36:08 -0400
In-Reply-To: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

No real API/ABI change incurred, since the definition of the structs'
types is not visible anyhow.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/ip6tables.h             |   10 +++---
 include/iptables.h              |   12 ++++----
 include/libiptc/libip6tc.h      |   61 +++++++++++++++++++--------------------
 include/libiptc/libiptc.h       |   61 +++++++++++++++++++--------------------
 include/libiptc/xtcshared.h     |    1 +
 iptables/ip6tables-restore.c    |    6 ++--
 iptables/ip6tables-save.c       |    2 +-
 iptables/ip6tables-standalone.c |    2 +-
 iptables/ip6tables.c            |   34 +++++++++++-----------
 iptables/iptables-restore.c     |    6 ++--
 iptables/iptables-save.c        |    2 +-
 iptables/iptables-standalone.c  |    2 +-
 iptables/iptables.c             |   34 +++++++++++-----------
 libiptc/libip4tc.c              |    9 ++----
 libiptc/libip6tc.c              |    5 +--
 libiptc/libiptc.c               |    5 +--
 16 files changed, 122 insertions(+), 130 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 1def393..37d2e0a 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -8,12 +8,12 @@
 
 /* Your shared library should call one of these. */
 extern int do_command6(int argc, char *argv[], char **table,
-		       struct ip6tc_handle **handle);
+		       struct xtc_handle **handle);
 
-extern int for_each_chain6(int (*fn)(const xt_chainlabel, int, struct ip6tc_handle *), int verbose, int builtinstoo, struct ip6tc_handle *handle);
-extern int flush_entries6(const xt_chainlabel chain, int verbose, struct ip6tc_handle *handle);
-extern int delete_chain6(const xt_chainlabel chain, int verbose, struct ip6tc_handle *handle);
-void print_rule6(const struct ip6t_entry *e, struct ip6tc_handle *h, const char *chain, int counters);
+extern int for_each_chain6(int (*fn)(const xt_chainlabel, int, struct xtc_handle *), int verbose, int builtinstoo, struct xtc_handle *handle);
+extern int flush_entries6(const xt_chainlabel chain, int verbose, struct xtc_handle *handle);
+extern int delete_chain6(const xt_chainlabel chain, int verbose, struct xtc_handle *handle);
+void print_rule6(const struct ip6t_entry *e, struct xtc_handle *h, const char *chain, int counters);
 
 extern struct xtables_globals ip6tables_globals;
 
diff --git a/include/iptables.h b/include/iptables.h
index 6edd369..c42613c 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -8,15 +8,15 @@
 
 /* Your shared library should call one of these. */
 extern int do_command4(int argc, char *argv[], char **table,
-		      struct iptc_handle **handle);
+		      struct xtc_handle **handle);
 extern int delete_chain4(const xt_chainlabel chain, int verbose,
-			struct iptc_handle *handle);
+			struct xtc_handle *handle);
 extern int flush_entries4(const xt_chainlabel chain, int verbose, 
-			struct iptc_handle *handle);
-extern int for_each_chain4(int (*fn)(const xt_chainlabel, int, struct iptc_handle *),
-		int verbose, int builtinstoo, struct iptc_handle *handle);
+			struct xtc_handle *handle);
+extern int for_each_chain4(int (*fn)(const xt_chainlabel, int, struct xtc_handle *),
+		int verbose, int builtinstoo, struct xtc_handle *handle);
 extern void print_rule4(const struct ipt_entry *e,
-		struct iptc_handle *handle, const char *chain, int counters);
+		struct xtc_handle *handle, const char *chain, int counters);
 
 extern struct xtables_globals iptables_globals;
 
diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 6332073..f85dda7 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -12,8 +12,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <libiptc/xtcshared.h>
 
-struct ip6tc_handle;
-
+#define ip6tc_handle xtc_handle
 #define ip6t_chainlabel xt_chainlabel
 
 #define IP6TC_LABEL_ACCEPT "ACCEPT"
@@ -22,37 +21,37 @@ struct ip6tc_handle;
 #define IP6TC_LABEL_RETURN "RETURN"
 
 /* Does this chain exist? */
-int ip6tc_is_chain(const char *chain, struct ip6tc_handle *const handle);
+int ip6tc_is_chain(const char *chain, struct xtc_handle *const handle);
 
 /* Take a snapshot of the rules. Returns NULL on error. */
-struct ip6tc_handle *ip6tc_init(const char *tablename);
+struct xtc_handle *ip6tc_init(const char *tablename);
 
 /* Cleanup after ip6tc_init(). */
-void ip6tc_free(struct ip6tc_handle *h);
+void ip6tc_free(struct xtc_handle *h);
 
 /* Iterator functions to run through the chains.  Returns NULL at end. */
-const char *ip6tc_first_chain(struct ip6tc_handle *handle);
-const char *ip6tc_next_chain(struct ip6tc_handle *handle);
+const char *ip6tc_first_chain(struct xtc_handle *handle);
+const char *ip6tc_next_chain(struct xtc_handle *handle);
 
 /* Get first rule in the given chain: NULL for empty chain. */
 const struct ip6t_entry *ip6tc_first_rule(const char *chain,
-					  struct ip6tc_handle *handle);
+					  struct xtc_handle *handle);
 
 /* Returns NULL when rules run out. */
 const struct ip6t_entry *ip6tc_next_rule(const struct ip6t_entry *prev,
-					 struct ip6tc_handle *handle);
+					 struct xtc_handle *handle);
 
 /* Returns a pointer to the target name of this position. */
 const char *ip6tc_get_target(const struct ip6t_entry *e,
-			     struct ip6tc_handle *handle);
+			     struct xtc_handle *handle);
 
 /* Is this a built-in chain? */
-int ip6tc_builtin(const char *chain, struct ip6tc_handle *const handle);
+int ip6tc_builtin(const char *chain, struct xtc_handle *const handle);
 
 /* Get the policy of a given built-in chain */
 const char *ip6tc_get_policy(const char *chain,
 			     struct ip6t_counters *counters,
-			     struct ip6tc_handle *handle);
+			     struct xtc_handle *handle);
 
 /* These functions return TRUE for OK or 0 and set errno. If errno ==
    0, it means there was a version error (ie. upgrade libiptc). */
@@ -62,92 +61,92 @@ const char *ip6tc_get_policy(const char *chain,
 int ip6tc_insert_entry(const xt_chainlabel chain,
 		       const struct ip6t_entry *e,
 		       unsigned int rulenum,
-		       struct ip6tc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `fw'. */
 int ip6tc_replace_entry(const xt_chainlabel chain,
 			const struct ip6t_entry *e,
 			unsigned int rulenum,
-			struct ip6tc_handle *handle);
+			struct xtc_handle *handle);
 
 /* Append entry `fw' to chain `chain'. Equivalent to insert with
    rulenum = length of chain. */
 int ip6tc_append_entry(const xt_chainlabel chain,
 		       const struct ip6t_entry *e,
-		       struct ip6tc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* Check whether a matching rule exists */
 int ip6tc_check_entry(const xt_chainlabel chain,
 		       const struct ip6t_entry *origfw,
 		       unsigned char *matchmask,
-		       struct ip6tc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* Delete the first rule in `chain' which matches `fw'. */
 int ip6tc_delete_entry(const xt_chainlabel chain,
 		       const struct ip6t_entry *origfw,
 		       unsigned char *matchmask,
-		       struct ip6tc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int ip6tc_delete_num_entry(const xt_chainlabel chain,
 			   unsigned int rulenum,
-			   struct ip6tc_handle *handle);
+			   struct xtc_handle *handle);
 
 /* Check the packet `fw' on chain `chain'. Returns the verdict, or
    NULL and sets errno. */
 const char *ip6tc_check_packet(const xt_chainlabel chain,
 			       struct ip6t_entry *,
-			       struct ip6tc_handle *handle);
+			       struct xtc_handle *handle);
 
 /* Flushes the entries in the given chain (ie. empties chain). */
 int ip6tc_flush_entries(const xt_chainlabel chain,
-			struct ip6tc_handle *handle);
+			struct xtc_handle *handle);
 
 /* Zeroes the counters in a chain. */
 int ip6tc_zero_entries(const xt_chainlabel chain,
-		       struct ip6tc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* Creates a new chain. */
 int ip6tc_create_chain(const xt_chainlabel chain,
-		       struct ip6tc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* Deletes a chain. */
 int ip6tc_delete_chain(const xt_chainlabel chain,
-		       struct ip6tc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* Renames a chain. */
 int ip6tc_rename_chain(const xt_chainlabel oldname,
 		       const xt_chainlabel newname,
-		       struct ip6tc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* Sets the policy on a built-in chain. */
 int ip6tc_set_policy(const xt_chainlabel chain,
 		     const xt_chainlabel policy,
 		     struct ip6t_counters *counters,
-		     struct ip6tc_handle *handle);
+		     struct xtc_handle *handle);
 
 /* Get the number of references to this chain */
 int ip6tc_get_references(unsigned int *ref, const xt_chainlabel chain,
-			 struct ip6tc_handle *handle);
+			 struct xtc_handle *handle);
 
 /* read packet and byte counters for a specific rule */
 struct ip6t_counters *ip6tc_read_counter(const xt_chainlabel chain,
 					unsigned int rulenum,
-					struct ip6tc_handle *handle);
+					struct xtc_handle *handle);
 
 /* zero packet and byte counters for a specific rule */
 int ip6tc_zero_counter(const xt_chainlabel chain,
 		       unsigned int rulenum,
-		       struct ip6tc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* set packet and byte counters for a specific rule */
 int ip6tc_set_counter(const xt_chainlabel chain,
 		      unsigned int rulenum,
 		      struct ip6t_counters *counters,
-		      struct ip6tc_handle *handle);
+		      struct xtc_handle *handle);
 
 /* Makes the actual changes. */
-int ip6tc_commit(struct ip6tc_handle *handle);
+int ip6tc_commit(struct xtc_handle *handle);
 
 /* Get raw socket. */
 int ip6tc_get_raw_socket(void);
@@ -158,6 +157,6 @@ const char *ip6tc_strerror(int err);
 /* Return prefix length, or -1 if not contiguous */
 int ipv6_prefix_length(const struct in6_addr *a);
 
-extern void dump_entries6(struct ip6tc_handle *const);
+extern void dump_entries6(struct xtc_handle *const);
 
 #endif /* _LIBIP6TC_H */
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index ded4d97..cf91725 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -16,8 +16,7 @@
 extern "C" {
 #endif
 
-struct iptc_handle;
-
+#define iptc_handle xtc_handle
 #define ipt_chainlabel xt_chainlabel
 
 #define IPTC_LABEL_ACCEPT  "ACCEPT"
@@ -26,37 +25,37 @@ struct iptc_handle;
 #define IPTC_LABEL_RETURN  "RETURN"
 
 /* Does this chain exist? */
-int iptc_is_chain(const char *chain, struct iptc_handle *const handle);
+int iptc_is_chain(const char *chain, struct xtc_handle *const handle);
 
 /* Take a snapshot of the rules.  Returns NULL on error. */
-struct iptc_handle *iptc_init(const char *tablename);
+struct xtc_handle *iptc_init(const char *tablename);
 
 /* Cleanup after iptc_init(). */
-void iptc_free(struct iptc_handle *h);
+void iptc_free(struct xtc_handle *h);
 
 /* Iterator functions to run through the chains.  Returns NULL at end. */
-const char *iptc_first_chain(struct iptc_handle *handle);
-const char *iptc_next_chain(struct iptc_handle *handle);
+const char *iptc_first_chain(struct xtc_handle *handle);
+const char *iptc_next_chain(struct xtc_handle *handle);
 
 /* Get first rule in the given chain: NULL for empty chain. */
 const struct ipt_entry *iptc_first_rule(const char *chain,
-					struct iptc_handle *handle);
+					struct xtc_handle *handle);
 
 /* Returns NULL when rules run out. */
 const struct ipt_entry *iptc_next_rule(const struct ipt_entry *prev,
-				       struct iptc_handle *handle);
+				       struct xtc_handle *handle);
 
 /* Returns a pointer to the target name of this entry. */
 const char *iptc_get_target(const struct ipt_entry *e,
-			    struct iptc_handle *handle);
+			    struct xtc_handle *handle);
 
 /* Is this a built-in chain? */
-int iptc_builtin(const char *chain, struct iptc_handle *const handle);
+int iptc_builtin(const char *chain, struct xtc_handle *const handle);
 
 /* Get the policy of a given built-in chain */
 const char *iptc_get_policy(const char *chain,
 			    struct ipt_counters *counter,
-			    struct iptc_handle *handle);
+			    struct xtc_handle *handle);
 
 /* These functions return TRUE for OK or 0 and set errno.  If errno ==
    0, it means there was a version error (ie. upgrade libiptc). */
@@ -66,94 +65,94 @@ const char *iptc_get_policy(const char *chain,
 int iptc_insert_entry(const xt_chainlabel chain,
 		      const struct ipt_entry *e,
 		      unsigned int rulenum,
-		      struct iptc_handle *handle);
+		      struct xtc_handle *handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `e'. */
 int iptc_replace_entry(const xt_chainlabel chain,
 		       const struct ipt_entry *e,
 		       unsigned int rulenum,
-		       struct iptc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* Append entry `e' to chain `chain'.  Equivalent to insert with
    rulenum = length of chain. */
 int iptc_append_entry(const xt_chainlabel chain,
 		      const struct ipt_entry *e,
-		      struct iptc_handle *handle);
+		      struct xtc_handle *handle);
 
 /* Check whether a mathching rule exists */
 int iptc_check_entry(const xt_chainlabel chain,
 		      const struct ipt_entry *origfw,
 		      unsigned char *matchmask,
-		      struct iptc_handle *handle);
+		      struct xtc_handle *handle);
 
 /* Delete the first rule in `chain' which matches `e', subject to
    matchmask (array of length == origfw) */
 int iptc_delete_entry(const xt_chainlabel chain,
 		      const struct ipt_entry *origfw,
 		      unsigned char *matchmask,
-		      struct iptc_handle *handle);
+		      struct xtc_handle *handle);
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int iptc_delete_num_entry(const xt_chainlabel chain,
 			  unsigned int rulenum,
-			  struct iptc_handle *handle);
+			  struct xtc_handle *handle);
 
 /* Check the packet `e' on chain `chain'.  Returns the verdict, or
    NULL and sets errno. */
 const char *iptc_check_packet(const xt_chainlabel chain,
 			      struct ipt_entry *entry,
-			      struct iptc_handle *handle);
+			      struct xtc_handle *handle);
 
 /* Flushes the entries in the given chain (ie. empties chain). */
 int iptc_flush_entries(const xt_chainlabel chain,
-		       struct iptc_handle *handle);
+		       struct xtc_handle *handle);
 
 /* Zeroes the counters in a chain. */
 int iptc_zero_entries(const xt_chainlabel chain,
-		      struct iptc_handle *handle);
+		      struct xtc_handle *handle);
 
 /* Creates a new chain. */
 int iptc_create_chain(const xt_chainlabel chain,
-		      struct iptc_handle *handle);
+		      struct xtc_handle *handle);
 
 /* Deletes a chain. */
 int iptc_delete_chain(const xt_chainlabel chain,
-		      struct iptc_handle *handle);
+		      struct xtc_handle *handle);
 
 /* Renames a chain. */
 int iptc_rename_chain(const xt_chainlabel oldname,
 		      const xt_chainlabel newname,
-		      struct iptc_handle *handle);
+		      struct xtc_handle *handle);
 
 /* Sets the policy on a built-in chain. */
 int iptc_set_policy(const xt_chainlabel chain,
 		    const xt_chainlabel policy,
 		    struct ipt_counters *counters,
-		    struct iptc_handle *handle);
+		    struct xtc_handle *handle);
 
 /* Get the number of references to this chain */
 int iptc_get_references(unsigned int *ref,
 			const xt_chainlabel chain,
-			struct iptc_handle *handle);
+			struct xtc_handle *handle);
 
 /* read packet and byte counters for a specific rule */
 struct ipt_counters *iptc_read_counter(const xt_chainlabel chain,
 				       unsigned int rulenum,
-				       struct iptc_handle *handle);
+				       struct xtc_handle *handle);
 
 /* zero packet and byte counters for a specific rule */
 int iptc_zero_counter(const xt_chainlabel chain,
 		      unsigned int rulenum,
-		      struct iptc_handle *handle);
+		      struct xtc_handle *handle);
 
 /* set packet and byte counters for a specific rule */
 int iptc_set_counter(const xt_chainlabel chain,
 		     unsigned int rulenum,
 		     struct ipt_counters *counters,
-		     struct iptc_handle *handle);
+		     struct xtc_handle *handle);
 
 /* Makes the actual changes. */
-int iptc_commit(struct iptc_handle *handle);
+int iptc_commit(struct xtc_handle *handle);
 
 /* Get raw socket. */
 int iptc_get_raw_socket(void);
@@ -161,7 +160,7 @@ int iptc_get_raw_socket(void);
 /* Translates errno numbers into more human-readable form than strerror. */
 const char *iptc_strerror(int err);
 
-extern void dump_entries(struct iptc_handle *const);
+extern void dump_entries(struct xtc_handle *const);
 
 #ifdef __cplusplus
 }
diff --git a/include/libiptc/xtcshared.h b/include/libiptc/xtcshared.h
index aaf87a4..89a5151 100644
--- a/include/libiptc/xtcshared.h
+++ b/include/libiptc/xtcshared.h
@@ -2,5 +2,6 @@
 #define _LIBXTC_SHARED_H 1
 
 typedef char xt_chainlabel[32];
+struct xtc_handle;
 
 #endif /* _LIBXTC_SHARED_H */
diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 1487504..c5afe31 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -56,9 +56,9 @@ static void print_usage(const char *name, const char *version)
 	exit(1);
 }
 
-static struct ip6tc_handle *create_handle(const char *tablename)
+static struct xtc_handle *create_handle(const char *tablename)
 {
-	struct ip6tc_handle *handle;
+	struct xtc_handle *handle;
 
 	handle = ip6tc_init(tablename);
 
@@ -116,7 +116,7 @@ static void free_argv(void) {
 
 int ip6tables_restore_main(int argc, char *argv[])
 {
-	struct ip6tc_handle *handle = NULL;
+	struct xtc_handle *handle = NULL;
 	char buffer[10240];
 	int c;
 	char curtable[IP6T_TABLE_MAXNAMELEN + 1];
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index 38b0c2f..fbfce78 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -60,7 +60,7 @@ static int for_each_table(int (*func)(const char *tablename))
 
 static int do_output(const char *tablename)
 {
-	struct ip6tc_handle *h;
+	struct xtc_handle *h;
 	const char *chain = NULL;
 
 	if (!tablename)
diff --git a/iptables/ip6tables-standalone.c b/iptables/ip6tables-standalone.c
index 6b82935..21b5811 100644
--- a/iptables/ip6tables-standalone.c
+++ b/iptables/ip6tables-standalone.c
@@ -42,7 +42,7 @@ ip6tables_main(int argc, char *argv[])
 {
 	int ret;
 	char *table = "filter";
-	struct ip6tc_handle *handle = NULL;
+	struct xtc_handle *handle = NULL;
 
 	ip6tables_globals.program_name = "ip6tables";
 	ret = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index c5d2a0b..7b12205 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -469,7 +469,7 @@ print_num(uint64_t number, unsigned int format)
 
 
 static void
-print_header(unsigned int format, const char *chain, struct ip6tc_handle *handle)
+print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 {
 	struct ip6t_counters counters;
 	const char *pol = ip6tc_get_policy(chain, &counters, handle);
@@ -545,7 +545,7 @@ print_firewall(const struct ip6t_entry *fw,
 	       const char *targname,
 	       unsigned int num,
 	       unsigned int format,
-	       struct ip6tc_handle *const handle)
+	       struct xtc_handle *const handle)
 {
 	const struct xtables_target *target = NULL;
 	const struct ip6t_entry_target *t;
@@ -667,7 +667,7 @@ print_firewall(const struct ip6t_entry *fw,
 
 static void
 print_firewall_line(const struct ip6t_entry *fw,
-		    struct ip6tc_handle *const h)
+		    struct xtc_handle *const h)
 {
 	struct ip6t_entry_target *t;
 
@@ -685,7 +685,7 @@ append_entry(const xt_chainlabel chain,
 	     const struct in6_addr daddrs[],
 	     const struct in6_addr dmasks[],
 	     int verbose,
-	     struct ip6tc_handle *handle)
+	     struct xtc_handle *handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -712,7 +712,7 @@ replace_entry(const xt_chainlabel chain,
 	      const struct in6_addr *saddr, const struct in6_addr *smask,
 	      const struct in6_addr *daddr, const struct in6_addr *dmask,
 	      int verbose,
-	      struct ip6tc_handle *handle)
+	      struct xtc_handle *handle)
 {
 	fw->ipv6.src = *saddr;
 	fw->ipv6.dst = *daddr;
@@ -735,7 +735,7 @@ insert_entry(const xt_chainlabel chain,
 	     const struct in6_addr daddrs[],
 	     const struct in6_addr dmasks[],
 	     int verbose,
-	     struct ip6tc_handle *handle)
+	     struct xtc_handle *handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -799,7 +799,7 @@ delete_entry(const xt_chainlabel chain,
 	     const struct in6_addr daddrs[],
 	     const struct in6_addr dmasks[],
 	     int verbose,
-	     struct ip6tc_handle *handle,
+	     struct xtc_handle *handle,
 	     struct xtables_rule_match *matches,
 	     const struct xtables_target *target)
 {
@@ -829,7 +829,7 @@ check_entry(const xt_chainlabel chain, struct ip6t_entry *fw,
 	    unsigned int nsaddrs, const struct in6_addr *saddrs,
 	    const struct in6_addr *smasks, unsigned int ndaddrs,
 	    const struct in6_addr *daddrs, const struct in6_addr *dmasks,
-	    bool verbose, struct ip6tc_handle *handle,
+	    bool verbose, struct xtc_handle *handle,
 	    struct xtables_rule_match *matches,
 	    const struct xtables_target *target)
 {
@@ -855,8 +855,8 @@ check_entry(const xt_chainlabel chain, struct ip6t_entry *fw,
 }
 
 int
-for_each_chain6(int (*fn)(const xt_chainlabel, int, struct ip6tc_handle *),
-	       int verbose, int builtinstoo, struct ip6tc_handle *handle)
+for_each_chain6(int (*fn)(const xt_chainlabel, int, struct xtc_handle *),
+	       int verbose, int builtinstoo, struct xtc_handle *handle)
 {
 	int ret = 1;
 	const char *chain;
@@ -892,7 +892,7 @@ for_each_chain6(int (*fn)(const xt_chainlabel, int, struct ip6tc_handle *),
 
 int
 flush_entries6(const xt_chainlabel chain, int verbose,
-	      struct ip6tc_handle *handle)
+	      struct xtc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain6(flush_entries6, verbose, 1, handle);
@@ -904,7 +904,7 @@ flush_entries6(const xt_chainlabel chain, int verbose,
 
 static int
 zero_entries(const xt_chainlabel chain, int verbose,
-	     struct ip6tc_handle *handle)
+	     struct xtc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain6(zero_entries, verbose, 1, handle);
@@ -916,7 +916,7 @@ zero_entries(const xt_chainlabel chain, int verbose,
 
 int
 delete_chain6(const xt_chainlabel chain, int verbose,
-	     struct ip6tc_handle *handle)
+	     struct xtc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain6(delete_chain6, verbose, 0, handle);
@@ -928,7 +928,7 @@ delete_chain6(const xt_chainlabel chain, int verbose,
 
 static int
 list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
-	     int expanded, int linenumbers, struct ip6tc_handle *handle)
+	     int expanded, int linenumbers, struct xtc_handle *handle)
 {
 	int found = 0;
 	unsigned int format;
@@ -1080,7 +1080,7 @@ static void print_ip(const char *prefix, const struct in6_addr *ip,
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
 void print_rule6(const struct ip6t_entry *e,
-		       struct ip6tc_handle *h, const char *chain, int counters)
+		       struct xtc_handle *h, const char *chain, int counters)
 {
 	const struct ip6t_entry_target *t;
 	const char *target_name;
@@ -1170,7 +1170,7 @@ void print_rule6(const struct ip6t_entry *e,
 
 static int
 list_rules(const xt_chainlabel chain, int rulenum, int counters,
-	     struct ip6tc_handle *handle)
+	     struct xtc_handle *handle)
 {
 	const char *this = NULL;
 	int found = 0;
@@ -1328,7 +1328,7 @@ static void command_match(struct iptables_command_state *cs)
 					     m->extra_opts, &m->option_offset);
 }
 
-int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **handle)
+int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle)
 {
 	struct iptables_command_state cs;
 	struct ip6t_entry *e = NULL;
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index d0bd79a..7152d75 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -56,9 +56,9 @@ static void print_usage(const char *name, const char *version)
 	exit(1);
 }
 
-static struct iptc_handle *create_handle(const char *tablename)
+static struct xtc_handle *create_handle(const char *tablename)
 {
-	struct iptc_handle *handle;
+	struct xtc_handle *handle;
 
 	handle = iptc_init(tablename);
 
@@ -116,7 +116,7 @@ static void free_argv(void) {
 int
 iptables_restore_main(int argc, char *argv[])
 {
-	struct iptc_handle *handle = NULL;
+	struct xtc_handle *handle = NULL;
 	char buffer[10240];
 	int c;
 	char curtable[IPT_TABLE_MAXNAMELEN + 1];
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index a25a186..ff42f88 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -58,7 +58,7 @@ static int for_each_table(int (*func)(const char *tablename))
 
 static int do_output(const char *tablename)
 {
-	struct iptc_handle *h;
+	struct xtc_handle *h;
 	const char *chain = NULL;
 
 	if (!tablename)
diff --git a/iptables/iptables-standalone.c b/iptables/iptables-standalone.c
index 1ebec33..683a44a 100644
--- a/iptables/iptables-standalone.c
+++ b/iptables/iptables-standalone.c
@@ -43,7 +43,7 @@ iptables_main(int argc, char *argv[])
 {
 	int ret;
 	char *table = "filter";
-	struct iptc_handle *handle = NULL;
+	struct xtc_handle *handle = NULL;
 
 	iptables_globals.program_name = "iptables";
 	ret = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index f5f47fa..d4a7ca1 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -471,7 +471,7 @@ print_num(uint64_t number, unsigned int format)
 
 
 static void
-print_header(unsigned int format, const char *chain, struct iptc_handle *handle)
+print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 {
 	struct ipt_counters counters;
 	const char *pol = iptc_get_policy(chain, &counters, handle);
@@ -547,7 +547,7 @@ print_firewall(const struct ipt_entry *fw,
 	       const char *targname,
 	       unsigned int num,
 	       unsigned int format,
-	       struct iptc_handle *const handle)
+	       struct xtc_handle *const handle)
 {
 	const struct xtables_target *target = NULL;
 	const struct ipt_entry_target *t;
@@ -669,7 +669,7 @@ print_firewall(const struct ipt_entry *fw,
 
 static void
 print_firewall_line(const struct ipt_entry *fw,
-		    struct iptc_handle *const h)
+		    struct xtc_handle *const h)
 {
 	struct ipt_entry_target *t;
 
@@ -687,7 +687,7 @@ append_entry(const xt_chainlabel chain,
 	     const struct in_addr daddrs[],
 	     const struct in_addr dmasks[],
 	     int verbose,
-	     struct iptc_handle *handle)
+	     struct xtc_handle *handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -714,7 +714,7 @@ replace_entry(const xt_chainlabel chain,
 	      const struct in_addr *saddr, const struct in_addr *smask,
 	      const struct in_addr *daddr, const struct in_addr *dmask,
 	      int verbose,
-	      struct iptc_handle *handle)
+	      struct xtc_handle *handle)
 {
 	fw->ip.src.s_addr = saddr->s_addr;
 	fw->ip.dst.s_addr = daddr->s_addr;
@@ -737,7 +737,7 @@ insert_entry(const xt_chainlabel chain,
 	     const struct in_addr daddrs[],
 	     const struct in_addr dmasks[],
 	     int verbose,
-	     struct iptc_handle *handle)
+	     struct xtc_handle *handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -801,7 +801,7 @@ delete_entry(const xt_chainlabel chain,
 	     const struct in_addr daddrs[],
 	     const struct in_addr dmasks[],
 	     int verbose,
-	     struct iptc_handle *handle,
+	     struct xtc_handle *handle,
 	     struct xtables_rule_match *matches,
 	     const struct xtables_target *target)
 {
@@ -831,7 +831,7 @@ check_entry(const xt_chainlabel chain, struct ipt_entry *fw,
 	    unsigned int nsaddrs, const struct in_addr *saddrs,
 	    const struct in_addr *smasks, unsigned int ndaddrs,
 	    const struct in_addr *daddrs, const struct in_addr *dmasks,
-	    bool verbose, struct iptc_handle *handle,
+	    bool verbose, struct xtc_handle *handle,
 	    struct xtables_rule_match *matches,
 	    const struct xtables_target *target)
 {
@@ -857,8 +857,8 @@ check_entry(const xt_chainlabel chain, struct ipt_entry *fw,
 }
 
 int
-for_each_chain4(int (*fn)(const xt_chainlabel, int, struct iptc_handle *),
-	       int verbose, int builtinstoo, struct iptc_handle *handle)
+for_each_chain4(int (*fn)(const xt_chainlabel, int, struct xtc_handle *),
+	       int verbose, int builtinstoo, struct xtc_handle *handle)
 {
         int ret = 1;
 	const char *chain;
@@ -894,7 +894,7 @@ for_each_chain4(int (*fn)(const xt_chainlabel, int, struct iptc_handle *),
 
 int
 flush_entries4(const xt_chainlabel chain, int verbose,
-	      struct iptc_handle *handle)
+	      struct xtc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain4(flush_entries4, verbose, 1, handle);
@@ -906,7 +906,7 @@ flush_entries4(const xt_chainlabel chain, int verbose,
 
 static int
 zero_entries(const xt_chainlabel chain, int verbose,
-	     struct iptc_handle *handle)
+	     struct xtc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain4(zero_entries, verbose, 1, handle);
@@ -918,7 +918,7 @@ zero_entries(const xt_chainlabel chain, int verbose,
 
 int
 delete_chain4(const xt_chainlabel chain, int verbose,
-	     struct iptc_handle *handle)
+	     struct xtc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain4(delete_chain4, verbose, 0, handle);
@@ -930,7 +930,7 @@ delete_chain4(const xt_chainlabel chain, int verbose,
 
 static int
 list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
-	     int expanded, int linenumbers, struct iptc_handle *handle)
+	     int expanded, int linenumbers, struct xtc_handle *handle)
 {
 	int found = 0;
 	unsigned int format;
@@ -1097,7 +1097,7 @@ static void print_ip(const char *prefix, uint32_t ip,
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
 void print_rule4(const struct ipt_entry *e,
-		struct iptc_handle *h, const char *chain, int counters)
+		struct xtc_handle *h, const char *chain, int counters)
 {
 	const struct ipt_entry_target *t;
 	const char *target_name;
@@ -1178,7 +1178,7 @@ void print_rule4(const struct ipt_entry *e,
 
 static int
 list_rules(const xt_chainlabel chain, int rulenum, int counters,
-	     struct iptc_handle *handle)
+	     struct xtc_handle *handle)
 {
 	const char *this = NULL;
 	int found = 0;
@@ -1340,7 +1340,7 @@ static void command_match(struct iptables_command_state *cs)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 }
 
-int do_command4(int argc, char *argv[], char **table, struct iptc_handle **handle)
+int do_command4(int argc, char *argv[], char **table, struct xtc_handle **handle)
 {
 	struct iptables_command_state cs;
 	struct ipt_entry *e = NULL;
diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index b9e50c5..cf29238 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -47,9 +47,6 @@ typedef unsigned int socklen_t;
 #define STRUCT_STANDARD_TARGET	struct ipt_standard_target
 #define STRUCT_REPLACE		struct ipt_replace
 
-#define STRUCT_TC_HANDLE	struct iptc_handle
-#define xtc_handle		iptc_handle
-
 #define ENTRY_ITERATE		IPT_ENTRY_ITERATE
 #define TABLE_MAXNAMELEN	IPT_TABLE_MAXNAMELEN
 #define FUNCTION_MAXNAMELEN	IPT_FUNCTION_MAXNAMELEN
@@ -123,7 +120,7 @@ typedef unsigned int socklen_t;
 #define IP_PARTS(n) IP_PARTS_NATIVE(ntohl(n))
 
 static int
-dump_entry(struct ipt_entry *e, struct iptc_handle *const handle)
+dump_entry(struct ipt_entry *e, struct xtc_handle *const handle)
 {
 	size_t i;
 	STRUCT_ENTRY_TARGET *t;
@@ -238,7 +235,7 @@ check_match(const STRUCT_ENTRY_MATCH *m, unsigned int *off)
 static inline int
 check_entry(const STRUCT_ENTRY *e, unsigned int *i, unsigned int *off,
 	    unsigned int user_offset, int *was_return,
-	    struct iptc_handle *h)
+	    struct xtc_handle *h)
 {
 	unsigned int toff;
 	STRUCT_STANDARD_TARGET *t;
@@ -314,7 +311,7 @@ check_entry(const STRUCT_ENTRY *e, unsigned int *i, unsigned int *off,
 #ifdef IPTC_DEBUG
 /* Do every conceivable sanity check on the handle */
 static void
-do_check(struct iptc_handle *h, unsigned int line)
+do_check(struct xtc_handle *h, unsigned int line)
 {
 	unsigned int i, n;
 	unsigned int user_offset; /* Offset of first user chain */
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index 93366e2..636466f 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -45,9 +45,6 @@ typedef unsigned int socklen_t;
 #define STRUCT_STANDARD_TARGET	struct ip6t_standard_target
 #define STRUCT_REPLACE		struct ip6t_replace
 
-#define STRUCT_TC_HANDLE	struct ip6tc_handle
-#define xtc_handle		ip6tc_handle
-
 #define ENTRY_ITERATE		IP6T_ENTRY_ITERATE
 #define TABLE_MAXNAMELEN	IP6T_TABLE_MAXNAMELEN
 #define FUNCTION_MAXNAMELEN	IP6T_FUNCTION_MAXNAMELEN
@@ -131,7 +128,7 @@ ipv6_prefix_length(const struct in6_addr *a)
 }
 
 static int
-dump_entry(struct ip6t_entry *e, struct ip6tc_handle *const handle)
+dump_entry(struct ip6t_entry *e, struct xtc_handle *const handle)
 {
 	size_t i;
 	char buf[40];
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 0a29a69..593c5de 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -121,8 +121,7 @@ struct chain_head
 	unsigned int foot_offset;	/* offset in rule blob */
 };
 
-STRUCT_TC_HANDLE
-{
+struct xtc_handle {
 	int sockfd;
 	int changed;			 /* Have changes been made? */
 
@@ -1270,7 +1269,7 @@ alloc_handle(const char *tablename, unsigned int size, unsigned int num_rules)
 {
 	struct xtc_handle *h;
 
-	h = malloc(sizeof(STRUCT_TC_HANDLE));
+	h = malloc(sizeof(*h));
 	if (!h) {
 		errno = ENOMEM;
 		return NULL;
-- 
1.7.3.4

