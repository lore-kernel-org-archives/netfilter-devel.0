From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ROUTE target fixes for 2.6.10+
Date: Thu, 10 Feb 2005 10:25:16 -0800
Message-ID: <20050210182516.GA3903@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Since initialized has been removed, the below is needed for 2.6.10+
kernels.

This fixes bugzilla #284

Phil



--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-route

diff -ru pom-orig/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c pom-new/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c
--- pom-orig/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2004-12-13 21:58:31.000000000 -0500
+++ pom-new/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2005-02-10 13:16:19.235968840 -0500
@@ -449,8 +449,7 @@
 	/*  - and look it like as a confirmed connection */
 	set_bit(IPS_CONFIRMED_BIT, &route_tee_track.status);
 	/* Initialize fake conntrack so that NAT will skip it */
-	route_tee_track.nat.info.initialized |= 
-		(1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
+	route_tee_track.status |= IPS_NAT_DONE_MASK;
 
 	return ipt_register_target(&ipt_route_reg);
 }

--7AUc2qLy4jB3hD7Z--
