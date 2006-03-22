From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/10]: futher {ip,ip6,arp}_tables unification
Date: Wed, 22 Mar 2006 19:47:56 +0100 (MET)
Message-ID: <20060322184756.5655.40066.sendpatchset@localhost.localdomain>
References: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: futher {ip,ip6,arp}_tables unification

This patch moves {ip,ip6,arp}t_entry_{match,target} definitions to
x_tables.h. This move simplifies code and future compatibility fixes.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
Acked-off-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bcf32a11bc08c3fbf6e983a68ab2a40e95f22e43
tree 709ab07969261741a3382b29e32a4975f7b8708d
parent 4dea04e970d17675cb21717b7cb02cce02ce155b
author Dmitry Mishin <dim@openvz.org> Tue, 21 Mar 2006 22:30:31 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 21 Mar 2006 22:30:31 +0100

 include/linux/netfilter/x_tables.h        |   56 ++++++++++++++++++++++++++++
 include/linux/netfilter_arp/arp_tables.h  |   31 +---------------
 include/linux/netfilter_ipv4/ip_tables.h  |   58 ++---------------------------
 include/linux/netfilter_ipv6/ip6_tables.h |   57 ++---------------------------
 include/net/tc_act/tc_ipt.h               |    4 +-
 5 files changed, 66 insertions(+), 140 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index bf71efb..1350e47 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -4,6 +4,62 @@
 #define XT_FUNCTION_MAXNAMELEN 30
 #define XT_TABLE_MAXNAMELEN 32
 
+struct xt_entry_match
+{
+	union {
+		struct {
+			u_int16_t match_size;
+
+			/* Used by userspace */
+			char name[XT_FUNCTION_MAXNAMELEN-1];
+
+			u_int8_t revision;
+		} user;
+		struct {
+			u_int16_t match_size;
+
+			/* Used inside the kernel */
+			struct xt_match *match;
+		} kernel;
+
+		/* Total length */
+		u_int16_t match_size;
+	} u;
+
+	unsigned char data[0];
+};
+
+struct xt_entry_target
+{
+	union {
+		struct {
+			u_int16_t target_size;
+
+			/* Used by userspace */
+			char name[XT_FUNCTION_MAXNAMELEN-1];
+
+			u_int8_t revision;
+		} user;
+		struct {
+			u_int16_t target_size;
+
+			/* Used inside the kernel */
+			struct xt_target *target;
+		} kernel;
+
+		/* Total length */
+		u_int16_t target_size;
+	} u;
+
+	unsigned char data[0];
+};
+
+struct xt_standard_target
+{
+	struct xt_entry_target target;
+	int verdict;
+};
+
 /* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
  * kernel supports, if >= revision. */
 struct xt_get_revision
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index a27be05..62cc27d 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -65,35 +65,8 @@ struct arpt_arp {
 	u_int16_t invflags;
 };
 
-struct arpt_entry_target
-{
-	union {
-		struct {
-			u_int16_t target_size;
-
-			/* Used by userspace */
-			char name[ARPT_FUNCTION_MAXNAMELEN-1];
-			u_int8_t revision;
-		} user;
-		struct {
-			u_int16_t target_size;
-
-			/* Used inside the kernel */
-			struct arpt_target *target;
-		} kernel;
-
-		/* Total length */
-		u_int16_t target_size;
-	} u;
-
-	unsigned char data[0];
-};
-
-struct arpt_standard_target
-{
-	struct arpt_entry_target target;
-	int verdict;
-};
+#define arpt_entry_target xt_entry_target
+#define arpt_standard_target xt_standard_target
 
 /* Values for "flag" field in struct arpt_ip (general arp structure).
  * No flags defined yet.
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index ee262b5..d5b8c0d 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -52,61 +52,9 @@ struct ipt_ip {
 	u_int8_t invflags;
 };
 
-struct ipt_entry_match
-{
-	union {
-		struct {
-			u_int16_t match_size;
-
-			/* Used by userspace */
-			char name[IPT_FUNCTION_MAXNAMELEN-1];
-
-			u_int8_t revision;
-		} user;
-		struct {
-			u_int16_t match_size;
-
-			/* Used inside the kernel */
-			struct ipt_match *match;
-		} kernel;
-
-		/* Total length */
-		u_int16_t match_size;
-	} u;
-
-	unsigned char data[0];
-};
-
-struct ipt_entry_target
-{
-	union {
-		struct {
-			u_int16_t target_size;
-
-			/* Used by userspace */
-			char name[IPT_FUNCTION_MAXNAMELEN-1];
-
-			u_int8_t revision;
-		} user;
-		struct {
-			u_int16_t target_size;
-
-			/* Used inside the kernel */
-			struct ipt_target *target;
-		} kernel;
-
-		/* Total length */
-		u_int16_t target_size;
-	} u;
-
-	unsigned char data[0];
-};
-
-struct ipt_standard_target
-{
-	struct ipt_entry_target target;
-	int verdict;
-};
+#define ipt_entry_match xt_entry_match
+#define ipt_entry_target xt_entry_target
+#define ipt_standard_target xt_standard_target
 
 #define ipt_counters xt_counters
 
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 7107f94..d0d5d1e 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -56,60 +56,9 @@ struct ip6t_ip6 {
 	u_int8_t invflags;
 };
 
-/* FIXME: If alignment in kernel different from userspace? --RR */
-struct ip6t_entry_match
-{
-	union {
-		struct {
-			u_int16_t match_size;
-
-			/* Used by userspace */
-			char name[IP6T_FUNCTION_MAXNAMELEN-1];
-			u_int8_t revision;
-		} user;
-		struct {
-			u_int16_t match_size;
-
-			/* Used inside the kernel */
-			struct ip6t_match *match;
-		} kernel;
-
-		/* Total length */
-		u_int16_t match_size;
-	} u;
-
-	unsigned char data[0];
-};
-
-struct ip6t_entry_target
-{
-	union {
-		struct {
-			u_int16_t target_size;
-
-			/* Used by userspace */
-			char name[IP6T_FUNCTION_MAXNAMELEN-1];
-			u_int8_t revision;
-		} user;
-		struct {
-			u_int16_t target_size;
-
-			/* Used inside the kernel */
-			struct ip6t_target *target;
-		} kernel;
-
-		/* Total length */
-		u_int16_t target_size;
-	} u;
-
-	unsigned char data[0];
-};
-
-struct ip6t_standard_target
-{
-	struct ip6t_entry_target target;
-	int verdict;
-};
+#define ip6t_entry_match xt_entry_match
+#define ip6t_entry_target xt_entry_target
+#define ip6t_standard_target xt_standard_target
 
 #define ip6t_counters	xt_counters
 
diff --git a/include/net/tc_act/tc_ipt.h b/include/net/tc_act/tc_ipt.h
index 02ecceb..cb37ad0 100644
--- a/include/net/tc_act/tc_ipt.h
+++ b/include/net/tc_act/tc_ipt.h
@@ -3,14 +3,14 @@
 
 #include <net/act_api.h>
 
-struct ipt_entry_target;
+struct xt_entry_target;
 
 struct tcf_ipt
 {
 	tca_gen(ipt);
 	u32 hook;
 	char *tname;
-	struct ipt_entry_target *t;
+	struct xt_entry_target *t;
 };
 
 #endif
