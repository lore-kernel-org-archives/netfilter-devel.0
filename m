From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: [RFC] netfilter: xt_TEE:  IPv4 Don't Fragmet options
Date: Thu, 14 Jun 2012 08:17:35 +0200 (CEST)
Message-ID: <rvd97lb.cb16bfe930b2100854041c0a3d714500@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>,
	"Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:60272 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2FNGRk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 02:17:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I  think it is wrong to always force the DF bit in IPv4, it's better to have an option
If an application don't set the DF bit, usually it doesn't expect to get an icmp back either.
The result is that the packet will be dropped...

To retain backwards compatibility I suggest adding a new option like

--ipv4-df-copy  Do not force "Don't Fragment" on the copied packet just copy the bit.

In IPv6 we don't have that option, so nothing has to be done there.


diff --git a/include/linux/netfilter/xt_TEE.h b/include/linux/netfilter/xt_TEE.h
index 5c21d5c..e5fca8a 100644
--- a/include/linux/netfilter/xt_TEE.h
+++ b/include/linux/netfilter/xt_TEE.h
@@ -4,6 +4,7 @@
 struct xt_tee_tginfo {
        union nf_inet_addr gw;
        char oif[16];
+       int df_copy;

        /* used internally by the kernel */
        struct xt_tee_priv *priv __attribute__((aligned(8)));
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index ee2e5bc..e9a1ca7 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -117,7 +117,8 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
         * decreased MTU on the clone route. IPv6 does this too.
         */
        iph = ip_hdr(skb);
-       iph->frag_off |= htons(IP_DF);
+       if (!info->df_copy)
+               iph->frag_off |= htons(IP_DF);
        if (par->hooknum == NF_INET_PRE_ROUTING ||
            par->hooknum == NF_INET_LOCAL_IN)
                --iph->ttl;


--
Regards 
Hans Schillstrom
+46 70 699 7150


