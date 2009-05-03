From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/9] extensions: switch numeric to bool
Date: Sun,  3 May 2009 21:54:28 +0200
Message-ID: <1241380473-22262-5-git-send-email-jengelh@medozas.de>
References: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34571 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbZECTyg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 May 2009 15:54:36 -0400
In-Reply-To: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac                    |    2 +-
 extensions/libip6t_HL.c         |    3 ++-
 extensions/libip6t_LOG.c        |    3 ++-
 extensions/libip6t_REJECT.c     |    3 ++-
 extensions/libip6t_ah.c         |    3 ++-
 extensions/libip6t_dst.c        |    3 ++-
 extensions/libip6t_frag.c       |    3 ++-
 extensions/libip6t_hbh.c        |    3 ++-
 extensions/libip6t_hl.c         |    3 ++-
 extensions/libip6t_icmp6.c      |    5 +++--
 extensions/libip6t_ipv6header.c |    3 ++-
 extensions/libip6t_mh.c         |    7 ++++---
 extensions/libip6t_policy.c     |    9 +++++----
 extensions/libip6t_rt.c         |    3 ++-
 extensions/libipt_CLUSTERIP.c   |    3 ++-
 extensions/libipt_DNAT.c        |    3 ++-
 extensions/libipt_ECN.c         |    3 ++-
 extensions/libipt_LOG.c         |    3 ++-
 extensions/libipt_MASQUERADE.c  |    3 ++-
 extensions/libipt_NETMAP.c      |    5 +++--
 extensions/libipt_REDIRECT.c    |    3 ++-
 extensions/libipt_REJECT.c      |    3 ++-
 extensions/libipt_SAME.c        |    3 ++-
 extensions/libipt_SET.c         |    3 ++-
 extensions/libipt_SNAT.c        |    3 ++-
 extensions/libipt_TTL.c         |    3 ++-
 extensions/libipt_ULOG.c        |    3 ++-
 extensions/libipt_addrtype.c    |    5 +++--
 extensions/libipt_ah.c          |    3 ++-
 extensions/libipt_ecn.c         |    3 ++-
 extensions/libipt_icmp.c        |    5 +++--
 extensions/libipt_policy.c      |    9 +++++----
 extensions/libipt_realm.c       |    7 ++++---
 extensions/libipt_set.c         |    3 ++-
 extensions/libipt_ttl.c         |    3 ++-
 extensions/libxt_CLASSIFY.c     |    5 +++--
 extensions/libxt_CONNMARK.c     |    5 +++--
 extensions/libxt_CONNSECMARK.c  |    3 ++-
 extensions/libxt_DSCP.c         |    5 +++--
 extensions/libxt_MARK.c         |    6 +++---
 extensions/libxt_NFLOG.c        |    3 ++-
 extensions/libxt_NFQUEUE.c      |    3 ++-
 extensions/libxt_RATEEST.c      |    3 ++-
 extensions/libxt_SECMARK.c      |    3 ++-
 extensions/libxt_TCPMSS.c       |    3 ++-
 extensions/libxt_TCPOPTSTRIP.c  |    2 +-
 extensions/libxt_TOS.c          |    5 +++--
 extensions/libxt_TPROXY.c       |    2 +-
 extensions/libxt_comment.c      |    3 ++-
 extensions/libxt_connbytes.c    |    4 +++-
 extensions/libxt_connlimit.c    |    5 +++--
 extensions/libxt_connmark.c     |    7 +++++--
 extensions/libxt_conntrack.c    |   11 ++++++-----
 extensions/libxt_dccp.c         |   14 ++++++++------
 extensions/libxt_dscp.c         |    3 ++-
 extensions/libxt_esp.c          |    3 ++-
 extensions/libxt_hashlimit.c    |    6 +++---
 extensions/libxt_helper.c       |    3 ++-
 extensions/libxt_iprange.c      |    7 ++++---
 extensions/libxt_length.c       |    3 ++-
 extensions/libxt_limit.c        |    3 ++-
 extensions/libxt_mac.c          |    3 ++-
 extensions/libxt_mark.c         |    4 ++--
 extensions/libxt_multiport.c    |   21 ++++++++++++---------
 extensions/libxt_owner.c        |    6 +++---
 extensions/libxt_physdev.c      |    3 ++-
 extensions/libxt_pkttype.c      |    3 ++-
 extensions/libxt_quota.c        |    3 ++-
 extensions/libxt_rateest.c      |    5 +++--
 extensions/libxt_recent.c       |    3 ++-
 extensions/libxt_sctp.c         |   15 ++++++++-------
 extensions/libxt_state.c        |    3 ++-
 extensions/libxt_statistic.c    |    4 +++-
 extensions/libxt_string.c       |    3 ++-
 extensions/libxt_tcp.c          |   11 ++++++-----
 extensions/libxt_tcpmss.c       |    3 ++-
 extensions/libxt_time.c         |    2 +-
 extensions/libxt_tos.c          |    4 ++--
 extensions/libxt_u32.c          |    3 ++-
 extensions/libxt_udp.c          |    7 ++++---
 include/xtables.h.in            |    4 ++--
 ip6tables.c                     |    7 ++++---
 iptables.c                      |    7 ++++---
 83 files changed, 228 insertions(+), 148 deletions(-)

diff --git a/configure.ac b/configure.ac
index c3a8c6c..a082932 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ AC_INIT([iptables], [1.4.3.2])
=20
 # See libtool.info "Libtool's versioning system"
 libxtables_vcurrent=3D3
-libxtables_vage=3D1
+libxtables_vage=3D0
=20
 AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_MACRO_DIR([m4])
diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 12d8e72..1cf5358 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -6,6 +6,7 @@
  */
=20
 #include <getopt.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -110,7 +111,7 @@ static void HL_save(const void *ip, const struct xt=
_entry_target *target)
 }
=20
 static void HL_print(const void *ip, const struct xt_entry_target *tar=
get,
-                     int numeric)
+                     bool numeric)
 {
 	const struct ip6t_HL_info *info =3D
 		(struct ip6t_HL_info *) target->data;
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 390cb97..a616694 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add LOG support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -190,7 +191,7 @@ static int LOG_parse(int c, char **argv, int invert=
, unsigned int *flags,
 }
=20
 static void LOG_print(const void *ip, const struct xt_entry_target *ta=
rget,
-                      int numeric)
+                      bool numeric)
 {
 	const struct ip6t_log_info *loginfo
 		=3D (const struct ip6t_log_info *)target->data;
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 527f595..846e61e 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -5,6 +5,7 @@
  * ported to IPv6 by Harald Welte <laforge@gnumonks.org>
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -103,7 +104,7 @@ static int REJECT_parse(int c, char **argv, int inv=
ert, unsigned int *flags,
 }
=20
 static void REJECT_print(const void *ip, const struct xt_entry_target =
*target,
-                         int numeric)
+                         bool numeric)
 {
 	const struct ip6t_reject_info *reject
 		=3D (const struct ip6t_reject_info *)target->data;
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 19b7ad4..cc3e5cb 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add AH support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -140,7 +141,7 @@ print_len(const char *name, u_int32_t len, int inve=
rt)
 }
=20
 static void ah_print(const void *ip, const struct xt_entry_match *matc=
h,
-                     int numeric)
+                     bool numeric)
 {
 	const struct ip6t_ah *ah =3D (struct ip6t_ah *)match->data;
=20
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index a47e3a3..b907225 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add Dst header support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -178,7 +179,7 @@ print_options(unsigned int optsnr, u_int16_t *optsp=
)
 }
=20
 static void dst_print(const void *ip, const struct xt_entry_match *mat=
ch,
-                      int numeric)
+                      bool numeric)
 {
 	const struct ip6t_opts *optinfo =3D (struct ip6t_opts *)match->data;
=20
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 905b494..946b8e2 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add Fragmentation header supp=
ort. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -163,7 +164,7 @@ print_ids(const char *name, u_int32_t min, u_int32_=
t max,
 }
=20
 static void frag_print(const void *ip, const struct xt_entry_match *ma=
tch,
-                       int numeric)
+                       bool numeric)
 {
 	const struct ip6t_frag *frag =3D (struct ip6t_frag *)match->data;
=20
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index e08d84a..18f60b2 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add Hop-by-Hop header support=
=2E */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -171,7 +172,7 @@ print_options(unsigned int optsnr, u_int16_t *optsp=
)
 }
