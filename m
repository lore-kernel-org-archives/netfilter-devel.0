Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 173AEC3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF7D22190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:02:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="gnCzfQMm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbfIAVCD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:02:03 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53636 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbfIAVCD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+B1m6y5dQm8wFK66WgsAEFqIA50xK9FdVT/ppzmIoo0=; b=gnCzfQMmjgJvGDr7Q50HzBh6wQ
        rKKSmJsPGLQQ8J0aEym6La6l9U1wPJidpJMcT0yd9YLx1LhAqjaFu9aXIWp43Fvpdqi0CV8k7NyY3
        yeX34VJyBaRtLYDZkmSeuOqo+YDlm3OrYC0wAywcJFRtXBbuNrPcXam8XtvkdbWyQOrFKIo07T8by
        rwrd10r8eKOYLovcoOjRBs7sTGrwNWbZK0k+vJBUxB4DyKxdmgGtLT642KmPwsX9dvddw+uVXvKIG
        bwAH5NFVeIzc6lVjhO4EIcy1MdtSt9QcLfTIGm2o3AmA1FZtlFTUMDRbbgPEsJLhXW+xd8DxgH0gQ
        egrClypQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Wor-0002Uf-Mg; Sun, 01 Sep 2019 21:51:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 23/29] netfilter: wrap some ipv6 tables code in a CONFIG_NF_TABLES_IPV6 check.
Date:   Sun,  1 Sep 2019 21:51:19 +0100
Message-Id: <20190901205126.6935-24-jeremy@azazel.net>
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

nft_set_pktinfo_ipv6_validate does nothing unless CONFIG_IPV6, and
therefore by implication CONFIG_NF_TABLES_IPV6, is enabled.  Wrap the
calls in a CONFIG_NF_TABLES_IPV6 check.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_chain_filter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b5d5d071d765..f411d9993612 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -207,9 +207,11 @@ nft_do_chain_bridge(void *priv,
 	case htons(ETH_P_IP):
 		nft_set_pktinfo_ipv4_validate(&pkt, skb);
 		break;
+#ifdef CONFIG_NF_TABLES_IPV6
 	case htons(ETH_P_IPV6):
 		nft_set_pktinfo_ipv6_validate(&pkt, skb);
 		break;
+#endif
 	default:
 		nft_set_pktinfo_unspec(&pkt, skb);
 		break;
@@ -262,9 +264,11 @@ static unsigned int nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 	case htons(ETH_P_IP):
 		nft_set_pktinfo_ipv4_validate(&pkt, skb);
 		break;
+#ifdef CONFIG_NF_TABLES_IPV6
 	case htons(ETH_P_IPV6):
 		nft_set_pktinfo_ipv6_validate(&pkt, skb);
 		break;
+#endif
 	default:
 		nft_set_pktinfo_unspec(&pkt, skb);
 		break;
-- 
2.23.0.rc1

