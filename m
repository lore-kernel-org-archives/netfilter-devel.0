From: Samir Bellabes <sbellabes@mandriva.com>
Subject: [NETFILTER] Kill lockhelp.h for rsh
Date: Mon, 29 Aug 2005 19:13:50 +0200
Message-ID: <m2zmr0vf75.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--=-=-=

Hi,
This patch fix the match rsh', after the kill_lockhelp.patch
Please apply at top of the svn tree.

regards,
Samir Bellabes


--=-=-=
Content-Type: text/x-patch; charset=iso-8859-15
Content-Disposition: attachment; filename=rsh_kill_lockhelp.patch
Content-Transfer-Encoding: quoted-printable


[NETFILTER] Kill lockhelp.h for rsh

---------------------------------------------------------------------------=
---

 include/linux/netfilter_ipv4/ip_conntrack_rsh.h |    3 +--
 net/ipv4/netfilter/ip_conntrack_rsh.c           |    7 +++----
 2 files changed, 4 insertions(+), 6 deletions(-)

---------------------------------------------------------------------------=
---

Index: patchlets/rsh/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack=
_rsh.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/rsh/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_rs=
h.h	(r=C3=A9vision 4248)
+++ patchlets/rsh/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_rs=
h.h	(copie de travail)
@@ -13,9 +13,8 @@
 #define _IP_CONNTRACK_RSH_H
=20
 #ifdef __KERNEL__
-#include <linux/netfilter_ipv4/lockhelp.h>
=20
-DECLARE_LOCK_EXTERN(ip_rsh_lock);
+extern spinlock_t ip_rsh_lock;
 #endif
=20
=20
Index: patchlets/rsh/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rsh.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/rsh/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rsh.c	(r=C3=
=A9vision 4248)
+++ patchlets/rsh/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rsh.c	(copie=
 de travail)
@@ -103,7 +103,6 @@
 #include <net/checksum.h>
 #include <net/tcp.h>
=20
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_rsh.h>
@@ -120,7 +119,7 @@
 MODULE_PARM_DESC(ports, "port numbers of RSH servers");
 #endif
=20
-static DECLARE_LOCK(rsh_buffer_lock);
+static spinlock_t rsh_buffer_lock =3D SPIN_LOCK_UNLOCKED;
 static char rsh_buffer[65535];
=20
 unsigned int (*ip_nat_rsh_hook)(struct sk_buff **pskb,
@@ -179,7 +178,7 @@
 	if (dataoff >=3D (*pskb)->len)
 		return NF_ACCEPT;
=20
-	LOCK_BH(&rsh_buffer_lock);
+	spin_lock_bh(&rsh_buffer_lock);
 	rb_ptr =3D skb_header_pointer(*pskb, dataoff,
 				    (*pskb)->len - dataoff, rsh_buffer);
 	BUG_ON(rb_ptr =3D=3D NULL);
@@ -256,7 +255,7 @@
 		ntohs(exp->mask.dst.u.tcp.port));
=20
 out:
-	UNLOCK_BH(&rsh_buffer_lock);
+	spin_unlock_bh(&rsh_buffer_lock);
=20
 	return ret;
 }

--=-=-=--