=20
 static void hbh_print(const void *ip, const struct xt_entry_match *mat=
ch,
-                      int numeric)
+                      bool numeric)
 {
 	const struct ip6t_opts *optinfo =3D (struct ip6t_opts *)match->data;
=20
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 9252c3d..117bfb8 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -6,6 +6,7 @@
  * Cleanups by Stephane Ouellette <ouellettes@videotron.ca>
  */
=20
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -87,7 +88,7 @@ static void hl_check(unsigned int flags)
 }
=20
 static void hl_print(const void *ip, const struct xt_entry_match *matc=
h,
-                     int numeric)
+                     bool numeric)
 {
 	static const char *op[] =3D {
 		[IP6T_HL_EQ] =3D "=3D=3D",
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 0678aac..7ef63e2 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add ICMP support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -176,7 +177,7 @@ static int icmp6_parse(int c, char **argv, int inve=
rt, unsigned int *flags,
 static void print_icmpv6type(u_int8_t type,
 			   u_int8_t code_min, u_int8_t code_max,
 			   int invert,
-			   int numeric)
+			   bool numeric)
 {
 	if (!numeric) {
 		unsigned int i;
@@ -211,7 +212,7 @@ static void print_icmpv6type(u_int8_t type,
 }
=20
 static void icmp6_print(const void *ip, const struct xt_entry_match *m=
atch,
-                        int numeric)
+                        bool numeric)
 {
 	const struct ip6t_icmp *icmpv6 =3D (struct ip6t_icmp *)match->data;
=20
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6h=
eader.c
index 479b313..8be284d 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -6,6 +6,7 @@ on whether they contain certain headers */
=20
 #include <getopt.h>
 #include <xtables.h>
+#include <stdbool.h>
 #include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -244,7 +245,7 @@ print_header(u_int8_t flags){
 }
=20
 static void ipv6header_print(const void *ip,
-                             const struct xt_entry_match *match, int n=
umeric)
+                             const struct xt_entry_match *match, bool =
numeric)
 {
 	const struct ip6t_ipv6header_info *info =3D (const struct ip6t_ipv6he=
ader_info *)match->data;
 	printf("ipv6header ");
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 9711f76..d63110a 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -11,6 +11,7 @@
  *
  * Based on libip6t_{icmpv6,udp}.c
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -159,7 +160,7 @@ static const char *type_to_name(u_int8_t type)
 	return NULL;
 }
=20
-static void print_type(u_int8_t type, int numeric)
+static void print_type(u_int8_t type, bool numeric)
 {
 	const char *name;
 	if (numeric || !(name =3D type_to_name(type)))
@@ -168,7 +169,7 @@ static void print_type(u_int8_t type, int numeric)
 		printf("%s", name);
 }
=20
-static void print_types(u_int8_t min, u_int8_t max, int invert, int nu=
meric)
+static void print_types(u_int8_t min, u_int8_t max, int invert, bool n=
umeric)
 {
 	const char *inv =3D invert ? "!" : "";
=20
@@ -187,7 +188,7 @@ static void print_types(u_int8_t min, u_int8_t max,=
 int invert, int numeric)
 }
=20
 static void mh_print(const void *ip, const struct xt_entry_match *matc=
h,
-                     int numeric)
+                     bool numeric)
 {
 	const struct ip6t_mh *mhinfo =3D (struct ip6t_mh *)match->data;
=20
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 5106c28..3efffe0 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add policy support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -329,7 +330,7 @@ static void policy_check(unsigned int flags)
 	}
 }
=20
-static void print_mode(char *prefix, u_int8_t mode, int numeric)
+static void print_mode(char *prefix, u_int8_t mode, bool numeric)
 {
 	printf("%smode ", prefix);
=20
@@ -346,7 +347,7 @@ static void print_mode(char *prefix, u_int8_t mode,=
 int numeric)
 	}
 }
=20
-static void print_proto(char *prefix, u_int8_t proto, int numeric)
+static void print_proto(char *prefix, u_int8_t proto, bool numeric)
 {
 	struct protoent *p =3D NULL;
=20
@@ -366,7 +367,7 @@ do {				\
 } while(0)
=20
 static void print_entry(char *prefix, const struct ip6t_policy_elem *e=
,
-                        int numeric)
+                        bool numeric)
 {
 	if (e->match.reqid) {
 		PRINT_INVERT(e->invert.reqid);
@@ -415,7 +416,7 @@ static void print_flags(char *prefix, const struct =
ip6t_policy_info *info)
 }
=20
 static void policy_print(const void *ip, const struct xt_entry_match *=
match,
-                         int numeric)
+                         bool numeric)
 {
 	const struct ip6t_policy_info *info =3D (void *)match->data;
 	unsigned int i;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index c9bf994..a242ea2 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add Routing header support. *=
/
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -261,7 +262,7 @@ print_addresses(unsigned int addrnr, struct in6_add=
r *addrp)
 }
=20
 static void rt_print(const void *ip, const struct xt_entry_match *matc=
h,
-                     int numeric)
+                     bool numeric)
 {
 	const struct ip6t_rt *rtinfo =3D (struct ip6t_rt *)match->data;
=20
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERI=
P.c
index 279aacf..874e0bb 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -3,6 +3,7 @@
  *
  * Development of this code was funded by SuSE AG, http://www.suse.com=
/
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -193,7 +194,7 @@ static char *mac2str(const u_int8_t mac[ETH_ALEN])
 }
=20
 static void CLUSTERIP_print(const void *ip,
-                            const struct xt_entry_target *target, int =
numeric)
+                            const struct xt_entry_target *target, bool=
 numeric)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo =3D
 		(const struct ipt_clusterip_tgt_info *)target->data;
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index dc79b44..aad4f61 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add destination-NAT support. *=
/
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -217,7 +218,7 @@ static void print_range(const struct nf_nat_range *=
r)
 }
=20
 static void DNAT_print(const void *ip, const struct xt_entry_target *t=
arget,
-                       int numeric)
+                       bool numeric)
 {
 	struct ipt_natinfo *info =3D (void *)target;
 	unsigned int i =3D 0;
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index bf1f8a5..52ccd0f 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -8,6 +8,7 @@
  *
  * $Id$
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -104,7 +105,7 @@ static void ECN_check(unsigned int flags)
 }
=20
 static void ECN_print(const void *ip, const struct xt_entry_target *ta=
rget,
-                      int numeric)
+                      bool numeric)
 {
 	const struct ipt_ECN_info *einfo =3D
 		(const struct ipt_ECN_info *)target->data;
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index ebcb574..07c7e5e 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add LOG support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -190,7 +191,7 @@ static int LOG_parse(int c, char **argv, int invert=
, unsigned int *flags,
 }
=20
 static void LOG_print(const void *ip, const struct xt_entry_target *ta=
rget,
-                      int numeric)
+                      bool numeric)
 {
 	const struct ipt_log_info *loginfo
 		=3D (const struct ipt_log_info *)target->data;
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUER=
ADE.c
index 82c2230..d7e2c8c 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add masquerade support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -109,7 +110,7 @@ static int MASQUERADE_parse(int c, char **argv, int=
 invert, unsigned int *flags,
=20
 static void
 MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
-                 int numeric)
+                 bool numeric)
 {
 	struct nf_nat_multi_range *mr
 		=3D (struct nf_nat_multi_range *)target->data;
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 9820230..5974bf5 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -2,6 +2,7 @@
    Author: Svenning Soerensen <svenning@post5.tele.dk>
 */
=20
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -138,7 +139,7 @@ static void NETMAP_check(unsigned int flags)
 }
