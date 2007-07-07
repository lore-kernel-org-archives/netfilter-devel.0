From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/50]: ip6_tables: fix explanation of valid upper
	protocol number
Date: Sat,  7 Jul 2007 14:23:03 +0200 (MEST)
Message-ID: <20070707122218.1589.75396.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip6_tables: fix explanation of valid upper protocol number

This explains the allowed upper protocol numbers. IP6T_F_NOPROTO was
introduced to use 0 as Hop-by-Hop option header, not wildcard. But that
seemed to be forgotten. 0 has been used as wildcard since 2002-08-23.

Signed-off-by: Yasuyuki Kozakai <yasuyuki@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 758639bdab77d422ed21343f206644a73d568787
tree 56c0a40182f8557e0fa995c127230fb28979346a
parent f32236698107064a21157edb09cf06645f63409f
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 07 Jul 2007 12:15:03 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:03 +0200

 include/linux/netfilter_ipv6/ip6_tables.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 4686f83..9a720f0 100644
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
