From: Anand Raj Manickam <anandrm@gmail.com>
Subject: [PATCH] iptables-nftables nft: Removes if_nametoindex ,NFT_META_OIF
 for outiface
Date: Fri, 11 Oct 2013 11:34:04 +0530
Message-ID: <CAEyr1FRKpudN76NbA-o0MAsMy8XpPFjBwviSy4xtWB46LcCekw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60298 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3JKGEG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:04:06 -0400
Received: by mail-qc0-f174.google.com with SMTP id v1so253707qcw.33
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2013 23:04:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the issue where , the Rules are added for non
existent interface and unable to delete.
eg xtables -t nat -I POSTROUTING -o eth10.10 -j MASQUERADE , allows
you to add the rule , where eth10.10 interface is not created.
But will not allow to delete as the label maps to * by  if_nametoindex().



diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 25cb177..407f650 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -145,13 +145,9 @@ void add_outiface(struct nft_rule *r, char
*iface, int invflags)
        else
                op = NFT_CMP_EQ;

-       if (iface[iface_len - 1] == '+') {
-               add_meta(r, NFT_META_OIFNAME);
-               add_cmp_ptr(r, op, iface, iface_len - 1);
-       } else {
-               add_meta(r, NFT_META_OIF);
-               add_cmp_u32(r, if_nametoindex(iface), op);
-       }
+       /*Removed NFT_META_OIF , will stick to NFT_META_OIFNAME as in
iptables */
+       add_meta(r, NFT_META_OIFNAME);
+       add_cmp_ptr(r, op, iface, iface_len);
 }

 void add_addr(struct nft_rule *r, int offset,
@@ -267,15 +263,15 @@ void parse_meta(struct nft_rule_expr *e, uint8_t
key, char *iniface,
                        *invflags |= IPT_INV_VIA_OUT;

                memcpy(outiface, ifname, len);
-               outiface[len] = '\0';

-               /* If zero, then this is an interface mask */
-               if (if_nametoindex(outiface) == 0) {
-                       outiface[len] = '+';
-                       outiface[len+1] = '\0';
-               }
+               if (outiface[len -1] == '+') {
+                                outiface[len] = '\0';
+                                memset(outiface_mask, 0xff, (len - 1));
+               } else {
+                                outiface[len + 1 ] = '\0';
+                                memset(outiface_mask, 0xff, (len + 1));
+               }

-               memset(outiface_mask, 0xff, len);
                break;
        default:
                DEBUGP("unknown meta key %d\n", key);
