From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
Subject: [2.6.13] u32 fix.
Date: Fri, 16 Sep 2005 15:48:38 +0200
Message-ID: <200509161548.38464.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_20sKDf1cDsjF86X"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
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

--Boundary-00=_20sKDf1cDsjF86X
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Could someone check and commit this lockhelp-fix?

Regards,
Pawe=C5=82.

--=20
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke

--Boundary-00=_20sKDf1cDsjF86X
Content-Type: text/x-diff;
  charset="utf-8";
  name="u32-2.6.13.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="u32-2.6.13.patch"

Index: patchlets/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c
===================================================================
--- patchlets/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c	(revision 4262)
+++ patchlets/u32/linux-2.6/net/ipv4/netfilter/ipt_u32.c	(working copy)
@@ -105,7 +105,6 @@
 
 #include <linux/netfilter_ipv4/ipt_u32.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
 
 /* #include <asm-i386/timex.h> for timing */
 
@@ -115,7 +114,7 @@
 
 /* This is slow, but it's simple. --RR */
 static char u32_buffer[65536];
-static DECLARE_LOCK(u32_lock);
+static DEFINE_SPINLOCK(u32_lock);
 
 static int
 match(const struct sk_buff *skb,
@@ -136,7 +135,7 @@
 
 	u_int32_t AttPos;
 
-	LOCK_BH(&u32_lock);
+	spin_lock_bh(&u32_lock);
 
 	head = skb_header_pointer(skb, 0, skb->len, u32_buffer);
 	BUG_ON(head == NULL);
@@ -148,7 +147,7 @@
 	        AttPos = 0;
 		pos = data->tests[testind].location[0].number;
 		if (AttPos + pos + 3 > skb->len || AttPos + pos < 0){
-			UNLOCK_BH(&u32_lock);
+			spin_unlock_bh(&u32_lock);
 			return 0;
 		}
 		val = (base[pos]<<24) + (base[pos+1]<<16) +
@@ -190,13 +189,13 @@
 			/* cycles2 = get_cycles(); 
 			   printk("failed %d in %d cycles\n", testind, 
 				  cycles2-cycles1); */
-			UNLOCK_BH(&u32_lock);
+			spin_unlock_bh(&u32_lock);
 			return 0;
 		}
 	}
 	/* cycles2 = get_cycles();
 	   printk("succeeded in %d cycles\n", cycles2-cycles1); */
-	UNLOCK_BH(&u32_lock);
+	spin_unlock_bh(&u32_lock);
 	return 1;
 }
 

--Boundary-00=_20sKDf1cDsjF86X--
