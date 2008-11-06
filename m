From: Jan Engelhardt <jengelh@medozas.de>
Subject: libiptc: remove typedef indirection
Date: Thu, 6 Nov 2008 09:34:34 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811060933060.26551@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52632 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYKFIei (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:34:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit ede2c549d4c8b35cec6b7eb5bbbaf95b40168ab0
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Nov 6 05:35:33 2008 +0100

libiptc: remove typedef indirection

Don't you hate it when iptc_handle_t *x actually is a double-indirection
struct iptc_handle **? This also shows the broken constness model, since
"const iptc_handle_t x" = "iptc_handle_t const x" =
"struct iptc_handle *const x", which is like no const at all.
Lots of things to do then.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/ip6tables.h        |   10 ++--
 include/iptables.h         |   12 ++--
 include/libiptc/libip6tc.h |   61 ++++++++---------
 include/libiptc/libiptc.h  |   61 ++++++++---------
 ip6tables-restore.c        |    6 +-
 ip6tables-save.c           |    2 +-
 ip6tables-standalone.c     |    2 +-
 ip6tables.c                |   32 +++++-----
 iptables-restore.c         |    6 +-
 iptables-save.c            |    2 +-
 iptables-standalone.c      |    2 +-
 iptables.c                 |   32 +++++-----
 libiptc/libip4tc.c         |    8 +-
 libiptc/libip6tc.c         |    6 +-
 libiptc/libiptc.c          |  132 ++++++++++++++++++------------------
 15 files changed, 186 insertions(+), 188 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index dfbc9b2..9e26455 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -17,11 +17,11 @@ extern int line;
 
 /* Your shared library should call one of these. */
 extern int do_command6(int argc, char *argv[], char **table,
-		       ip6tc_handle_t *handle);
+		       struct ip6tc_handle **handle);
 
-extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *), int verbose, int builtinstoo, ip6tc_handle_t *handle);
-extern int flush_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
-extern int delete_chain(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
-void print_rule(const struct ip6t_entry *e, ip6tc_handle_t *h, const char *chain, int counters);
+extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle **), int verbose, int builtinstoo, struct ip6tc_handle **handle);
+extern int flush_entries(const ip6t_chainlabel chain, int verbose, struct ip6tc_handle **handle);
+extern int delete_chain(const ip6t_chainlabel chain, int verbose, struct ip6tc_handle **handle);
+void print_rule(const struct ip6t_entry *e, struct ip6tc_handle **h, const char *chain, int counters);
 
 #endif /*_IP6TABLES_USER_H*/
diff --git a/include/iptables.h b/include/iptables.h
index 99e8e1e..424db59 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -17,15 +17,15 @@ extern int line;
 
 /* Your shared library should call one of these. */
 extern int do_command(int argc, char *argv[], char **table,
-		      iptc_handle_t *handle);
+		      struct iptc_handle **handle);
 extern int delete_chain(const ipt_chainlabel chain, int verbose,
-			iptc_handle_t *handle);
+			struct iptc_handle **handle);
 extern int flush_entries(const ipt_chainlabel chain, int verbose, 
-			iptc_handle_t *handle);
-extern int for_each_chain(int (*fn)(const ipt_chainlabel, int, iptc_handle_t *),
-		int verbose, int builtinstoo, iptc_handle_t *handle);
+			struct iptc_handle **handle);
+extern int for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle **),
+		int verbose, int builtinstoo, struct iptc_handle **handle);
 extern void print_rule(const struct ipt_entry *e,
-		iptc_handle_t *handle, const char *chain, int counters);
+		struct iptc_handle **handle, const char *chain, int counters);
 
 /* kernel revision handling */
 extern int kernel_version;
diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 6e8a565..9f8c08f 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -11,6 +11,8 @@
 #endif
 #define IP6T_ALIGN(s) (((s) + (IP6T_MIN_ALIGN-1)) & ~(IP6T_MIN_ALIGN-1))
 
+struct ip6tc_handle;
+
 typedef char ip6t_chainlabel[32];
 
 #define IP6TC_LABEL_ACCEPT "ACCEPT"
@@ -18,41 +20,38 @@ typedef char ip6t_chainlabel[32];
 #define IP6TC_LABEL_QUEUE   "QUEUE"
 #define IP6TC_LABEL_RETURN "RETURN"
 
-/* Transparent handle type. */
-typedef struct ip6tc_handle *ip6tc_handle_t;
-
 /* Does this chain exist? */
-int ip6tc_is_chain(const char *chain, const ip6tc_handle_t handle);
+int ip6tc_is_chain(const char *chain, struct ip6tc_handle *const handle);
 
 /* Take a snapshot of the rules. Returns NULL on error. */
-ip6tc_handle_t ip6tc_init(const char *tablename);
+struct ip6tc_handle *ip6tc_init(const char *tablename);
 
 /* Cleanup after ip6tc_init(). */
-void ip6tc_free(ip6tc_handle_t *h);
+void ip6tc_free(struct ip6tc_handle **h);
 
 /* Iterator functions to run through the chains.  Returns NULL at end. */
-const char *ip6tc_first_chain(ip6tc_handle_t *handle);
-const char *ip6tc_next_chain(ip6tc_handle_t *handle);
+const char *ip6tc_first_chain(struct ip6tc_handle **handle);
+const char *ip6tc_next_chain(struct ip6tc_handle **handle);
 
 /* Get first rule in the given chain: NULL for empty chain. */
 const struct ip6t_entry *ip6tc_first_rule(const char *chain,
-					  ip6tc_handle_t *handle);
+					  struct ip6tc_handle **handle);
 
 /* Returns NULL when rules run out. */
 const struct ip6t_entry *ip6tc_next_rule(const struct ip6t_entry *prev,
-					 ip6tc_handle_t *handle);
+					 struct ip6tc_handle **handle);
 
 /* Returns a pointer to the target name of this position. */
 const char *ip6tc_get_target(const struct ip6t_entry *e,
-			     ip6tc_handle_t *handle);
+			     struct ip6tc_handle **handle);
 
 /* Is this a built-in chain? */
-int ip6tc_builtin(const char *chain, const ip6tc_handle_t handle);
+int ip6tc_builtin(const char *chain, struct ip6tc_handle *const handle);
 
 /* Get the policy of a given built-in chain */
 const char *ip6tc_get_policy(const char *chain,
 			     struct ip6t_counters *counters,
-			     ip6tc_handle_t *handle);
+			     struct ip6tc_handle **handle);
 
 /* These functions return TRUE for OK or 0 and set errno. If errno ==
    0, it means there was a version error (ie. upgrade libiptc). */
