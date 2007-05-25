From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: ip6_tables: Fixes explanation of valid upper protocol
 number
Date: Fri, 25 May 2007 17:10:01 +0900 (JST)
Message-ID: <200705250810.l4P8A2ab020658@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


This explains the allowed upper protocol numbers. IP6T_F_NOPROTO was
introduced to use 0 as Hop-by-Hop option header, not wildcard. But that
seemed to be forgotten. 0 has been used as wildcard since 2002-08-23.

Signed-off-by: Yasuyuki Kozakai <yasuyuki@netfilter.org>
---
 include/linux/netfilter_ipv6/ip6_tables.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 4686f83..5641f03 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -44,8 +44,14 @@ struct ip6t_ip6 {
 	char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
 	unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
 
-	/* ARGH, HopByHop uses 0, so can't do 0 = ANY,
-	   instead IP6T_F_NOPROTO must be set */
+	/* Upper protocol number
+	 * - The allowed value is 0 (any) or protocol number of last parsable
+	 *   header, which is 50 (ESP), 59 (No Next Header), 135 (MH), or
+	 *   the non IPv6 extension headers.
+	 * - The protocol numbers of IPv6 extension headers except of ESP and
+	 *   MH do not match any packets.
+	 * - You also need to set IP6T_FLAGS_PROTO to "flags" to check protocol.
+	 */
 	u_int16_t proto;
 	/* TOS to match iff flags & IP6T_F_TOS */
 	u_int8_t tos;
-- 
1.4.4
