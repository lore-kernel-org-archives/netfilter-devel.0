From: Jan Engelhardt <jengelh@medozas.de>
Subject: libiptc: remove indirections
Date: Thu, 6 Nov 2008 09:35:00 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811060934380.26551@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0811060933060.26551@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52638 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYKFIfC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:35:02 -0500
In-Reply-To: <alpine.LNX.1.10.0811060933060.26551@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f37c89aec3ca88c5984b36888b634c88f67918e8
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Nov 6 05:35:35 2008 +0100

libiptc: remove indirections

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/ip6tables.h        |    8 +-
 include/iptables.h         |   10 +-
 include/libiptc/libip6tc.h |   48 ++++----
 include/libiptc/libiptc.h  |   48 ++++----
 ip6tables-restore.c        |   16 ++-
 ip6tables-save.c           |   18 ++--
 ip6tables-standalone.c     |    6 +-
 ip6tables.c                |   70 ++++++------
 iptables-restore.c         |   16 ++-
 iptables-save.c            |   18 ++--
 iptables-standalone.c      |    6 +-
 iptables.c                 |   70 ++++++------
 libiptc/libiptc.c          |  229 ++++++++++++++++++------------------
 13 files changed, 284 insertions(+), 279 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 9e26455..1956cf0 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -19,9 +19,9 @@ extern int line;
 extern int do_command6(int argc, char *argv[], char **table,
 		       struct ip6tc_handle **handle);
 
-extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle **), int verbose, int builtinstoo, struct ip6tc_handle **handle);
-extern int flush_entries(const ip6t_chainlabel chain, int verbose, struct ip6tc_handle **handle);
-extern int delete_chain(const ip6t_chainlabel chain, int verbose, struct ip6tc_handle **handle);
-void print_rule(const struct ip6t_entry *e, struct ip6tc_handle **h, const char *chain, int counters);
+extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle *), int verbose, int builtinstoo, struct ip6tc_handle *handle);
+extern int flush_entries(const ip6t_chainlabel chain, int verbose, struct ip6tc_handle *handle);
+extern int delete_chain(const ip6t_chainlabel chain, int verbose, struct ip6tc_handle *handle);
+void print_rule(const struct ip6t_entry *e, struct ip6tc_handle *h, const char *chain, int counters);
 
 #endif /*_IP6TABLES_USER_H*/
diff --git a/include/iptables.h b/include/iptables.h
index 424db59..f7ae0cc 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -19,13 +19,13 @@ extern int line;
 extern int do_command(int argc, char *argv[], char **table,
 		      struct iptc_handle **handle);
 extern int delete_chain(const ipt_chainlabel chain, int verbose,
-			struct iptc_handle **handle);
+			struct iptc_handle *handle);
 extern int flush_entries(const ipt_chainlabel chain, int verbose, 
-			struct iptc_handle **handle);
-extern int for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle **),
-		int verbose, int builtinstoo, struct iptc_handle **handle);
+			struct iptc_handle *handle);
+extern int for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle *),
+		int verbose, int builtinstoo, struct iptc_handle *handle);
 extern void print_rule(const struct ipt_entry *e,
-		struct iptc_handle **handle, const char *chain, int counters);
+		struct iptc_handle *handle, const char *chain, int counters);
 
 /* kernel revision handling */
 extern int kernel_version;
diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 9f8c08f..3f1eadb 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -27,23 +27,23 @@ int ip6tc_is_chain(const char *chain, struct ip6tc_handle *const handle);
 struct ip6tc_handle *ip6tc_init(const char *tablename);
 
 /* Cleanup after ip6tc_init(). */
-void ip6tc_free(struct ip6tc_handle **h);
+void ip6tc_free(struct ip6tc_handle *h);
 
 /* Iterator functions to run through the chains.  Returns NULL at end. */
-const char *ip6tc_first_chain(struct ip6tc_handle **handle);
-const char *ip6tc_next_chain(struct ip6tc_handle **handle);
+const char *ip6tc_first_chain(struct ip6tc_handle *handle);
+const char *ip6tc_next_chain(struct ip6tc_handle *handle);
 
 /* Get first rule in the given chain: NULL for empty chain. */
 const struct ip6t_entry *ip6tc_first_rule(const char *chain,
-					  struct ip6tc_handle **handle);
+					  struct ip6tc_handle *handle);
 
 /* Returns NULL when rules run out. */
 const struct ip6t_entry *ip6tc_next_rule(const struct ip6t_entry *prev,
-					 struct ip6tc_handle **handle);
+					 struct ip6tc_handle *handle);
 
 /* Returns a pointer to the target name of this position. */
 const char *ip6tc_get_target(const struct ip6t_entry *e,
-			     struct ip6tc_handle **handle);
+			     struct ip6tc_handle *handle);
 
 /* Is this a built-in chain? */
 int ip6tc_builtin(const char *chain, struct ip6tc_handle *const handle);
@@ -51,7 +51,7 @@ int ip6tc_builtin(const char *chain, struct ip6tc_handle *const handle);
 /* Get the policy of a given built-in chain */
 const char *ip6tc_get_policy(const char *chain,
 			     struct ip6t_counters *counters,
-			     struct ip6tc_handle **handle);
+			     struct ip6tc_handle *handle);
 
 /* These functions return TRUE for OK or 0 and set errno. If errno ==
    0, it means there was a version error (ie. upgrade libiptc). */
@@ -61,86 +61,86 @@ const char *ip6tc_get_policy(const char *chain,
 int ip6tc_insert_entry(const ip6t_chainlabel chain,
 		       const struct ip6t_entry *e,
 		       unsigned int rulenum,
-		       struct ip6tc_handle **handle);
+		       struct ip6tc_handle *handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `fw'. */
 int ip6tc_replace_entry(const ip6t_chainlabel chain,
 			const struct ip6t_entry *e,
 			unsigned int rulenum,
-			struct ip6tc_handle **handle);
+			struct ip6tc_handle *handle);
 
 /* Append entry `fw' to chain `chain'. Equivalent to insert with
    rulenum = length of chain. */
 int ip6tc_append_entry(const ip6t_chainlabel chain,
 		       const struct ip6t_entry *e,
-		       struct ip6tc_handle **handle);
+		       struct ip6tc_handle *handle);
 
 /* Delete the first rule in `chain' which matches `fw'. */
 int ip6tc_delete_entry(const ip6t_chainlabel chain,
 		       const struct ip6t_entry *origfw,
 		       unsigned char *matchmask,
-		       struct ip6tc_handle **handle);
+		       struct ip6tc_handle *handle);
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int ip6tc_delete_num_entry(const ip6t_chainlabel chain,
 			   unsigned int rulenum,
-			   struct ip6tc_handle **handle);
+			   struct ip6tc_handle *handle);
 
 /* Check the packet `fw' on chain `chain'. Returns the verdict, or
    NULL and sets errno. */
 const char *ip6tc_check_packet(const ip6t_chainlabel chain,
 			       struct ip6t_entry *,
-			       struct ip6tc_handle **handle);
+			       struct ip6tc_handle *handle);
 
 /* Flushes the entries in the given chain (ie. empties chain). */
 int ip6tc_flush_entries(const ip6t_chainlabel chain,
-			struct ip6tc_handle **handle);
+			struct ip6tc_handle *handle);
 
 /* Zeroes the counters in a chain. */
 int ip6tc_zero_entries(const ip6t_chainlabel chain,
-		       struct ip6tc_handle **handle);
+		       struct ip6tc_handle *handle);
 
 /* Creates a new chain. */
 int ip6tc_create_chain(const ip6t_chainlabel chain,
-		       struct ip6tc_handle **handle);
+		       struct ip6tc_handle *handle);
 
 /* Deletes a chain. */
 int ip6tc_delete_chain(const ip6t_chainlabel chain,
-		       struct ip6tc_handle **handle);
+		       struct ip6tc_handle *handle);
 
 /* Renames a chain. */
 int ip6tc_rename_chain(const ip6t_chainlabel oldname,
 		       const ip6t_chainlabel newname,
-		       struct ip6tc_handle **handle);
+		       struct ip6tc_handle *handle);
 
 /* Sets the policy on a built-in chain. */
 int ip6tc_set_policy(const ip6t_chainlabel chain,
 		     const ip6t_chainlabel policy,
 		     struct ip6t_counters *counters,
-		     struct ip6tc_handle **handle);
+		     struct ip6tc_handle *handle);
 
 /* Get the number of references to this chain */
 int ip6tc_get_references(unsigned int *ref, const ip6t_chainlabel chain,
-			 struct ip6tc_handle **handle);
+			 struct ip6tc_handle *handle);
 
 /* read packet and byte counters for a specific rule */
 struct ip6t_counters *ip6tc_read_counter(const ip6t_chainlabel chain,
 					unsigned int rulenum,
-					struct ip6tc_handle **handle);
+					struct ip6tc_handle *handle);
 
 /* zero packet and byte counters for a specific rule */
 int ip6tc_zero_counter(const ip6t_chainlabel chain,
 		       unsigned int rulenum,
-		       struct ip6tc_handle **handle);
+		       struct ip6tc_handle *handle);
 
 /* set packet and byte counters for a specific rule */
 int ip6tc_set_counter(const ip6t_chainlabel chain,
 		      unsigned int rulenum,
 		      struct ip6t_counters *counters,
-		      struct ip6tc_handle **handle);
+		      struct ip6tc_handle *handle);
 
 /* Makes the actual changes. */