=20
 static void NETMAP_print(const void *ip, const struct xt_entry_target =
*target,
-                         int numeric)
+                         bool numeric)
 {
 	struct nf_nat_multi_range *mr
 		=3D (struct nf_nat_multi_range *)target->data;
@@ -159,7 +160,7 @@ static void NETMAP_print(const void *ip, const stru=
ct xt_entry_target *target,
 static void NETMAP_save(const void *ip, const struct xt_entry_target *=
target)
 {
 	printf("--%s ", NETMAP_opts[0].name);
-	NETMAP_print(ip, target, 0);
+	NETMAP_print(ip, target, false);
 }
=20
 static struct xtables_target netmap_tg_reg =3D {
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.=
c
index 658f933..a857de3 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add redirect support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -122,7 +123,7 @@ static int REDIRECT_parse(int c, char **argv, int i=
nvert, unsigned int *flags,
 }
=20
 static void REDIRECT_print(const void *ip, const struct xt_entry_targe=
t *target,
-                           int numeric)
+                           bool numeric)
 {
 	struct nf_nat_multi_range *mr
 		=3D (struct nf_nat_multi_range *)target->data;
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 5b23f54..e8737e5 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -2,6 +2,7 @@
  *
  * (C) 2000 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -122,7 +123,7 @@ static int REJECT_parse(int c, char **argv, int inv=
ert, unsigned int *flags,
 }
=20
 static void REJECT_print(const void *ip, const struct xt_entry_target =
*target,
-                         int numeric)
+                         bool numeric)
 {
 	const struct ipt_reject_info *reject
 		=3D (const struct ipt_reject_info *)target->data;
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index a07d9f4..3c361b8 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add simple non load-balancing =
SNAT support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -135,7 +136,7 @@ static void SAME_check(unsigned int flags)
 }
=20
 static void SAME_print(const void *ip, const struct xt_entry_target *t=
arget,
-                       int numeric)
+                       bool numeric)
 {
 	unsigned int count;
 	struct ipt_same_info *mr
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 5da41a0..7cd7882 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -9,6 +9,7 @@
  */
=20
 /* Shared library add-on to iptables to add IP set mangling target. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -127,7 +128,7 @@ print_target(const char *prefix, const struct ipt_s=
et_info *info)
 }
=20
 static void SET_print(const void *ip, const struct xt_entry_target *ta=
rget,
-                      int numeric)
+                      bool numeric)
 {
 	struct ipt_set_info_target *info =3D
 	    (struct ipt_set_info_target *) target->data;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 9609ad9..1d5caa4 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add source-NAT support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -217,7 +218,7 @@ static void print_range(const struct nf_nat_range *=
r)
 }
=20
 static void SNAT_print(const void *ip, const struct xt_entry_target *t=
arget,
-                       int numeric)
+                       bool numeric)
 {
 	struct ipt_natinfo *info =3D (void *)target;
 	unsigned int i =3D 0;
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 0e2be0b..f0bfeab 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -5,6 +5,7 @@
  *
  * This program is distributed under the terms of GNU GPL
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -110,7 +111,7 @@ static void TTL_save(const void *ip, const struct x=
t_entry_target *target)
 }
=20
 static void TTL_print(const void *ip, const struct xt_entry_target *ta=
rget,
-                      int numeric)
+                      bool numeric)
 {
 	const struct ipt_TTL_info *info =3D
 		(struct ipt_TTL_info *) target->data;
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 3fa91f2..333ac88 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -9,6 +9,7 @@
  *=20
  * libipt_ULOG.c,v 1.7 2001/01/30 11:55:02 laforge Exp
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -165,7 +166,7 @@ static void ULOG_save(const void *ip, const struct =
xt_entry_target *target)
 }
=20
 static void ULOG_print(const void *ip, const struct xt_entry_target *t=
arget,
-                       int numeric)
+                       bool numeric)
 {
 	const struct ipt_ulog_info *loginfo
 	    =3D (const struct ipt_ulog_info *) target->data;
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.=
c
index ecd51b5..dca3a0e 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -2,6 +2,7 @@
  *=20
  * This program is released under the terms of GNU GPL */
=20
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -212,7 +213,7 @@ static void print_types(u_int16_t mask)
 }
=20
 static void addrtype_print_v0(const void *ip, const struct xt_entry_ma=
tch *match,
-                              int numeric)
+                              bool numeric)
 {
 	const struct ipt_addrtype_info *info =3D=20
 		(struct ipt_addrtype_info *) match->data;
@@ -233,7 +234,7 @@ static void addrtype_print_v0(const void *ip, const=
 struct xt_entry_match *match
 }
=20
 static void addrtype_print_v1(const void *ip, const struct xt_entry_ma=
tch *match,
-                              int numeric)
+                              bool numeric)
 {
 	const struct ipt_addrtype_info_v1 *info =3D=20
 		(struct ipt_addrtype_info_v1 *) match->data;
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index d049b42..62a5b80 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add AH support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -117,7 +118,7 @@ print_spis(const char *name, u_int32_t min, u_int32=
_t max,
 }
=20
 static void ah_print(const void *ip, const struct xt_entry_match *matc=
h,
-                     int numeric)
+                     bool numeric)
 {
 	const struct ipt_ah *ah =3D (struct ipt_ah *)match->data;
=20
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 3ee190e..ddbaeab 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -7,6 +7,7 @@
  * libipt_ecn.c borrowed heavily from libipt_dscp.c
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -90,7 +91,7 @@ static void ecn_check(unsigned int flags)
 }
=20
 static void ecn_print(const void *ip, const struct xt_entry_match *mat=
ch,
-                      int numeric)
+                      bool numeric)
 {
 	const struct ipt_ecn_info *einfo =3D
 		(const struct ipt_ecn_info *)match->data;
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 15c1787..6524fc9 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add ICMP support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -201,7 +202,7 @@ static int icmp_parse(int c, char **argv, int inver=
t, unsigned int *flags,
 static void print_icmptype(u_int8_t type,
 			   u_int8_t code_min, u_int8_t code_max,
 			   int invert,
-			   int numeric)
+			   bool numeric)
 {
 	if (!numeric) {
 		unsigned int i;
@@ -236,7 +237,7 @@ static void print_icmptype(u_int8_t type,
 }
=20
 static void icmp_print(const void *ip, const struct xt_entry_match *ma=
tch,
-                       int numeric)
+                       bool numeric)
 {
 	const struct ipt_icmp *icmp =3D (struct ipt_icmp *)match->data;
=20
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index ae7282a..ae416ba 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add policy support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -297,7 +298,7 @@ static void policy_check(unsigned int flags)
 	}
 }
=20
-static void print_mode(char *prefix, u_int8_t mode, int numeric)
+static void print_mode(char *prefix, u_int8_t mode, bool numeric)
 {
 	printf("%smode ", prefix);
=20
@@ -314,7 +315,7 @@ static void print_mode(char *prefix, u_int8_t mode,=
 int numeric)
 	}
 }