@@ -62,86 +61,86 @@ const char *ip6tc_get_policy(const char *chain,
 int ip6tc_insert_entry(const ip6t_chainlabel chain,
 		       const struct ip6t_entry *e,
 		       unsigned int rulenum,
-		       ip6tc_handle_t *handle);
+		       struct ip6tc_handle **handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `fw'. */
 int ip6tc_replace_entry(const ip6t_chainlabel chain,
 			const struct ip6t_entry *e,
 			unsigned int rulenum,
-			ip6tc_handle_t *handle);
+			struct ip6tc_handle **handle);
 
 /* Append entry `fw' to chain `chain'. Equivalent to insert with
    rulenum = length of chain. */
 int ip6tc_append_entry(const ip6t_chainlabel chain,
 		       const struct ip6t_entry *e,
-		       ip6tc_handle_t *handle);
+		       struct ip6tc_handle **handle);
 
 /* Delete the first rule in `chain' which matches `fw'. */
 int ip6tc_delete_entry(const ip6t_chainlabel chain,
 		       const struct ip6t_entry *origfw,
 		       unsigned char *matchmask,
-		       ip6tc_handle_t *handle);
+		       struct ip6tc_handle **handle);
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int ip6tc_delete_num_entry(const ip6t_chainlabel chain,
 			   unsigned int rulenum,
-			   ip6tc_handle_t *handle);
+			   struct ip6tc_handle **handle);
 
 /* Check the packet `fw' on chain `chain'. Returns the verdict, or
    NULL and sets errno. */
 const char *ip6tc_check_packet(const ip6t_chainlabel chain,
 			       struct ip6t_entry *,
-			       ip6tc_handle_t *handle);
+			       struct ip6tc_handle **handle);
 
 /* Flushes the entries in the given chain (ie. empties chain). */
 int ip6tc_flush_entries(const ip6t_chainlabel chain,
-			ip6tc_handle_t *handle);
+			struct ip6tc_handle **handle);
 
 /* Zeroes the counters in a chain. */
 int ip6tc_zero_entries(const ip6t_chainlabel chain,
-		       ip6tc_handle_t *handle);
+		       struct ip6tc_handle **handle);
 
 /* Creates a new chain. */
 int ip6tc_create_chain(const ip6t_chainlabel chain,
-		       ip6tc_handle_t *handle);
+		       struct ip6tc_handle **handle);
 
 /* Deletes a chain. */
 int ip6tc_delete_chain(const ip6t_chainlabel chain,
-		       ip6tc_handle_t *handle);
+		       struct ip6tc_handle **handle);
 
 /* Renames a chain. */
 int ip6tc_rename_chain(const ip6t_chainlabel oldname,
 		       const ip6t_chainlabel newname,
-		       ip6tc_handle_t *handle);
+		       struct ip6tc_handle **handle);
 
 /* Sets the policy on a built-in chain. */
 int ip6tc_set_policy(const ip6t_chainlabel chain,
 		     const ip6t_chainlabel policy,
 		     struct ip6t_counters *counters,
-		     ip6tc_handle_t *handle);
+		     struct ip6tc_handle **handle);
 
 /* Get the number of references to this chain */
 int ip6tc_get_references(unsigned int *ref, const ip6t_chainlabel chain,
-			 ip6tc_handle_t *handle);
+			 struct ip6tc_handle **handle);
 
 /* read packet and byte counters for a specific rule */
 struct ip6t_counters *ip6tc_read_counter(const ip6t_chainlabel chain,
 					unsigned int rulenum,
-					ip6tc_handle_t *handle);
+					struct ip6tc_handle **handle);
 
 /* zero packet and byte counters for a specific rule */
 int ip6tc_zero_counter(const ip6t_chainlabel chain,
 		       unsigned int rulenum,
-		       ip6tc_handle_t *handle);
+		       struct ip6tc_handle **handle);
 
 /* set packet and byte counters for a specific rule */
 int ip6tc_set_counter(const ip6t_chainlabel chain,
 		      unsigned int rulenum,
 		      struct ip6t_counters *counters,
-		      ip6tc_handle_t *handle);
+		      struct ip6tc_handle **handle);
 
 /* Makes the actual changes. */
-int ip6tc_commit(ip6tc_handle_t *handle);
+int ip6tc_commit(struct ip6tc_handle **handle);
 
 /* Get raw socket. */
 int ip6tc_get_raw_socket(void);
@@ -152,6 +151,6 @@ const char *ip6tc_strerror(int err);
 /* Return prefix length, or -1 if not contiguous */
 int ipv6_prefix_length(const struct in6_addr *a);
 
-extern void dump_entries6(const ip6tc_handle_t);
+extern void dump_entries6(struct ip6tc_handle *const);
 
 #endif /* _LIBIP6TC_H */
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index 1f6f95d..dd1ec6b 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -19,6 +19,8 @@ extern "C" {
 
 #define IPT_ALIGN(s) (((s) + ((IPT_MIN_ALIGN)-1)) & ~((IPT_MIN_ALIGN)-1))
 
+struct iptc_handle;
+
 typedef char ipt_chainlabel[32];
 
 #define IPTC_LABEL_ACCEPT  "ACCEPT"
@@ -26,41 +28,38 @@ typedef char ipt_chainlabel[32];
 #define IPTC_LABEL_QUEUE   "QUEUE"
 #define IPTC_LABEL_RETURN  "RETURN"
 
-/* Transparent handle type. */
-typedef struct iptc_handle *iptc_handle_t;
-
 /* Does this chain exist? */
-int iptc_is_chain(const char *chain, const iptc_handle_t handle);
+int iptc_is_chain(const char *chain, struct iptc_handle *const handle);
 
 /* Take a snapshot of the rules.  Returns NULL on error. */
-iptc_handle_t iptc_init(const char *tablename);
+struct iptc_handle *iptc_init(const char *tablename);
 
 /* Cleanup after iptc_init(). */
-void iptc_free(iptc_handle_t *h);
+void iptc_free(struct iptc_handle **h);
 
 /* Iterator functions to run through the chains.  Returns NULL at end. */
-const char *iptc_first_chain(iptc_handle_t *handle);
-const char *iptc_next_chain(iptc_handle_t *handle);
+const char *iptc_first_chain(struct iptc_handle **handle);
+const char *iptc_next_chain(struct iptc_handle **handle);
 
 /* Get first rule in the given chain: NULL for empty chain. */
 const struct ipt_entry *iptc_first_rule(const char *chain,
-					iptc_handle_t *handle);
+					struct iptc_handle **handle);
 
 /* Returns NULL when rules run out. */
 const struct ipt_entry *iptc_next_rule(const struct ipt_entry *prev,
-				       iptc_handle_t *handle);
+				       struct iptc_handle **handle);
 
 /* Returns a pointer to the target name of this entry. */
 const char *iptc_get_target(const struct ipt_entry *e,
-			    iptc_handle_t *handle);
+			    struct iptc_handle **handle);
 
 /* Is this a built-in chain? */
-int iptc_builtin(const char *chain, const iptc_handle_t handle);
+int iptc_builtin(const char *chain, struct iptc_handle *const handle);
 
 /* Get the policy of a given built-in chain */
 const char *iptc_get_policy(const char *chain,
 			    struct ipt_counters *counter,
-			    iptc_handle_t *handle);
+			    struct iptc_handle **handle);
 
 /* These functions return TRUE for OK or 0 and set errno.  If errno ==
    0, it means there was a version error (ie. upgrade libiptc). */
