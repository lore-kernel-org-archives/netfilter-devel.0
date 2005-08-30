From: Samir Bellabes <sbellabes@mandriva.com>
Subject: [PATCH] kill lockhelp for rtsp - missing ip_conntrack_rtsp.c
Date: Tue, 30 Aug 2005 17:49:00 +0200
Message-ID: <m2psrvs9w3.fsf@cerbere.dyndns.info>
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
ip_conntrack_rtsp.c is still using lockhelp.h
Sorry to have split this in two parts.

btw, Harald, should i repost patches for fixing the missing lockhelp.h
with creating a new directory 'linux-2.6.13' in extension ? :
rtsp-conntrack
   - linux
   - linux-2.6.11 ( reverse changes )
   - linux-2.6.13 ( a copy of linux-2.6.11 + fix lockhelp.h )

regards, 
Samir Bellabes


--=-=-=
Content-Type: text/x-patch; charset=iso-8859-15
Content-Disposition: attachment; filename=rtsp-conntrack_kill_lockhelp2.patch
Content-Transfer-Encoding: quoted-printable

[NETFILTER] kill lockhelp.h - missing fixes

---------------------------------------------------------------------------=
---

 ip_conntrack_rtsp.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

---------------------------------------------------------------------------=
---

Index: linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rtsp.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rtsp.c	(r=C3=A9vision 4251)
+++ linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rtsp.c	(copie de travail)
@@ -31,7 +31,6 @@
 #include <net/checksum.h>
 #include <net/tcp.h>
=20
-#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_rtsp.h>
=20
@@ -70,7 +69,7 @@
 MODULE_PARM_DESC(setup_timeout, "timeout on for unestablished data channel=
s");
=20
 static char rtsp_buffer[65536];
-static DECLARE_LOCK(rtsp_buffer_lock);
+static DEFINE_SPINLOCK(rtsp_buffer_lock);
=20
 unsigned int (*ip_nat_rtsp_hook)(struct sk_buff **pskb,
 				 enum ip_conntrack_info ctinfo,
@@ -415,7 +414,7 @@
     if (dataoff >=3D (*pskb)->len)
 	    return NF_ACCEPT;
=20
-    LOCK_BH(&rtsp_buffer_lock);
+    spin_lock_bh(&rtsp_buffer_lock);
     rb_ptr =3D skb_header_pointer(*pskb, dataoff,
 		    		(*pskb)->len - dataoff, rtsp_buffer);
     BUG_ON(rb_ptr =3D=3D NULL);
@@ -443,7 +442,7 @@
         break;
     }
=20
-    UNLOCK_BH(&rtsp_buffer_lock);
+    spin_unlock_bh(&rtsp_buffer_lock);
=20
     return ret;
 }

--=-=-=--
