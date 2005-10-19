From: Amin Azez <azez@ufomechanic.net>
Subject: PATCH Re: ipt_ulog.h versus ebt_ulog.h
Date: Wed, 19 Oct 2005 14:05:27 +0100
Message-ID: <43564497.20009@ufomechanic.net>
References: <dj519g$ke6$1@sea.gmane.org> <435614E6.1080200@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030409080804070805020602"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <435614E6.1080200@ufomechanic.net>
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

This is a multi-part message in MIME format.
--------------030409080804070805020602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Do we need an equivalent patch for ulog2?

ipt_ULOG was logging the bridge device instead of the physical devices
(for bridged packets at least).

This patch does it's best to cause logging of the physical devices
involved. I realise the patch is not going to be handled as it addresses
ulog1 but I should ask if the problem of not logging physical devices is
also a problem with ulog2.

Harald; also does it make sense with ulog2 to talk about merging
ebt_ulog_packet_msg and ulog_packet_msg?

Sam



--------------030409080804070805020602
Content-Type: text/x-patch;
 name="ulog.physdev2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ulog.physdev2.patch"

--- ./net/ipv4/netfilter/ipt_ULOG.c.prephysdev	2005-10-19 10:46:52.000000000 +0100
+++ ./net/ipv4/netfilter/ipt_ULOG.c	2005-10-19 11:55:49.000000000 +0100
@@ -244,14 +244,26 @@
 	} else
 		pm->mac_len = 0;
 
-	if (in)
-		strncpy(pm->indev_name, in->name, sizeof(pm->indev_name));
-	else
+	if (in) {
+#ifdef CONFIG_BRIDGE_NETFILTER
+		if (skb->nf_bridge) 
+			strncpy(pm->indev_name, &(skb->nf_bridge->physindev->name), sizeof(pm->indev_name));
+		else if (skb->input_dev) 
+			strncpy(pm->indev_name, &(skb->input_dev.name), sizeof(pm->indev_name));
+		else 
+#endif
+			strncpy(pm->indev_name, in->name, sizeof(pm->indev_name));
+	} else
 		pm->indev_name[0] = '\0';
 
-	if (out)
+	if (out) {
+#ifdef CONFIG_BRIDGE_NETFILTER
+		if (skb->nf_bridge) 
+			strncpy(pm->outdev_name, &(skb->nf_bridge->physoutdev->name), sizeof(pm->outdev_name));
+		else 
+#endif
 		strncpy(pm->outdev_name, out->name, sizeof(pm->outdev_name));
-	else
+	} else
 		pm->outdev_name[0] = '\0';
 
 	/* copy_len <= skb->len, so can't fail. */

--------------030409080804070805020602--
