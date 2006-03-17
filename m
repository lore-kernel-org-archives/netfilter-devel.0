From: Dmitry Mishin <dim@openvz.org>
Subject: Re: [Devel] [PATCH] futher {ip,ip6,arp}_tables unification
Date: Fri, 17 Mar 2006 19:02:33 +0300
Message-ID: <200603171902.34281.dim@openvz.org>
References: <200603171446.19856.dim@openvz.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_a2tGENMs1EzXo+i"
Cc: Dmitry Mishin <dim@openvz.org>, dev@openvz.org,
	netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: devel@openvz.org
In-Reply-To: <200603171446.19856.dim@openvz.org>
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

--Boundary-00=_a2tGENMs1EzXo+i
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Forgot required tc_ipt.h modification. Corrected.

On Friday 17 March 2006 14:46, Dmitry Mishin wrote:
>  This patch moves {ip,ip6,arp}t_entry_{match,target} definitions to
>  x_tables.h. This move simplifies code and future compatibility fixes.
>
> Signed-off-by: Dmitry Mishin <dim@openvz.org>
> Acked-off-by: Kirill Korotaev <dev@openvz.org>

-- 
Thanks,
Dmitry.

--Boundary-00=_a2tGENMs1EzXo+i
Content-Type: text/plain; charset="utf-8"; name="diff-ms-xt-entry-20060317"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="diff-ms-xt-entry-20060317"

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 46a0f97..ad72a4f 100644
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
index fd21796..3f89d2f 100644
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
index 76ba24b..56eebc6 100644
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
index f249b57..45dc603 100644
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

--Boundary-00=_a2tGENMs1EzXo+i--