@@ -70,88 +69,88 @@ const char *iptc_get_policy(const char *chain,
 int iptc_insert_entry(const ipt_chainlabel chain,
 		      const struct ipt_entry *e,
 		      unsigned int rulenum,
-		      iptc_handle_t *handle);
+		      struct iptc_handle **handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `e'. */
 int iptc_replace_entry(const ipt_chainlabel chain,
 		       const struct ipt_entry *e,
 		       unsigned int rulenum,
-		       iptc_handle_t *handle);
+		       struct iptc_handle **handle);
 
 /* Append entry `e' to chain `chain'.  Equivalent to insert with
    rulenum = length of chain. */
 int iptc_append_entry(const ipt_chainlabel chain,
 		      const struct ipt_entry *e,
-		      iptc_handle_t *handle);
+		      struct iptc_handle **handle);
 
 /* Delete the first rule in `chain' which matches `e', subject to
    matchmask (array of length == origfw) */
 int iptc_delete_entry(const ipt_chainlabel chain,
 		      const struct ipt_entry *origfw,
 		      unsigned char *matchmask,
-		      iptc_handle_t *handle);
+		      struct iptc_handle **handle);
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int iptc_delete_num_entry(const ipt_chainlabel chain,
 			  unsigned int rulenum,
-			  iptc_handle_t *handle);
+			  struct iptc_handle **handle);
 
 /* Check the packet `e' on chain `chain'.  Returns the verdict, or
    NULL and sets errno. */
 const char *iptc_check_packet(const ipt_chainlabel chain,
 			      struct ipt_entry *entry,
-			      iptc_handle_t *handle);
+			      struct iptc_handle **handle);
 
 /* Flushes the entries in the given chain (ie. empties chain). */
 int iptc_flush_entries(const ipt_chainlabel chain,
-		       iptc_handle_t *handle);
+		       struct iptc_handle **handle);
 
 /* Zeroes the counters in a chain. */
 int iptc_zero_entries(const ipt_chainlabel chain,
-		      iptc_handle_t *handle);
+		      struct iptc_handle **handle);
 
 /* Creates a new chain. */
 int iptc_create_chain(const ipt_chainlabel chain,
-		      iptc_handle_t *handle);
+		      struct iptc_handle **handle);
 
 /* Deletes a chain. */
 int iptc_delete_chain(const ipt_chainlabel chain,
-		      iptc_handle_t *handle);
+		      struct iptc_handle **handle);
 
 /* Renames a chain. */
 int iptc_rename_chain(const ipt_chainlabel oldname,
 		      const ipt_chainlabel newname,
-		      iptc_handle_t *handle);
+		      struct iptc_handle **handle);
 
 /* Sets the policy on a built-in chain. */
 int iptc_set_policy(const ipt_chainlabel chain,
 		    const ipt_chainlabel policy,
 		    struct ipt_counters *counters,
-		    iptc_handle_t *handle);
+		    struct iptc_handle **handle);
 
 /* Get the number of references to this chain */
 int iptc_get_references(unsigned int *ref,
 			const ipt_chainlabel chain,
-			iptc_handle_t *handle);
+			struct iptc_handle **handle);
 
 /* read packet and byte counters for a specific rule */
 struct ipt_counters *iptc_read_counter(const ipt_chainlabel chain,
 				       unsigned int rulenum,
-				       iptc_handle_t *handle);
+				       struct iptc_handle **handle);
 
 /* zero packet and byte counters for a specific rule */
 int iptc_zero_counter(const ipt_chainlabel chain,
 		      unsigned int rulenum,
-		      iptc_handle_t *handle);
+		      struct iptc_handle **handle);
 
 /* set packet and byte counters for a specific rule */
 int iptc_set_counter(const ipt_chainlabel chain,
 		     unsigned int rulenum,
 		     struct ipt_counters *counters,
-		     iptc_handle_t *handle);
+		     struct iptc_handle **handle);
 
 /* Makes the actual changes. */
-int iptc_commit(iptc_handle_t *handle);
+int iptc_commit(struct iptc_handle **handle);
 
 /* Get raw socket. */
 int iptc_get_raw_socket(void);
@@ -159,7 +158,7 @@ int iptc_get_raw_socket(void);
 /* Translates errno numbers into more human-readable form than strerror. */
 const char *iptc_strerror(int err);
 
-extern void dump_entries(const iptc_handle_t);
+extern void dump_entries(struct iptc_handle *const);
 
 #ifdef __cplusplus
 }
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index f51e38f..d2a9df3 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -56,10 +56,10 @@ static void print_usage(const char *name, const char *version)
 	exit(1);
 }
 
