From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] gre_in_range: 16/32 bit fix
Date: Thu, 18 May 2006 17:38:52 +0400
Message-ID: <20060518133852.GA13516@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
To: netdev@vger.kernel.org
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

GRE keys are 16 bit.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv4/netfilter/ip_nat_proto_gre.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/netfilter/ip_nat_proto_gre.c
+++ 1/net/ipv4/netfilter/ip_nat_proto_gre.c
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