-int ip6tc_commit(struct ip6tc_handle **handle);
+int ip6tc_commit(struct ip6tc_handle *handle);
 
 /* Get raw socket. */
 int ip6tc_get_raw_socket(void);
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index dd1ec6b..482b11d 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -35,23 +35,23 @@ int iptc_is_chain(const char *chain, struct iptc_handle *const handle);
 struct iptc_handle *iptc_init(const char *tablename);
 
 /* Cleanup after iptc_init(). */
-void iptc_free(struct iptc_handle **h);
+void iptc_free(struct iptc_handle *h);
 
 /* Iterator functions to run through the chains.  Returns NULL at end. */
-const char *iptc_first_chain(struct iptc_handle **handle);
-const char *iptc_next_chain(struct iptc_handle **handle);
+const char *iptc_first_chain(struct iptc_handle *handle);
+const char *iptc_next_chain(struct iptc_handle *handle);
 
 /* Get first rule in the given chain: NULL for empty chain. */
 const struct ipt_entry *iptc_first_rule(const char *chain,
-					struct iptc_handle **handle);
+					struct iptc_handle *handle);
 
 /* Returns NULL when rules run out. */
 const struct ipt_entry *iptc_next_rule(const struct ipt_entry *prev,
-				       struct iptc_handle **handle);
+				       struct iptc_handle *handle);
 
 /* Returns a pointer to the target name of this entry. */
 const char *iptc_get_target(const struct ipt_entry *e,
-			    struct iptc_handle **handle);
+			    struct iptc_handle *handle);
 
 /* Is this a built-in chain? */
 int iptc_builtin(const char *chain, struct iptc_handle *const handle);
@@ -59,7 +59,7 @@ int iptc_builtin(const char *chain, struct iptc_handle *const handle);
 /* Get the policy of a given built-in chain */
 const char *iptc_get_policy(const char *chain,
 			    struct ipt_counters *counter,
-			    struct iptc_handle **handle);
+			    struct iptc_handle *handle);
 
 /* These functions return TRUE for OK or 0 and set errno.  If errno ==
    0, it means there was a version error (ie. upgrade libiptc). */
@@ -69,88 +69,88 @@ const char *iptc_get_policy(const char *chain,
 int iptc_insert_entry(const ipt_chainlabel chain,
 		      const struct ipt_entry *e,
 		      unsigned int rulenum,
-		      struct iptc_handle **handle);
+		      struct iptc_handle *handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `e'. */
 int iptc_replace_entry(const ipt_chainlabel chain,
 		       const struct ipt_entry *e,
 		       unsigned int rulenum,
-		       struct iptc_handle **handle);
+		       struct iptc_handle *handle);
 
 /* Append entry `e' to chain `chain'.  Equivalent to insert with
    rulenum = length of chain. */
 int iptc_append_entry(const ipt_chainlabel chain,
 		      const struct ipt_entry *e,
-		      struct iptc_handle **handle);
+		      struct iptc_handle *handle);
 
 /* Delete the first rule in `chain' which matches `e', subject to
    matchmask (array of length == origfw) */
 int iptc_delete_entry(const ipt_chainlabel chain,
 		      const struct ipt_entry *origfw,
 		      unsigned char *matchmask,
-		      struct iptc_handle **handle);
+		      struct iptc_handle *handle);
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int iptc_delete_num_entry(const ipt_chainlabel chain,
 			  unsigned int rulenum,
-			  struct iptc_handle **handle);
+			  struct iptc_handle *handle);
 
 /* Check the packet `e' on chain `chain'.  Returns the verdict, or
    NULL and sets errno. */
 const char *iptc_check_packet(const ipt_chainlabel chain,
 			      struct ipt_entry *entry,
-			      struct iptc_handle **handle);
+			      struct iptc_handle *handle);
 
 /* Flushes the entries in the given chain (ie. empties chain). */
 int iptc_flush_entries(const ipt_chainlabel chain,
-		       struct iptc_handle **handle);
+		       struct iptc_handle *handle);
 
 /* Zeroes the counters in a chain. */
 int iptc_zero_entries(const ipt_chainlabel chain,
-		      struct iptc_handle **handle);
+		      struct iptc_handle *handle);
 
 /* Creates a new chain. */
 int iptc_create_chain(const ipt_chainlabel chain,
-		      struct iptc_handle **handle);
+		      struct iptc_handle *handle);
 
 /* Deletes a chain. */
 int iptc_delete_chain(const ipt_chainlabel chain,
-		      struct iptc_handle **handle);
+		      struct iptc_handle *handle);
 
 /* Renames a chain. */
 int iptc_rename_chain(const ipt_chainlabel oldname,
 		      const ipt_chainlabel newname,
-		      struct iptc_handle **handle);
+		      struct iptc_handle *handle);
 
 /* Sets the policy on a built-in chain. */
 int iptc_set_policy(const ipt_chainlabel chain,
 		    const ipt_chainlabel policy,
 		    struct ipt_counters *counters,
-		    struct iptc_handle **handle);
+		    struct iptc_handle *handle);
 
 /* Get the number of references to this chain */
 int iptc_get_references(unsigned int *ref,
 			const ipt_chainlabel chain,
-			struct iptc_handle **handle);
+			struct iptc_handle *handle);
 
 /* read packet and byte counters for a specific rule */
 struct ipt_counters *iptc_read_counter(const ipt_chainlabel chain,
 				       unsigned int rulenum,
-				       struct iptc_handle **handle);
+				       struct iptc_handle *handle);
 
 /* zero packet and byte counters for a specific rule */
 int iptc_zero_counter(const ipt_chainlabel chain,
 		      unsigned int rulenum,
-		      struct iptc_handle **handle);
+		      struct iptc_handle *handle);
 
 /* set packet and byte counters for a specific rule */
 int iptc_set_counter(const ipt_chainlabel chain,
 		     unsigned int rulenum,
 		     struct ipt_counters *counters,
-		     struct iptc_handle **handle);
+		     struct iptc_handle *handle);
 
 /* Makes the actual changes. */
-int iptc_commit(struct iptc_handle **handle);
+int iptc_commit(struct iptc_handle *handle);
 
 /* Get raw socket. */
 int iptc_get_raw_socket(void);
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index d2a9df3..0daae5f 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -199,7 +199,9 @@ int main(int argc, char *argv[])
 		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
 			if (!testing) {
 				DEBUGP("Calling commit\n");
-				ret = ip6tc_commit(&handle);
+				ret = ip6tc_commit(handle);
+				ip6tc_free(handle);
+				handle = NULL;
 			} else {
 				DEBUGP("Not calling commit, testing\n");
 				ret = 1;
@@ -221,19 +223,19 @@ int main(int argc, char *argv[])
 			curtable[IP6T_TABLE_MAXNAMELEN] = '\0';
 
 			if (handle)
-				ip6tc_free(&handle);
+				ip6tc_free(handle);
 
 			handle = create_handle(table, modprobe);
 			if (noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
 				for_each_chain(flush_entries, verbose, 1,
-						&handle);
+						handle);
 
 				DEBUGP("Deleting all user-defined chains "
 				       "of table '%s'\n", table);
 				for_each_chain(delete_chain, verbose, 0,
-						&handle) ;
+						handle);
 			}
 
 			ret = 1;
