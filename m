From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] use correct ipt_physdev.h header in iptables userspace tool
Date: Sat, 25 Oct 2003 08:48:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310250848.37967.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Fzhm/bAi0jHLB3p"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Dirk Morris <dmorris@metavize.com>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_Fzhm/bAi0jHLB3p
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Harald, this just makes the userspace tool use the right 2.6.0-test8
header file. Remember we broke compatibility to get things working
on the parisc?

cheers,
Bart

--- iptables-1.2.9rc1/include/linux/netfilter_ipv4/ipt_physdev.h.old	2003-10-25 08:41:48.000000000 +0200
+++ iptables-1.2.9rc1/include/linux/netfilter_ipv4/ipt_physdev.h	2003-10-25 08:43:31.000000000 +0200
@@ -13,12 +13,12 @@
 #define IPT_PHYSDEV_OP_MASK		(0x20 - 1)
 
 struct ipt_physdev_info {
-	u_int8_t invert;
-	u_int8_t bitmask;
 	char physindev[IFNAMSIZ];
 	char in_mask[IFNAMSIZ];
 	char physoutdev[IFNAMSIZ];
 	char out_mask[IFNAMSIZ];
+	u_int8_t invert;
+	u_int8_t bitmask;
 };
 
 #endif /*_IPT_PHYSDEV_H*/

--Boundary-00=_Fzhm/bAi0jHLB3p
Content-Type: text/x-diff;
  charset="us-ascii";
  name="ipt_userspace_physdev_h.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="ipt_userspace_physdev_h.diff"

--- iptables-1.2.9rc1/include/linux/netfilter_ipv4/ipt_physdev.h.old	2003-10-25 08:41:48.000000000 +0200
+++ iptables-1.2.9rc1/include/linux/netfilter_ipv4/ipt_physdev.h	2003-10-25 08:43:31.000000000 +0200
@@ -13,12 +13,12 @@
 #define IPT_PHYSDEV_OP_MASK		(0x20 - 1)
 
 struct ipt_physdev_info {
-	u_int8_t invert;
-	u_int8_t bitmask;
 	char physindev[IFNAMSIZ];
 	char in_mask[IFNAMSIZ];
 	char physoutdev[IFNAMSIZ];
 	char out_mask[IFNAMSIZ];
+	u_int8_t invert;
+	u_int8_t bitmask;
 };
 
 #endif /*_IPT_PHYSDEV_H*/

--Boundary-00=_Fzhm/bAi0jHLB3p--
