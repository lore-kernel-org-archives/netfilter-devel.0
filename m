From: Tim Gardner <timg@tpi.com>
Subject: [PATCH] patch-o-matic-ng PPTP missing GRE dependency
Date: Wed, 17 Mar 2004 09:40:08 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403170940.08902.timg@tpi.com>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Seems to me that PPTP depends on GRE. Otherwise you get unresolved refere=
nces=20
because ip_nat_proto_gre.c does not get compiled.

rtg

<--Snip-->
diff -r -u --new-file=20
pptp-conntrack-nat.old/linux/net/ipv4/netfilter/Config.in.ladd=20
pptp-conntrack-nat/linux/net/ipv4/netfilter/Config.in.ladd
--- pptp-conntrack-nat.old/linux/net/ipv4/netfilter/Config.in.ladd=092004=
-03-05=20
02:30:28.000000000 -0700
+++ pptp-conntrack-nat/linux/net/ipv4/netfilter/Config.in.ladd=092004-03-=
17=20
09:28:29.000000000 -0700
@@ -1,5 +1,6 @@
   dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP=20
$CONFIG_IP_NF_CONNTRACK
-  dep_tristate '  PPTP protocol support' CONFIG_IP_NF_PPTP=20
$CONFIG_IP_NF_CONNTRACK
+  dep_tristate 'GRE protocol support' CONFIG_IP_NF_CT_PROTO_GRE=20
$CONFIG_IP_NF_CONNTRACK
+  dep_tristate '  PPTP protocol support' CONFIG_IP_NF_PPTP=20
$CONFIG_IP_NF_CT_PROTO_GRE
   if [ "$CONFIG_IP_NF_PPTP" !=3D "n" ]; then
 =09bool   '    PPTP verbose debug' CONFIG_IP_NF_PPTP_DEBUG
   fi

--=20
Tim Gardner - timg@tpi.com
www.tpi.com 406-443-5357
