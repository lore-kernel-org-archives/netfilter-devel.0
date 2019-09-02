Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8865CC3A5A5
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60C2C22CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="KAhfQR0r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfIBXcM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:12 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43962 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXcL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OlR+v2wsEq5hAGzISsZ2+4ObWrh7A2ym6Iwi5ZU/K04=; b=KAhfQR0rhvyQKP7SeyRNogj+g0
        9Kh/SftLRSisg8og+ezqelioo2aAcnvnS9v+eBINdLXUA8V1ZM2IZVFZtpSlVPyy3BeLx800yNB1G
        bLPcrziqTPrbw/PcEnXY6CbwdsQYP1f1IDDE1LndYp550/aBns6GuAVXfHt5/tcWPuLcaYPn0SIPp
        Uu7ZXs1LHswSaHQGKY0PNFoMdeZbTFLcN/9YeRir7/M2Q1K2URh083apzdedu/Ga6lDCP/MegTL+k
        HGT2JWDXLXkgHp+M6aTVIO/gtaAYbdhSlScgBSe1HDJTeUw5LfxjjXk9L3aIPRFn/k2J3ljoysda0
        r+FLCihQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPR-0004la-KD; Tue, 03 Sep 2019 00:06:53 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 19/30] netfilter: replace defined(CONFIG...) || defined(CONFIG...MODULE) with IS_ENABLED(CONFIG...).
Date:   Tue,  3 Sep 2019 00:06:39 +0100
Message-Id: <20190902230650.14621-20-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190902230650.14621-1-jeremy@azazel.net>
References: <20190902230650.14621-1-jeremy@azazel.net>
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
 include/net/netfilter/nf_nat.h                 | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

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
index eeb336809679..362ff94fa6b0 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -22,7 +22,7 @@ enum nf_nat_manip_type {
 /* per conntrack: nat application helper private data */
 union nf_conntrack_nat_help {
 	/* insert nat helper private data here */
-#if defined(CONFIG_NF_NAT_PPTP) || defined(CONFIG_NF_NAT_PPTP_MODULE)
+#if IS_ENABLED(CONFIG_NF_NAT_PPTP)
 	struct nf_nat_pptp nat_pptp_info;
 #endif
 };
@@ -47,7 +47,7 @@ struct nf_conn_nat *nf_ct_nat_ext_add(struct nf_conn *ct);
 
 static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
 {
-#if defined(CONFIG_NF_NAT) || defined(CONFIG_NF_NAT_MODULE)
+#if IS_ENABLED(CONFIG_NF_NAT)
 	return nf_ct_ext_find(ct, NF_CT_EXT_NAT);
 #else
 	return NULL;
-- 
2.23.0.rc1

