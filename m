From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.4 5/6]: Fix potential memory corruption in NAT code
 (aka memory NAT)
Date: Mon, 01 Aug 2005 02:42:35 +0200
Message-ID: <42ED6FFB.9050004@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="5.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="5.diff"
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

[NETFILTER]: Fix potential memory corruption in NAT code (aka memory NAT)

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b3db926712f01d98e672510bdb69b940e09880eb
tree aa069a1d615f75a986c4b74975ffbf00d3927cf4
parent 3828b256e2b5adae44649792fee705bc91b1c44a
author Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 20:26:49 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 20:26:49 +0200

 net/ipv4/netfilter/ip_nat_proto_tcp.c |    3 ++-
 net/ipv4/netfilter/ip_nat_proto_udp.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter/ip_nat_proto_tcp.c
--- a/net/ipv4/netfilter/ip_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c
@@ -31,7 +31,8 @@ tcp_unique_tuple(struct ip_conntrack_tup
 		 enum ip_nat_manip_type maniptype,
 		 const struct ip_conntrack *conntrack)
 {
-	static u_int16_t port = 0, *portptr;
+	static u_int16_t port = 0;
+	u_int16_t *portptr;
 	unsigned int range_size, min, i;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
diff --git a/net/ipv4/netfilter/ip_nat_proto_udp.c b/net/ipv4/netfilter/ip_nat_proto_udp.c
--- a/net/ipv4/netfilter/ip_nat_proto_udp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_udp.c
@@ -32,7 +32,8 @@ udp_unique_tuple(struct ip_conntrack_tup
 		 enum ip_nat_manip_type maniptype,
 		 const struct ip_conntrack *conntrack)
 {
-	static u_int16_t port = 0, *portptr;
+	static u_int16_t port = 0;
+	u_int16_t *portptr;
 	unsigned int range_size, min, i;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
