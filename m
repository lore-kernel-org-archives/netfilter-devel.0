From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/*]: GRE conntrack: fix htons/htonl confusion
Date: Fri, 19 May 2006 03:21:45 +0200
Message-ID: <446D1DA9.5000507@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010201000608030303020404"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------010201000608030303020404
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Dave,

following are three more fixes on top of the last two: the
byteorder fixes from Alexey Dobriyan and Solar Designer's
do_add_counters fix. Please also apply.


 net/ipv4/netfilter/arp_tables.c       |    2 +-
 net/ipv4/netfilter/ip_nat_proto_gre.c |   12 ++++++------
 net/ipv6/netfilter/ip6_tables.c       |    2 +-
 net/netfilter/nfnetlink_log.c         |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

Alexey Dobriyan:
      [NETFILTER]: GRE conntrack: fix htons/htonl confusion

Kirill Korotaev:
      [NETFILTER]: Fix do_add_counters race, possible oops or info leak
(CVE-2006-0039)

Patrick McHardy:
      [NETFILTER]: nfnetlink_log: fix byteorder confusion

--------------010201000608030303020404
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: GRE conntrack: fix htons/htonl confusion

GRE keys are 16 bit.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 326640604c2d35b4b93808fc478e337a9f94414c
tree ed970126dc0500310b6c7cc812ad1e438ce701c0
parent a54c9d30dbb06391ec4422aaf0e1dc2c8c53bd3e
author Alexey Dobriyan <adobriyan@gmail.com> Thu, 18 May 2006 16:35:47 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 18 May 2006 16:35:47 +0200

 net/ipv4/netfilter/ip_nat_proto_gre.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_proto_gre.c b/net/ipv4/netfilter/ip_nat_proto_gre.c
index 6c4899d..96ceaba 100644
--- a/net/ipv4/netfilter/ip_nat_proto_gre.c
+++ b/net/ipv4/netfilter/ip_nat_proto_gre.c
@@ -49,15 +49,15 @@ gre_in_range(const struct ip_conntrack_t
 	     const union ip_conntrack_manip_proto *min,
 	     const union ip_conntrack_manip_proto *max)
 {
-	u_int32_t key;
+	__be16 key;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
 		key = tuple->src.u.gre.key;
 	else
 		key = tuple->dst.u.gre.key;
 
-	return ntohl(key) >= ntohl(min->gre.key)
-		&& ntohl(key) <= ntohl(max->gre.key);
+	return ntohs(key) >= ntohs(min->gre.key)
+		&& ntohs(key) <= ntohs(max->gre.key);
 }
 
 /* generate unique tuple ... */
@@ -81,14 +81,14 @@ gre_unique_tuple(struct ip_conntrack_tup
 		min = 1;
 		range_size = 0xffff;
 	} else {
-		min = ntohl(range->min.gre.key);
-		range_size = ntohl(range->max.gre.key) - min + 1;
+		min = ntohs(range->min.gre.key);
+		range_size = ntohs(range->max.gre.key) - min + 1;
 	}
 
 	DEBUGP("min = %u, range_size = %u\n", min, range_size); 
 
 	for (i = 0; i < range_size; i++, key++) {
-		*keyptr = htonl(min + key % range_size);
+		*keyptr = htons(min + key % range_size);
 		if (!ip_nat_used_tuple(tuple, conntrack))
 			return 1;
 	}

--------------010201000608030303020404--
