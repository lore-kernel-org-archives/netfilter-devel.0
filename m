From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH][Netfilter]: forgotten dev_put for bridge-devices in nf_reinject() in netfilter.c
Date: Sun, 15 Dec 2002 23:40:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200212152340.57407.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hello David,

The following patch was sent last Tuesday (5 days ago) on the netdev and=20
netfilter-devel mailing lists and I don't see it in Linus' tree yet, so I=
=20
thought I'd send it directly to you.

The patch is from Patrick McHardy <kaber@trash.net>.

The problem was caused by the bridge-netfilter patch from me. nf_queue()=20
dev_holds the phys{in,out}dev devices, but nf_reinject() doesn't dev_put(=
)=20
them.

If this is already in your patch queue, my apologies, otherwise,
please apply,

Bart

--- linux-2.5.50/net/core/netfilter.c.orig=092002-12-10 14:16:20.00000000=
0 +0100
+++ linux-2.5.50/net/core/netfilter.c=092002-12-10 14:19:23.000000000 +01=
00
@@ -574,7 +574,15 @@
 =09/* Release those devices we held, or Alexey will kill me. */
 =09if (info->indev) dev_put(info->indev);
 =09if (info->outdev) dev_put(info->outdev);
-=09
+#if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
+=09if (skb->nf_bridge) {
+=09=09if (skb->nf_bridge->physindev)
+=09=09=09dev_put(skb->nf_bridge->physindev);
+=09=09if (skb->nf_bridge->physoutdev)
+=09=09=09dev_put(skb->nf_bridge->physoutdev);
+=09}
+#endif
+
 =09kfree(info);
 =09return;
 }
