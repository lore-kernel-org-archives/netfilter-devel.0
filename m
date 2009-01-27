From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxtables: prefix names and order it #1
Date: Tue, 27 Jan 2009 15:01:23 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, jamal <hadi@cyberus.ca>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44334 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZA0OBZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 09:01:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


As previously mentioned, libxtables needs some goodtime cleanup first.
Now let me throw patches (unspecified number as of yet) at it-


---8<---
parent ea268e19a8b820cce4bab3318e656efa51134487 (v1.4.3-rc1-22-gea268e1)
commit d6c2522895ff2906cd905bd2ef728bf388bdaa77
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 27 14:58:41 2009 +0100

libxtables: prefix names and order it #1

It is good practice to prefix names in a library some way so that
it does not clash with external programs' variable names right
on the first try.

This change: rename fw_[cm]alloc to xtables_[cm]alloc and
move the definition from internal.h to xtables.h to avoid
potential compiler warnings.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am                |    2 +-
 include/xtables.h.in       |    3 +++
 include/xtables/internal.h |    3 ---
 ip6tables.c                |   14 +++++++-------
 iptables.c                 |   14 +++++++-------
 xtables.c                  |   19 +++++++++++--------
 6 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 4852d2a..83ab3bb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -14,7 +14,7 @@ libiptc_libiptc_a_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
 
 lib_LTLIBRARIES       = libxtables.la
 libxtables_la_SOURCES = xtables.c
-libxtables_la_LDFLAGS = -version 0:0:0
+libxtables_la_LDFLAGS = -version-info 1:0:0
 
 # iptables, dynamic
 iptables_SOURCES          = iptables-standalone.c iptables.c
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 8327c42..e63d171 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -140,6 +140,9 @@ struct xtables_target
 #endif
 };
 
+extern void *xtables_calloc(size_t, size_t);
+extern void *xtables_malloc(size_t);
+
 /* Your shared library should call one of these. */
 extern void xtables_register_match(struct xtables_match *me);
 extern void xtables_register_target(struct xtables_target *me);
