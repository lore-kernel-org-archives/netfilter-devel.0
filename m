Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82306C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 453542190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="DKYK/7ku"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfIAVBU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:01:20 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53546 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbfIAVBT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZmvKMdx1Yja1CfdPxcR6lw1Mp1wLQW+OmLCcmt4PitM=; b=DKYK/7kuo7zCxWQO7Xi9Lnmk0M
        0/sn+p5qfLFIcMeOKpKQ4jhvsbUUzXEWHE9NjykBVj2kP6/qwSO/IuxebM/8j3WXgt1YP/vN/u40F
        QhYP7SPJ6EWbh1pRHhyAnKkSrWeuqLJtQLE2Zp87MiIc7A2/f28JhrJFKBO9LUDTAiL4q+NXKx0QB
        JytQ6x2fJq7AT+8o3d6R9IUATNlhoDQX93Yl43dtBgy5yMomms6U7uofPLS2YcbRFulWzLQfKc6bX
        TbExhhzbV8sLbhO1g6HsYeALQjggSbSDLMPrcn5fWXIXl5G6YrabAAKrN1dLpWbuvPwasBO/7z90U
        0EK4g1Uw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Wos-0002Uf-0U; Sun, 01 Sep 2019 21:51:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 25/29] netfilter: add CONFIG_NETFILTER check to linux/netfilter.h.
Date:   Sun,  1 Sep 2019 21:51:21 +0100
Message-Id: <20190901205126.6935-26-jeremy@azazel.net>
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

The bulk of this header is already wrapped in CONFIG_NETFILTER or
CONFIG_NF_CONNTRACK checks.  The last few definitions are also only
required if CONFIG_NETFILTER is enabled.  Add another conditional for
that remainder.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 3bed59528fed..075d48ef6a48 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -16,6 +16,7 @@
 #include <net/net_namespace.h>
 
 #ifdef CONFIG_NETFILTER
+
 static inline int NF_DROP_GETERR(int verdict)
 {
 	return -(verdict >> NF_VERDICT_QBITS);
@@ -415,11 +416,13 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 {
 	return 1;
 }
+
 struct flowi;
 static inline void
 nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 {
 }
+
 #endif /*CONFIG_NETFILTER*/
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -440,6 +443,8 @@ static inline bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
 }
 #endif
 
+#ifdef CONFIG_NETFILTER
+
 struct nf_conn;
 enum ip_conntrack_info;
 
@@ -486,4 +491,6 @@ struct nf_bridge_frag_data {
 	__be16  vlan_proto;
 };
 
+#endif /* CONFIG_NETFILTER */
+
 #endif /*__LINUX_NETFILTER_H*/
-- 
2.23.0.rc1

