From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH, RFC] possible use of freed skbuff in netfilter.c
Date: Fri, 25 Apr 2003 19:57:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304251957.18012.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Rusty Russel <rusty@rustcorp.com.au>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David S.Miller <davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Dave,

When dev_put'ing bridge devices in netfilter.c::reinject the skb can alre=
ady=20
be freed. The patch below fixes this by delaying the freeing of the skb a=
=20
bit. AFAIK, calling kfree_skb outside the read_lock causes no problems.
Could someone of the netfilter core team approve or disapprove this chang=
e?
This is bug 86 of the netfilter bugtracking system.

cheers,
Bart

--- linux-2.5.68/net/core/netfilter.c.old=09Fri Apr 25 19:23:35 2003
+++ linux-2.5.68/net/core/netfilter.c=09Fri Apr 25 19:24:47 2003
@@ -559,10 +559,6 @@
 =09=09nf_queue(skb, elem, info->pf, info->hook,=20
 =09=09=09 info->indev, info->outdev, info->okfn);
 =09=09break;
-
-=09case NF_DROP:
-=09=09kfree_skb(skb);
-=09=09break;
 =09}
 =09br_read_unlock_bh(BR_NETPROTO_LOCK);
=20
@@ -578,6 +574,10 @@
 =09}
 #endif
=20
+
+=09if (verdict =3D=3D NF_DROP)
+=09=09kfree_skb(skb);
+
 =09kfree(info);
 =09return;
 }