@@ -255,14 +257,14 @@ int main(int argc, char *argv[])
 			if (ip6tc_builtin(chain, handle) <= 0) {
 				if (noflush && ip6tc_is_chain(chain, handle)) {
 					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
-					if (!ip6tc_flush_entries(chain, &handle))
+					if (!ip6tc_flush_entries(chain, handle))
 						exit_error(PARAMETER_PROBLEM,
 							   "error flushing chain "
 							   "'%s':%s\n", chain,
 							   strerror(errno));
 				} else {
 					DEBUGP("Creating new chain '%s'\n", chain);
-					if (!ip6tc_create_chain(chain, &handle))
+					if (!ip6tc_create_chain(chain, handle))
 						exit_error(PARAMETER_PROBLEM,
 							   "error creating chain "
 							   "'%s':%s\n", chain,
@@ -300,7 +302,7 @@ int main(int argc, char *argv[])
 					chain, policy);
 
 				if (!ip6tc_set_policy(chain, policy, &count,
-						     &handle))
+						     handle))
 					exit_error(OTHER_PROBLEM,
 						"Can't set policy `%s'"
 						" on `%s' line %u: %s\n",
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 360f0e4..d5f8e54 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -81,15 +81,15 @@ static int do_output(const char *tablename)
 
 		/* Dump out chain names first,
 		 * thereby preventing dependency conflicts */
-		for (chain = ip6tc_first_chain(&h);
+		for (chain = ip6tc_first_chain(h);
 		     chain;
-		     chain = ip6tc_next_chain(&h)) {
+		     chain = ip6tc_next_chain(h)) {
 
 			printf(":%s ", chain);
 			if (ip6tc_builtin(chain, h)) {
 				struct ip6t_counters count;
 				printf("%s ",
-				       ip6tc_get_policy(chain, &count, &h));
+				       ip6tc_get_policy(chain, &count, h));
 				printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
 			} else {
 				printf("- [0:0]\n");
@@ -97,16 +97,16 @@ static int do_output(const char *tablename)
 		}
 
 
-		for (chain = ip6tc_first_chain(&h);
+		for (chain = ip6tc_first_chain(h);
 		     chain;
-		     chain = ip6tc_next_chain(&h)) {
+		     chain = ip6tc_next_chain(h)) {
 			const struct ip6t_entry *e;
 
 			/* Dump out rules */
-			e = ip6tc_first_rule(chain, &h);
+			e = ip6tc_first_rule(chain, h);
 			while(e) {
-				print_rule(e, &h, chain, show_counters);
-				e = ip6tc_next_rule(e, &h);
+				print_rule(e, h, chain, show_counters);
+				e = ip6tc_next_rule(e, h);
 			}
 		}
 
@@ -118,7 +118,7 @@ static int do_output(const char *tablename)
 		exit_error(OTHER_PROBLEM, "Binary NYI\n");
 	}
 
-	ip6tc_free(&h);
+	ip6tc_free(h);
 
 	return 1;
 }
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 9a0b2b3..ba30f0e 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -66,8 +66,10 @@ main(int argc, char *argv[])
 #endif
 
 	ret = do_command6(argc, argv, &table, &handle);
-	if (ret)
-		ret = ip6tc_commit(&handle);
+	if (ret) {
+		ret = ip6tc_commit(handle);
+		ip6tc_free(handle);
+	}
 
 	if (!ret)
 		fprintf(stderr, "ip6tables: %s\n",
diff --git a/ip6tables.c b/ip6tables.c
index da1da63..989f3bc 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -651,7 +651,7 @@ print_num(u_int64_t number, unsigned int format)
 
 
 static void
-print_header(unsigned int format, const char *chain, struct ip6tc_handle **handle)
+print_header(unsigned int format, const char *chain, struct ip6tc_handle *handle)
 {
 	struct ip6t_counters counters;
 	const char *pol = ip6tc_get_policy(chain, &counters, handle);
@@ -865,7 +865,7 @@ append_entry(const ip6t_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in6_addr daddrs[],
 	     int verbose,
-	     struct ip6tc_handle **handle)
+	     struct ip6tc_handle *handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -875,7 +875,7 @@ append_entry(const ip6t_chainlabel chain,
 		for (j = 0; j < ndaddrs; j++) {
 			fw->ipv6.dst = daddrs[j];
 			if (verbose)
-				print_firewall_line(fw, *handle);
+				print_firewall_line(fw, handle);
 			ret &= ip6tc_append_entry(chain, fw, handle);
 		}
 	}
@@ -890,13 +890,13 @@ replace_entry(const ip6t_chainlabel chain,
 	      const struct in6_addr *saddr,
 	      const struct in6_addr *daddr,
 	      int verbose,
-	      struct ip6tc_handle **handle)
+	      struct ip6tc_handle *handle)
 {
 	fw->ipv6.src = *saddr;
 	fw->ipv6.dst = *daddr;
 
 	if (verbose)
-		print_firewall_line(fw, *handle);
+		print_firewall_line(fw, handle);
 	return ip6tc_replace_entry(chain, fw, rulenum, handle);
 }
 
@@ -909,7 +909,7 @@ insert_entry(const ip6t_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in6_addr daddrs[],
 	     int verbose,
-	     struct ip6tc_handle **handle)
+	     struct ip6tc_handle *handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -919,7 +919,7 @@ insert_entry(const ip6t_chainlabel chain,
 		for (j = 0; j < ndaddrs; j++) {
 			fw->ipv6.dst = daddrs[j];
 			if (verbose)
-				print_firewall_line(fw, *handle);
+				print_firewall_line(fw, handle);
 			ret &= ip6tc_insert_entry(chain, fw, rulenum, handle);
 		}
 	}
@@ -968,7 +968,7 @@ delete_entry(const ip6t_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in6_addr daddrs[],
 	     int verbose,
-	     struct ip6tc_handle **handle,
+	     struct ip6tc_handle *handle,
 	     struct ip6tables_rule_match *matches)
 {
 	unsigned int i, j;
@@ -981,7 +981,7 @@ delete_entry(const ip6t_chainlabel chain,
 		for (j = 0; j < ndaddrs; j++) {
 			fw->ipv6.dst = daddrs[j];
 			if (verbose)
-				print_firewall_line(fw, *handle);
+				print_firewall_line(fw, handle);
 			ret &= ip6tc_delete_entry(chain, fw, mask, handle);
 		}
 	}
@@ -991,8 +991,8 @@ delete_entry(const ip6t_chainlabel chain,
 }
 
 int
-for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle **),
-	       int verbose, int builtinstoo, struct ip6tc_handle **handle)
+for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle *),
+	       int verbose, int builtinstoo, struct ip6tc_handle *handle)
 {
 	int ret = 1;
 	const char *chain;
@@ -1017,7 +1017,7 @@ for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle **),
 	for (i = 0; i < chaincount; i++) {
 		if (!builtinstoo
 		    && ip6tc_builtin(chains + i*sizeof(ip6t_chainlabel),
-				    *handle) == 1)
+				    handle) == 1)
 			continue;
 		ret &= fn(chains + i*sizeof(ip6t_chainlabel), verbose, handle);
 	}