-static ip6tc_handle_t create_handle(const char *tablename,
+static struct ip6tc_handle *create_handle(const char *tablename,
                                     const char *modprobe)
 {
-	ip6tc_handle_t handle;
+	struct ip6tc_handle *handle;
 
 	handle = ip6tc_init(tablename);
 
@@ -119,7 +119,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 int main(int argc, char *argv[])
 #endif
 {
-	ip6tc_handle_t handle = NULL;
+	struct ip6tc_handle *handle = NULL;
 	char buffer[10240];
 	int c;
 	char curtable[IP6T_TABLE_MAXNAMELEN + 1];
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 7b03d7c..360f0e4 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -61,7 +61,7 @@ static int for_each_table(int (*func)(const char *tablename))
 
 static int do_output(const char *tablename)
 {
-	ip6tc_handle_t h;
+	struct ip6tc_handle *h;
 	const char *chain = NULL;
 
 	if (!tablename)
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 5bdcd4f..9a0b2b3 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -47,7 +47,7 @@ main(int argc, char *argv[])
 {
 	int ret;
 	char *table = "filter";
-	ip6tc_handle_t handle = NULL;
+	struct ip6tc_handle *handle = NULL;
 
 	program_name = "ip6tables";
 	program_version = XTABLES_VERSION;
diff --git a/ip6tables.c b/ip6tables.c
index 12298ca..da1da63 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -651,7 +651,7 @@ print_num(u_int64_t number, unsigned int format)
 
 
 static void
-print_header(unsigned int format, const char *chain, ip6tc_handle_t *handle)
+print_header(unsigned int format, const char *chain, struct ip6tc_handle **handle)
 {
 	struct ip6t_counters counters;
 	const char *pol = ip6tc_get_policy(chain, &counters, handle);
@@ -726,7 +726,7 @@ print_firewall(const struct ip6t_entry *fw,
 	       const char *targname,
 	       unsigned int num,
 	       unsigned int format,
-	       const ip6tc_handle_t handle)
+	       struct ip6tc_handle *const handle)
 {
 	struct xtables_target *target = NULL;
 	const struct ip6t_entry_target *t;
@@ -849,7 +849,7 @@ print_firewall(const struct ip6t_entry *fw,
 
 static void
 print_firewall_line(const struct ip6t_entry *fw,
-		    const ip6tc_handle_t h)
+		    struct ip6tc_handle *const h)
 {
 	struct ip6t_entry_target *t;
 
@@ -865,7 +865,7 @@ append_entry(const ip6t_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in6_addr daddrs[],
 	     int verbose,
-	     ip6tc_handle_t *handle)
+	     struct ip6tc_handle **handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -890,7 +890,7 @@ replace_entry(const ip6t_chainlabel chain,
 	      const struct in6_addr *saddr,
 	      const struct in6_addr *daddr,
 	      int verbose,
-	      ip6tc_handle_t *handle)
+	      struct ip6tc_handle **handle)
 {
 	fw->ipv6.src = *saddr;
 	fw->ipv6.dst = *daddr;
@@ -909,7 +909,7 @@ insert_entry(const ip6t_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in6_addr daddrs[],
 	     int verbose,
-	     ip6tc_handle_t *handle)
+	     struct ip6tc_handle **handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -968,7 +968,7 @@ delete_entry(const ip6t_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in6_addr daddrs[],
 	     int verbose,
-	     ip6tc_handle_t *handle,
+	     struct ip6tc_handle **handle,
 	     struct ip6tables_rule_match *matches)
 {
 	unsigned int i, j;
@@ -991,8 +991,8 @@ delete_entry(const ip6t_chainlabel chain,
 }
 
 int
-for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *),
-	       int verbose, int builtinstoo, ip6tc_handle_t *handle)
+for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle **),
+	       int verbose, int builtinstoo, struct ip6tc_handle **handle)
 {
 	int ret = 1;
 	const char *chain;
@@ -1028,7 +1028,7 @@ for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *),
 
 int
 flush_entries(const ip6t_chainlabel chain, int verbose,
-	      ip6tc_handle_t *handle)
+	      struct ip6tc_handle **handle)
 {
 	if (!chain)
 		return for_each_chain(flush_entries, verbose, 1, handle);
@@ -1040,7 +1040,7 @@ flush_entries(const ip6t_chainlabel chain, int verbose,
 
 static int
 zero_entries(const ip6t_chainlabel chain, int verbose,
-	     ip6tc_handle_t *handle)
+	     struct ip6tc_handle **handle)
 {
 	if (!chain)
 		return for_each_chain(zero_entries, verbose, 1, handle);
@@ -1052,7 +1052,7 @@ zero_entries(const ip6t_chainlabel chain, int verbose,
 
 int
 delete_chain(const ip6t_chainlabel chain, int verbose,
-	     ip6tc_handle_t *handle)
+	     struct ip6tc_handle **handle)
 {
 	if (!chain)
 		return for_each_chain(delete_chain, verbose, 0, handle);
@@ -1064,7 +1064,7 @@ delete_chain(const ip6t_chainlabel chain, int verbose,
 
 static int
 list_entries(const ip6t_chainlabel chain, int rulenum, int verbose, int numeric,
-	     int expanded, int linenumbers, ip6tc_handle_t *handle)
+	     int expanded, int linenumbers, struct ip6tc_handle **handle)
 {
 	int found = 0;
 	unsigned int format;
@@ -1217,7 +1217,7 @@ static void print_ip(char *prefix, const struct in6_addr *ip, const struct in6_a
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
 void print_rule(const struct ip6t_entry *e,
-		       ip6tc_handle_t *h, const char *chain, int counters)
+		       struct ip6tc_handle **h, const char *chain, int counters)
 {
 	struct ip6t_entry_target *t;
 	const char *target_name;
@@ -1307,7 +1307,7 @@ void print_rule(const struct ip6t_entry *e,
 
 static int
 list_rules(const ip6t_chainlabel chain, int rulenum, int counters,
-	     ip6tc_handle_t *handle)
+	     struct ip6tc_handle **handle)
 {
 	const char *this = NULL;
 	int found = 0;
@@ -1415,7 +1415,7 @@ static void set_revision(char *name, u_int8_t revision)
 	name[IP6T_FUNCTION_MAXNAMELEN - 1] = revision;
 }
 
-int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
+int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **handle)
 {
 	struct ip6t_entry fw, *e = NULL;
 	int invert = 0;
diff --git a/iptables-restore.c b/iptables-restore.c
index dcbed14..a8ce7cc 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -55,9 +55,9 @@ static void print_usage(const char *name, const char *version)
 	exit(1);
 }
 
-static iptc_handle_t create_handle(const char *tablename, const char *modprobe)
+static struct iptc_handle *create_handle(const char *tablename, const char *modprobe)
 {
-	iptc_handle_t handle;
+	struct iptc_handle *handle;
 
 	handle = iptc_init(tablename);
 
@@ -119,7 +119,7 @@ int
 main(int argc, char *argv[])
 #endif
 {
-	iptc_handle_t handle = NULL;
+	struct iptc_handle *handle = NULL;
 	char buffer[10240];
 	int c;
 	char curtable[IPT_TABLE_MAXNAMELEN + 1];
diff --git a/iptables-save.c b/iptables-save.c
index ecccac4..52b85d8 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -59,7 +59,7 @@ static int for_each_table(int (*func)(const char *tablename))
 
 static int do_output(const char *tablename)
 {
-	iptc_handle_t h;
+	struct iptc_handle *h;
 	const char *chain = NULL;
 
 	if (!tablename)
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 55d9bbe..d62c317 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -48,7 +48,7 @@ main(int argc, char *argv[])
 {
 	int ret;
 	char *table = "filter";
-	iptc_handle_t handle = NULL;
+	struct iptc_handle *handle = NULL;
 
 	program_name = "iptables";
 	program_version = XTABLES_VERSION;
diff --git a/iptables.c b/iptables.c
index b927a11..52f90d2 100644
--- a/iptables.c
+++ b/iptables.c
@@ -646,7 +646,7 @@ print_num(u_int64_t number, unsigned int format)
 
 
 static void
-print_header(unsigned int format, const char *chain, iptc_handle_t *handle)
+print_header(unsigned int format, const char *chain, struct iptc_handle **handle)
 {
 	struct ipt_counters counters;
 	const char *pol = iptc_get_policy(chain, &counters, handle);
@@ -721,7 +721,7 @@ print_firewall(const struct ipt_entry *fw,
 	       const char *targname,
 	       unsigned int num,
 	       unsigned int format,
-	       const iptc_handle_t handle)
+	       struct iptc_handle *const handle)
 {
 	struct xtables_target *target = NULL;
 	const struct ipt_entry_target *t;
@@ -842,7 +842,7 @@ print_firewall(const struct ipt_entry *fw,
 
 static void
 print_firewall_line(const struct ipt_entry *fw,
-		    const iptc_handle_t h)
+		    struct iptc_handle *const h)
 {
 	struct ipt_entry_target *t;
 
@@ -858,7 +858,7 @@ append_entry(const ipt_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in_addr daddrs[],
 	     int verbose,
-	     iptc_handle_t *handle)
+	     struct iptc_handle **handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -883,7 +883,7 @@ replace_entry(const ipt_chainlabel chain,
 	      const struct in_addr *saddr,
 	      const struct in_addr *daddr,
 	      int verbose,
-	      iptc_handle_t *handle)
+	      struct iptc_handle **handle)
 {
 	fw->ip.src.s_addr = saddr->s_addr;
 	fw->ip.dst.s_addr = daddr->s_addr;
@@ -902,7 +902,7 @@ insert_entry(const ipt_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in_addr daddrs[],
 	     int verbose,
-	     iptc_handle_t *handle)
+	     struct iptc_handle **handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -961,7 +961,7 @@ delete_entry(const ipt_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in_addr daddrs[],
 	     int verbose,
-	     iptc_handle_t *handle,
+	     struct iptc_handle **handle,
 	     struct iptables_rule_match *matches)
 {
 	unsigned int i, j;
@@ -984,8 +984,8 @@ delete_entry(const ipt_chainlabel chain,
 }
 
 int
-for_each_chain(int (*fn)(const ipt_chainlabel, int, iptc_handle_t *),
-	       int verbose, int builtinstoo, iptc_handle_t *handle)
+for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle **),
+	       int verbose, int builtinstoo, struct iptc_handle **handle)
 {
         int ret = 1;
 	const char *chain;
@@ -1021,7 +1021,7 @@ for_each_chain(int (*fn)(const ipt_chainlabel, int, iptc_handle_t *),
 
 int
 flush_entries(const ipt_chainlabel chain, int verbose,
-	      iptc_handle_t *handle)
+	      struct iptc_handle **handle)
 {
 	if (!chain)
 		return for_each_chain(flush_entries, verbose, 1, handle);
@@ -1033,7 +1033,7 @@ flush_entries(const ipt_chainlabel chain, int verbose,
 
 static int
 zero_entries(const ipt_chainlabel chain, int verbose,
-	     iptc_handle_t *handle)
+	     struct iptc_handle **handle)
 {
 	if (!chain)
 		return for_each_chain(zero_entries, verbose, 1, handle);
@@ -1045,7 +1045,7 @@ zero_entries(const ipt_chainlabel chain, int verbose,
 
 int
 delete_chain(const ipt_chainlabel chain, int verbose,
-	     iptc_handle_t *handle)
+	     struct iptc_handle **handle)
 {
 	if (!chain)
 		return for_each_chain(delete_chain, verbose, 0, handle);
@@ -1057,7 +1057,7 @@ delete_chain(const ipt_chainlabel chain, int verbose,
 
 static int
 list_entries(const ipt_chainlabel chain, int rulenum, int verbose, int numeric,
-	     int expanded, int linenumbers, iptc_handle_t *handle)
+	     int expanded, int linenumbers, struct iptc_handle **handle)
 {
 	int found = 0;
 	unsigned int format;
@@ -1225,7 +1225,7 @@ static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
 void print_rule(const struct ipt_entry *e,
-		iptc_handle_t *h, const char *chain, int counters)
+		struct iptc_handle **h, const char *chain, int counters)
 {
 	struct ipt_entry_target *t;
 	const char *target_name;
@@ -1306,7 +1306,7 @@ void print_rule(const struct ipt_entry *e,
 
 static int
 list_rules(const ipt_chainlabel chain, int rulenum, int counters,
-	     iptc_handle_t *handle)
+	     struct iptc_handle **handle)
 {
 	const char *this = NULL;
 	int found = 0;
@@ -1429,7 +1429,7 @@ get_kernel_version(void) {
 	kernel_version = LINUX_VERSION(x, y, z);
 }
 
-int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
+int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle)
 {
 	struct ipt_entry fw, *e = NULL;
 	int invert = 0;
diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index 71af17f..e8aaf6a 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -51,7 +51,7 @@ typedef unsigned int socklen_t;
 #define STRUCT_REPLACE		struct ipt_replace
 
 #define STRUCT_TC_HANDLE	struct iptc_handle
-#define TC_HANDLE_T		iptc_handle_t
+#define xtc_handle		iptc_handle
 
 #define ENTRY_ITERATE		IPT_ENTRY_ITERATE
 #define TABLE_MAXNAMELEN	IPT_TABLE_MAXNAMELEN
@@ -126,7 +126,7 @@ typedef unsigned int socklen_t;
 #define IP_PARTS(n) IP_PARTS_NATIVE(ntohl(n))
 
 int
-dump_entry(STRUCT_ENTRY *e, const TC_HANDLE_T handle)
+dump_entry(STRUCT_ENTRY *e, struct iptc_handle *const handle)
 {
 	size_t i;
 	STRUCT_ENTRY_TARGET *t;
@@ -240,7 +240,7 @@ check_match(const STRUCT_ENTRY_MATCH *m, unsigned int *off)
 static inline int
 check_entry(const STRUCT_ENTRY *e, unsigned int *i, unsigned int *off,
 	    unsigned int user_offset, int *was_return,
-	    TC_HANDLE_T h)
+	    struct iptc_handle *h)
 {
 	unsigned int toff;
 	STRUCT_STANDARD_TARGET *t;
@@ -316,7 +316,7 @@ check_entry(const STRUCT_ENTRY *e, unsigned int *i, unsigned int *off,
 #ifdef IPTC_DEBUG
 /* Do every conceivable sanity check on the handle */
 static void
-do_check(TC_HANDLE_T h, unsigned int line)
+do_check(struct iptc_handle *h, unsigned int line)
 {
 	unsigned int i, n;
 	unsigned int user_offset; /* Offset of first user chain */
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index 71e262e..221a9f3 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -46,7 +46,7 @@ typedef unsigned int socklen_t;
 #define STRUCT_REPLACE		struct ip6t_replace
 
 #define STRUCT_TC_HANDLE	struct ip6tc_handle
-#define TC_HANDLE_T		ip6tc_handle_t
+#define xtc_handle		ip6tc_handle
 
 #define ENTRY_ITERATE		IP6T_ENTRY_ITERATE
 #define TABLE_MAXNAMELEN	IP6T_TABLE_MAXNAMELEN
@@ -131,7 +131,7 @@ ipv6_prefix_length(const struct in6_addr *a)
 }
 
 static int
-dump_entry(struct ip6t_entry *e, const ip6tc_handle_t handle)
+dump_entry(struct ip6t_entry *e, struct ip6tc_handle *const handle)
 {
 	size_t i;
 	char buf[40];
@@ -261,7 +261,7 @@ unconditional(const struct ip6t_ip6 *ipv6)
 #ifdef IPTC_DEBUG
 /* Do every conceivable sanity check on the handle */
 static void
-do_check(TC_HANDLE_T h, unsigned int line)
+do_check(struct xtc_handle *h, unsigned int line)
 {
 	unsigned int i, n;
 	unsigned int user_offset; /* Offset of first user chain */
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 39c8e99..1e2cd6e 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -185,13 +185,13 @@ static struct rule_head *iptcc_alloc_rule(struct chain_head *c, unsigned int siz
 
 /* notify us that the ruleset has been modified by the user */
 static inline void
-set_changed(TC_HANDLE_T h)
+set_changed(struct xtc_handle *h)
 {
 	h->changed = 1;
 }
 
 #ifdef IPTC_DEBUG
-static void do_check(TC_HANDLE_T h, unsigned int line);
+static void do_check(struct xtc_handle *h, unsigned int line);
 #define CHECK(h) do { if (!getenv("IPTC_NO_CHECK")) do_check((h), __LINE__); } while(0)
 #else
 #define CHECK(h)
@@ -228,13 +228,13 @@ iptcb_get_entry_n(STRUCT_ENTRY *i,
 }
 
 static inline STRUCT_ENTRY *
-iptcb_get_entry(TC_HANDLE_T h, unsigned int offset)
+iptcb_get_entry(struct xtc_handle *h, unsigned int offset)
 {
 	return (STRUCT_ENTRY *)((char *)h->entries->entrytable + offset);
 }
 
 static unsigned int
-iptcb_entry2index(const TC_HANDLE_T h, const STRUCT_ENTRY *seek)
+iptcb_entry2index(struct xtc_handle *const h, const STRUCT_ENTRY *seek)
 {
 	unsigned int pos = 0;
 
@@ -248,27 +248,27 @@ iptcb_entry2index(const TC_HANDLE_T h, const STRUCT_ENTRY *seek)
 }
 
 static inline STRUCT_ENTRY *
-iptcb_offset2entry(TC_HANDLE_T h, unsigned int offset)
+iptcb_offset2entry(struct xtc_handle *h, unsigned int offset)
 {
 	return (STRUCT_ENTRY *) ((void *)h->entries->entrytable+offset);
 }
 
 
 static inline unsigned long
-iptcb_entry2offset(const TC_HANDLE_T h, const STRUCT_ENTRY *e)
+iptcb_entry2offset(struct xtc_handle *const h, const STRUCT_ENTRY *e)
 {
 	return (void *)e - (void *)h->entries->entrytable;
 }
 
 static inline unsigned int
-iptcb_offset2index(const TC_HANDLE_T h, unsigned int offset)
+iptcb_offset2index(struct xtc_handle *const h, unsigned int offset)
 {
 	return iptcb_entry2index(h, iptcb_offset2entry(h, offset));
 }
 
 /* Returns 0 if not hook entry, else hooknumber + 1 */
 static inline unsigned int
-iptcb_ent_is_hook_entry(STRUCT_ENTRY *e, TC_HANDLE_T h)
+iptcb_ent_is_hook_entry(STRUCT_ENTRY *e, struct xtc_handle *h)
 {
 	unsigned int i;
 
@@ -329,7 +329,7 @@ static inline unsigned int iptcc_is_builtin(struct chain_head *c);
  */
 static struct list_head *
 __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
-			    unsigned int *idx, TC_HANDLE_T handle,
+			    unsigned int *idx, struct xtc_handle *handle,
 			    enum bsearch_type type)
 {
 	unsigned int pos, end;
@@ -432,7 +432,7 @@ __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
 /* Wrapper for string chain name based bsearch */
 static struct list_head *
 iptcc_bsearch_chain_index(const char *name, unsigned int *idx,
-			  TC_HANDLE_T handle)
+			  struct xtc_handle *handle)
 {
 	return __iptcc_bsearch_chain_index(name, 0, idx, handle, BSEARCH_NAME);
 }
@@ -441,7 +441,7 @@ iptcc_bsearch_chain_index(const char *name, unsigned int *idx,
 /* Wrapper for offset chain based bsearch */
 static struct list_head *
 iptcc_bsearch_chain_offset(unsigned int offset, unsigned int *idx,
-			  TC_HANDLE_T handle)
+			  struct xtc_handle *handle)
 {
 	struct list_head *pos;
 
@@ -461,7 +461,7 @@ iptcc_bsearch_chain_offset(unsigned int offset, unsigned int *idx,
 /* Trivial linear search of chain index. Function used for verifying
    the output of bsearch function */
 static struct list_head *
-iptcc_linearly_search_chain_index(const char *name, TC_HANDLE_T handle)
+iptcc_linearly_search_chain_index(const char *name, struct xtc_handle *handle)
 {
 	unsigned int i=0;
 	int res=0;
@@ -489,7 +489,7 @@ iptcc_linearly_search_chain_index(const char *name, TC_HANDLE_T handle)
 }
 #endif
 
-static int iptcc_chain_index_alloc(TC_HANDLE_T h)
+static int iptcc_chain_index_alloc(struct xtc_handle *h)
 {
 	unsigned int list_length = CHAIN_INDEX_BUCKET_LEN;
 	unsigned int array_elems;
@@ -514,7 +514,7 @@ static int iptcc_chain_index_alloc(TC_HANDLE_T h)
 	return 1;
 }
 
-static void iptcc_chain_index_free(TC_HANDLE_T h)
+static void iptcc_chain_index_free(struct xtc_handle *h)
 {
 	h->chain_index_sz = 0;
 	free(h->chain_index);
@@ -522,7 +522,7 @@ static void iptcc_chain_index_free(TC_HANDLE_T h)
 
 
 #ifdef DEBUG
-static void iptcc_chain_index_dump(TC_HANDLE_T h)
+static void iptcc_chain_index_dump(struct xtc_handle *h)
 {
 	unsigned int i = 0;
 
@@ -537,7 +537,7 @@ static void iptcc_chain_index_dump(TC_HANDLE_T h)
 #endif
 
 /* Build the chain index */
-static int iptcc_chain_index_build(TC_HANDLE_T h)
+static int iptcc_chain_index_build(struct xtc_handle *h)
 {
 	unsigned int list_length = CHAIN_INDEX_BUCKET_LEN;
 	unsigned int chains = 0;
@@ -579,7 +579,7 @@ static int iptcc_chain_index_build(TC_HANDLE_T h)
 	return 1;
 }
 
-static int iptcc_chain_index_rebuild(TC_HANDLE_T h)
+static int iptcc_chain_index_rebuild(struct xtc_handle *h)
 {
 	debug("REBUILD chain index array\n");
 	iptcc_chain_index_free(h);
@@ -601,7 +601,7 @@ static int iptcc_chain_index_rebuild(TC_HANDLE_T h)
  * because list_for_each processing will always hit the first chain
  * index, thus causing a rebuild for every chain.
  */
-static int iptcc_chain_index_delete_chain(struct chain_head *c, TC_HANDLE_T h)
+static int iptcc_chain_index_delete_chain(struct chain_head *c, struct xtc_handle *h)
 {
 	struct list_head *index_ptr, *index_ptr2, *next;
 	struct chain_head *c2;
@@ -681,7 +681,7 @@ static struct rule_head *iptcc_get_rule_num_reverse(struct chain_head *c,
 
 /* Returns chain head if found, otherwise NULL. */
 static struct chain_head *
-iptcc_find_chain_by_offset(TC_HANDLE_T handle, unsigned int offset)
+iptcc_find_chain_by_offset(struct xtc_handle *handle, unsigned int offset)
 {
 	struct list_head *pos;
 	struct list_head *list_start_pos;
@@ -713,7 +713,7 @@ iptcc_find_chain_by_offset(TC_HANDLE_T handle, unsigned int offset)
 
 /* Returns chain head if found, otherwise NULL. */
 static struct chain_head *
-iptcc_find_label(const char *name, TC_HANDLE_T handle)
+iptcc_find_label(const char *name, struct xtc_handle *handle)
 {
 	struct list_head *pos;
 	struct list_head *list_start_pos;
@@ -810,7 +810,7 @@ static void iptcc_delete_rule(struct rule_head *r)
  * chain policy rules.
  * WARNING: This function has ugly design and relies on a lot of context, only
  * to be called from specific places within the parser */
-static int __iptcc_p_del_policy(TC_HANDLE_T h, unsigned int num)
+static int __iptcc_p_del_policy(struct xtc_handle *h, unsigned int num)
 {
 	if (h->chain_iterator_cur) {
 		/* policy rule is last rule */
@@ -842,7 +842,7 @@ static int __iptcc_p_del_policy(TC_HANDLE_T h, unsigned int num)
 }
 
 /* alphabetically insert a chain into the list */
-static inline void iptc_insert_chain(TC_HANDLE_T h, struct chain_head *c)
+static inline void iptc_insert_chain(struct xtc_handle *h, struct chain_head *c)
 {
 	struct chain_head *tmp;
 	struct list_head  *list_start_pos;
@@ -885,7 +885,7 @@ static inline void iptc_insert_chain(TC_HANDLE_T h, struct chain_head *c)
 
 /* Another ugly helper function split out of cache_add_entry to make it less
  * spaghetti code */
-static void __iptcc_p_add_chain(TC_HANDLE_T h, struct chain_head *c,
+static void __iptcc_p_add_chain(struct xtc_handle *h, struct chain_head *c,
 				unsigned int offset, unsigned int *num)
 {
 	struct list_head  *tail = h->chains.prev;
@@ -928,7 +928,7 @@ static void __iptcc_p_add_chain(TC_HANDLE_T h, struct chain_head *c,
 
 /* main parser function: add an entry from the blob to the cache */
 static int cache_add_entry(STRUCT_ENTRY *e, 
-			   TC_HANDLE_T h, 
+			   struct xtc_handle *h, 
 			   STRUCT_ENTRY **prev,
 			   unsigned int *num)
 {
@@ -1038,7 +1038,7 @@ out_inc:
 
 
 /* parse an iptables blob into it's pieces */
-static int parse_table(TC_HANDLE_T h)
+static int parse_table(struct xtc_handle *h)
 {
 	STRUCT_ENTRY *prev;
 	unsigned int num = 0;
@@ -1109,7 +1109,7 @@ struct iptcb_chain_error {
 
 
 /* compile rule from cache into blob */
-static inline int iptcc_compile_rule (TC_HANDLE_T h, STRUCT_REPLACE *repl, struct rule_head *r)
+static inline int iptcc_compile_rule (struct xtc_handle *h, STRUCT_REPLACE *repl, struct rule_head *r)
 {
 	/* handle jumps */
 	if (r->type == IPTCC_R_JUMP) {
@@ -1134,7 +1134,7 @@ static inline int iptcc_compile_rule (TC_HANDLE_T h, STRUCT_REPLACE *repl, struc
 }
 
 /* compile chain from cache into blob */
-static int iptcc_compile_chain(TC_HANDLE_T h, STRUCT_REPLACE *repl, struct chain_head *c)
+static int iptcc_compile_chain(struct xtc_handle *h, STRUCT_REPLACE *repl, struct chain_head *c)
 {
 	int ret;
 	struct rule_head *r;
@@ -1182,7 +1182,7 @@ static int iptcc_compile_chain(TC_HANDLE_T h, STRUCT_REPLACE *repl, struct chain
 }
 
 /* calculate offset and number for every rule in the cache */
-static int iptcc_compile_chain_offsets(TC_HANDLE_T h, struct chain_head *c,
+static int iptcc_compile_chain_offsets(struct xtc_handle *h, struct chain_head *c,
 				       unsigned int *offset, unsigned int *num)
 {
 	struct rule_head *r;
@@ -1217,7 +1217,7 @@ static int iptcc_compile_chain_offsets(TC_HANDLE_T h, struct chain_head *c,
 }
 
 /* put the pieces back together again */
-static int iptcc_compile_table_prep(TC_HANDLE_T h, unsigned int *size)
+static int iptcc_compile_table_prep(struct xtc_handle *h, unsigned int *size)
 {
 	struct chain_head *c;
 	unsigned int offset = 0, num = 0;
@@ -1240,7 +1240,7 @@ static int iptcc_compile_table_prep(TC_HANDLE_T h, unsigned int *size)
 	return num;
 }
 
-static int iptcc_compile_table(TC_HANDLE_T h, STRUCT_REPLACE *repl)
+static int iptcc_compile_table(struct xtc_handle *h, STRUCT_REPLACE *repl)
 {
 	struct chain_head *c;
 	struct iptcb_chain_error *error;
@@ -1269,11 +1269,11 @@ static int iptcc_compile_table(TC_HANDLE_T h, STRUCT_REPLACE *repl)
  **********************************************************************/
 
 /* Allocate handle of given size */
-static TC_HANDLE_T
+static struct xtc_handle *
 alloc_handle(const char *tablename, unsigned int size, unsigned int num_rules)
 {
 	size_t len;
-	TC_HANDLE_T h;
+	struct xtc_handle *h;
 
 	len = sizeof(STRUCT_TC_HANDLE) + size;
 
@@ -1302,10 +1302,10 @@ out_free_handle:
 }
 
 
-TC_HANDLE_T
+struct xtc_handle *
 TC_INIT(const char *tablename)
 {
-	TC_HANDLE_T h;
+	struct xtc_handle *h;
 	STRUCT_GETINFO info;
 	unsigned int tmp;
 	socklen_t s;
@@ -1383,7 +1383,7 @@ error:
 }
 
 void
-TC_FREE(TC_HANDLE_T *h)
+TC_FREE(struct xtc_handle **h)
 {
 	struct chain_head *c, *tmp;
 
@@ -1418,10 +1418,10 @@ print_match(const STRUCT_ENTRY_MATCH *m)
 	return 0;
 }
 
-static int dump_entry(STRUCT_ENTRY *e, const TC_HANDLE_T handle);
+static int dump_entry(STRUCT_ENTRY *e, struct xtc_handle *const handle);
  
 void
-TC_DUMP_ENTRIES(const TC_HANDLE_T handle)
+TC_DUMP_ENTRIES(struct xtc_handle *const handle)
 {
 	iptc_fn = TC_DUMP_ENTRIES;
 	CHECK(handle);
@@ -1447,13 +1447,13 @@ TC_DUMP_ENTRIES(const TC_HANDLE_T handle)
 }
 
 /* Does this chain exist? */
-int TC_IS_CHAIN(const char *chain, const TC_HANDLE_T handle)
+int TC_IS_CHAIN(const char *chain, struct xtc_handle *const handle)
 {
 	iptc_fn = TC_IS_CHAIN;
 	return iptcc_find_label(chain, handle) != NULL;
 }
 
-static void iptcc_chain_iterator_advance(TC_HANDLE_T handle)
+static void iptcc_chain_iterator_advance(struct xtc_handle *handle)
 {
 	struct chain_head *c = handle->chain_iterator_cur;
 
@@ -1466,7 +1466,7 @@ static void iptcc_chain_iterator_advance(TC_HANDLE_T handle)
 
 /* Iterator functions to run through the chains. */
 const char *
-TC_FIRST_CHAIN(TC_HANDLE_T *handle)
+TC_FIRST_CHAIN(struct xtc_handle **handle)
 {
 	struct chain_head *c = list_entry((*handle)->chains.next,
 					  struct chain_head, list);
@@ -1488,7 +1488,7 @@ TC_FIRST_CHAIN(TC_HANDLE_T *handle)
 
 /* Iterator functions to run through the chains.  Returns NULL at end. */
 const char *
-TC_NEXT_CHAIN(TC_HANDLE_T *handle)
+TC_NEXT_CHAIN(struct xtc_handle **handle)
 {
 	struct chain_head *c = (*handle)->chain_iterator_cur;
 
@@ -1507,7 +1507,7 @@ TC_NEXT_CHAIN(TC_HANDLE_T *handle)
 
 /* Get first rule in the given chain: NULL for empty chain. */
 const STRUCT_ENTRY *
-TC_FIRST_RULE(const char *chain, TC_HANDLE_T *handle)
+TC_FIRST_RULE(const char *chain, struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -1537,7 +1537,7 @@ TC_FIRST_RULE(const char *chain, TC_HANDLE_T *handle)
 
 /* Returns NULL when rules run out. */
 const STRUCT_ENTRY *
-TC_NEXT_RULE(const STRUCT_ENTRY *prev, TC_HANDLE_T *handle)
+TC_NEXT_RULE(const STRUCT_ENTRY *prev, struct xtc_handle **handle)
 {
 	struct rule_head *r;
 
@@ -1572,7 +1572,7 @@ TC_NEXT_RULE(const STRUCT_ENTRY *prev, TC_HANDLE_T *handle)
 
 /* How many rules in this chain? */
 static unsigned int
-TC_NUM_RULES(const char *chain, TC_HANDLE_T *handle)
+TC_NUM_RULES(const char *chain, struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	iptc_fn = TC_NUM_RULES;
@@ -1588,7 +1588,7 @@ TC_NUM_RULES(const char *chain, TC_HANDLE_T *handle)
 }
 
 static const STRUCT_ENTRY *
-TC_GET_RULE(const char *chain, unsigned int n, TC_HANDLE_T *handle)
+TC_GET_RULE(const char *chain, unsigned int n, struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -1637,7 +1637,7 @@ static const char *standard_target_map(int verdict)
 
 /* Returns a pointer to the target name of this position. */
 const char *TC_GET_TARGET(const STRUCT_ENTRY *ce,
-			  TC_HANDLE_T *handle)
+			  struct xtc_handle **handle)
 {
 	STRUCT_ENTRY *e = (STRUCT_ENTRY *)ce;
 	struct rule_head *r = container_of(e, struct rule_head, entry[0]);
@@ -1666,7 +1666,7 @@ const char *TC_GET_TARGET(const STRUCT_ENTRY *ce,
 }
 /* Is this a built-in chain?  Actually returns hook + 1. */
 int
-TC_BUILTIN(const char *chain, const TC_HANDLE_T handle)
+TC_BUILTIN(const char *chain, struct xtc_handle *const handle)
 {
 	struct chain_head *c;
 	
@@ -1685,7 +1685,7 @@ TC_BUILTIN(const char *chain, const TC_HANDLE_T handle)
 const char *
 TC_GET_POLICY(const char *chain,
 	      STRUCT_COUNTERS *counters,
-	      TC_HANDLE_T *handle)
+	      struct xtc_handle **handle)
 {
 	struct chain_head *c;
 
@@ -1731,7 +1731,7 @@ iptcc_standard_map(struct rule_head *r, int verdict)
 }
 
 static int
-iptcc_map_target(const TC_HANDLE_T handle,
+iptcc_map_target(struct xtc_handle *const handle,
 	   struct rule_head *r)
 {
 	STRUCT_ENTRY *e = r->entry;
@@ -1786,7 +1786,7 @@ int
 TC_INSERT_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *e,
 		unsigned int rulenum,
-		TC_HANDLE_T *handle)
+		struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -1845,7 +1845,7 @@ int
 TC_REPLACE_ENTRY(const IPT_CHAINLABEL chain,
 		 const STRUCT_ENTRY *e,
 		 unsigned int rulenum,
-		 TC_HANDLE_T *handle)
+		 struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r, *old;
@@ -1895,7 +1895,7 @@ TC_REPLACE_ENTRY(const IPT_CHAINLABEL chain,
 int
 TC_APPEND_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *e,
-		TC_HANDLE_T *handle)
+		struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -2003,7 +2003,7 @@ int
 TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *origfw,
 		unsigned char *matchmask,
-		TC_HANDLE_T *handle)
+		struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r, *i;
@@ -2074,7 +2074,7 @@ TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 int
 TC_DELETE_NUM_ENTRY(const IPT_CHAINLABEL chain,
 		    unsigned int rulenum,
-		    TC_HANDLE_T *handle)
+		    struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -2120,7 +2120,7 @@ TC_DELETE_NUM_ENTRY(const IPT_CHAINLABEL chain,
 const char *
 TC_CHECK_PACKET(const IPT_CHAINLABEL chain,
 		STRUCT_ENTRY *entry,
-		TC_HANDLE_T *handle)
+		struct xtc_handle **handle)
 {
 	iptc_fn = TC_CHECK_PACKET;
 	errno = ENOSYS;
@@ -2129,7 +2129,7 @@ TC_CHECK_PACKET(const IPT_CHAINLABEL chain,
 
 /* Flushes the entries in the given chain (ie. empties chain). */
 int
-TC_FLUSH_ENTRIES(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
+TC_FLUSH_ENTRIES(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r, *tmp;
@@ -2153,7 +2153,7 @@ TC_FLUSH_ENTRIES(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 
 /* Zeroes the counters in a chain. */
 int
-TC_ZERO_ENTRIES(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
+TC_ZERO_ENTRIES(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -2180,7 +2180,7 @@ TC_ZERO_ENTRIES(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 STRUCT_COUNTERS *
 TC_READ_COUNTER(const IPT_CHAINLABEL chain,
 		unsigned int rulenum,
-		TC_HANDLE_T *handle)
+		struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -2204,7 +2204,7 @@ TC_READ_COUNTER(const IPT_CHAINLABEL chain,
 int
 TC_ZERO_COUNTER(const IPT_CHAINLABEL chain,
 		unsigned int rulenum,
-		TC_HANDLE_T *handle)
+		struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -2234,7 +2234,7 @@ int
 TC_SET_COUNTER(const IPT_CHAINLABEL chain,
 	       unsigned int rulenum,
 	       STRUCT_COUNTERS *counters,
-	       TC_HANDLE_T *handle)
+	       struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -2267,7 +2267,7 @@ TC_SET_COUNTER(const IPT_CHAINLABEL chain,
 /* To create a chain, create two rules: error node and unconditional
  * return. */
 int
-TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
+TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 {
 	static struct chain_head *c;
 	int capacity;
@@ -2327,7 +2327,7 @@ TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 /* Get the number of references to this chain. */
 int
 TC_GET_REFERENCES(unsigned int *ref, const IPT_CHAINLABEL chain,
-		  TC_HANDLE_T *handle)
+		  struct xtc_handle **handle)
 {
 	struct chain_head *c;
 
@@ -2344,7 +2344,7 @@ TC_GET_REFERENCES(unsigned int *ref, const IPT_CHAINLABEL chain,
 
 /* Deletes a chain. */
 int
-TC_DELETE_CHAIN(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
+TC_DELETE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 {
 	unsigned int references;
 	struct chain_head *c;
@@ -2401,7 +2401,7 @@ TC_DELETE_CHAIN(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 /* Renames a chain. */
 int TC_RENAME_CHAIN(const IPT_CHAINLABEL oldname,
 		    const IPT_CHAINLABEL newname,
-		    TC_HANDLE_T *handle)
+		    struct xtc_handle **handle)
 {
 	struct chain_head *c;
 	iptc_fn = TC_RENAME_CHAIN;
@@ -2440,7 +2440,7 @@ int
 TC_SET_POLICY(const IPT_CHAINLABEL chain,
 	      const IPT_CHAINLABEL policy,
 	      STRUCT_COUNTERS *counters,
-	      TC_HANDLE_T *handle)
+	      struct xtc_handle **handle)
 {
 	struct chain_head *c;
 
@@ -2547,7 +2547,7 @@ static void counters_map_set(STRUCT_COUNTERS_INFO *newcounters,
 
 
 int
-TC_COMMIT(TC_HANDLE_T *handle)
+TC_COMMIT(struct xtc_handle **handle)
 {
 	/* Replace, then map back the counters. */
 	STRUCT_REPLACE *repl;

