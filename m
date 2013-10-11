From: Anand Raj Manickam <anandrm@gmail.com>
Subject: [PATCH] iptables-nftables nft: Removes if_nametoindex ,NFT_META_IIF, iniface
Date: Fri, 11 Oct 2013 12:03:32 +0530
Message-ID: <CAEyr1FQSk84f57Z=ep_DE_hJGee0vR9PqTGThjOkkH-=fE5ZCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:58651 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3JKGdd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:33:33 -0400
Received: by mail-qa0-f54.google.com with SMTP id j15so389347qaq.20
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2013 23:33:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch takes care of in interfaces .

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 25cb177..49a9890 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -124,13 +124,8 @@ void add_iniface(struct nft_rule *r, char *iface,
int invflags)
        else
                op = NFT_CMP_EQ;

-       if (iface[iface_len - 1] == '+') {
-               add_meta(r, NFT_META_IIFNAME);
-               add_cmp_ptr(r, op, iface, iface_len - 1);
-       } else {
-               add_meta(r, NFT_META_IIF);
-               add_cmp_u32(r, if_nametoindex(iface), op);
-       }
+       add_meta(r, NFT_META_IIFNAME);
+       add_cmp_ptr(r, op, iface, iface_len);
 }

 void add_addr(struct nft_rule *r, int offset,
@@ -251,15 +242,14 @@ void parse_meta(struct nft_rule_expr *e, uint8_t
key, char *iniface,
                        *invflags |= IPT_INV_VIA_IN;

                memcpy(iniface, ifname, len);
-               iniface[len] = '\0';

-               /* If zero, then this is an interface mask */
-               if (if_nametoindex(iniface) == 0) {
-                       iniface[len] = '+';
-                       iniface[len+1] = '\0';
+               if (iniface[len-1] == '+') {
+                       iniface[len] = '\0';
+                       memset(iniface_mask, 0xff, (len - 1));
+               } else {
+                       iniface[len + 1] = '\0';
+                       memset(iniface_mask, 0xff, (len + 1));
                }
-
-               memset(iniface_mask, 0xff, len);
                break;