@@ -1028,7 +1028,7 @@ for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle **),
 
 int
 flush_entries(const ip6t_chainlabel chain, int verbose,
-	      struct ip6tc_handle **handle)
+	      struct ip6tc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain(flush_entries, verbose, 1, handle);
@@ -1040,7 +1040,7 @@ flush_entries(const ip6t_chainlabel chain, int verbose,
 
 static int
 zero_entries(const ip6t_chainlabel chain, int verbose,
-	     struct ip6tc_handle **handle)
+	     struct ip6tc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain(zero_entries, verbose, 1, handle);
@@ -1052,7 +1052,7 @@ zero_entries(const ip6t_chainlabel chain, int verbose,
 
 int
 delete_chain(const ip6t_chainlabel chain, int verbose,
-	     struct ip6tc_handle **handle)
+	     struct ip6tc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain(delete_chain, verbose, 0, handle);
@@ -1064,7 +1064,7 @@ delete_chain(const ip6t_chainlabel chain, int verbose,
 
 static int
 list_entries(const ip6t_chainlabel chain, int rulenum, int verbose, int numeric,
-	     int expanded, int linenumbers, struct ip6tc_handle **handle)
+	     int expanded, int linenumbers, struct ip6tc_handle *handle)
 {
 	int found = 0;
 	unsigned int format;
@@ -1108,7 +1108,7 @@ list_entries(const ip6t_chainlabel chain, int rulenum, int verbose, int numeric,
 					       ip6tc_get_target(i, handle),
 					       num,
 					       format,
-					       *handle);
+					       handle);
 			i = ip6tc_next_rule(i, handle);
 		}
 		found = 1;
@@ -1217,7 +1217,7 @@ static void print_ip(char *prefix, const struct in6_addr *ip, const struct in6_a
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
 void print_rule(const struct ip6t_entry *e,
-		       struct ip6tc_handle **h, const char *chain, int counters)
+		       struct ip6tc_handle *h, const char *chain, int counters)
 {
 	struct ip6t_entry_target *t;
 	const char *target_name;
@@ -1307,7 +1307,7 @@ void print_rule(const struct ip6t_entry *e,
 
 static int
 list_rules(const ip6t_chainlabel chain, int rulenum, int counters,
-	     struct ip6tc_handle **handle)
+	     struct ip6tc_handle *handle)
 {
 	const char *this = NULL;
 	int found = 0;
@@ -1323,7 +1323,7 @@ list_rules(const ip6t_chainlabel chain, int rulenum, int counters,
 		if (chain && strcmp(this, chain) != 0)
 			continue;
 
-		if (ip6tc_builtin(this, *handle)) {
+		if (ip6tc_builtin(this, handle)) {
 			struct ip6t_counters count;
 			printf("-P %s %s", this, ip6tc_get_policy(this, &count, handle));
 			if (counters)
@@ -2034,33 +2034,33 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		ret = append_entry(chain, e,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE,
-				   handle);
+				   *handle);
 		break;
 	case CMD_DELETE:
 		ret = delete_entry(chain, e,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE,
-				   handle, matches);
+				   *handle, matches);
 		break;
 	case CMD_DELETE_NUM:
-		ret = ip6tc_delete_num_entry(chain, rulenum - 1, handle);
+		ret = ip6tc_delete_num_entry(chain, rulenum - 1, *handle);
 		break;
 	case CMD_REPLACE:
 		ret = replace_entry(chain, e, rulenum - 1,
 				    saddrs, daddrs, options&OPT_VERBOSE,
-				    handle);
+				    *handle);
 		break;
 	case CMD_INSERT:
 		ret = insert_entry(chain, e, rulenum - 1,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE,
-				   handle);
+				   *handle);
 		break;
 	case CMD_FLUSH:
-		ret = flush_entries(chain, options&OPT_VERBOSE, handle);
+		ret = flush_entries(chain, options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_ZERO:
-		ret = zero_entries(chain, options&OPT_VERBOSE, handle);
+		ret = zero_entries(chain, options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
@@ -2070,32 +2070,32 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				   options&OPT_NUMERIC,
 				   options&OPT_EXPANDED,
 				   options&OPT_LINENUMBERS,
-				   handle);
+				   *handle);
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
-					   options&OPT_VERBOSE, handle);
+					   options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_LIST_RULES:
 	case CMD_LIST_RULES|CMD_ZERO:
 		ret = list_rules(chain,
 				   rulenum,
 				   options&OPT_VERBOSE,
-				   handle);
+				   *handle);
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
-					   options&OPT_VERBOSE, handle);
+					   options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_NEW_CHAIN:
-		ret = ip6tc_create_chain(chain, handle);
+		ret = ip6tc_create_chain(chain, *handle);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret = delete_chain(chain, options&OPT_VERBOSE, handle);
+		ret = delete_chain(chain, options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_RENAME_CHAIN:
-		ret = ip6tc_rename_chain(chain, newname,	handle);
+		ret = ip6tc_rename_chain(chain, newname,	*handle);
 		break;
 	case CMD_SET_POLICY:
-		ret = ip6tc_set_policy(chain, policy, options&OPT_COUNTERS ? &fw.counters : NULL, handle);
+		ret = ip6tc_set_policy(chain, policy, options&OPT_COUNTERS ? &fw.counters : NULL, *handle);
 		break;
 	default:
 		/* We should never reach this... */
diff --git a/iptables-restore.c b/iptables-restore.c
index a8ce7cc..12e558d 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -203,7 +203,9 @@ main(int argc, char *argv[])
 		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
 			if (!testing) {
 				DEBUGP("Calling commit\n");
-				ret = iptc_commit(&handle);
+				ret = iptc_commit(handle);
+				iptc_free(handle);
+				handle = NULL;
 			} else {
 				DEBUGP("Not calling commit, testing\n");
 				ret = 1;
@@ -227,19 +229,19 @@ main(int argc, char *argv[])
 			if (tablename && (strcmp(tablename, table) != 0))
 				continue;
 			if (handle)
-				iptc_free(&handle);
+				iptc_free(handle);
 
 			handle = create_handle(table, modprobe);
 			if (noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
 				for_each_chain(flush_entries, verbose, 1,
-						&handle);
+						handle);
 
 				DEBUGP("Deleting all user-defined chains "
 				       "of table '%s'\n", table);
 				for_each_chain(delete_chain, verbose, 0,
-						&handle) ;
+						handle);
 			}
 
 			ret = 1;
@@ -261,14 +263,14 @@ main(int argc, char *argv[])
 			if (iptc_builtin(chain, handle) <= 0) {
 				if (noflush && iptc_is_chain(chain, handle)) {
 					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
-					if (!iptc_flush_entries(chain, &handle))
+					if (!iptc_flush_entries(chain, handle))
 						exit_error(PARAMETER_PROBLEM,
 							   "error flushing chain "
 							   "'%s':%s\n", chain,
 							   strerror(errno));
 				} else {
 					DEBUGP("Creating new chain '%s'\n", chain);
-					if (!iptc_create_chain(chain, &handle))
+					if (!iptc_create_chain(chain, handle))
 						exit_error(PARAMETER_PROBLEM,
 							   "error creating chain "
 							   "'%s':%s\n", chain,
@@ -306,7 +308,7 @@ main(int argc, char *argv[])
 					chain, policy);
 
 				if (!iptc_set_policy(chain, policy, &count,
-						     &handle))
+						     handle))
 					exit_error(OTHER_PROBLEM,
 						"Can't set policy `%s'"
 						" on `%s' line %u: %s\n",
diff --git a/iptables-save.c b/iptables-save.c
index 52b85d8..6252c0b 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -79,15 +79,15 @@ static int do_output(const char *tablename)
 
 		/* Dump out chain names first,
 		 * thereby preventing dependency conflicts */
-		for (chain = iptc_first_chain(&h);
+		for (chain = iptc_first_chain(h);
 		     chain;
-		     chain = iptc_next_chain(&h)) {
+		     chain = iptc_next_chain(h)) {
 
 			printf(":%s ", chain);
 			if (iptc_builtin(chain, h)) {
 				struct ipt_counters count;
 				printf("%s ",
-				       iptc_get_policy(chain, &count, &h));
+				       iptc_get_policy(chain, &count, h));
 				printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
 			} else {
 				printf("- [0:0]\n");
@@ -95,16 +95,16 @@ static int do_output(const char *tablename)
 		}
 
 
-		for (chain = iptc_first_chain(&h);
+		for (chain = iptc_first_chain(h);
 		     chain;
-		     chain = iptc_next_chain(&h)) {
+		     chain = iptc_next_chain(h)) {
 			const struct ipt_entry *e;
 
 			/* Dump out rules */
-			e = iptc_first_rule(chain, &h);
+			e = iptc_first_rule(chain, h);
 			while(e) {
-				print_rule(e, &h, chain, show_counters);
-				e = iptc_next_rule(e, &h);
+				print_rule(e, h, chain, show_counters);
+				e = iptc_next_rule(e, h);
 			}
 		}
 
@@ -116,7 +116,7 @@ static int do_output(const char *tablename)
 		exit_error(OTHER_PROBLEM, "Binary NYI\n");
 	}
 
-	iptc_free(&h);
+	iptc_free(h);
 
 	return 1;
 }
diff --git a/iptables-standalone.c b/iptables-standalone.c
index d62c317..001bb04 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -67,8 +67,10 @@ main(int argc, char *argv[])
 #endif
 
 	ret = do_command(argc, argv, &table, &handle);
-	if (ret)
-		ret = iptc_commit(&handle);
+	if (ret) {
+		ret = iptc_commit(handle);
+		iptc_free(handle);
+	}
 
 	if (!ret) {
 		fprintf(stderr, "iptables: %s\n",
diff --git a/iptables.c b/iptables.c
index 52f90d2..7efd3cf 100644
--- a/iptables.c
+++ b/iptables.c
@@ -646,7 +646,7 @@ print_num(u_int64_t number, unsigned int format)
 
 
 static void
-print_header(unsigned int format, const char *chain, struct iptc_handle **handle)
+print_header(unsigned int format, const char *chain, struct iptc_handle *handle)
 {
 	struct ipt_counters counters;
 	const char *pol = iptc_get_policy(chain, &counters, handle);
@@ -858,7 +858,7 @@ append_entry(const ipt_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in_addr daddrs[],
 	     int verbose,
-	     struct iptc_handle **handle)
+	     struct iptc_handle *handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -868,7 +868,7 @@ append_entry(const ipt_chainlabel chain,
 		for (j = 0; j < ndaddrs; j++) {
 			fw->ip.dst.s_addr = daddrs[j].s_addr;
 			if (verbose)
-				print_firewall_line(fw, *handle);
+				print_firewall_line(fw, handle);
 			ret &= iptc_append_entry(chain, fw, handle);
 		}
 	}
@@ -883,13 +883,13 @@ replace_entry(const ipt_chainlabel chain,
 	      const struct in_addr *saddr,
 	      const struct in_addr *daddr,
 	      int verbose,
-	      struct iptc_handle **handle)
+	      struct iptc_handle *handle)
 {
 	fw->ip.src.s_addr = saddr->s_addr;
 	fw->ip.dst.s_addr = daddr->s_addr;
 
 	if (verbose)
-		print_firewall_line(fw, *handle);
+		print_firewall_line(fw, handle);
 	return iptc_replace_entry(chain, fw, rulenum, handle);
 }
 
@@ -902,7 +902,7 @@ insert_entry(const ipt_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in_addr daddrs[],
 	     int verbose,
-	     struct iptc_handle **handle)
+	     struct iptc_handle *handle)
 {
 	unsigned int i, j;
 	int ret = 1;
@@ -912,7 +912,7 @@ insert_entry(const ipt_chainlabel chain,
 		for (j = 0; j < ndaddrs; j++) {
 			fw->ip.dst.s_addr = daddrs[j].s_addr;
 			if (verbose)
-				print_firewall_line(fw, *handle);
+				print_firewall_line(fw, handle);
 			ret &= iptc_insert_entry(chain, fw, rulenum, handle);
 		}
 	}
@@ -961,7 +961,7 @@ delete_entry(const ipt_chainlabel chain,
 	     unsigned int ndaddrs,
 	     const struct in_addr daddrs[],
 	     int verbose,
-	     struct iptc_handle **handle,
+	     struct iptc_handle *handle,
 	     struct iptables_rule_match *matches)
 {
 	unsigned int i, j;
@@ -974,7 +974,7 @@ delete_entry(const ipt_chainlabel chain,
 		for (j = 0; j < ndaddrs; j++) {
 			fw->ip.dst.s_addr = daddrs[j].s_addr;
 			if (verbose)
-				print_firewall_line(fw, *handle);
+				print_firewall_line(fw, handle);
 			ret &= iptc_delete_entry(chain, fw, mask, handle);
 		}
 	}
@@ -984,8 +984,8 @@ delete_entry(const ipt_chainlabel chain,
 }
 
 int
-for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle **),
-	       int verbose, int builtinstoo, struct iptc_handle **handle)
+for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle *),
+	       int verbose, int builtinstoo, struct iptc_handle *handle)
 {
         int ret = 1;
 	const char *chain;
@@ -1010,7 +1010,7 @@ for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle **),
 	for (i = 0; i < chaincount; i++) {
 		if (!builtinstoo
 		    && iptc_builtin(chains + i*sizeof(ipt_chainlabel),
-				    *handle) == 1)
+				    handle) == 1)
 			continue;
 	        ret &= fn(chains + i*sizeof(ipt_chainlabel), verbose, handle);
 	}
