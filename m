From: Bob Hockney <bhockney@ix.netcom.com>
Subject: [PATCH] nfnetlink_log mac address for 6in4 tunnels
Date: Wed, 5 Dec 2012 11:05:21 -0700 (GMT-07:00)
Message-ID: <5368964.1354730721679.JavaMail.root@elwamui-rustique.atl.sa.earthlink.net>
Reply-To: Bob Hockney <bhockney@ix.netcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:35534 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193Ab2LESFW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:05:22 -0500
Received: from [209.86.224.48] (helo=elwamui-rustique.atl.sa.earthlink.net)
	by elasmtp-dupuy.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <bhockney@ix.netcom.com>)
	id 1TgJLV-0003VF-TJ
	for netfilter-devel@vger.kernel.org; Wed, 05 Dec 2012 13:05:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For tunnelled ipv6in4 packets, the LOG target (xt_LOG.c) adjusts the start of the mac field to start at the ethernet header instead of the ipv4 header for the tunnel.  This patch conforms what is passed by the NFLOG target through nfnetlink to what the LOG target does.  Code borrowed from xt_LOG.c.

===
--- a/net/netfilter/nfnetlink_log.c        2012-11-28 17:11:02.285514325 -0700
+++ b/net/netfilter/nfnetlink_log.c 2012-11-28 17:10:38.551830948 -0700
@@ -382,6 +382,7 @@
        struct nfgenmsg *nfmsg;
        sk_buff_data_t old_tail = inst->skb->tail;
        struct sock *sk;
+       const unsigned char *hwhdrp;

        nlh = nlmsg_put(inst->skb, 0, 0,
                        NFNL_SUBSYS_ULOG << 8 | NFULNL_MSG_PACKET,
@@ -483,9 +484,16 @@
        if (indev && skb_mac_header_was_set(skb)) {
                if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
                    nla_put_be16(inst->skb, NFULA_HWLEN,
-                                htons(skb->dev->hard_header_len)) ||
-                   nla_put(inst->skb, NFULA_HWHEADER, skb->dev->hard_header_len,
-                           skb_mac_header(skb)))
+                                htons(skb->dev->hard_header_len)))
+                       goto nla_put_failure;
+
+               hwhdrp = skb_mac_header(skb);
+
+               if (skb->dev->type == ARPHRD_SIT)
+                       hwhdrp -= ETH_HLEN;
+
+               if (!(hwhdrp < skb->head) && nla_put(inst->skb, NFULA_HWHEADER,
+                           skb->dev->hard_header_len, hwhdrp))
                        goto nla_put_failure;
        }




