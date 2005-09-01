From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 6/10] add nf_conntrack support to connbytes
 match
Date: Thu, 01 Sep 2005 18:14:41 +0900 (JST)
Message-ID: <200509010914.j819EgJG006120@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_18_14_41_2005_214)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Thu_Sep__1_18_14_41_2005_214)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_18_14_41_2005_214)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="06-connbytes.patch"

[NETFILTER] add nf_conntrack support to connbytes match

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 3476e266ba733aa5214ac79977fc64596c80f4c6
tree 5e973f5cb5cc1847e3ae434349840b21b1566579
parent 873123d0c0b5e410dcda66d477d4211e0c5c349c
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:30:48 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:30:48 +0900

 net/ipv4/netfilter/Kconfig         |    3 ++-
 net/ipv4/netfilter/ipt_connbytes.c |   39 ++++++++++++++++++------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -389,7 +389,8 @@ config IP_NF_MATCH_CONNMARK
 
 config IP_NF_MATCH_CONNBYTES
 	tristate  'Connection byte/packet counter match support'
-	depends on IP_NF_CT_ACCT && IP_NF_IPTABLES
+	depends on IP_NF_IPTABLES
+	depends on IP_NF_CT_ACCT || (NF_CT_ACCT && NF_CONNTRACK_IPV4)
 	help
 	  This option adds a `connbytes' match, which allows you to match the
 	  number of bytes and/or packets for each direction within a connection.
diff --git a/net/ipv4/netfilter/ipt_connbytes.c b/net/ipv4/netfilter/ipt_connbytes.c
--- a/net/ipv4/netfilter/ipt_connbytes.c
+++ b/net/ipv4/netfilter/ipt_connbytes.c
@@ -10,7 +10,7 @@
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack_compat.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_connbytes.h>
 
@@ -46,60 +46,59 @@ match(const struct sk_buff *skb,
       int *hotdrop)
 {
 	const struct ipt_connbytes_info *sinfo = matchinfo;
-	enum ip_conntrack_info ctinfo;
-	struct ip_conntrack *ct;
 	u_int64_t what = 0;	/* initialize to make gcc happy */
+	const struct ip_conntrack_counter *counters;
 
-	if (!(ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo)))
+	if (!(counters = nf_ct_get_counters(skb)))
 		return 0; /* no match */
 
 	switch (sinfo->what) {
 	case IPT_CONNBYTES_PKTS:
 		switch (sinfo->direction) {
 		case IPT_CONNBYTES_DIR_ORIGINAL:
-			what = ct->counters[IP_CT_DIR_ORIGINAL].packets;
+			what = counters[IP_CT_DIR_ORIGINAL].packets;
 			break;
 		case IPT_CONNBYTES_DIR_REPLY:
-			what = ct->counters[IP_CT_DIR_REPLY].packets;
+			what = counters[IP_CT_DIR_REPLY].packets;
 			break;
 		case IPT_CONNBYTES_DIR_BOTH:
-			what = ct->counters[IP_CT_DIR_ORIGINAL].packets;
-			what += ct->counters[IP_CT_DIR_REPLY].packets;
+			what = counters[IP_CT_DIR_ORIGINAL].packets;
+			what += counters[IP_CT_DIR_REPLY].packets;
 			break;
 		}
 		break;
 	case IPT_CONNBYTES_BYTES:
 		switch (sinfo->direction) {
 		case IPT_CONNBYTES_DIR_ORIGINAL:
-			what = ct->counters[IP_CT_DIR_ORIGINAL].bytes;
+			what = counters[IP_CT_DIR_ORIGINAL].bytes;
 			break;
 		case IPT_CONNBYTES_DIR_REPLY:
-			what = ct->counters[IP_CT_DIR_REPLY].bytes;
+			what = counters[IP_CT_DIR_REPLY].bytes;
 			break;
 		case IPT_CONNBYTES_DIR_BOTH:
-			what = ct->counters[IP_CT_DIR_ORIGINAL].bytes;
-			what += ct->counters[IP_CT_DIR_REPLY].bytes;
+			what = counters[IP_CT_DIR_ORIGINAL].bytes;
+			what += counters[IP_CT_DIR_REPLY].bytes;
 			break;
 		}
 		break;
 	case IPT_CONNBYTES_AVGPKT:
 		switch (sinfo->direction) {
 		case IPT_CONNBYTES_DIR_ORIGINAL:
-			what = div64_64(ct->counters[IP_CT_DIR_ORIGINAL].bytes,
-					ct->counters[IP_CT_DIR_ORIGINAL].packets);
+			what = div64_64(counters[IP_CT_DIR_ORIGINAL].bytes,
+					counters[IP_CT_DIR_ORIGINAL].packets);
 			break;
 		case IPT_CONNBYTES_DIR_REPLY:
-			what = div64_64(ct->counters[IP_CT_DIR_REPLY].bytes,
-					ct->counters[IP_CT_DIR_REPLY].packets);
+			what = div64_64(counters[IP_CT_DIR_REPLY].bytes,
+					counters[IP_CT_DIR_REPLY].packets);
 			break;
 		case IPT_CONNBYTES_DIR_BOTH:
 			{
 				u_int64_t bytes;
 				u_int64_t pkts;
-				bytes = ct->counters[IP_CT_DIR_ORIGINAL].bytes +
-					ct->counters[IP_CT_DIR_REPLY].bytes;
-				pkts = ct->counters[IP_CT_DIR_ORIGINAL].packets+
-					ct->counters[IP_CT_DIR_REPLY].packets;
+				bytes = counters[IP_CT_DIR_ORIGINAL].bytes +
+					counters[IP_CT_DIR_REPLY].bytes;
+				pkts = counters[IP_CT_DIR_ORIGINAL].packets+
+					counters[IP_CT_DIR_REPLY].packets;
 
 				/* FIXME_THEORETICAL: what to do if sum
 				 * overflows ? */

----Next_Part(Thu_Sep__1_18_14_41_2005_214)----