@@ -1021,7 +1021,7 @@ for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle **),
 
 int
 flush_entries(const ipt_chainlabel chain, int verbose,
-	      struct iptc_handle **handle)
+	      struct iptc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain(flush_entries, verbose, 1, handle);
@@ -1033,7 +1033,7 @@ flush_entries(const ipt_chainlabel chain, int verbose,
 
 static int
 zero_entries(const ipt_chainlabel chain, int verbose,
-	     struct iptc_handle **handle)
+	     struct iptc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain(zero_entries, verbose, 1, handle);
@@ -1045,7 +1045,7 @@ zero_entries(const ipt_chainlabel chain, int verbose,
 
 int
 delete_chain(const ipt_chainlabel chain, int verbose,
-	     struct iptc_handle **handle)
+	     struct iptc_handle *handle)
 {
 	if (!chain)
 		return for_each_chain(delete_chain, verbose, 0, handle);
@@ -1057,7 +1057,7 @@ delete_chain(const ipt_chainlabel chain, int verbose,
 
 static int
 list_entries(const ipt_chainlabel chain, int rulenum, int verbose, int numeric,
-	     int expanded, int linenumbers, struct iptc_handle **handle)
+	     int expanded, int linenumbers, struct iptc_handle *handle)
 {
 	int found = 0;
 	unsigned int format;
@@ -1101,7 +1101,7 @@ list_entries(const ipt_chainlabel chain, int rulenum, int verbose, int numeric,
 					       iptc_get_target(i, handle),
 					       num,
 					       format,
-					       *handle);
+					       handle);
 			i = iptc_next_rule(i, handle);
 		}
 		found = 1;
@@ -1225,7 +1225,7 @@ static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
 void print_rule(const struct ipt_entry *e,
-		struct iptc_handle **h, const char *chain, int counters)
+		struct iptc_handle *h, const char *chain, int counters)
 {
 	struct ipt_entry_target *t;
 	const char *target_name;
@@ -1306,7 +1306,7 @@ void print_rule(const struct ipt_entry *e,
 
 static int
 list_rules(const ipt_chainlabel chain, int rulenum, int counters,
-	     struct iptc_handle **handle)
+	     struct iptc_handle *handle)
 {
 	const char *this = NULL;
 	int found = 0;
@@ -1322,7 +1322,7 @@ list_rules(const ipt_chainlabel chain, int rulenum, int counters,
 		if (chain && strcmp(this, chain) != 0)
 			continue;
 
-		if (iptc_builtin(this, *handle)) {
+		if (iptc_builtin(this, handle)) {
 			struct ipt_counters count;
 			printf("-P %s %s", this, iptc_get_policy(this, &count, handle));
 			if (counters)
@@ -2066,33 +2066,33 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		ret = append_entry(chain, e,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE,
-				   handle);
+				   *handle);
 		break;
 	case CMD_DELETE:
 		ret = delete_entry(chain, e,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE,
-				   handle, matches);
+				   *handle, matches);
 		break;
 	case CMD_DELETE_NUM:
-		ret = iptc_delete_num_entry(chain, rulenum - 1, handle);
+		ret = iptc_delete_num_entry(chain, rulenum - 1, *handle);
 		break;
 	case CMD_REPLACE:
 		ret = replace_entry(chain, e, rulenum - 1,
 				    saddrs, daddrs, options&OPT_VERBOSE,
-				    handle);
+				    *handle);
 		break;
 	case CMD_INSERT:
 		ret = insert_entry(chain, e, rulenum - 1,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE,
-				   handle);
+				   *handle);
 		break;
 	case CMD_FLUSH:
-		ret = flush_entries(chain, options&OPT_VERBOSE, handle);
+		ret = flush_entries(chain, options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_ZERO:
-		ret = zero_entries(chain, options&OPT_VERBOSE, handle);
+		ret = zero_entries(chain, options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
@@ -2102,32 +2102,32 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				   options&OPT_NUMERIC,
 				   options&OPT_EXPANDED,
 				   options&OPT_LINENUMBERS,
-				   handle);
+				   *handle);
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
-					   options&OPT_VERBOSE, handle);
+					   options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_LIST_RULES:
 	case CMD_LIST_RULES|CMD_ZERO:
 		ret = list_rules(chain,
 				   rulenum,
 				   options&OPT_VERBOSE,
-				   handle);
+				   *handle);
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
-					   options&OPT_VERBOSE, handle);
+					   options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_NEW_CHAIN:
-		ret = iptc_create_chain(chain, handle);
+		ret = iptc_create_chain(chain, *handle);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret = delete_chain(chain, options&OPT_VERBOSE, handle);
+		ret = delete_chain(chain, options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_RENAME_CHAIN:
-		ret = iptc_rename_chain(chain, newname,	handle);
+		ret = iptc_rename_chain(chain, newname,	*handle);
 		break;
 	case CMD_SET_POLICY:
-		ret = iptc_set_policy(chain, policy, options&OPT_COUNTERS ? &fw.counters : NULL, handle);
+		ret = iptc_set_policy(chain, policy, options&OPT_COUNTERS ? &fw.counters : NULL, *handle);
 		break;
 	default:
 		/* We should never reach this... */
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 1e2cd6e..9de50ad 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1375,7 +1375,7 @@ retry:
 	CHECK(h);
 	return h;
 error:
-	TC_FREE(&h);
+	TC_FREE(h);
 	/* A different process changed the ruleset size, retry */
 	if (errno == EAGAIN)
 		goto retry;
@@ -1383,7 +1383,7 @@ error:
 }
 
 void
-TC_FREE(struct xtc_handle **h)
+TC_FREE(struct xtc_handle *h)
 {
 	struct chain_head *c, *tmp;
 
@@ -1393,7 +1393,7 @@ TC_FREE(struct xtc_handle **h)
 		sockfd = -1;
 	}
 