=20
-static void print_proto(char *prefix, u_int8_t proto, int numeric)
+static void print_proto(char *prefix, u_int8_t proto, bool numeric)
 {
 	struct protoent *p =3D NULL;
=20
@@ -334,7 +335,7 @@ do {				\
 } while(0)
=20
 static void print_entry(char *prefix, const struct ipt_policy_elem *e,
-                        int numeric)
+                        bool numeric)
 {
 	if (e->match.reqid) {
 		PRINT_INVERT(e->invert.reqid);
@@ -383,7 +384,7 @@ static void print_flags(char *prefix, const struct =
ipt_policy_info *info)
 }
=20
 static void policy_print(const void *ip, const struct xt_entry_match *=
match,
-                         int numeric)
+                         bool numeric)
 {
 	const struct ipt_policy_info *info =3D (void *)match->data;
 	unsigned int i;
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 29f6b98..279476e 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add realm matching support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -188,14 +189,14 @@ static int realm_parse(int c, char **argv, int in=
vert, unsigned int *flags,
 }
=20
 static void
-print_realm(unsigned long id, unsigned long mask, int numeric)
+print_realm(unsigned long id, unsigned long mask, bool numeric)
 {
 	const char* name =3D NULL;
=20
 	if (mask !=3D 0xffffffff)
 		printf("0x%lx/0x%lx ", id, mask);
 	else {
-		if (numeric =3D=3D 0)
+		if (!numeric)
 			name =3D realm_id2name(id);
 		if (name)
 			printf("%s ", name);
@@ -205,7 +206,7 @@ print_realm(unsigned long id, unsigned long mask, i=
nt numeric)
 }
=20
 static void realm_print(const void *ip, const struct xt_entry_match *m=
atch,
-                        int numeric)
+                        bool numeric)
 {
 	struct ipt_realm_info *ri =3D (struct ipt_realm_info *) match->data;
=20
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 845b2b0..8a3da13 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -9,6 +9,7 @@
  */
=20
 /* Shared library add-on to iptables to add IP set matching. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -119,7 +120,7 @@ print_match(const char *prefix, const struct ipt_se=
t_info *info)
=20
 /* Prints out the matchinfo. */
 static void set_print(const void *ip, const struct xt_entry_match *mat=
ch,
-                      int numeric)
+                      bool numeric)
 {
 	struct ipt_set_info_match *info =3D=20
 		(struct ipt_set_info_match *) match->data;
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 019a556..860acf2 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -5,6 +5,7 @@
  *
  * This program is released under the terms of GNU GPL */
=20
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -90,7 +91,7 @@ static void ttl_check(unsigned int flags)
 }
=20
 static void ttl_print(const void *ip, const struct xt_entry_match *mat=
ch,
-                      int numeric)
+                      bool numeric)
 {
 	const struct ipt_ttl_info *info =3D=20
 		(struct ipt_ttl_info *) match->data;
diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index 7db2e4c..8708c23 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add CLASSIFY target support. *=
/
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -69,7 +70,7 @@ CLASSIFY_final_check(unsigned int flags)
 }
=20
 static void
-CLASSIFY_print_class(unsigned int priority, int numeric)
+CLASSIFY_print_class(unsigned int priority, bool numeric)
 {
 	printf("%x:%x ", TC_H_MAJ(priority)>>16, TC_H_MIN(priority));
 }
@@ -77,7 +78,7 @@ CLASSIFY_print_class(unsigned int priority, int numer=
ic)
 static void
 CLASSIFY_print(const void *ip,
       const struct xt_entry_target *target,
-      int numeric)
+      bool numeric)
 {
 	const struct xt_classify_target_info *clinfo =3D
 		(const struct xt_classify_target_info *)target->data;
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 6e42898..b39244d 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -19,6 +19,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -271,7 +272,7 @@ print_mask(const char *text, unsigned long mask)
 }
=20
 static void CONNMARK_print(const void *ip,
-                           const struct xt_entry_target *target, int n=
umeric)
+                           const struct xt_entry_target *target, bool =
numeric)
 {
 	const struct xt_connmark_target_info *markinfo =3D
 		(const struct xt_connmark_target_info *)target->data;
@@ -299,7 +300,7 @@ static void CONNMARK_print(const void *ip,
=20
 static void
 connmark_tg_print(const void *ip, const struct xt_entry_target *target=
,
-                  int numeric)
+                  bool numeric)
 {
 	const struct xt_connmark_tginfo1 *info =3D (const void *)target->data=
;
=20
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECM=
ARK.c
index 1515f6f..c01b587 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -87,7 +88,7 @@ static void print_connsecmark(struct xt_connsecmark_t=
arget_info *info)
=20
 static void
 CONNSECMARK_print(const void *ip, const struct xt_entry_target *target=
,
-                  int numeric)
+                  bool numeric)
 {
 	struct xt_connsecmark_target_info *info =3D
 		(struct xt_connsecmark_target_info*)(target)->data;
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index ddb9c99..22fd476 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -9,6 +9,7 @@
  *
  * --set-class added by Iain Barnes
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -107,13 +108,13 @@ static void DSCP_check(unsigned int flags)
 }
=20
 static void
-print_dscp(u_int8_t dscp, int numeric)
+print_dscp(u_int8_t dscp, bool numeric)
 {
  	printf("0x%02x ", dscp);
 }
=20
 static void DSCP_print(const void *ip, const struct xt_entry_target *t=
arget,
-                       int numeric)
+                       bool numeric)
 {
 	const struct xt_DSCP_info *dinfo =3D
 		(const struct xt_DSCP_info *)target->data;
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index ec2fe96..d8d83ed 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -199,7 +199,7 @@ print_mark(unsigned long mark)
 }
=20
 static void MARK_print_v0(const void *ip,
-                          const struct xt_entry_target *target, int nu=
meric)
+                          const struct xt_entry_target *target, bool n=
umeric)
 {
 	const struct xt_mark_target_info *markinfo =3D
 		(const struct xt_mark_target_info *)target->data;
@@ -217,7 +217,7 @@ static void MARK_save_v0(const void *ip, const stru=
ct xt_entry_target *target)
 }
=20
 static void MARK_print_v1(const void *ip, const struct xt_entry_target=
 *target,
-                          int numeric)
+                          bool numeric)
 {
 	const struct xt_mark_target_info_v1 *markinfo =3D
 		(const struct xt_mark_target_info_v1 *)target->data;
@@ -237,7 +237,7 @@ static void MARK_print_v1(const void *ip, const str=
uct xt_entry_target *target,
 }
=20
 static void mark_tg_print(const void *ip, const struct xt_entry_target=
 *target,
-                          int numeric)
+                          bool numeric)
 {
 	const struct xt_mark_tginfo2 *info =3D (const void *)target->data;
=20
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 007c7b4..a214631 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -1,3 +1,4 @@
+#include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
@@ -124,7 +125,7 @@ static void nflog_print(const struct xt_nflog_info =
*info, char *prefix)
 }
=20
 static void NFLOG_print(const void *ip, const struct xt_entry_target *=
target,
-                        int numeric)
+                        bool numeric)
 {
 	const struct xt_nflog_info *info =3D (struct xt_nflog_info *)target->=
data;
=20
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 3ca2239..c4cd335 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -5,6 +5,7 @@
  * This program is distributed under the terms of GNU GPL v2, 1991
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -62,7 +63,7 @@ NFQUEUE_parse(int c, char **argv, int invert, unsigne=
d int *flags,
 }
=20
 static void NFQUEUE_print(const void *ip,
-                          const struct xt_entry_target *target, int nu=
meric)
+                          const struct xt_entry_target *target, bool n=
umeric)
 {
 	const struct xt_NFQ_info *tinfo =3D
 		(const struct xt_NFQ_info *)target->data;
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index d4fd6dd..da0963a 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -1,3 +1,4 @@
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -190,7 +191,7 @@ __RATEEST_print(const struct xt_entry_target *targe=
t, const char *prefix)
=20
 static void
 RATEEST_print(const void *ip, const struct xt_entry_target *target,
-	      int numeric)
+	      bool numeric)
 {
 	__RATEEST_print(target, "");
 }
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 9db2327..977321a 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -74,7 +75,7 @@ static void print_secmark(struct xt_secmark_target_in=
fo *info)
 }
=20
 static void SECMARK_print(const void *ip, const struct xt_entry_target=
 *target,
-                          int numeric)
+                          bool numeric)
 {
 	struct xt_secmark_target_info *info =3D
 		(struct xt_secmark_target_info*)(target)->data;
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index ac9e2d0..cff1dc1 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -2,6 +2,7 @@
  *
  * Copyright (c) 2000 Marc Boucher
 */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -98,7 +99,7 @@ static void TCPMSS_check(unsigned int flags)
 }
