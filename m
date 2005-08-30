From: Samir Bellabes <sbellabes@mandriva.com>
Subject: [PATCH] kill lockhelp.h for u32
Date: Tue, 30 Aug 2005 19:50:52 +0200
Message-ID: <m2k6i3qpoj.fsf@cerbere.dyndns.info>
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
this fix missing lockhelp.h for u32

regards,
Samir Bellabes


--=-=-=
Content-Type: text/x-patch; charset=iso-8859-15
Content-Disposition: attachment; filename=u32_kill_lockhelp.patch
Content-Transfer-Encoding: quoted-printable

[NETFILTER] kill lockhelp.h for u32

---------------------------------------------------------------------------=
---

 ipt_u32.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

---------------------------------------------------------------------------=
---

Index: linux-2.6/net/ipv4/netfilter/ipt_u32.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6/net/ipv4/netfilter/ipt_u32.c	(r=C3=A9vision 4251)
+++ linux-2.6/net/ipv4/netfilter/ipt_u32.c	(copie de travail)
@@ -105,7 +105,6 @@
=20
 #include <linux/netfilter_ipv4/ipt_u32.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
=20
 /* #include <asm-i386/timex.h> for timing */
=20
@@ -115,7 +114,7 @@
=20
 /* This is slow, but it's simple. --RR */
 static char u32_buffer[65536];
-static DECLARE_LOCK(u32_lock);
+static DEFINE_SPINLOCK(u32_lock);
=20
 static int
 match(const struct sk_buff *skb,
@@ -136,7 +135,7 @@
=20
 	u_int32_t AttPos;
=20
-	LOCK_BH(&u32_lock);
+	spin_lock_bh(&u32_lock);
=20
 	head =3D skb_header_pointer(skb, 0, skb->len, u32_buffer);
 	BUG_ON(head =3D=3D NULL);
@@ -148,7 +147,7 @@
 	        AttPos =3D 0;
 		pos =3D data->tests[testind].location[0].number;
 		if (AttPos + pos + 3 > skb->len || AttPos + pos < 0){
-			UNLOCK_BH(&u32_lock);
+			spin_unlock_bh(&u32_lock);
 			return 0;
 		}
 		val =3D (base[pos]<<24) + (base[pos+1]<<16) +
@@ -190,13 +189,13 @@
 			/* cycles2 =3D get_cycles();=20
 			   printk("failed %d in %d cycles\n", testind,=20
 				  cycles2-cycles1); */
-			UNLOCK_BH(&u32_lock);
+			spin_unlock_bh(&u32_lock);
 			return 0;
 		}
 	}
 	/* cycles2 =3D get_cycles();
 	   printk("succeeded in %d cycles\n", cycles2-cycles1); */
-	UNLOCK_BH(&u32_lock);
+	spin_unlock_bh(&u32_lock);
 	return 1;
 }
=20

--=-=-=--
