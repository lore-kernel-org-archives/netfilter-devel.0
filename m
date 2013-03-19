From: pablo@netfilter.org
Subject: [PATCH 1/2] libip6t_NETMAP: Use xtables_ip6mask_to_cidr and get rid of libip6tc dependency
Date: Wed, 20 Mar 2013 00:43:05 +0100
Message-ID: <1363736586-4313-1-git-send-email-pablo@netfilter.org>
Cc: ldv@altlinux.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39731 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab3CSXnO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:43:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch changes the NETMAP target extension (IPv6 side) to use
the xtables_ip6mask_to_cidr available in libxtables.

As a side effect, we get rid of the libip6tc dependency.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/GNUmakefile.in   |    1 -
 extensions/libip6t_NETMAP.c |    2 +-
 include/libiptc/libip6tc.h  |    3 ---
 iptables/ip6tables.c        |    2 +-
 libiptc/libip6tc.c          |    2 +-
 5 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index adad4d6..3db6985 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -105,7 +105,6 @@ libxt_state.so: libxt_conntrack.so
 	${AM_VERBOSE_GEN} ln -fs $< $@
 
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
-ip6t_NETMAP_LIBADD  = ../libiptc/libip6tc.la
 xt_RATEEST_LIBADD   = -lm
 xt_statistic_LIBADD = -lm
 
diff --git a/extensions/libip6t_NETMAP.c b/extensions/libip6t_NETMAP.c
index d14dece..a4df70e 100644
--- a/extensions/libip6t_NETMAP.c
+++ b/extensions/libip6t_NETMAP.c
@@ -61,7 +61,7 @@ static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
 	printf("%s", xtables_ip6addr_to_numeric(&a));
 	for (i = 0; i < 4; i++)
 		a.s6_addr32[i] = ~(r->min_addr.ip6[i] ^ r->max_addr.ip6[i]);
-	bits = ipv6_prefix_length(&a);
+	bits = xtables_ip6mask_to_cidr(&a);
 	if (bits < 0)
 		printf("/%s", xtables_ip6addr_to_numeric(&a));
 	else
diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index c656bc4..9aed80a 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -154,9 +154,6 @@ int ip6tc_get_raw_socket(void);
 /* Translates errno numbers into more human-readable form than strerror. */
 const char *ip6tc_strerror(int err);
 
-/* Return prefix length, or -1 if not contiguous */
-int ipv6_prefix_length(const struct in6_addr *a);
-
 extern void dump_entries6(struct xtc_handle *const);
 
 extern const struct xtc_ops ip6tc_ops;
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 4cfbea3..7d02cc1 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1022,7 +1022,7 @@ static void print_ip(const char *prefix, const struct in6_addr *ip,
 		     const struct in6_addr *mask, int invert)
 {
 	char buf[51];
-	int l = ipv6_prefix_length(mask);
+	int l = xtables_ip6mask_to_cidr(mask);
 
 	if (l == 0 && !invert)
 		return;
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index 7128e1c..ca01bcb 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -113,7 +113,7 @@ typedef unsigned int socklen_t;
 #define BIT6(a, l) \
  ((ntohl(a->s6_addr32[(l) / 32]) >> (31 - ((l) & 31))) & 1)
 
-int
+static int
 ipv6_prefix_length(const struct in6_addr *a)
 {
 	int l, i;
-- 
1.7.10.4

