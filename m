Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EDEC3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6650F2190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="j1ph2TEo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbfIAVCX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:02:23 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53754 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729059AbfIAVCX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:02:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Stt/HXY36S8lfRaNUai3VgdvST0n/5WNeEhLXbyT+tk=; b=j1ph2TEoBR6wNGXGRPrU/QQvl1
        rPi3DTzfdGthPNPzPXrT0fnYztwyB3XBKTRhUgbZ9YAt7tw0Na4xZ9lXCu6jkzVJkEHCl2aNZA2BG
        cEAhJSNdqJTjdDiG5ufoFr9fEIXMB7QQ0sXMhqP2wnYTuf8MfL2IzLleZT3Tost0/Hyeg7F2BayoS
        oJAQYKlwY8nQSXQ7oxW1TvlLhCFr4yjlk50JTnPuJBdoVKUE5hTvRcVP7syPCIS5yVucYAKKTTmpM
        vOt6+ldzQYmkD5C6FqRjviwraa2az70/ZjWXvPIX9PzPtU3xADueYDHQyjhc8l1XBARxFJvJLhtsn
        L00Gp6gw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Woq-0002Uf-SF; Sun, 01 Sep 2019 21:51:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 18/29] netfilter: replace defined(CONFIG...) || defined(CONFIG...MODULE) with IS_ENABLED(CONFIG...).
Date:   Sun,  1 Sep 2019 21:51:14 +0100
Message-Id: <20190901205126.6935-19-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190901205126.6935-1-jeremy@azazel.net>
References: <20190901205126.6935-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A few headers contain instances of:

  #if defined(CONFIG_XXX) or defined(CONFIG_XXX_MODULE)

Replace them with:

  #if IS_ENABLED(CONFIG_XXX)

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter.h                      | 2 +-
 include/linux/netfilter/ipset/ip_set_getport.h | 2 +-
 include/net/netfilter/nf_conntrack_extend.h    | 2 +-
 include/net/netfilter/nf_nat.h                 | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 4c94dd4cc8d0..3bed59528fed 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -422,7 +422,7 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 }
 #endif /*CONFIG_NETFILTER*/
 
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_zones_common.h>
 
 extern void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *) __rcu;
diff --git a/include/linux/netfilter/ipset/ip_set_getport.h b/include/linux/netfilter/ipset/ip_set_getport.h
index a906df06948b..d74cd112b88a 100644
--- a/include/linux/netfilter/ipset/ip_set_getport.h
+++ b/include/linux/netfilter/ipset/ip_set_getport.h
@@ -9,7 +9,7 @@
 extern bool ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
 				__be16 *port, u8 *proto);
 
-#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 extern bool ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
 				__be16 *port, u8 *proto);
 #else
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 21f887c5058c..112a6f40dfaf 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -8,7 +8,7 @@
 
 enum nf_ct_ext_id {
 	NF_CT_EXT_HELPER,
-#if defined(CONFIG_NF_NAT) || defined(CONFIG_NF_NAT_MODULE)
+#if IS_ENABLED(CONFIG_NF_NAT)
 	NF_CT_EXT_NAT,
 #endif
 	NF_CT_EXT_SEQADJ,
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 518b3288bab4..327bf218de65 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -24,7 +24,7 @@ enum nf_nat_manip_type {
 /* per conntrack: nat application helper private data */
 union nf_conntrack_nat_help {
 	/* insert nat helper private data here */
-#if defined(CONFIG_NF_NAT_PPTP) || defined(CONFIG_NF_NAT_PPTP_MODULE)
+#if IS_ENABLED(CONFIG_NF_NAT_PPTP)
 	struct nf_nat_pptp nat_pptp_info;
 #endif
 };
-- 
2.23.0.rc1

