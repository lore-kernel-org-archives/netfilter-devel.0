From: James Morris <jmorris@intercode.com.au>
Subject: [PATCH]: forgotten dev_put for bridge-devices in nf_reinject (fwd)
Date: Wed, 11 Dec 2002 11:54:34 +1100 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0212111154180.4481-200000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY=------------000505020000010609080306
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Content-ID: <Mutt.LNX.4.44.0212111154190.4481@blackbird.intercode.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

--------------000505020000010609080306
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <Mutt.LNX.4.44.0212111154191.4481@blackbird.intercode.com.au>

---------- Forwarded message ----------
Date: Tue, 10 Dec 2002 14:35:58 +0100
From: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Cc: netdev@oss.sgi.com
Subject: [PATCH]: forgotten dev_put for bridge-devices in nf_reinject

Hi.

The attached patch releases the bridge devices grabbed in nf_queue after 
reinjecting the packet.
Seems someone forgot these (or planned to get Rusty killed) ;)

Bye,
Patrick

--------------000505020000010609080306
Content-Type: TEXT/PLAIN; NAME="nfqueue-bridge-devput.diff"
Content-ID: <Mutt.LNX.4.44.0212111154192.4481@blackbird.intercode.com.au>
Content-Description: 
Content-Disposition: INLINE; FILENAME="nfqueue-bridge-devput.diff"

--- linux-2.5.50/net/core/netfilter.c.orig	2002-12-10 14:16:20.000000000 +0100
+++ linux-2.5.50/net/core/netfilter.c	2002-12-10 14:19:23.000000000 +0100
@@ -574,7 +574,15 @@
 	/* Release those devices we held, or Alexey will kill me. */
 	if (info->indev) dev_put(info->indev);
 	if (info->outdev) dev_put(info->outdev);
-	
+#if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
+	if (skb->nf_bridge) {
+		if (skb->nf_bridge->physindev)
+			dev_put(skb->nf_bridge->physindev);
+		if (skb->nf_bridge->physoutdev)
+			dev_put(skb->nf_bridge->physoutdev);
+	}
+#endif
+
 	kfree(info);
 	return;
 }

--------------000505020000010609080306--
