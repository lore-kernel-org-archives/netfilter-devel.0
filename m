From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 01/13] Loosen source address check on IPv4 output
Date: Sun, 30 Sep 2007 22:51:52 +0200
Message-ID: <20070930205152.10969.59108.stgit@nessa.odu>
References: <20070930205141.10969.27205.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:40423 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXI3VLy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:11:54 -0400
In-Reply-To: <20070930205141.10969.27205.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

ip_route_output() contains a check to make sure that no flows with
non-local source IP addresses are routed. This obviously makes using
such addresses impossible.

This patch introduces a flowi flag which makes omitting this check
possible. The new flag provides a way of handling transparent and
non-transparent connections differently.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 include/net/flow.h |    1 +
 net/ipv4/route.c   |   20 +++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index af59fa5..c734d50 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -49,6 +49,7 @@ struct flowi {
 	__u8	proto;
 	__u8	flags;
 #define FLOWI_FLAG_MULTIPATHOLDROUTE 0x01
+#define FLOWI_FLAG_ANYSRC 0x02
 	union {
 		struct {
 			__be16	sport;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index c7ca94b..26e9659 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2172,11 +2172,6 @@ static int ip_route_output_slow(struct rtable **rp, const struct flowi *oldflp)
 		    ZERONET(oldflp->fl4_src))
 			goto out;
 
-		/* It is equivalent to inet_addr_type(saddr) == RTN_LOCAL */
-		dev_out = ip_dev_find(oldflp->fl4_src);
-		if (dev_out == NULL)
-			goto out;
-
 		/* I removed check for oif == dev_out->oif here.
 		   It was wrong for two reasons:
 		   1. ip_dev_find(saddr) can return wrong iface, if saddr is
@@ -2187,6 +2182,11 @@ static int ip_route_output_slow(struct rtable **rp, const struct flowi *oldflp)
 
 		if (oldflp->oif == 0
 		    && (MULTICAST(oldflp->fl4_dst) || oldflp->fl4_dst == htonl(0xFFFFFFFF))) {
+			/* It is equivalent to inet_addr_type(saddr) == RTN_LOCAL */
+			dev_out = ip_dev_find(oldflp->fl4_src);
+			if (dev_out == NULL)
+				goto out;
+
 			/* Special hack: user can direct multicasts
 			   and limited broadcast via necessary interface
 			   without fiddling with IP_MULTICAST_IF or IP_PKTINFO.
@@ -2205,9 +2205,15 @@ static int ip_route_output_slow(struct rtable **rp, const struct flowi *oldflp)
 			fl.oif = dev_out->ifindex;
 			goto make_route;
 		}
-		if (dev_out)
+
+		if (!(oldflp->flags & FLOWI_FLAG_ANYSRC)) {
+			/* It is equivalent to inet_addr_type(saddr) == RTN_LOCAL */
+			dev_out = ip_dev_find(oldflp->fl4_src);
+			if (dev_out == NULL)
+				goto out;
 			dev_put(dev_out);
-		dev_out = NULL;
+			dev_out = NULL;
+		}
 	}
 
 

