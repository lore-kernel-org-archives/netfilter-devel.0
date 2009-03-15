From: Jan Engelhardt <jengelh@medozas.de>
Subject: (pull) pending patches
Date: Sun, 15 Mar 2009 21:44:56 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903152142090.17985@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58153 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbZCOUpB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:45:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


please pull from
	git://dev.medozas.de/iptables

there are still two tidbits not present in nf/master that were submitted 
earlier (headers and limits.h). I also added a commit for turning the 
deprecation of DROP-in-nat into enforcement.

$ git shortlog nf/master..HEAD
Jan Engelhardt (4):
      include: resynchronize headers with 2.6.29-rc5
      extensions: add missing limits.h include
      iptables: turn deprecation warning into enforcing mode
      Merge commit 'nf/master'

Combined stat and patch for review:

 extensions/libip6t_icmp6.c                    |    1 +
 extensions/libipt_DNAT.c                      |   15 ++--
 extensions/libipt_MASQUERADE.c                |   27 +++---
 extensions/libipt_NETMAP.c                    |   20 ++--
 extensions/libipt_REDIRECT.c                  |   27 +++---
 extensions/libipt_SAME.c                      |    8 +-
 extensions/libipt_SNAT.c                      |   15 ++--
 extensions/libipt_icmp.c                      |    1 +
 extensions/libxt_multiport.c                  |    1 +
 include/libiptc/libip6tc.h                    |    5 +
 include/libiptc/libiptc.h                     |    5 +
 include/linux/netfilter/nf_conntrack_common.h |    2 +-
 include/linux/netfilter/nf_conntrack_tuple.h  |  103 ----------------------
 include/linux/netfilter/nf_nat.h              |   45 ----------
 include/linux/netfilter/xt_NFLOG.h            |    2 +-
 include/linux/netfilter/xt_connlimit.h        |    9 ++-
 include/linux/netfilter/xt_conntrack.h        |    1 +
 include/linux/netfilter/xt_quota.h            |    2 +
 include/linux/netfilter/xt_sctp.h             |   10 +--
 include/linux/netfilter/xt_string.h           |    6 +-
 include/linux/netfilter_ipv4/ip_tables.h      |    2 +
 include/linux/netfilter_ipv4/ipt_SAME.h       |    2 +-
 include/linux/netfilter_ipv6/ip6_tables.h     |    2 +
 include/linux/netfilter_ipv6/ip6t_TCPMSS.h    |   10 --
 include/linux/types.h                         |   21 +----
 include/net/netfilter/nf_conntrack_tuple.h    |  114 +++++++++++++++++++++++++
 include/net/netfilter/nf_nat.h                |   54 ++++++++++++
 iptables.c                                    |    7 +-
 xtables.c                                     |    1 +
 29 files changed, 269 insertions(+), 249 deletions(-)

diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 69171d1..0678aac 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -5,6 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
+#include <limits.h> /* INT_MAX in ip6_tables.h */
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
 struct icmpv6_names {
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index f0a2369..b5f8028 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -6,8 +6,9 @@
 #include <getopt.h>
 #include <xtables.h>
 #include <iptables.h> /* get_kernel_version */
+#include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat.h>
 
 #define IPT_DNAT_OPT_DEST 0x1
 #define IPT_DNAT_OPT_RANDOM 0x2
@@ -17,7 +18,7 @@
 struct ipt_natinfo
 {
 	struct xt_entry_target t;
-	struct ip_nat_multi_range mr;
+	struct nf_nat_multi_range mr;
 };
 
 static void DNAT_help(void)
@@ -36,7 +37,7 @@ static const struct option DNAT_opts[] = {
 };
 
 static struct ipt_natinfo *
-append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
+append_range(struct ipt_natinfo *info, const struct nf_nat_range *range)
 {
 	unsigned int size;
 
@@ -58,7 +59,7 @@ append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
 static struct xt_entry_target *
 parse_to(char *arg, int portok, struct ipt_natinfo *info)
 {
-	struct ip_nat_range range;
+	struct nf_nat_range range;
 	char *colon, *dash, *error;
 	const struct in_addr *ip;
 
@@ -189,7 +190,7 @@ static void DNAT_check(unsigned int flags)
 			   "You must specify --to-destination");
 }
 
-static void print_range(const struct ip_nat_range *r)
+static void print_range(const struct nf_nat_range *r)
 {
 	if (r->flags & IP_NAT_RANGE_MAP_IPS) {
 		struct in_addr a;
@@ -242,8 +243,8 @@ static struct xtables_target dnat_tg_reg = {
 	.name		= "DNAT",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
+	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= DNAT_help,
 	.parse		= DNAT_parse,
 	.final_check	= DNAT_check,
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 0180bf6..82c2230 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -5,8 +5,9 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
+#include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat.h>
 
 static void MASQUERADE_help(void)
 {
@@ -26,7 +27,7 @@ static const struct option MASQUERADE_opts[] = {
 
 static void MASQUERADE_init(struct xt_entry_target *t)
 {
-	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
+	struct nf_nat_multi_range *mr = (struct nf_nat_multi_range *)t->data;
 
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
@@ -35,7 +36,7 @@ static void MASQUERADE_init(struct xt_entry_target *t)
 
 /* Parses ports */
 static void
-parse_ports(const char *arg, struct ip_nat_multi_range *mr)
+parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 {
 	const char *dash;
 	int port;
@@ -72,8 +73,8 @@ static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
 {
 	const struct ipt_entry *entry = e;
 	int portok;
-	struct ip_nat_multi_range *mr
-		= (struct ip_nat_multi_range *)(*target)->data;
+	struct nf_nat_multi_range *mr
+		= (struct nf_nat_multi_range *)(*target)->data;
 
 	if (entry->ip.proto == IPPROTO_TCP
 	    || entry->ip.proto == IPPROTO_UDP
@@ -110,9 +111,9 @@ static void
 MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
                  int numeric)
 {
-	struct ip_nat_multi_range *mr
-		= (struct ip_nat_multi_range *)target->data;
-	struct ip_nat_range *r = &mr->range[0];
+	struct nf_nat_multi_range *mr
+		= (struct nf_nat_multi_range *)target->data;
+	struct nf_nat_range *r = &mr->range[0];
 
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
 		printf("masq ports: ");
@@ -129,9 +130,9 @@ MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
 static void
 MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 {
-	struct ip_nat_multi_range *mr
-		= (struct ip_nat_multi_range *)target->data;
-	struct ip_nat_range *r = &mr->range[0];
+	struct nf_nat_multi_range *mr
+		= (struct nf_nat_multi_range *)target->data;
+	struct nf_nat_range *r = &mr->range[0];
 
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
 		printf("--to-ports %hu", ntohs(r->min.tcp.port));
@@ -148,8 +149,8 @@ static struct xtables_target masquerade_tg_reg = {
 	.name		= "MASQUERADE",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
+	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= MASQUERADE_help,
 	.init		= MASQUERADE_init,
 	.parse		= MASQUERADE_parse,
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index f718d2c..9820230 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -8,7 +8,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat.h>
 
 #define MODULENAME "NETMAP"
 
@@ -53,7 +53,7 @@ netmask2bits(u_int32_t netmask)
 
 static void NETMAP_init(struct xt_entry_target *t)
 {
-	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
+	struct nf_nat_multi_range *mr = (struct nf_nat_multi_range *)t->data;
 
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
@@ -62,7 +62,7 @@ static void NETMAP_init(struct xt_entry_target *t)
 
 /* Parses network address */
 static void
-parse_to(char *arg, struct ip_nat_range *range)
+parse_to(char *arg, struct nf_nat_range *range)
 {
 	char *slash;
 	const struct in_addr *ip;
@@ -112,8 +112,8 @@ parse_to(char *arg, struct ip_nat_range *range)
 static int NETMAP_parse(int c, char **argv, int invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
-	struct ip_nat_multi_range *mr
-		= (struct ip_nat_multi_range *)(*target)->data;
+	struct nf_nat_multi_range *mr
+		= (struct nf_nat_multi_range *)(*target)->data;
 
 	switch (c) {
 	case '1':
@@ -140,9 +140,9 @@ static void NETMAP_check(unsigned int flags)
 static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
                          int numeric)
 {
-	struct ip_nat_multi_range *mr
-		= (struct ip_nat_multi_range *)target->data;
-	struct ip_nat_range *r = &mr->range[0];
+	struct nf_nat_multi_range *mr
+		= (struct nf_nat_multi_range *)target->data;
+	struct nf_nat_range *r = &mr->range[0];
 	struct in_addr a;
 	int bits;
 
@@ -166,8 +166,8 @@ static struct xtables_target netmap_tg_reg = {
 	.name		= MODULENAME,
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
+	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= NETMAP_help,
 	.init		= NETMAP_init,
 	.parse		= NETMAP_parse,
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 8fcb46a..658f933 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -5,8 +5,9 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
+#include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat.h>
 
 #define IPT_REDIRECT_OPT_DEST	0x01
 #define IPT_REDIRECT_OPT_RANDOM	0x02
@@ -27,7 +28,7 @@ static const struct option REDIRECT_opts[] = {
 
 static void REDIRECT_init(struct xt_entry_target *t)
 {
-	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
+	struct nf_nat_multi_range *mr = (struct nf_nat_multi_range *)t->data;
 
 	/* Actually, it's 0, but it's ignored at the moment. */
 	mr->rangesize = 1;
@@ -36,7 +37,7 @@ static void REDIRECT_init(struct xt_entry_target *t)
 
 /* Parses ports */
 static void
-parse_ports(const char *arg, struct ip_nat_multi_range *mr)
+parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 {
 	const char *dash;
 	int port;
@@ -78,8 +79,8 @@ static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
                           const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
-	struct ip_nat_multi_range *mr
-		= (struct ip_nat_multi_range *)(*target)->data;
+	struct nf_nat_multi_range *mr
+		= (struct nf_nat_multi_range *)(*target)->data;
 	int portok;
 
 	if (entry->ip.proto == IPPROTO_TCP
@@ -123,9 +124,9 @@ static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
 static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
                            int numeric)
 {
-	struct ip_nat_multi_range *mr
-		= (struct ip_nat_multi_range *)target->data;
-	struct ip_nat_range *r = &mr->range[0];
+	struct nf_nat_multi_range *mr
+		= (struct nf_nat_multi_range *)target->data;
+	struct nf_nat_range *r = &mr->range[0];
 
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
 		printf("redir ports ");
@@ -140,9 +141,9 @@ static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
 
 static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 {
-	struct ip_nat_multi_range *mr
-		= (struct ip_nat_multi_range *)target->data;
-	struct ip_nat_range *r = &mr->range[0];
+	struct nf_nat_multi_range *mr
+		= (struct nf_nat_multi_range *)target->data;
+	struct nf_nat_range *r = &mr->range[0];
 
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
 		printf("--to-ports ");
@@ -159,8 +160,8 @@ static struct xtables_target redirect_tg_reg = {
 	.name		= "REDIRECT",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
+	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= REDIRECT_help,
 	.init		= REDIRECT_init,
  	.parse		= REDIRECT_parse,
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index dabdb3f..a07d9f4 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
-#include <linux/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat.h>
 /* For 64bit kernel / 32bit userspace */
 #include <linux/netfilter_ipv4/ipt_SAME.h>
 
@@ -44,7 +44,7 @@ static void SAME_init(struct xt_entry_target *t)
 
 /* Parses range of IPs */
 static void
-parse_to(char *arg, struct ip_nat_range *range)
+parse_to(char *arg, struct nf_nat_range *range)
 {
 	char *dash;
 	const struct in_addr *ip;
@@ -145,7 +145,7 @@ static void SAME_print(const void *ip, const struct xt_entry_target *target,
 	printf("same:");
 	
 	for (count = 0; count < mr->rangesize; count++) {
-		struct ip_nat_range *r = &mr->range[count];
+		struct nf_nat_range *r = &mr->range[count];
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
@@ -176,7 +176,7 @@ static void SAME_save(const void *ip, const struct xt_entry_target *target)
 	int random_selection = 0;
 
 	for (count = 0; count < mr->rangesize; count++) {
-		struct ip_nat_range *r = &mr->range[count];
+		struct nf_nat_range *r = &mr->range[count];
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index fda03ea..944fe67 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -6,8 +6,9 @@
 #include <getopt.h>
 #include <xtables.h>
 #include <iptables.h>
+#include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat.h>
 
 #define IPT_SNAT_OPT_SOURCE 0x01
 #define IPT_SNAT_OPT_RANDOM 0x02
@@ -17,7 +18,7 @@
 struct ipt_natinfo
 {
 	struct xt_entry_target t;
-	struct ip_nat_multi_range mr;
+	struct nf_nat_multi_range mr;
 };
 
 static void SNAT_help(void)
@@ -36,7 +37,7 @@ static const struct option SNAT_opts[] = {
 };
 
 static struct ipt_natinfo *
-append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
+append_range(struct ipt_natinfo *info, const struct nf_nat_range *range)
 {
 	unsigned int size;
 
@@ -58,7 +59,7 @@ append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
 static struct xt_entry_target *
 parse_to(char *arg, int portok, struct ipt_natinfo *info)
 {
-	struct ip_nat_range range;
+	struct nf_nat_range range;
 	char *colon, *dash, *error;
 	const struct in_addr *ip;
 
@@ -190,7 +191,7 @@ static void SNAT_check(unsigned int flags)
 			   "You must specify --to-source");
 }
 
-static void print_range(const struct ip_nat_range *r)
+static void print_range(const struct nf_nat_range *r)
 {
 	if (r->flags & IP_NAT_RANGE_MAP_IPS) {
 		struct in_addr a;
@@ -243,8 +244,8 @@ static struct xtables_target snat_tg_reg = {
 	.name		= "SNAT",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
+	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
 	.help		= SNAT_help,
 	.parse		= SNAT_parse,
 	.final_check	= SNAT_check,
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 7dac0b7..15c1787 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -5,6 +5,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <xtables.h>
+#include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 /* special hack for icmp-type 'any': 
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 54b9e2c..c3c8bb9 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -8,6 +8,7 @@
 #include <xtables.h>
 #include <libiptc/libiptc.h>
 #include <libiptc/libip6tc.h>
+#include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/xt_multiport.h>
diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 3f1eadb..33ec69d 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -4,6 +4,11 @@
 
 #include <linux/types.h>
 #include <libiptc/ipt_kernel_headers.h>
+#ifdef __cplusplus
+#	include <climits>
+#else
+#	include <limits.h> /* INT_MAX in ip6_tables.h */
+#endif
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
 #ifndef IP6T_MIN_ALIGN
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index 482b11d..5d782da 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -4,6 +4,11 @@
 
 #include <linux/types.h>
 #include <libiptc/ipt_kernel_headers.h>
+#ifdef __cplusplus
+#	include <climits>
+#else
+#	include <limits.h> /* INT_MAX in ip_tables.h */
+#endif
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 #ifdef __cplusplus
diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index b887a99..d766ef1 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -122,7 +122,7 @@ enum ip_conntrack_events
 	IPCT_NATINFO_BIT = 10,
 	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
 
-	/* Counter highest bit has been set */
+	/* Counter highest bit has been set, unused */
 	IPCT_COUNTER_FILLING_BIT = 11,
 	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
 
diff --git a/include/linux/netfilter/nf_conntrack_tuple.h b/include/linux/netfilter/nf_conntrack_tuple.h
deleted file mode 100644
index cd5044e..0000000
--- a/include/linux/netfilter/nf_conntrack_tuple.h
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- * Definitions and Declarations for tuple.
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- generalize L3 protocol dependent part.
- *
- * Derived from include/linux/netfiter_ipv4/ip_conntrack_tuple.h
- */
-
-#ifndef _NF_CONNTRACK_TUPLE_H
-#define _NF_CONNTRACK_TUPLE_H
-
-#include <linux/netfilter/nf_conntrack_tuple_common.h>
-
-/* A `tuple' is a structure containing the information to uniquely
-  identify a connection.  ie. if two packets have the same tuple, they
-  are in the same connection; if not, they are not.
-
-  We divide the structure along "manipulatable" and
-  "non-manipulatable" lines, for the benefit of the NAT code.
-*/
-
-#define NF_CT_TUPLE_L3SIZE	4
-
-/* The l3 protocol-specific manipulable parts of the tuple: always in
-   network order! */
-union nf_conntrack_address {
-	u_int32_t all[NF_CT_TUPLE_L3SIZE];
-	__be32 ip;
-	__be32 ip6[4];
-};
-
-/* The protocol-specific manipulable parts of the tuple: always in
-   network order! */
-union nf_conntrack_man_proto
-{
-	/* Add other protocols here. */
-	u_int16_t all;
-
-	struct {
-		__be16 port;
-	} tcp;
-	struct {
-		__be16 port;
-	} udp;
-	struct {
-		__be16 id;
-	} icmp;
-	struct {
-		__be16 port;
-	} sctp;
-	struct {
-		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
-	} gre;
-};
-
-/* The manipulable part of the tuple. */
-struct nf_conntrack_man
-{
-	union nf_conntrack_address u3;
-	union nf_conntrack_man_proto u;
-	/* Layer 3 protocol */
-	u_int16_t l3num;
-};
-
-/* This contains the information to distinguish a connection. */
-struct nf_conntrack_tuple
-{
-	struct nf_conntrack_man src;
-
-	/* These are the parts of the tuple which are fixed. */
-	struct {
-		union nf_conntrack_address u3;
-		union {
-			/* Add other protocols here. */
-			u_int16_t all;
-
-			struct {
-				__be16 port;
-			} tcp;
-			struct {
-				__be16 port;
-			} udp;
-			struct {
-				u_int8_t type, code;
-			} icmp;
-			struct {
-				__be16 port;
-			} sctp;
-			struct {
-				__be16 key;
-			} gre;
-		} u;
-
-		/* The protocol. */
-		u_int8_t protonum;
-
-		/* The direction (for tuplehash) */
-		u_int8_t dir;
-	} dst;
-};
-
-#endif /* _NF_CONNTRACK_TUPLE_H */
diff --git a/include/linux/netfilter/nf_nat.h b/include/linux/netfilter/nf_nat.h
deleted file mode 100644
index 5d3b5e0..0000000
--- a/include/linux/netfilter/nf_nat.h
+++ /dev/null
@@ -1,45 +0,0 @@
-#ifndef _NF_NAT_H
-#define _NF_NAT_H
-#include <linux/netfilter_ipv4.h>
-#include <linux/netfilter/nf_conntrack_tuple.h>
-
-#define NF_NAT_MAPPING_TYPE_MAX_NAMELEN 16
-
-enum nf_nat_manip_type
-{
-	IP_NAT_MANIP_SRC,
-	IP_NAT_MANIP_DST
-};
-
-/* SRC manip occurs POST_ROUTING or LOCAL_IN */
-#define HOOK2MANIP(hooknum) ((hooknum) != NF_IP_POST_ROUTING && (hooknum) != NF_IP_LOCAL_IN)
-
-#define IP_NAT_RANGE_MAP_IPS 1
-#define IP_NAT_RANGE_PROTO_SPECIFIED 2
-#define IP_NAT_RANGE_PROTO_RANDOM 4
-
-/* Single range specification. */
-struct nf_nat_range
-{
-	/* Set to OR of flags above. */
-	unsigned int flags;
-
-	/* Inclusive: network order. */
-	__be32 min_ip, max_ip;
-
-	/* Inclusive: network order */
-	union nf_conntrack_man_proto min, max;
-};
-
-/* For backwards compat: don't use in modern code. */
-struct nf_nat_multi_range_compat
-{
-	unsigned int rangesize; /* Must be 1. */
-
-	/* hangs off end. */
-	struct nf_nat_range range[1];
-};
-
-#define ip_nat_range nf_nat_range
-#define ip_nat_multi_range nf_nat_multi_range_compat
-#endif
diff --git a/include/linux/netfilter/xt_NFLOG.h b/include/linux/netfilter/xt_NFLOG.h
index 4b36aeb..cdcd0ed 100644
--- a/include/linux/netfilter/xt_NFLOG.h
+++ b/include/linux/netfilter/xt_NFLOG.h
@@ -2,7 +2,7 @@
 #define _XT_NFLOG_TARGET
 
 #define XT_NFLOG_DEFAULT_GROUP		0x1
-#define XT_NFLOG_DEFAULT_THRESHOLD	0
+#define XT_NFLOG_DEFAULT_THRESHOLD	1
 
 #define XT_NFLOG_MASK			0x0
 
diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 90ae8b4..9ba54e4 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -5,12 +5,15 @@ struct xt_connlimit_data;
 
 struct xt_connlimit_info {
 	union {
-		u_int32_t v4_mask;
-		u_int32_t v6_mask[4];
+		union nf_inet_addr mask;
+		union {
+			__be32 v4_mask;
+			__be32 v6_mask[4];
+		};
 	};
 	unsigned int limit, inverse;
 
-	/* this needs to be at the end */
+	/* Used internally by the kernel */
 	struct xt_connlimit_data *data __attribute__((aligned(8)));
 };
 
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index f3fd83e..8f53452 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -5,6 +5,7 @@
 #ifndef _XT_CONNTRACK_H
 #define _XT_CONNTRACK_H
 
+#include <linux/types.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 
 #define XT_CONNTRACK_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index acd7fd7..4c8368d 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -9,6 +9,8 @@ enum xt_quota_flags {
 struct xt_quota_info {
 	u_int32_t		flags;
 	u_int32_t		pad;
+
+	/* Used internally by the kernel */
 	aligned_u64		quota;
 	struct xt_quota_info	*master;
 };
diff --git a/include/linux/netfilter/xt_sctp.h b/include/linux/netfilter/xt_sctp.h
index 62ffdcb..d41af84 100644
--- a/include/linux/netfilter/xt_sctp.h
+++ b/include/linux/netfilter/xt_sctp.h
@@ -7,10 +7,6 @@
 
 #define XT_SCTP_VALID_FLAGS		0x07
 
-/* temporary */
-#define SCTP_ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
-
-
 struct xt_sctp_flag_info {
 	u_int8_t chunktype;
 	u_int8_t flag;
@@ -67,8 +63,8 @@ struct xt_sctp_info {
 	memcpy((destmap), (srcmap), sizeof(srcmap))
 
 #define SCTP_CHUNKMAP_IS_CLEAR(chunkmap) \
-	__sctp_chunkmap_is_clear((chunkmap), SCTP_ARRAY_SIZE(chunkmap))
-static inline bool
+	__sctp_chunkmap_is_clear((chunkmap), ARRAY_SIZE(chunkmap))
+static __inline__ bool
 __sctp_chunkmap_is_clear(const u_int32_t *chunkmap, unsigned int n)
 {
 	unsigned int i;
@@ -80,7 +76,7 @@ __sctp_chunkmap_is_clear(const u_int32_t *chunkmap, unsigned int n)
 
 #define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
 	__sctp_chunkmap_is_all_set((chunkmap), ARRAY_SIZE(chunkmap))
-static inline bool
+static __inline__ bool
 __sctp_chunkmap_is_all_set(const u_int32_t *chunkmap, unsigned int n)
 {
 	unsigned int i;
diff --git a/include/linux/netfilter/xt_string.h b/include/linux/netfilter/xt_string.h
index f1c182f..8a6ba7b 100644
--- a/include/linux/netfilter/xt_string.h
+++ b/include/linux/netfilter/xt_string.h
@@ -6,7 +6,7 @@
 
 enum {
 	XT_STRING_FLAG_INVERT		= 0x01,
-	XT_STRING_FLAG_IGNORECASE 	= 0x02
+	XT_STRING_FLAG_IGNORECASE	= 0x02
 };
 
 struct xt_string_info
@@ -18,11 +18,11 @@ struct xt_string_info
 	u_int8_t  patlen;
 	union {
 		struct {
-			u_int8_t invert;
+			u_int8_t  invert;
 		} v0;
 
 		struct {
-			u_int8_t flags;
+			u_int8_t  flags;
 		} v1;
 	} u;
 
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index fc64b97..a9f21c9 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -15,6 +15,8 @@
 #ifndef _IPTABLES_H
 #define _IPTABLES_H
 
+#include <linux/types.h>
+
 #include <linux/netfilter_ipv4.h>
 
 #include <linux/netfilter/x_tables.h>
diff --git a/include/linux/netfilter_ipv4/ipt_SAME.h b/include/linux/netfilter_ipv4/ipt_SAME.h
index cc4c0b2..be6e682 100644
--- a/include/linux/netfilter_ipv4/ipt_SAME.h
+++ b/include/linux/netfilter_ipv4/ipt_SAME.h
@@ -13,7 +13,7 @@ struct ipt_same_info
 	u_int32_t *iparray;
 
 	/* hangs off end. */
-	struct ip_nat_range range[IPT_SAME_MAX_RANGE];
+	struct nf_nat_range range[IPT_SAME_MAX_RANGE];
 };
 
 #endif /*_IPT_SAME_H*/
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 68b22fc..70ed8a1 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -15,6 +15,8 @@
 #ifndef _IP6_TABLES_H
 #define _IP6_TABLES_H
 
+#include <linux/types.h>
+
 #include <linux/netfilter_ipv6.h>
 
 #include <linux/netfilter/x_tables.h>
diff --git a/include/linux/netfilter_ipv6/ip6t_TCPMSS.h b/include/linux/netfilter_ipv6/ip6t_TCPMSS.h
deleted file mode 100644
index 412d1cb..0000000
--- a/include/linux/netfilter_ipv6/ip6t_TCPMSS.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _IP6T_TCPMSS_H
-#define _IP6T_TCPMSS_H
-
-struct ip6t_tcpmss_info {
-	u_int16_t mss;
-};
-
-#define IP6T_TCPMSS_CLAMP_PMTU 0xffff
-
-#endif /*_IP6T_TCPMSS_H*/
diff --git a/include/linux/types.h b/include/linux/types.h
index d9e8c4f..eb6a9be 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -108,19 +108,14 @@ typedef		__s64		int64_t;
  *
  * Linux always considers sectors to be 512 bytes long independently
  * of the devices real block size.
+ *
+ * blkcnt_t is the type of the inode's block count.
  */
 #ifdef CONFIG_LBD
 typedef u64 sector_t;
-#else
-typedef unsigned long sector_t;
-#endif
-
-/*
- * The type of the inode's block count.
- */
-#ifdef CONFIG_LSF
 typedef u64 blkcnt_t;
 #else
+typedef unsigned long sector_t;
 typedef unsigned long blkcnt_t;
 #endif
 
@@ -154,19 +149,11 @@ typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
 typedef __u32 __bitwise __le32;
 typedef __u32 __bitwise __be32;
-#if defined(__GNUC__)
 typedef __u64 __bitwise __le64;
 typedef __u64 __bitwise __be64;
-#endif
+
 typedef __u16 __bitwise __sum16;
 typedef __u32 __bitwise __wsum;
 
 
-struct ustat {
-	__kernel_daddr_t	f_tfree;
-	__kernel_ino_t		f_tinode;
-	char			f_fname[6];
-	char			f_fpack[6];
-};
-
 #endif /* _LINUX_TYPES_H */
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
new file mode 100644
index 0000000..c40e0b4
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -0,0 +1,114 @@
+/* This file was manually copied from the Linux kernel source
+ * and manually stripped from __KERNEL__ sections and unused functions.
+ */
+
+/*
+ * Definitions and Declarations for tuple.
+ *
+ * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
+ *	- generalize L3 protocol dependent part.
+ *
+ * Derived from include/linux/netfiter_ipv4/ip_conntrack_tuple.h
+ */
+
+#ifndef _NF_CONNTRACK_TUPLE_H
+#define _NF_CONNTRACK_TUPLE_H
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+
+/* A `tuple' is a structure containing the information to uniquely
+  identify a connection.  ie. if two packets have the same tuple, they
+  are in the same connection; if not, they are not.
+
+  We divide the structure along "manipulatable" and
+  "non-manipulatable" lines, for the benefit of the NAT code.
+*/
+
+#define NF_CT_TUPLE_L3SIZE	ARRAY_SIZE(((union nf_inet_addr *)NULL)->all)
+
+/* The protocol-specific manipulable parts of the tuple: always in
+   network order! */
+union nf_conntrack_man_proto
+{
+	/* Add other protocols here. */
+	__be16 all;
+
+	struct {
+		__be16 port;
+	} tcp;
+	struct {
+		__be16 port;
+	} udp;
+	struct {
+		__be16 id;
+	} icmp;
+	struct {
+		__be16 port;
+	} dccp;
+	struct {
+		__be16 port;
+	} sctp;
+	struct {
+		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
+	} gre;
+};
+
+/* The manipulable part of the tuple. */
+struct nf_conntrack_man
+{
+	union nf_inet_addr u3;
+	union nf_conntrack_man_proto u;
+	/* Layer 3 protocol */
+	u_int16_t l3num;
+};
+
+/* This contains the information to distinguish a connection. */
+struct nf_conntrack_tuple
+{
+	struct nf_conntrack_man src;
+
+	/* These are the parts of the tuple which are fixed. */
+	struct {
+		union nf_inet_addr u3;
+		union {
+			/* Add other protocols here. */
+			__be16 all;
+
+			struct {
+				__be16 port;
+			} tcp;
+			struct {
+				__be16 port;
+			} udp;
+			struct {
+				u_int8_t type, code;
+			} icmp;
+			struct {
+				__be16 port;
+			} dccp;
+			struct {
+				__be16 port;
+			} sctp;
+			struct {
+				__be16 key;
+			} gre;
+		} u;
+
+		/* The protocol. */
+		u_int8_t protonum;
+
+		/* The direction (for tuplehash) */
+		u_int8_t dir;
+	} dst;
+};
+
+struct nf_conntrack_tuple_mask
+{
+	struct {
+		union nf_inet_addr u3;
+		union nf_conntrack_man_proto u;
+	} src;
+};
+
+#endif /* _NF_CONNTRACK_TUPLE_H */
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
new file mode 100644
index 0000000..094473e
--- /dev/null
+++ b/include/net/netfilter/nf_nat.h
@@ -0,0 +1,54 @@
+#ifndef _NF_NAT_H
+#define _NF_NAT_H
+#include <linux/netfilter_ipv4.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+#define NF_NAT_MAPPING_TYPE_MAX_NAMELEN 16
+
+enum nf_nat_manip_type
+{
+	IP_NAT_MANIP_SRC,
+	IP_NAT_MANIP_DST
+};
+
+/* SRC manip occurs POST_ROUTING or LOCAL_IN */
+#define HOOK2MANIP(hooknum) ((hooknum) != NF_INET_POST_ROUTING && \
+			     (hooknum) != NF_INET_LOCAL_IN)
+
+#define IP_NAT_RANGE_MAP_IPS 1
+#define IP_NAT_RANGE_PROTO_SPECIFIED 2
+#define IP_NAT_RANGE_PROTO_RANDOM 4
+
+/* NAT sequence number modifications */
+struct nf_nat_seq {
+	/* position of the last TCP sequence number modification (if any) */
+	u_int32_t correction_pos;
+
+	/* sequence number offset before and after last modification */
+	int16_t offset_before, offset_after;
+};
+
+/* Single range specification. */
+struct nf_nat_range
+{
+	/* Set to OR of flags above. */
+	unsigned int flags;
+
+	/* Inclusive: network order. */
+	__be32 min_ip, max_ip;
+
+	/* Inclusive: network order */
+	union nf_conntrack_man_proto min, max;
+};
+
+/* For backwards compat: don't use in modern code. */
+struct nf_nat_multi_range_compat
+{
+	unsigned int rangesize; /* Must be 1. */
+
+	/* hangs off end. */
+	struct nf_nat_range range[1];
+};
+
+#define nf_nat_multi_range nf_nat_multi_range_compat
+#endif
diff --git a/iptables.c b/iptables.c
index 8e37bee..3449dec 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1818,10 +1818,9 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	if (strcmp(*table, "nat") == 0 &&
 	    ((policy != NULL && strcmp(policy, "DROP") == 0) ||
 	    (jumpto != NULL && strcmp(jumpto, "DROP") == 0)))
-		fprintf(stderr, "\nThe \"nat\" table is not intended for "
-		        "filtering, hence the use of DROP is deprecated and "
-		        "will permanently be disabled in the next iptables "
-		        "release. Please adjust your scripts.\n\n");
+		xtables_error(PARAMETER_PROBLEM,
+			"\nThe \"nat\" table is not intended for filtering, "
+		        "the use of DROP is therefore inhibited.\n\n");
 
 	for (matchp = matches; matchp; matchp = matchp->next)
 		if (matchp->match->final_check != NULL)
diff --git a/xtables.c b/xtables.c
index f305673..1214127 100644
--- a/xtables.c
+++ b/xtables.c
@@ -32,6 +32,7 @@
 #include <arpa/inet.h>
 
 #include <xtables.h>
+#include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <libiptc/libxtc.h>