=20
 static void TCPMSS_print(const void *ip, const struct xt_entry_target =
*target,
-                         int numeric)
+                         bool numeric)
 {
 	const struct xt_tcpmss_info *mssinfo =3D
 		(const struct xt_tcpmss_info *)target->data;
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTST=
RIP.c
index cf946fc..aa36a55 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -158,7 +158,7 @@ tcpoptstrip_print_list(const struct xt_tcpoptstrip_=
target_info *info,
=20
 static void
 tcpoptstrip_tg_print(const void *ip, const struct xt_entry_target *tar=
get,
-                     int numeric)
+                     bool numeric)
 {
 	const struct xt_tcpoptstrip_target_info *info =3D
 		(const void *)target->data;
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index c08f53b..b809f92 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -5,6 +5,7 @@
  * Contact: Jan Engelhardt <jengelh@computergmbh.de>
  */
 #include <getopt.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -158,7 +159,7 @@ static void tos_tg_check(unsigned int flags)
 }
=20
 static void tos_tg_print_v0(const void *ip,
-                            const struct xt_entry_target *target, int =
numeric)
+                            const struct xt_entry_target *target, bool=
 numeric)
 {
 	const struct ipt_tos_target_info *info =3D (const void *)target->data=
;
=20
@@ -168,7 +169,7 @@ static void tos_tg_print_v0(const void *ip,
 }
=20
 static void tos_tg_print(const void *ip, const struct xt_entry_target =
*target,
-                         int numeric)
+                         bool numeric)
 {
 	const struct xt_tos_target_info *info =3D (const void *)target->data;
=20
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index d410c52..392833e 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -110,7 +110,7 @@ static void tproxy_tg_check(unsigned int flags)
 }
=20
 static void tproxy_tg_print(const void *ip, const struct xt_entry_targ=
et *target,
-			 int numeric)
+			 bool numeric)
 {
 	const struct xt_tproxy_target_info *info =3D (const void *)target->da=
ta;
 	printf("TPROXY redirect %s:%u mark 0x%x/0x%x",
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 67d7f99..c9ad07b 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -6,6 +6,7 @@
  *     2004-05-12: Brad Fisher <brad@info-link.net>
  *         Port to patch-o-matic-ng
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -69,7 +70,7 @@ static void comment_check(unsigned int flags)
 }
=20
 static void
-comment_print(const void *ip, const struct xt_entry_match *match, int =
numeric)
+comment_print(const void *ip, const struct xt_entry_match *match, bool=
 numeric)
 {
 	struct xt_comment_info *commentinfo =3D (struct xt_comment_info *)mat=
ch->data;
=20
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.=
c
index 9f6af1c..b34ef88 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add byte tracking support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -139,7 +140,8 @@ static void print_direction(struct xt_connbytes_inf=
o *sinfo)
 }
=20
 static void
-connbytes_print(const void *ip, const struct xt_entry_match *match, in=
t numeric)
+connbytes_print(const void *ip, const struct xt_entry_match *match,
+                bool numeric)
 {
 	struct xt_connbytes_info *sinfo =3D (struct xt_connbytes_info *)match=
->data;
=20
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.=
c
index f001a2e..abb0d5d 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add connection limit support. =
*/
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -143,7 +144,7 @@ static unsigned int count_bits6(const u_int32_t *ma=
sk)
 }
=20
 static void connlimit_print4(const void *ip,
-                             const struct xt_entry_match *match, int n=
umeric)
+                             const struct xt_entry_match *match, bool =
numeric)
 {
 	const struct xt_connlimit_info *info =3D (const void *)match->data;
=20
@@ -152,7 +153,7 @@ static void connlimit_print4(const void *ip,
 }
=20
 static void connlimit_print6(const void *ip,
-                             const struct xt_entry_match *match, int n=
umeric)
+                             const struct xt_entry_match *match, bool =
numeric)
 {
 	const struct xt_connlimit_info *info =3D (const void *)match->data;
 	printf("#conn/%u %s %u ", count_bits6(info->v6_mask),
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 2dca5a5..9fe64a8 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -19,6 +19,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -119,7 +120,8 @@ static void connmark_mt_check(unsigned int flags)
 }
=20
 static void
-connmark_print(const void *ip, const struct xt_entry_match *match, int=
 numeric)
+connmark_print(const void *ip, const struct xt_entry_match *match,
+               bool numeric)
 {
 	struct xt_connmark_info *info =3D (struct xt_connmark_info *)match->d=
ata;
=20
@@ -130,7 +132,8 @@ connmark_print(const void *ip, const struct xt_entr=
y_match *match, int numeric)
 }
=20
 static void
-connmark_mt_print(const void *ip, const struct xt_entry_match *match, =
int numeric)
+connmark_mt_print(const void *ip, const struct xt_entry_match *match,
+                  bool numeric)
 {
 	const struct xt_connmark_mtinfo1 *info =3D (const void *)match->data;
=20
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.=
c
index 358b255..56451fa 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -779,7 +779,7 @@ conntrack_dump_addr(const union nf_inet_addr *addr,
 }
=20
 static void
-print_addr(struct in_addr *addr, struct in_addr *mask, int inv, int nu=
meric)
+print_addr(struct in_addr *addr, struct in_addr *mask, int inv, bool n=
umeric)
 {
 	char buf[BUFSIZ];
=20
@@ -799,7 +799,8 @@ print_addr(struct in_addr *addr, struct in_addr *ma=
sk, int inv, int numeric)
 }
=20
 static void
-matchinfo_print(const void *ip, const struct xt_entry_match *match, in=
t numeric, const char *optpfx)
+matchinfo_print(const void *ip, const struct xt_entry_match *match,
+                bool numeric, const char *optpfx)
 {
 	struct xt_conntrack_info *sinfo =3D (void *)match->data;
=20
@@ -997,21 +998,21 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 =
*info, const char *prefix,
 }
=20
 static void conntrack_print(const void *ip, const struct xt_entry_matc=
h *match,
-                            int numeric)
+                            bool numeric)
 {
 	matchinfo_print(ip, match, numeric, "");
 }
=20
 static void
 conntrack_mt_print(const void *ip, const struct xt_entry_match *match,
-                   int numeric)
+                   bool numeric)
 {
 	conntrack_dump((const void *)match->data, "", NFPROTO_IPV4, numeric);
 }
=20
 static void
 conntrack_mt6_print(const void *ip, const struct xt_entry_match *match=
,
-                    int numeric)
+                    bool numeric)
 {
 	conntrack_dump((const void *)match->data, "", NFPROTO_IPV6, numeric);
 }
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 413624e..b45405c 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -5,6 +5,7 @@
  * This program is distributed under the terms of GNU GPL v2, 1991
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -201,7 +202,7 @@ port_to_service(int port)
 }
=20
 static void
-print_port(u_int16_t port, int numeric)
+print_port(u_int16_t port, bool numeric)
 {
 	char *service;
=20
@@ -213,7 +214,7 @@ print_port(u_int16_t port, int numeric)
=20
 static void
 print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, int numeric)
