From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/5]: Fix potential memory corruption in NAT code (aka
 memory NAT)
Date: Fri, 22 Jul 2005 09:35:43 +0200
Message-ID: <42E0A1CF.7090509@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

The portptr pointing to the port in the conntrack tuple is declared static,
which could result in memory corruption when two packets of the same
protocol are NATed at the same time and one conntrack goes away.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ca30527af14847bab487c91df56f99df3c7ad1b2
tree 5cc239c38671adf873d4ce219bd507738cdd2757
parent bbdfd0b519cf535692a25adc5aa7cab3079220b4
author Patrick McHardy <kaber@trash.net> Fri, 22 Jul 2005 09:22:33 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 22 Jul 2005 09:22:33 +0200

 net/ipv4/netfilter/ip_nat_proto_tcp.c |    3 ++-
 net/ipv4/netfilter/ip_nat_proto_udp.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter/ip_nat_proto_tcp.c
--- a/net/ipv4/netfilter/ip_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c
@@ -40,7 +40,8 @@ tcp_unique_tuple(struct ip_conntrack_tup
 		 enum ip_nat_manip_type maniptype,
 		 const struct ip_conntrack *conntrack)
 {
-	static u_int16_t port, *portptr;
+	static u_int16_t port;
+	u_int16_t *portptr;
 	unsigned int range_size, min, i;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
diff --git a/net/ipv4/netfilter/ip_nat_proto_udp.c b/net/ipv4/netfilter/ip_nat_proto_udp.c
--- a/net/ipv4/netfilter/ip_nat_proto_udp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_udp.c
@@ -41,7 +41,8 @@ udp_unique_tuple(struct ip_conntrack_tup
 		 enum ip_nat_manip_type maniptype,
 		 const struct ip_conntrack *conntrack)
 {
-	static u_int16_t port, *portptr;
+	static u_int16_t port;
+	u_int16_t *portptr;
 	unsigned int range_size, min, i;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