-	list_for_each_entry_safe(c, tmp, &(*h)->chains, list) {
+	list_for_each_entry_safe(c, tmp, &h->chains, list) {
 		struct rule_head *r, *rtmp;
 
 		list_for_each_entry_safe(r, rtmp, &c->rules, list) {
@@ -1403,12 +1403,10 @@ TC_FREE(struct xtc_handle **h)
 		free(c);
 	}
 
-	iptcc_chain_index_free(*h);
-
-	free((*h)->entries);
-	free(*h);
+	iptcc_chain_index_free(h);
 
-	*h = NULL;
+	free(h->entries);
+	free(h);
 }
 
 static inline int
@@ -1466,21 +1464,21 @@ static void iptcc_chain_iterator_advance(struct xtc_handle *handle)
 
 /* Iterator functions to run through the chains. */
 const char *
-TC_FIRST_CHAIN(struct xtc_handle **handle)
+TC_FIRST_CHAIN(struct xtc_handle *handle)
 {
-	struct chain_head *c = list_entry((*handle)->chains.next,
+	struct chain_head *c = list_entry(handle->chains.next,
 					  struct chain_head, list);
 
 	iptc_fn = TC_FIRST_CHAIN;
 
 
-	if (list_empty(&(*handle)->chains)) {
+	if (list_empty(&handle->chains)) {
 		DEBUGP(": no chains\n");
 		return NULL;
 	}
 
-	(*handle)->chain_iterator_cur = c;
-	iptcc_chain_iterator_advance(*handle);
+	handle->chain_iterator_cur = c;
+	iptcc_chain_iterator_advance(handle);
 
 	DEBUGP(": returning `%s'\n", c->name);
 	return c->name;
@@ -1488,9 +1486,9 @@ TC_FIRST_CHAIN(struct xtc_handle **handle)
 
 /* Iterator functions to run through the chains.  Returns NULL at end. */
 const char *
-TC_NEXT_CHAIN(struct xtc_handle **handle)
+TC_NEXT_CHAIN(struct xtc_handle *handle)
 {
-	struct chain_head *c = (*handle)->chain_iterator_cur;
+	struct chain_head *c = handle->chain_iterator_cur;
 
 	iptc_fn = TC_NEXT_CHAIN;
 
@@ -1499,7 +1497,7 @@ TC_NEXT_CHAIN(struct xtc_handle **handle)
 		return NULL;
 	}
 
-	iptcc_chain_iterator_advance(*handle);
+	iptcc_chain_iterator_advance(handle);
 	
 	DEBUGP(": returning `%s'\n", c->name);
 	return c->name;
@@ -1507,7 +1505,7 @@ TC_NEXT_CHAIN(struct xtc_handle **handle)
 
 /* Get first rule in the given chain: NULL for empty chain. */
 const STRUCT_ENTRY *
-TC_FIRST_RULE(const char *chain, struct xtc_handle **handle)
+TC_FIRST_RULE(const char *chain, struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -1516,7 +1514,7 @@ TC_FIRST_RULE(const char *chain, struct xtc_handle **handle)
 
 	DEBUGP("first rule(%s): ", chain);
 
-	c = iptcc_find_label(chain, *handle);
+	c = iptcc_find_label(chain, handle);
 	if (!c) {
 		errno = ENOENT;
 		return NULL;
@@ -1529,7 +1527,7 @@ TC_FIRST_RULE(const char *chain, struct xtc_handle **handle)
 	}
 
 	r = list_entry(c->rules.next, struct rule_head, list);
-	(*handle)->rule_iterator_cur = r;
+	handle->rule_iterator_cur = r;
 	DEBUGP_C("%p\n", r);
 
 	return r->entry;
@@ -1537,33 +1535,33 @@ TC_FIRST_RULE(const char *chain, struct xtc_handle **handle)
 
 /* Returns NULL when rules run out. */
 const STRUCT_ENTRY *
-TC_NEXT_RULE(const STRUCT_ENTRY *prev, struct xtc_handle **handle)
+TC_NEXT_RULE(const STRUCT_ENTRY *prev, struct xtc_handle *handle)
 {
 	struct rule_head *r;
 
 	iptc_fn = TC_NEXT_RULE;
-	DEBUGP("rule_iterator_cur=%p...", (*handle)->rule_iterator_cur);
+	DEBUGP("rule_iterator_cur=%p...", handle->rule_iterator_cur);
 
-	if (!(*handle)->rule_iterator_cur) {
+	if (handle->rule_iterator_cur == NULL) {
 		DEBUGP_C("returning NULL\n");
 		return NULL;
 	}
 	
-	r = list_entry((*handle)->rule_iterator_cur->list.next, 
+	r = list_entry(handle->rule_iterator_cur->list.next, 
 			struct rule_head, list);
 
 	iptc_fn = TC_NEXT_RULE;
 
 	DEBUGP_C("next=%p, head=%p...", &r->list, 
-		&(*handle)->rule_iterator_cur->chain->rules);
+		&handle->rule_iterator_cur->chain->rules);
 
-	if (&r->list == &(*handle)->rule_iterator_cur->chain->rules) {
-		(*handle)->rule_iterator_cur = NULL;
+	if (&r->list == &handle->rule_iterator_cur->chain->rules) {
+		handle->rule_iterator_cur = NULL;
 		DEBUGP_C("finished, returning NULL\n");
 		return NULL;
 	}
 
-	(*handle)->rule_iterator_cur = r;
+	handle->rule_iterator_cur = r;
 
 	/* NOTE: prev is without any influence ! */
 	DEBUGP_C("returning rule %p\n", r);
@@ -1572,13 +1570,13 @@ TC_NEXT_RULE(const STRUCT_ENTRY *prev, struct xtc_handle **handle)
 
 /* How many rules in this chain? */
 static unsigned int
-TC_NUM_RULES(const char *chain, struct xtc_handle **handle)
+TC_NUM_RULES(const char *chain, struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	iptc_fn = TC_NUM_RULES;
-	CHECK(*handle);
+	CHECK(handle);
 
-	c = iptcc_find_label(chain, *handle);
+	c = iptcc_find_label(chain, handle);
 	if (!c) {
 		errno = ENOENT;
 		return (unsigned int)-1;
@@ -1588,16 +1586,16 @@ TC_NUM_RULES(const char *chain, struct xtc_handle **handle)
 }
 
 static const STRUCT_ENTRY *
-TC_GET_RULE(const char *chain, unsigned int n, struct xtc_handle **handle)
+TC_GET_RULE(const char *chain, unsigned int n, struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
 	
 	iptc_fn = TC_GET_RULE;
 
-	CHECK(*handle);
+	CHECK(handle);
 
-	c = iptcc_find_label(chain, *handle);
+	c = iptcc_find_label(chain, handle);
 	if (!c) {
 		errno = ENOENT;
 		return NULL;
@@ -1637,7 +1635,7 @@ static const char *standard_target_map(int verdict)
 
 /* Returns a pointer to the target name of this position. */
 const char *TC_GET_TARGET(const STRUCT_ENTRY *ce,
-			  struct xtc_handle **handle)
+			  struct xtc_handle *handle)
 {
 	STRUCT_ENTRY *e = (STRUCT_ENTRY *)ce;
 	struct rule_head *r = container_of(e, struct rule_head, entry[0]);
@@ -1685,7 +1683,7 @@ TC_BUILTIN(const char *chain, struct xtc_handle *const handle)
 const char *
 TC_GET_POLICY(const char *chain,
 	      STRUCT_COUNTERS *counters,
-	      struct xtc_handle **handle)
+	      struct xtc_handle *handle)
 {
 	struct chain_head *c;
 
@@ -1693,7 +1691,7 @@ TC_GET_POLICY(const char *chain,
 
 	DEBUGP("called for chain %s\n", chain);
 
-	c = iptcc_find_label(chain, *handle);
+	c = iptcc_find_label(chain, handle);
 	if (!c) {
 		errno = ENOENT;
 		return NULL;
@@ -1786,7 +1784,7 @@ int
 TC_INSERT_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *e,
 		unsigned int rulenum,
-		struct xtc_handle **handle)
+		struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -1794,7 +1792,7 @@ TC_INSERT_ENTRY(const IPT_CHAINLABEL chain,
 
 	iptc_fn = TC_INSERT_ENTRY;
 
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		errno = ENOENT;
 		return 0;
 	}
@@ -1827,7 +1825,7 @@ TC_INSERT_ENTRY(const IPT_CHAINLABEL chain,
 	memcpy(r->entry, e, e->next_offset);
 	r->counter_map.maptype = COUNTER_MAP_SET;
 
-	if (!iptcc_map_target(*handle, r)) {
+	if (!iptcc_map_target(handle, r)) {
 		free(r);
 		return 0;
 	}
@@ -1835,7 +1833,7 @@ TC_INSERT_ENTRY(const IPT_CHAINLABEL chain,
 	list_add_tail(&r->list, prev);
 	c->num_rules++;
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -1845,14 +1843,14 @@ int
 TC_REPLACE_ENTRY(const IPT_CHAINLABEL chain,
 		 const STRUCT_ENTRY *e,
 		 unsigned int rulenum,
-		 struct xtc_handle **handle)
+		 struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r, *old;
 
 	iptc_fn = TC_REPLACE_ENTRY;
 
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		errno = ENOENT;
 		return 0;
 	}
@@ -1877,7 +1875,7 @@ TC_REPLACE_ENTRY(const IPT_CHAINLABEL chain,
 	memcpy(r->entry, e, e->next_offset);
 	r->counter_map.maptype = COUNTER_MAP_SET;
 
-	if (!iptcc_map_target(*handle, r)) {
+	if (!iptcc_map_target(handle, r)) {
 		free(r);
 		return 0;
 	}
@@ -1885,7 +1883,7 @@ TC_REPLACE_ENTRY(const IPT_CHAINLABEL chain,
 	list_add(&r->list, &old->list);
 	iptcc_delete_rule(old);
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -1895,13 +1893,13 @@ TC_REPLACE_ENTRY(const IPT_CHAINLABEL chain,
 int
 TC_APPEND_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *e,
-		struct xtc_handle **handle)
+		struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
 
 	iptc_fn = TC_APPEND_ENTRY;
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		DEBUGP("unable to find chain `%s'\n", chain);
 		errno = ENOENT;
 		return 0;
@@ -1916,7 +1914,7 @@ TC_APPEND_ENTRY(const IPT_CHAINLABEL chain,
 	memcpy(r->entry, e, e->next_offset);
 	r->counter_map.maptype = COUNTER_MAP_SET;
 
-	if (!iptcc_map_target(*handle, r)) {
+	if (!iptcc_map_target(handle, r)) {
 		DEBUGP("unable to map target of rule for chain `%s'\n", chain);
 		free(r);
 		return 0;
@@ -1925,7 +1923,7 @@ TC_APPEND_ENTRY(const IPT_CHAINLABEL chain,
 	list_add_tail(&r->list, &c->rules);
 	c->num_rules++;
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -2003,13 +2001,13 @@ int
 TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *origfw,
 		unsigned char *matchmask,
-		struct xtc_handle **handle)
+		struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r, *i;
 
 	iptc_fn = TC_DELETE_ENTRY;
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		errno = ENOENT;
 		return 0;
 	}
@@ -2023,7 +2021,7 @@ TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 
 	memcpy(r->entry, origfw, origfw->next_offset);
 	r->counter_map.maptype = COUNTER_MAP_NOMAP;
-	if (!iptcc_map_target(*handle, r)) {
+	if (!iptcc_map_target(handle, r)) {
 		DEBUGP("unable to map target of rule for chain `%s'\n", chain);
 		free(r);
 		return 0;
@@ -2050,16 +2048,16 @@ TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 		/* If we are about to delete the rule that is the
 		 * current iterator, move rule iterator back.  next
 		 * pointer will then point to real next node */
-		if (i == (*handle)->rule_iterator_cur) {
-			(*handle)->rule_iterator_cur = 
-				list_entry((*handle)->rule_iterator_cur->list.prev,
+		if (i == handle->rule_iterator_cur) {
+			handle->rule_iterator_cur = 
+				list_entry(handle->rule_iterator_cur->list.prev,
 					   struct rule_head, list);
 		}
 
 		c->num_rules--;
 		iptcc_delete_rule(i);
 
-		set_changed(*handle);
+		set_changed(handle);
 		free(r);
 		return 1;
 	}
@@ -2074,14 +2072,14 @@ TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 int
 TC_DELETE_NUM_ENTRY(const IPT_CHAINLABEL chain,
 		    unsigned int rulenum,
-		    struct xtc_handle **handle)
+		    struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
 
 	iptc_fn = TC_DELETE_NUM_ENTRY;
 
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		errno = ENOENT;
 		return 0;
 	}
@@ -2101,16 +2099,16 @@ TC_DELETE_NUM_ENTRY(const IPT_CHAINLABEL chain,
 	/* If we are about to delete the rule that is the current
 	 * iterator, move rule iterator back.  next pointer will then
 	 * point to real next node */
-	if (r == (*handle)->rule_iterator_cur) {
-		(*handle)->rule_iterator_cur = 
-			list_entry((*handle)->rule_iterator_cur->list.prev,
+	if (r == handle->rule_iterator_cur) {
+		handle->rule_iterator_cur = 
+			list_entry(handle->rule_iterator_cur->list.prev,
 				   struct rule_head, list);
 	}
 
 	c->num_rules--;
 	iptcc_delete_rule(r);
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -2120,7 +2118,7 @@ TC_DELETE_NUM_ENTRY(const IPT_CHAINLABEL chain,
 const char *
 TC_CHECK_PACKET(const IPT_CHAINLABEL chain,
 		STRUCT_ENTRY *entry,
-		struct xtc_handle **handle)
+		struct xtc_handle *handle)
 {
 	iptc_fn = TC_CHECK_PACKET;
 	errno = ENOSYS;
@@ -2129,13 +2127,13 @@ TC_CHECK_PACKET(const IPT_CHAINLABEL chain,
 
 /* Flushes the entries in the given chain (ie. empties chain). */
 int
-TC_FLUSH_ENTRIES(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
+TC_FLUSH_ENTRIES(const IPT_CHAINLABEL chain, struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r, *tmp;
 
 	iptc_fn = TC_FLUSH_ENTRIES;
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		errno = ENOENT;
 		return 0;
 	}
@@ -2146,20 +2144,20 @@ TC_FLUSH_ENTRIES(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 
 	c->num_rules = 0;
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
 
 /* Zeroes the counters in a chain. */
 int
-TC_ZERO_ENTRIES(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
+TC_ZERO_ENTRIES(const IPT_CHAINLABEL chain, struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
 
 	iptc_fn = TC_ZERO_ENTRIES;
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		errno = ENOENT;
 		return 0;
 	}
@@ -2172,7 +2170,7 @@ TC_ZERO_ENTRIES(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 			r->counter_map.maptype = COUNTER_MAP_ZEROED;
 	}
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -2180,7 +2178,7 @@ TC_ZERO_ENTRIES(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 STRUCT_COUNTERS *
 TC_READ_COUNTER(const IPT_CHAINLABEL chain,
 		unsigned int rulenum,
-		struct xtc_handle **handle)
+		struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -2188,7 +2186,7 @@ TC_READ_COUNTER(const IPT_CHAINLABEL chain,
 	iptc_fn = TC_READ_COUNTER;
 	CHECK(*handle);
 
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		errno = ENOENT;
 		return NULL;
 	}
@@ -2204,15 +2202,15 @@ TC_READ_COUNTER(const IPT_CHAINLABEL chain,
 int
 TC_ZERO_COUNTER(const IPT_CHAINLABEL chain,
 		unsigned int rulenum,
-		struct xtc_handle **handle)
+		struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
 	
 	iptc_fn = TC_ZERO_COUNTER;
-	CHECK(*handle);
+	CHECK(handle);
 
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		errno = ENOENT;
 		return 0;
 	}
@@ -2225,7 +2223,7 @@ TC_ZERO_COUNTER(const IPT_CHAINLABEL chain,
 	if (r->counter_map.maptype == COUNTER_MAP_NORMAL_MAP)
 		r->counter_map.maptype = COUNTER_MAP_ZEROED;
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -2234,16 +2232,16 @@ int
 TC_SET_COUNTER(const IPT_CHAINLABEL chain,
 	       unsigned int rulenum,
 	       STRUCT_COUNTERS *counters,
-	       struct xtc_handle **handle)
+	       struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
 	STRUCT_ENTRY *e;
 
 	iptc_fn = TC_SET_COUNTER;
-	CHECK(*handle);
+	CHECK(handle);
 
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		errno = ENOENT;
 		return 0;
 	}
@@ -2258,7 +2256,7 @@ TC_SET_COUNTER(const IPT_CHAINLABEL chain,
 
 	memcpy(&e->counters, counters, sizeof(STRUCT_COUNTERS));
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -2267,7 +2265,7 @@ TC_SET_COUNTER(const IPT_CHAINLABEL chain,
 /* To create a chain, create two rules: error node and unconditional
  * return. */
 int
-TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
+TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle *handle)
 {
 	static struct chain_head *c;
 	int capacity;
@@ -2277,7 +2275,7 @@ TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 
 	/* find_label doesn't cover built-in targets: DROP, ACCEPT,
            QUEUE, RETURN. */
-	if (iptcc_find_label(chain, *handle)
+	if (iptcc_find_label(chain, handle)
 	    || strcmp(chain, LABEL_DROP) == 0
 	    || strcmp(chain, LABEL_ACCEPT) == 0
 	    || strcmp(chain, LABEL_QUEUE) == 0
@@ -2300,10 +2298,10 @@ TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 		return 0;
 
 	}
-	(*handle)->num_chains++; /* New user defined chain */
+	handle->num_chains++; /* New user defined chain */
 
 	DEBUGP("Creating chain `%s'\n", chain);
-	iptc_insert_chain(*handle, c); /* Insert sorted */
+	iptc_insert_chain(handle, c); /* Insert sorted */
 
 	/* Inserting chains don't change the correctness of the chain
 	 * index (except if its smaller than index[0], but that
@@ -2311,15 +2309,15 @@ TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 	 * in the buckets. Thus, only rebuild chain index when the
 	 * capacity is exceed with CHAIN_INDEX_INSERT_MAX chains.
 	 */
-	capacity = (*handle)->chain_index_sz * CHAIN_INDEX_BUCKET_LEN;
-	exceeded = ((((*handle)->num_chains)-capacity));
+	capacity = handle->chain_index_sz * CHAIN_INDEX_BUCKET_LEN;
+	exceeded = handle->num_chains - capacity;
 	if (exceeded > CHAIN_INDEX_INSERT_MAX) {
 		debug("Capacity(%d) exceeded(%d) rebuild (chains:%d)\n",
-		      capacity, exceeded, (*handle)->num_chains);
-		iptcc_chain_index_rebuild(*handle);
+		      capacity, exceeded, handle->num_chains);
+		iptcc_chain_index_rebuild(handle);
 	}
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -2327,12 +2325,12 @@ TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 /* Get the number of references to this chain. */
 int
 TC_GET_REFERENCES(unsigned int *ref, const IPT_CHAINLABEL chain,
-		  struct xtc_handle **handle)
+		  struct xtc_handle *handle)
 {
 	struct chain_head *c;
 
 	iptc_fn = TC_GET_REFERENCES;
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		errno = ENOENT;
 		return 0;
 	}
@@ -2344,20 +2342,20 @@ TC_GET_REFERENCES(unsigned int *ref, const IPT_CHAINLABEL chain,
 
 /* Deletes a chain. */
 int
-TC_DELETE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
+TC_DELETE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle *handle)
 {
 	unsigned int references;
 	struct chain_head *c;
 
 	iptc_fn = TC_DELETE_CHAIN;
 
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		DEBUGP("cannot find chain `%s'\n", chain);
 		errno = ENOENT;
 		return 0;
 	}
 
-	if (TC_BUILTIN(chain, *handle)) {
+	if (TC_BUILTIN(chain, handle)) {
 		DEBUGP("cannot remove builtin chain `%s'\n", chain);
 		errno = EINVAL;
 		return 0;
@@ -2382,18 +2380,18 @@ TC_DELETE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 
 	/* If we are about to delete the chain that is the current
 	 * iterator, move chain iterator forward. */
-	if (c == (*handle)->chain_iterator_cur)
-		iptcc_chain_iterator_advance(*handle);
+	if (c == handle->chain_iterator_cur)
+		iptcc_chain_iterator_advance(handle);
 
-	(*handle)->num_chains--; /* One user defined chain deleted */
+	handle->num_chains--; /* One user defined chain deleted */
 
 	//list_del(&c->list); /* Done in iptcc_chain_index_delete_chain() */
-	iptcc_chain_index_delete_chain(c, *handle);
+	iptcc_chain_index_delete_chain(c, handle);
 	free(c);
 
 	DEBUGP("chain `%s' deleted\n", chain);
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -2401,14 +2399,14 @@ TC_DELETE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle **handle)
 /* Renames a chain. */
 int TC_RENAME_CHAIN(const IPT_CHAINLABEL oldname,
 		    const IPT_CHAINLABEL newname,
-		    struct xtc_handle **handle)
+		    struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	iptc_fn = TC_RENAME_CHAIN;
 
 	/* find_label doesn't cover built-in targets: DROP, ACCEPT,
            QUEUE, RETURN. */
-	if (iptcc_find_label(newname, *handle)
+	if (iptcc_find_label(newname, handle)
 	    || strcmp(newname, LABEL_DROP) == 0
 	    || strcmp(newname, LABEL_ACCEPT) == 0
 	    || strcmp(newname, LABEL_QUEUE) == 0
@@ -2417,8 +2415,8 @@ int TC_RENAME_CHAIN(const IPT_CHAINLABEL oldname,
 		return 0;
 	}
 
-	if (!(c = iptcc_find_label(oldname, *handle))
-	    || TC_BUILTIN(oldname, *handle)) {
+	if (!(c = iptcc_find_label(oldname, handle))
+	    || TC_BUILTIN(oldname, handle)) {
 		errno = ENOENT;
 		return 0;
 	}
@@ -2430,7 +2428,7 @@ int TC_RENAME_CHAIN(const IPT_CHAINLABEL oldname,
 
 	strncpy(c->name, newname, sizeof(IPT_CHAINLABEL));
 	
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -2440,13 +2438,13 @@ int
 TC_SET_POLICY(const IPT_CHAINLABEL chain,
 	      const IPT_CHAINLABEL policy,
 	      STRUCT_COUNTERS *counters,
-	      struct xtc_handle **handle)
+	      struct xtc_handle *handle)
 {
 	struct chain_head *c;
 
 	iptc_fn = TC_SET_POLICY;
 
-	if (!(c = iptcc_find_label(chain, *handle))) {
+	if (!(c = iptcc_find_label(chain, handle))) {
 		DEBUGP("cannot find chain `%s'\n", chain);
 		errno = ENOENT;
 		return 0;
@@ -2475,7 +2473,7 @@ TC_SET_POLICY(const IPT_CHAINLABEL chain,
 		c->counter_map.maptype = COUNTER_MAP_NOMAP;
 	}
 
-	set_changed(*handle);
+	set_changed(handle);
 
 	return 1;
 }
@@ -2547,7 +2545,7 @@ static void counters_map_set(STRUCT_COUNTERS_INFO *newcounters,
 
 
 int
-TC_COMMIT(struct xtc_handle **handle)
+TC_COMMIT(struct xtc_handle *handle)
 {
 	/* Replace, then map back the counters. */
 	STRUCT_REPLACE *repl;
@@ -2562,10 +2560,10 @@ TC_COMMIT(struct xtc_handle **handle)
 	CHECK(*handle);
 
 	/* Don't commit if nothing changed. */
-	if (!(*handle)->changed)
+	if (!handle->changed)
 		goto finished;
 
-	new_number = iptcc_compile_table_prep(*handle, &new_size);
+	new_number = iptcc_compile_table_prep(handle, &new_size);
 	if (new_number < 0) {
 		errno = ENOMEM;
 		goto out_zero;
@@ -2587,7 +2585,7 @@ TC_COMMIT(struct xtc_handle **handle)
 
 	/* These are the old counters we will get from kernel */
 	repl->counters = malloc(sizeof(STRUCT_COUNTERS)
-				* (*handle)->info.num_entries);
+				* handle->info.num_entries);
 	if (!repl->counters) {
 		errno = ENOMEM;
 		goto out_free_repl;
@@ -2600,17 +2598,17 @@ TC_COMMIT(struct xtc_handle **handle)
 	}
 	memset(newcounters, 0, counterlen);
 
-	strcpy(repl->name, (*handle)->info.name);
+	strcpy(repl->name, handle->info.name);
 	repl->num_entries = new_number;
 	repl->size = new_size;
 
-	repl->num_counters = (*handle)->info.num_entries;
-	repl->valid_hooks = (*handle)->info.valid_hooks;
+	repl->num_counters = handle->info.num_entries;
+	repl->valid_hooks  = handle->info.valid_hooks;
 
 	DEBUGP("num_entries=%u, size=%u, num_counters=%u\n",
 		repl->num_entries, repl->size, repl->num_counters);
 
-	ret = iptcc_compile_table(*handle, repl);
+	ret = iptcc_compile_table(handle, repl);
 	if (ret < 0) {
 		errno = ret;
 		goto out_free_newcounters;
@@ -2634,10 +2632,10 @@ TC_COMMIT(struct xtc_handle **handle)
 		goto out_free_newcounters;
 
 	/* Put counters back. */
-	strcpy(newcounters->name, (*handle)->info.name);
+	strcpy(newcounters->name, handle->info.name);
 	newcounters->num_counters = new_number;
 
-	list_for_each_entry(c, &(*handle)->chains, list) {
+	list_for_each_entry(c, &handle->chains, list) {
 		struct rule_head *r;
 
 		/* Builtin chains have their own counters */
@@ -2714,7 +2712,6 @@ TC_COMMIT(struct xtc_handle **handle)
 	free(newcounters);
 
 finished:
-	TC_FREE(handle);
 	return 1;
 
 out_free_newcounters:
