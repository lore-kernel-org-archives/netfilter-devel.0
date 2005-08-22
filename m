From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 4/4]: Add goto target
Date: Mon, 22 Aug 2005 02:04:10 +0200
Message-ID: <4309167A.8060508@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="04.diff"
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

[NETFILTER]: Add goto target

Originally written by Henrik Nordstrom <hno@marasystems.com>, taken
from netfilter patch-o-matic and added ip6_tables support.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c0286a0beb36ea99cbe7064c259f93cbba8b1149
tree dd1a56bd04eb5f0329006289eacfd6b0b86ebc83
parent a0a72e7c68dee59a8345cdffbe0da7085deec867
author Patrick McHardy <kaber@trash.net> Sun, 21 Aug 2005 21:57:03 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 21 Aug 2005 21:57:03 +0200

 include/linux/netfilter_ipv4/ip_tables.h  |    3 ++-
 include/linux/netfilter_ipv6/ip6_tables.h |    3 ++-
 net/ipv4/netfilter/ip_tables.c            |    4 ++--
 net/ipv6/netfilter/ip6_tables.c           |    4 ++--
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -109,7 +109,8 @@ struct ipt_counters
 
 /* Values for "flag" field in struct ipt_ip (general ip structure). */
 #define IPT_F_FRAG		0x01	/* Set if rule is a fragment rule */
-#define IPT_F_MASK		0x01	/* All possible flag bits mask. */
+#define IPT_F_GOTO		0x02	/* Set if jump is a goto */
+#define IPT_F_MASK		0x03	/* All possible flag bits mask. */
 
 /* Values for "inv" field in struct ipt_ip. */
 #define IPT_INV_VIA_IN		0x01	/* Invert the sense of IN IFACE. */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -111,7 +111,8 @@ struct ip6t_counters
 #define IP6T_F_PROTO		0x01	/* Set if rule cares about upper 
 					   protocols */
 #define IP6T_F_TOS		0x02	/* Match the TOS. */
-#define IP6T_F_MASK		0x03	/* All possible flag bits mask. */
+#define IP6T_F_GOTO		0x04	/* Set if jump is a goto */
+#define IP6T_F_MASK		0x07	/* All possible flag bits mask. */
 
 /* Values for "inv" field in struct ip6t_ip6. */
 #define IP6T_INV_VIA_IN		0x01	/* Invert the sense of IN IFACE. */
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -340,8 +340,8 @@ ipt_do_table(struct sk_buff **pskb,
 							 back->comefrom);
 					continue;
 				}
-				if (table_base + v
-				    != (void *)e + e->next_offset) {
+				if (table_base + v != (void *)e + e->next_offset
+				    && !(e->ip.flags & IPT_F_GOTO)) {
 					/* Save old back ptr in next entry */
 					struct ipt_entry *next
 						= (void *)e + e->next_offset;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -433,8 +433,8 @@ ip6t_do_table(struct sk_buff **pskb,
 							 back->comefrom);
 					continue;
 				}
-				if (table_base + v
-				    != (void *)e + e->next_offset) {
+				if (table_base + v != (void *)e + e->next_offset
+				    && !(e->ipv6.flags & IP6T_F_GOTO)) {
 					/* Save old back ptr in next entry */
 					struct ip6t_entry *next
 						= (void *)e + e->next_offset;