diff --git a/include/xtables/internal.h b/include/xtables/internal.h
index 24a5078..6b78d3a 100644
--- a/include/xtables/internal.h
+++ b/include/xtables/internal.h
@@ -43,9 +43,6 @@ struct xtables_rule_match {
 
 extern char *lib_dir;
 
-extern void *fw_calloc(size_t count, size_t size);
-extern void *fw_malloc(size_t size);
-
 extern const char *modprobe_program;
 extern int xtables_insmod(const char *modname, const char *modprobe, int quiet);
 extern int load_xtables_ko(const char *modprobe, int quiet);
diff --git a/ip6tables.c b/ip6tables.c
index 3c45c07..59c1011 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -939,7 +939,7 @@ make_delete_mask(struct ip6t_entry *fw, struct ip6tables_rule_match *matches)
 	for (matchp = matches; matchp; matchp = matchp->next)
 		size += IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + matchp->match->size;
 
-	mask = fw_calloc(1, size
+	mask = xtables_calloc(1, size
 			 + IP6T_ALIGN(sizeof(struct ip6t_entry_target))
 			 + xtables_targets->size);
 
@@ -1005,7 +1005,7 @@ for_each_chain(int (*fn)(const ip6t_chainlabel, int, struct ip6tc_handle *),
 		chain = ip6tc_next_chain(handle);
 	}
 
-	chains = fw_malloc(sizeof(ip6t_chainlabel) * chaincount);
+	chains = xtables_malloc(sizeof(ip6t_chainlabel) * chaincount);
 	i = 0;
 	chain = ip6tc_first_chain(handle);
 	while (chain) {
@@ -1371,7 +1371,7 @@ generate_entry(const struct ip6t_entry *fw,
 	for (matchp = matches; matchp; matchp = matchp->next)
 		size += matchp->match->m->u.match_size;
 
-	e = fw_malloc(size + target->u.target_size);
+	e = xtables_malloc(size + target->u.target_size);
 	*e = *fw;
 	e->target_offset = size;
 	e->next_offset = size + target->u.target_size;
@@ -1674,7 +1674,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				size = IP6T_ALIGN(sizeof(struct ip6t_entry_target))
 					+ target->size;
 
-				target->t = fw_calloc(1, size);
+				target->t = xtables_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
 				set_revision(target->t->u.user.name,
@@ -1726,7 +1726,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches);
 			size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
 					 + m->size;
-			m->m = fw_calloc(1, size);
+			m->m = xtables_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
 			set_revision(m->m->u.user.name, m->revision);
@@ -1873,7 +1873,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
 							 + m->size;
 
-					m->m = fw_calloc(1, size);
+					m->m = xtables_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
 					set_revision(m->m->u.user.name,
@@ -2022,7 +2022,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 			size = sizeof(struct ip6t_entry_target)
 				+ target->size;
-			target->t = fw_calloc(1, size);
+			target->t = xtables_calloc(1, size);
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
 			if (target->init != NULL)
diff --git a/iptables.c b/iptables.c
index b75df87..0b7edd8 100644
--- a/iptables.c
+++ b/iptables.c
@@ -932,7 +932,7 @@ make_delete_mask(struct ipt_entry *fw, struct iptables_rule_match *matches)
 	for (matchp = matches; matchp; matchp = matchp->next)
 		size += IPT_ALIGN(sizeof(struct ipt_entry_match)) + matchp->match->size;
 
-	mask = fw_calloc(1, size
+	mask = xtables_calloc(1, size
 			 + IPT_ALIGN(sizeof(struct ipt_entry_target))
 			 + xtables_targets->size);
 
@@ -998,7 +998,7 @@ for_each_chain(int (*fn)(const ipt_chainlabel, int, struct iptc_handle *),
 		chain = iptc_next_chain(handle);
         }
 
-	chains = fw_malloc(sizeof(ipt_chainlabel) * chaincount);
+	chains = xtables_malloc(sizeof(ipt_chainlabel) * chaincount);
 	i = 0;
 	chain = iptc_first_chain(handle);
 	while (chain) {
@@ -1370,7 +1370,7 @@ generate_entry(const struct ipt_entry *fw,
 	for (matchp = matches; matchp; matchp = matchp->next)
 		size += matchp->match->m->u.match_size;
 
-	e = fw_malloc(size + target->u.target_size);
+	e = xtables_malloc(size + target->u.target_size);
 	*e = *fw;
 	e->target_offset = size;
 	e->next_offset = size + target->u.target_size;
@@ -1679,7 +1679,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				size = IPT_ALIGN(sizeof(struct ipt_entry_target))
 					+ target->size;
 
-				target->t = fw_calloc(1, size);
+				target->t = xtables_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
 				set_revision(target->t->u.user.name,
@@ -1737,7 +1737,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches);
 			size = IPT_ALIGN(sizeof(struct ipt_entry_match))
 					 + m->size;
-			m->m = fw_calloc(1, size);
+			m->m = xtables_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
 			set_revision(m->m->u.user.name, m->revision);
@@ -1891,7 +1891,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					size = IPT_ALIGN(sizeof(struct ipt_entry_match))
 							 + m->size;
 
-					m->m = fw_calloc(1, size);
+					m->m = xtables_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
 					set_revision(m->m->u.user.name,
@@ -2051,7 +2051,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 			size = sizeof(struct ipt_entry_target)
 				+ target->size;
-			target->t = fw_calloc(1, size);
+			target->t = xtables_calloc(1, size);
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
 			if (!iptc_is_chain(jumpto, *handle))
diff --git a/xtables.c b/xtables.c
index abdd283..83c72ee 100644
--- a/xtables.c
+++ b/xtables.c
@@ -53,7 +53,10 @@ const char *modprobe_program = NULL;
 struct xtables_match *xtables_matches;
 struct xtables_target *xtables_targets;
 
-void *fw_calloc(size_t count, size_t size)
+/**
+ * xtables_*alloc - wrappers that exit on failure
+ */
+void *xtables_calloc(size_t count, size_t size)
 {
 	void *p;
 
@@ -65,7 +68,7 @@ void *fw_calloc(size_t count, size_t size)
 	return p;
 }
 
-void *fw_malloc(size_t size)
+void *xtables_malloc(size_t size)
 {
 	void *p;
 
@@ -379,7 +382,7 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 				break;
 
 			/* Second and subsequent clones */
-			clone = fw_malloc(sizeof(struct xtables_match));
+			clone = xtables_malloc(sizeof(struct xtables_match));
 			memcpy(clone, ptr, sizeof(struct xtables_match));
 			clone->mflags = 0;
 			/* This is a clone: */
@@ -416,7 +419,7 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 		struct xtables_rule_match **i;
 		struct xtables_rule_match *newentry;
 
-		newentry = fw_malloc(sizeof(struct xtables_rule_match));
+		newentry = xtables_malloc(sizeof(struct xtables_rule_match));
 
 		for (i = matches; *i; i = &(*i)->next) {
 			if (strcmp(name, (*i)->match->name) == 0)
@@ -876,7 +879,7 @@ static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
 
 		while (host->h_addr_list[*naddr] != NULL)
 			++*naddr;
-		addr = fw_calloc(*naddr, sizeof(struct in_addr) * *naddr);
+		addr = xtables_calloc(*naddr, sizeof(struct in_addr) * *naddr);
 		for (i = 0; i < *naddr; i++)
 			memcpy(&addr[i], host->h_addr_list[i],
 			       sizeof(struct in_addr));
@@ -893,7 +896,7 @@ ipparse_hostnetwork(const char *name, unsigned int *naddrs)
 
 	if ((addrptmp = numeric_to_ipaddr(name)) != NULL ||
 	    (addrptmp = network_to_ipaddr(name)) != NULL) {
-		addrp = fw_malloc(sizeof(struct in_addr));
+		addrp = xtables_malloc(sizeof(struct in_addr));
 		memcpy(addrp, addrptmp, sizeof(*addrp));
 		*naddrs = 1;
 		return addrp;
@@ -1089,7 +1092,7 @@ host_to_ip6addr(const char *name, unsigned int *naddr)
 		        ip6addr_to_numeric(&((struct sockaddr_in6 *)res->ai_addr)->sin6_addr));
 #endif
 		/* Get the first element of the address-chain */
-		addr = fw_malloc(sizeof(struct in6_addr));
+		addr = xtables_malloc(sizeof(struct in6_addr));
 		memcpy(addr, &((const struct sockaddr_in6 *)res->ai_addr)->sin6_addr,
 		       sizeof(struct in6_addr));
 		freeaddrinfo(res);
@@ -1115,7 +1118,7 @@ ip6parse_hostnetwork(const char *name, unsigned int *naddrs)
 
 	if ((addrptmp = numeric_to_ip6addr(name)) != NULL ||
 	    (addrptmp = network_to_ip6addr(name)) != NULL) {
-		addrp = fw_malloc(sizeof(struct in6_addr));
+		addrp = xtables_malloc(sizeof(struct in6_addr));
 		memcpy(addrp, addrptmp, sizeof(*addrp));
 		*naddrs = 1;
 		return addrp;
-- 
# Created with git-export-patch

