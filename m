Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D384C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 13:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEEEC64E4D
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 13:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhBCNwn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 08:52:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232460AbhBCNwL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 08:52:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 717B364E43;
        Wed,  3 Feb 2021 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612360290;
        bh=/KEuRgVOiA/VvIPSzucVMF3o8/yUTvTxNRQRpZ1mn68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEuanVo3hPfhP87VtCstAWPnr9Xr+WcjLVCvvy0359C1LrJjWDpG7lLX+6wQfJmNd
         OM52P5pBsWmAhw9axoiz0MBwZn15/btJXij7vUVk+HGwkoLI02PgDo4PMwcA0nuQz8
         CmRC0A4CKGEvik5Nl46HDqzyPd7G3A9ryh617dHwoAS+a+cmZsHq3eNA+CJnMwA3NP
         u4qbH771msTfRhVE2vs76mzaJ46u+xOVSieiI/rdfKtFDmjKa+I/v9PoSnM55y4pvq
         PwyNsyCO2pghLPQ/QOG+uoOGQe+h/WVNt/77i67iPmT7wi2k0drOJDL5mb+brIn3vW
         miZNym37wH4Xw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>
Subject: [PATCH net-next v2 4/4] netfilter: move handlers to net/ip_vs.h
Date:   Wed,  3 Feb 2021 15:51:12 +0200
Message-Id: <20210203135112.4083711-5-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203135112.4083711-1-leon@kernel.org>
References: <20210203135112.4083711-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Fix the following compilation warnings:
net/netfilter/ipvs/ip_vs_proto_tcp.c:147:1: warning: no previous prototype for 'tcp_snat_handler' [-Wmissing-prototypes]
  147 | tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
      | ^~~~~~~~~~~~~~~~
net/netfilter/ipvs/ip_vs_proto_udp.c:136:1: warning: no previous prototype for 'udp_snat_handler' [-Wmissing-prototypes]
  136 | udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
      | ^~~~~~~~~~~~~~~~

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/ip_vs.h             | 11 +++++++++++
 net/netfilter/ipvs/ip_vs_core.c | 12 ------------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index d609e957a3ec..7cb5a1aace40 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1712,4 +1712,15 @@ ip_vs_dest_conn_overhead(struct ip_vs_dest *dest)
 		atomic_read(&dest->inactconns);
 }

+#ifdef CONFIG_IP_VS_PROTO_TCP
+INDIRECT_CALLABLE_DECLARE(int
+	tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
+			 struct ip_vs_conn *cp, struct ip_vs_iphdr *iph));
+#endif
+
+#ifdef CONFIG_IP_VS_PROTO_UDP
+INDIRECT_CALLABLE_DECLARE(int
+	udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
+			 struct ip_vs_conn *cp, struct ip_vs_iphdr *iph));
+#endif
 #endif	/* _NET_IP_VS_H */
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 54e086c65721..0c132ff9b446 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -68,18 +68,6 @@ EXPORT_SYMBOL(ip_vs_get_debug_level);
 #endif
 EXPORT_SYMBOL(ip_vs_new_conn_out);

-#ifdef CONFIG_IP_VS_PROTO_TCP
-INDIRECT_CALLABLE_DECLARE(int
-	tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
-			 struct ip_vs_conn *cp, struct ip_vs_iphdr *iph));
-#endif
-
-#ifdef CONFIG_IP_VS_PROTO_UDP
-INDIRECT_CALLABLE_DECLARE(int
-	udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
-			 struct ip_vs_conn *cp, struct ip_vs_iphdr *iph));
-#endif
-
 #if defined(CONFIG_IP_VS_PROTO_TCP) && defined(CONFIG_IP_VS_PROTO_UDP)
 #define SNAT_CALL(f, ...) \
 	INDIRECT_CALL_2(f, tcp_snat_handler, udp_snat_handler, __VA_ARGS__)
--
2.29.2

