From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: [PATCH] fix undefined expression in RPC match target
Date: Tue, 4 May 2004 16:41:19 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040504204119.GE25872@ti64.telemetry-investments.com>
Reply-To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

The attached patch against patch-o-matic-ng
corrects a typo in the RPC match target.

Regards,

	Bill Rugolsky

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="netfilter-conntrack-rpc-fixincr.patch"

--- patch-o-matic-ng/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c.fixincr	2003-12-18 13:48:00.000000000 -0500
+++ patch-o-matic-ng/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c	2004-05-04 15:06:31.000000000 -0400
@@ -249,7 +249,7 @@
 		}
 
 		/* Verifies if packet is really an RPC reply packet */
-		data = data++;
+		data++;
 		if (IXDR_GET_INT32(data) != 1) {
 			DEBUGP("packet is not a valid RPC reply. [skip]\n");
 			return NF_ACCEPT;
--- patch-o-matic-ng/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_udp.c.fixincr	2003-12-18 13:48:00.000000000 -0500
+++ patch-o-matic-ng/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_udp.c	2004-05-04 15:06:45.000000000 -0400
@@ -249,7 +249,7 @@
 		}
 
 		/* Verifies if packet is really an RPC reply packet */
-		data = data++;
+		data++;
 		if (IXDR_GET_INT32(data) != 1) {
 			DEBUGP("packet is not a valid RPC reply. [skip]\n");
 			return NF_ACCEPT;

--MGYHOYXEY6WxJCY8--
