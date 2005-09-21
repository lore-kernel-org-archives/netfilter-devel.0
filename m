From: "Heyman, Michael" <Michael.Heyman@sparta.com>
Subject: (no subject)
Date: Wed, 21 Sep 2005 07:29:22 -0400
Message-ID: <87CDEF0BA329934CB1B2A156A90BBF1205BE92@coyote.columbia.ads.sparta.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

I found what apears to be a bug in the "net/ipv4/netfilter/ip_tables.c"
code. The issue arose when I had a mangle table target that could return
NF_STOLEN. The ipt_do_table() routine uses the contents of the sk_buff
to calculate "datalen" even though the sk_buff, upon return from the
"target()" call with NF_STOLEN, should be assumed invalid (in my case, I
had set the returned sk_buff to NULL).

I cannot change the kernel my target must run on. This led me to simply
set the sk_buff returned to a static with the required values,
"skb->len" and "skb->nh.iph->ihl", set to zero. Doing this doesn't seem
to break anything.

I have included a possible patch to fix the issue, I haven't tested the
patch but the idea is to simply move the sk_buff access to a point where
the sk_buff should be valid.

A quick grep shows a similar construct in
"net/ipv4/netfilter/arp_tables.c:arpt_do_table()" that may need a
similar fix.

-Michael Heyman


--- foo.c	2005-09-21 07:00:35.000000000 -0400
+++ net/ipv4/netfilter/ip_tables.c	2005-06-17 15:48:29.000000000
-0400
@@ -378,15 +378,16 @@
 				((struct ipt_entry
*)table_base)->comefrom
 					=3D 0x57acc001;
 #endif
-				/* Target might have changed stuff. */
-				ip =3D (*pskb)->nh.iph;
-				datalen =3D (*pskb)->len - ip->ihl * 4;
-
 				if (verdict =3D=3D IPT_CONTINUE)
 					e =3D (void *)e + e->next_offset;
 				else
 					/* Verdict */
 					break;
+
+				/* Target might have changed stuff. */
+				ip =3D (*pskb)->nh.iph;
+				datalen =3D (*pskb)->len - ip->ihl * 4;
+
 			}
 		} else=20