+	    int invert, bool numeric)
 {
 	const char *inv =3D invert ? "!" : "";
=20
@@ -233,7 +234,7 @@ print_ports(const char *name, u_int16_t min, u_int1=
6_t max,
 }
=20
 static void
-print_types(u_int16_t types, int inverted, int numeric)
+print_types(u_int16_t types, int inverted, bool numeric)
 {
 	int have_type =3D 0;
=20
@@ -260,14 +261,14 @@ print_types(u_int16_t types, int inverted, int nu=
meric)
 }
=20
 static void
-print_option(u_int8_t option, int invert, int numeric)
+print_option(u_int8_t option, int invert, bool numeric)
 {
 	if (option || invert)
 		printf("option=3D%s%u ", invert ? "!" : "", option);
 }
=20
 static void
-dccp_print(const void *ip, const struct xt_entry_match *match, int num=
eric)
+dccp_print(const void *ip, const struct xt_entry_match *match, bool nu=
meric)
 {
 	const struct xt_dccp_info *einfo =3D
 		(const struct xt_dccp_info *)match->data;
@@ -325,7 +326,8 @@ static void dccp_save(const void *ip, const struct =
xt_entry_match *match)
=20
 	if (einfo->flags & XT_DCCP_TYPE) {
 		printf("--dccp-type ");
-		print_types(einfo->typemask, einfo->invflags & XT_DCCP_TYPE,0);
+		print_types(einfo->typemask, einfo->invflags & XT_DCCP_TYPE,
+		            false);
 	}
=20
 	if (einfo->flags & XT_DCCP_OPTION) {
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 62fa6af..866c5e9 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -12,6 +12,7 @@
  * http://www.iana.org/assignments/dscp-registry
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -115,7 +116,7 @@ static void dscp_check(unsigned int flags)
 }
=20
 static void
-dscp_print(const void *ip, const struct xt_entry_match *match, int num=
eric)
+dscp_print(const void *ip, const struct xt_entry_match *match, bool nu=
meric)
 {
 	const struct xt_dscp_info *dinfo =3D
 		(const struct xt_dscp_info *)match->data;
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 5769edb..fbce617 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add ESP support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -116,7 +117,7 @@ print_spis(const char *name, u_int32_t min, u_int32=
_t max,
 }
=20
 static void
-esp_print(const void *ip, const struct xt_entry_match *match, int nume=
ric)
+esp_print(const void *ip, const struct xt_entry_match *match, bool num=
eric)
 {
 	const struct xt_esp *esp =3D (struct xt_esp *)match->data;
=20
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.=
c
index 9a7e5de..3de0ff1 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -523,7 +523,7 @@ static void print_mode(unsigned int mode, char sepa=
rator)
 }
=20
 static void hashlimit_print(const void *ip,
-                            const struct xt_entry_match *match, int nu=
meric)
+                            const struct xt_entry_match *match, bool n=
umeric)
 {
 	struct xt_hashlimit_info *r =3D=20
 		(struct xt_hashlimit_info *)match->data;
@@ -572,7 +572,7 @@ hashlimit_mt_print(const struct xt_hashlimit_mtinfo=
1 *info, unsigned int dmask)
=20
 static void
 hashlimit_mt4_print(const void *ip, const struct xt_entry_match *match=
,
-                   int numeric)
+                    bool numeric)
 {
 	const struct xt_hashlimit_mtinfo1 *info =3D (const void *)match->data=
;
=20
@@ -581,7 +581,7 @@ hashlimit_mt4_print(const void *ip, const struct xt=
_entry_match *match,
=20
 static void
 hashlimit_mt6_print(const void *ip, const struct xt_entry_match *match=
,
-                   int numeric)
+                    bool numeric)
 {
 	const struct xt_hashlimit_mtinfo1 *info =3D (const void *)match->data=
;
=20
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 8378be7..bfb5ae3 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add related packet matching su=
pport. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -53,7 +54,7 @@ static void helper_check(unsigned int flags)
 }
=20
 static void
-helper_print(const void *ip, const struct xt_entry_match *match, int n=
umeric)
+helper_print(const void *ip, const struct xt_entry_match *match, bool =
numeric)
 {
 	struct xt_helper_info *info =3D (struct xt_helper_info *)match->data;
=20
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index bc5b2ae..c89e022 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add IP range matching support.=
 */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -218,7 +219,7 @@ print_iprange(const struct ipt_iprange *range)
 }
=20
 static void iprange_print(const void *ip, const struct xt_entry_match =
*match,
-                          int numeric)
+                          bool numeric)
 {
 	const struct ipt_iprange_info *info =3D (const void *)match->data;
=20
@@ -238,7 +239,7 @@ static void iprange_print(const void *ip, const str=
uct xt_entry_match *match,
=20
 static void
 iprange_mt4_print(const void *ip, const struct xt_entry_match *match,
-                  int numeric)
+                  bool numeric)
 {
 	const struct xt_iprange_mtinfo *info =3D (const void *)match->data;
=20
@@ -264,7 +265,7 @@ iprange_mt4_print(const void *ip, const struct xt_e=
ntry_match *match,
=20
 static void
 iprange_mt6_print(const void *ip, const struct xt_entry_match *match,
-                  int numeric)
+                  bool numeric)
 {
 	const struct xt_iprange_mtinfo *info =3D (const void *)match->data;
=20
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 7bb31a8..53d8089 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add packet length matching sup=
port. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -91,7 +92,7 @@ static void length_check(unsigned int flags)
 }
=20
 static void
-length_print(const void *ip, const struct xt_entry_match *match, int n=
umeric)
+length_print(const void *ip, const struct xt_entry_match *match, bool =
numeric)
 {
 	const struct xt_length_info *info =3D (void *)match->data;
=20
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index f785d2d..6f86a4f 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -4,6 +4,7 @@
  * Herv=C3=A9 Eychenne    <rv@wallfire.org>
  */
=20
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -142,7 +143,7 @@ static void print_rate(u_int32_t period)
 }
=20
 static void
-limit_print(const void *ip, const struct xt_entry_match *match, int nu=
meric)
+limit_print(const void *ip, const struct xt_entry_match *match, bool n=
umeric)
 {
 	struct xt_rateinfo *r =3D (struct xt_rateinfo *)match->data;
 	printf("limit: avg "); print_rate(r->avg);
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index a57e341..bc1066c 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add MAC address support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -89,7 +90,7 @@ static void mac_check(unsigned int flags)
 }
=20
 static void
-mac_print(const void *ip, const struct xt_entry_match *match, int nume=
ric)
+mac_print(const void *ip, const struct xt_entry_match *match, bool num=
eric)
 {
 	const struct xt_mac_info *info =3D (void *)match->data;
 	printf("MAC ");
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index ceca995..834edc4 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -97,7 +97,7 @@ static void mark_mt_check(unsigned int flags)
 }
=20
 static void
-mark_mt_print(const void *ip, const struct xt_entry_match *match, int =
numeric)
+mark_mt_print(const void *ip, const struct xt_entry_match *match, bool=
 numeric)
 {
 	const struct xt_mark_mtinfo1 *info =3D (const void *)match->data;
=20
@@ -108,7 +108,7 @@ mark_mt_print(const void *ip, const struct xt_entry=
_match *match, int numeric)
 }
=20
 static void
-mark_print(const void *ip, const struct xt_entry_match *match, int num=
eric)
+mark_print(const void *ip, const struct xt_entry_match *match, bool nu=
meric)
 {
 	struct xt_mark_info *info =3D (struct xt_mark_info *)match->data;
=20
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.=
c
index 9959a20..2d36ab0 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add multiple TCP port support.=
 */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -302,7 +303,7 @@ port_to_service(int port, u_int8_t proto)
 }
=20
 static void
-print_port(u_int16_t port, u_int8_t protocol, int numeric)
+print_port(u_int16_t port, u_int8_t protocol, bool numeric)
 {
 	char *service;
=20
@@ -314,7 +315,7 @@ print_port(u_int16_t port, u_int8_t protocol, int n=
umeric)
=20
 /* Prints out the matchinfo. */
 static void
-__multiport_print(const struct xt_entry_match *match, int numeric,
+__multiport_print(const struct xt_entry_match *match, bool numeric,
                   u_int16_t proto)
 {
 	const struct xt_multiport *multiinfo
@@ -349,21 +350,21 @@ __multiport_print(const struct xt_entry_match *ma=
tch, int numeric,
 }
=20
 static void multiport_print(const void *ip_void,
-                            const struct xt_entry_match *match, int nu=
meric)
+                            const struct xt_entry_match *match, bool n=
umeric)
 {
 	const struct ipt_ip *ip =3D ip_void;
 	__multiport_print(match, numeric, ip->proto);
 }
=20
 static void multiport_print6(const void *ip_void,
-                             const struct xt_entry_match *match, int n=
umeric)
+                             const struct xt_entry_match *match, bool =
numeric)
 {
 	const struct ip6t_ip6 *ip =3D ip_void;
 	__multiport_print(match, numeric, ip->proto);
 }
=20
 static void __multiport_print_v1(const struct xt_entry_match *match,
-                                 int numeric, u_int16_t proto)
+                                 bool numeric, u_int16_t proto)
 {
 	const struct xt_multiport_v1 *multiinfo
 		=3D (const struct xt_multiport_v1 *)match->data;
@@ -403,15 +404,17 @@ static void __multiport_print_v1(const struct xt_=
entry_match *match,
 	printf(" ");
 }
=20
-static void multiport_print_v1(const void *ip_void,
-                               const struct xt_entry_match *match, int=
 numeric)
+static void
+multiport_print_v1(const void *ip_void, const struct xt_entry_match *m=
atch,
+                   bool numeric)
 {
 	const struct ipt_ip *ip =3D ip_void;
 	__multiport_print_v1(match, numeric, ip->proto);
 }
=20
-static void multiport_print6_v1(const void *ip_void,
-                                const struct xt_entry_match *match, in=
t numeric)
+static void
+multiport_print6_v1(const void *ip_void, const struct xt_entry_match *=
match,
+                    bool numeric)
 {
 	const struct ip6t_ip6 *ip =3D ip_void;
 	__multiport_print_v1(match, numeric, ip->proto);
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index d27b3ae..5e7c581 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -464,7 +464,7 @@ owner_mt_print_item(const struct xt_owner_match_inf=
o *info, const char *label,
=20
 static void
 owner_mt_print_v0(const void *ip, const struct xt_entry_match *match,
-                  int numeric)
+                  bool numeric)
 {
 	const struct ipt_owner_info *info =3D (void *)match->data;
=20
@@ -479,7 +479,7 @@ owner_mt_print_v0(const void *ip, const struct xt_e=
ntry_match *match,
=20
 static void
 owner_mt6_print_v0(const void *ip, const struct xt_entry_match *match,
-                   int numeric)
+                   bool numeric)
 {
 	const struct ip6t_owner_info *info =3D (void *)match->data;
=20
@@ -490,7 +490,7 @@ owner_mt6_print_v0(const void *ip, const struct xt_=
entry_match *match,
 }
=20
 static void owner_mt_print(const void *ip, const struct xt_entry_match=
 *match,
-                           int numeric)
+                           bool numeric)
 {
 	const struct xt_owner_match_info *info =3D (void *)match->data;
=20
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index c87779b..9e477f1 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add bridge port matching suppo=
rt. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -112,7 +113,7 @@ static void physdev_check(unsigned int flags)
 }
=20
 static void
-physdev_print(const void *ip, const struct xt_entry_match *match, int =
numeric)
+physdev_print(const void *ip, const struct xt_entry_match *match, bool=
 numeric)
 {
 	struct xt_physdev_info *info =3D
 		(struct xt_physdev_info*)match->data;
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 0fa933f..e2dca1a 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -4,6 +4,7 @@
  *
  * Michal Ludvig <michal@logix.cz>
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -128,7 +129,7 @@ static void print_pkttype(struct xt_pkttype_info *i=
nfo)
 }
=20
 static void pkttype_print(const void *ip, const struct xt_entry_match =
*match,
-                          int numeric)
+                          bool numeric)
 {
 	struct xt_pkttype_info *info =3D (struct xt_pkttype_info *)match->dat=
a;
 =09
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 2657b2a..d1c5023 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -3,6 +3,7 @@
  *
  * Sam Johnston <samj@samj.net>
  */
+#include <stdbool.h>
 #include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -23,7 +24,7 @@ static void quota_help(void)
 }
=20
 static void
-quota_print(const void *ip, const struct xt_entry_match *match, int nu=
meric)
+quota_print(const void *ip, const struct xt_entry_match *match, bool n=
umeric)
 {
 	struct xt_quota_info *q =3D (struct xt_quota_info *) match->data;
 	printf("quota: %llu bytes", (unsigned long long) q->quota);
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 3cff07d..f9844c4 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -1,3 +1,4 @@
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -317,7 +318,7 @@ rateest_final_check(unsigned int flags)
 }
=20
 static void
-rateest_print_rate(u_int32_t rate, int numeric)
+rateest_print_rate(u_int32_t rate, bool numeric)
 {
 	double tmp =3D (double)rate*8;
=20
@@ -353,7 +354,7 @@ rateest_print_mode(struct xt_rateest_match_info *in=
fo, const char *prefix)
 }
=20
 static void
-rateest_print(const void *ip, const struct xt_entry_match *match, int =
numeric)
+rateest_print(const void *ip, const struct xt_entry_match *match, bool=
 numeric)
 {
 	struct xt_rateest_match_info *info =3D (void *)match->data;
=20
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 47c35ff..ce281b2 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add recent matching support. *=
/
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -159,7 +160,7 @@ static void recent_check(unsigned int flags)
 }
=20
 static void recent_print(const void *ip, const struct xt_entry_match *=
match,
-                         int numeric)
+                         bool numeric)
 {
 	const struct xt_recent_mtinfo *info =3D (const void *)match->data;
=20
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index b889406..3098859 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -7,6 +7,7 @@
  * libipt_ecn.c borrowed heavily from libipt_dscp.c
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -39,7 +40,7 @@
 #endif
=20
 static void
-print_chunk(u_int32_t chunknum, int numeric);
+print_chunk(u_int32_t chunknum, bool numeric);
=20
 static void sctp_init(struct xt_entry_match *m)
 {
@@ -326,7 +327,7 @@ port_to_service(int port)
 }
=20
 static void
-print_port(u_int16_t port, int numeric)
+print_port(u_int16_t port, bool numeric)
 {
 	char *service;
=20
@@ -338,7 +339,7 @@ print_port(u_int16_t port, int numeric)
=20
 static void
 print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, int numeric)
+	    int invert, bool numeric)
 {
 	const char *inv =3D invert ? "!" : "";
=20
@@ -381,7 +382,7 @@ print_chunk_flags(u_int32_t chunknum, u_int8_t chun=
k_flags, u_int8_t chunk_flags
 }
=20
 static void
-print_chunk(u_int32_t chunknum, int numeric)
+print_chunk(u_int32_t chunknum, bool numeric)
 {
 	if (numeric) {
 		printf("0x%04X", chunknum);
@@ -397,7 +398,7 @@ print_chunk(u_int32_t chunknum, int numeric)
 }
=20
 static void
-print_chunks(const struct xt_sctp_info *einfo, int numeric)
+print_chunks(const struct xt_sctp_info *einfo, bool numeric)
 {
 	u_int32_t chunk_match_type =3D einfo->chunk_match_type;
 	const struct xt_sctp_flag_info *flag_info =3D einfo->flag_info;
@@ -445,7 +446,7 @@ out:
 }
=20
 static void
-sctp_print(const void *ip, const struct xt_entry_match *match, int num=
eric)
+sctp_print(const void *ip, const struct xt_entry_match *match, bool nu=
meric)
 {
 	const struct xt_sctp_info *einfo =3D
 		(const struct xt_sctp_info *)match->data;
@@ -504,7 +505,7 @@ static void sctp_save(const void *ip, const struct =
xt_entry_match *match)
 			printf("! ");
 		printf("--chunk-types ");
=20
-		print_chunks(einfo, 0);
+		print_chunks(einfo, false);
 	}
 }
=20
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 0f26443..bb21952 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add state tracking support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -122,7 +123,7 @@ static void state_print_state(unsigned int statemas=
k)
 static void
 state_print(const void *ip,
       const struct xt_entry_match *match,
-      int numeric)
+      bool numeric)
 {
 	struct xt_state_info *sinfo =3D (struct xt_state_info *)match->data;
=20
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.=
c
index fa044ad..29541ee 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -1,3 +1,4 @@
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -144,7 +145,8 @@ static void print_match(const struct xt_statistic_i=
nfo *info, char *prefix)
 }
=20
 static void
-statistic_print(const void *ip, const struct xt_entry_match *match, in=
t numeric)
+statistic_print(const void *ip, const struct xt_entry_match *match,
+                bool numeric)
 {
 	struct xt_statistic_info *info =3D (struct xt_statistic_info *)match-=
>data;
=20
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index ba4b720..ecdf31a 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -21,6 +21,7 @@
  *             ipt_string_info.
  */
 #define _GNU_SOURCE 1
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -301,7 +302,7 @@ print_string(const char *str, const unsigned short =
int len)
 }
=20
 static void
-string_print(const void *ip, const struct xt_entry_match *match, int n=
umeric)
+string_print(const void *ip, const struct xt_entry_match *match, bool =
numeric)
 {
 	const struct xt_string_info *info =3D
 	    (const struct xt_string_info*) match->data;
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index d2ad53b..a1b115d 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add TCP support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -225,7 +226,7 @@ port_to_service(int port)
 }
=20
 static void
-print_port(u_int16_t port, int numeric)
+print_port(u_int16_t port, bool numeric)
 {
 	char *service;
=20
@@ -237,7 +238,7 @@ print_port(u_int16_t port, int numeric)
=20
 static void
 print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, int numeric)
+	    int invert, bool numeric)
 {
 	const char *inv =3D invert ? "!" : "";
=20
@@ -257,7 +258,7 @@ print_ports(const char *name, u_int16_t min, u_int1=
6_t max,
 }
=20
 static void
-print_option(u_int8_t option, int invert, int numeric)
+print_option(u_int8_t option, int invert, bool numeric)
 {
 	if (option || invert)
 		printf("option=3D%s%u ", invert ? "!" : "", option);
@@ -286,7 +287,7 @@ print_tcpf(u_int8_t flags)
 }
=20
 static void
-print_flags(u_int8_t mask, u_int8_t cmp, int invert, int numeric)
+print_flags(u_int8_t mask, u_int8_t cmp, int invert, bool numeric)
 {
 	if (mask || invert) {
 		printf("flags:%s", invert ? "!" : "");
@@ -302,7 +303,7 @@ print_flags(u_int8_t mask, u_int8_t cmp, int invert=
, int numeric)
 }
=20
 static void
-tcp_print(const void *ip, const struct xt_entry_match *match, int nume=
ric)
+tcp_print(const void *ip, const struct xt_entry_match *match, bool num=
eric)
 {
 	const struct xt_tcp *tcp =3D (struct xt_tcp *)match->data;
=20
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 46529f9..1347b5f 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add tcp MSS matching support. =
*/
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -86,7 +87,7 @@ static void tcpmss_check(unsigned int flags)
 }
=20
 static void
-tcpmss_print(const void *ip, const struct xt_entry_match *match, int n=
umeric)
+tcpmss_print(const void *ip, const struct xt_entry_match *match, bool =
numeric)
 {
 	const struct xt_tcpmss_match_info *info =3D (void *)match->data;
=20
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index eb8b671..7fbc6b5 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -404,7 +404,7 @@ static inline void divide_time(unsigned int fulltim=
e, unsigned int *hours,
 }
=20
 static void time_print(const void *ip, const struct xt_entry_match *ma=
tch,
-                       int numeric)
+                       bool numeric)
 {
 	struct xt_time_info *info =3D (void *)match->data;
 	unsigned int h, m, s;
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index b810ea6..abac46e 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -95,7 +95,7 @@ static void tos_mt_check(unsigned int flags)
 }
=20
 static void tos_mt_print_v0(const void *ip, const struct xt_entry_matc=
h *match,
-                            int numeric)
+                            bool numeric)
 {
 	const struct ipt_tos_info *info =3D (const void *)match->data;
=20
@@ -107,7 +107,7 @@ static void tos_mt_print_v0(const void *ip, const s=
truct xt_entry_match *match,
 }
=20
 static void tos_mt_print(const void *ip, const struct xt_entry_match *=
match,
-                         int numeric)
+                         bool numeric)
 {
 	const struct xt_tos_match_info *info =3D (const void *)match->data;
=20
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index c2aeb27..f0e0979 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <getopt.h>
 #include <netdb.h>
+#include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
@@ -247,7 +248,7 @@ static int u32_parse(int c, char **argv, int invert=
, unsigned int *flags,
 }
=20
 static void u32_print(const void *ip, const struct xt_entry_match *mat=
ch,
-                      int numeric)
+                      bool numeric)
 {
 	const struct xt_u32 *data =3D (const void *)match->data;
 	printf("u32 ");
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 4b4e84f..66372a4 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add UDP support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -109,7 +110,7 @@ port_to_service(int port)
 }
=20
 static void
-print_port(u_int16_t port, int numeric)
+print_port(u_int16_t port, bool numeric)
 {
 	char *service;
=20
@@ -121,7 +122,7 @@ print_port(u_int16_t port, int numeric)
=20
 static void
 print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, int numeric)
+	    int invert, bool numeric)
 {
 	const char *inv =3D invert ? "!" : "";
=20
@@ -141,7 +142,7 @@ print_ports(const char *name, u_int16_t min, u_int1=
6_t max,
 }
=20
 static void
-udp_print(const void *ip, const struct xt_entry_match *match, int nume=
ric)
+udp_print(const void *ip, const struct xt_entry_match *match, bool num=
eric)
 {
 	const struct xt_udp *udp =3D (struct xt_udp *)match->data;
=20
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 4f8fedb..ed599bc 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -77,7 +77,7 @@ struct xtables_match
 	/* Prints out the match iff non-NULL: put space at end */
 	/* ip is struct ipt_ip * for example */
 	void (*print)(const void *ip,
-		      const struct xt_entry_match *match, int numeric);
+		      const struct xt_entry_match *match, bool numeric);
=20
 	/* Saves the match info in parsable form to stdout. */
 	/* ip is struct ipt_ip * for example */
@@ -138,7 +138,7 @@ struct xtables_target
=20
 	/* Prints out the target iff non-NULL: put space at end */
 	void (*print)(const void *ip,
-		      const struct xt_entry_target *target, int numeric);
+		      const struct xt_entry_target *target, bool numeric);
=20
 	/* Saves the targinfo in parsable form to stdout. */
 	void (*save)(const void *ip,
diff --git a/ip6tables.c b/ip6tables.c
index 31c4b45..cf1508b 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -579,7 +579,7 @@ print_header(unsigned int format, const char *chain=
, struct ip6tc_handle *handle
 static int
 print_match(const struct ip6t_entry_match *m,
 	    const struct ip6t_ip6 *ip,
-	    int numeric)
+	    bool numeric)
 {
 	struct xtables_match *match =3D
 		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
@@ -953,8 +953,9 @@ delete_chain(const ip6t_chainlabel chain, int verbo=
se,
 }
=20
 static int
-list_entries(const ip6t_chainlabel chain, int rulenum, int verbose, in=
t numeric,
-	     int expanded, int linenumbers, struct ip6tc_handle *handle)
+list_entries(const ip6t_chainlabel chain, int rulenum, int verbose,
+             bool numeric, int expanded, int linenumbers,
+             struct ip6tc_handle *handle)
 {
 	int found =3D 0;
 	unsigned int format;
diff --git a/iptables.c b/iptables.c
index 7c075da..e1f936a 100644
--- a/iptables.c
+++ b/iptables.c
@@ -583,7 +583,7 @@ print_header(unsigned int format, const char *chain=
, struct iptc_handle *handle)
 static int
 print_match(const struct ipt_entry_match *m,
 	    const struct ipt_ip *ip,
-	    int numeric)
+	    bool numeric)
 {
 	struct xtables_match *match =3D
 		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
@@ -955,8 +955,9 @@ delete_chain(const ipt_chainlabel chain, int verbos=
e,
 }
=20
 static int
-list_entries(const ipt_chainlabel chain, int rulenum, int verbose, int=
 numeric,
-	     int expanded, int linenumbers, struct iptc_handle *handle)
+list_entries(const ipt_chainlabel chain, int rulenum, int verbose,
+             bool numeric, int expanded, int linenumbers,
+             struct iptc_handle *handle)
 {
 	int found =3D 0;
 	unsigned int format;
--=20
1.6.2.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
