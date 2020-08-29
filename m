Return-Path: <SRS0=fjj5=CH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9973C433E2
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 06:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C34F207BB
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 06:19:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CoI4yR30"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgH2GT2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Aug 2020 02:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgH2GT1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Aug 2020 02:19:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B24C061236
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2020 23:19:27 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k15so1038314wrn.10
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2020 23:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=v5OTpPH68wwXTJfQwIxYwDoIhX9bJGZtUpevwj58Ts8=;
        b=CoI4yR30+uwypoyhcPZ/Op21Zl/qhzKlCpshPa5baQuVMmOi5ZwIr8Bfk5gRcvcKX3
         MdXVrwN4Mvg8tU5TSQTFVBwgrsW3IdORus+DtO+CXyxxrQdsZDqzrgQq56JREl8OuDw8
         B9VE0aR8/dQvpIUtBCyoAzCMs2zvypRVRch8RJ7iT4XQPkS3TKSphizqK1kc/tgvkLpu
         fTxCAmUd3/o5mp323hPQs+RlgTvS/Q1uydho9AEojOOLB1BcjZKMY4wO0TGQpA23zyPu
         qa5vSCrLIAw/HjewvuIvsw0HaVh+DBBvuRU0cnMSmPJzQuI/IGHZmqxbKlcgyzucct8p
         j9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=v5OTpPH68wwXTJfQwIxYwDoIhX9bJGZtUpevwj58Ts8=;
        b=R2j77Bs1AZTyytw3qFFnRbqVDUl23gK1I2V9vCApn00v9yid1cFedHMQ7KM4xwlc94
         JJaefTb28SNsPYaqwh7U8AA4zrFjqG7KkC35+aPDRV8pgZJX2LqUuTx2camcewbS0YYL
         yDVUgKBjj3VWMH3j/+Gb02fO2GWxpv9Eeh38xU7g4GXr7ga+rMclJU8eOiTgr07K9VAC
         KRhczpJFADWZ2OR+HfpsttlFk7qV1YT6dXS843z2ZHzNWA9bg6fepeNIHG94bwPWrSPo
         iLZB8GFracLV3Ls6zT5hjz00qtmsHggSjmB/vaxfQ7kenj/8wu43enVySpvuQjuaatMc
         Pspw==
X-Gm-Message-State: AOAM533XwIF6P56rNGW2W5yd+DEaKsqE+LmA3YBeznT7GYYFmSDteNM3
        oirglGOLnWcuI38FNfoFVmV95tUrqwKIlw==
X-Google-Smtp-Source: ABdhPJyzZBBr5UW/EciBH2+waNHLm7JvBeHgSs8l0IpPYkyYUqafrc2j0u1ZrWIlT0pI2Vtwqzdm2A==
X-Received: by 2002:a5d:4ecf:: with SMTP id s15mr2220981wrv.202.1598681965899;
        Fri, 28 Aug 2020 23:19:25 -0700 (PDT)
Received: from localhost.localdomain (94-21-174-118.pool.digikabel.hu. [94.21.174.118])
        by smtp.gmail.com with ESMTPSA id 32sm2483004wrh.18.2020.08.28.23.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 23:19:24 -0700 (PDT)
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Balazs Scheidler <bazsi77@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next v2] netfilter: nft_socket: add wildcard support
Date:   Sat, 29 Aug 2020 08:19:15 +0200
Message-Id: <20200829061915.21634-1-bazsi77@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200828154425.21259-1-pablo@netfilter.org>
References: <20200828154425.21259-1-pablo@netfilter.org>
Organization: BalaBit IT Security Ltd.
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add NFT_SOCKET_WILDCARD to match to wildcard socket listener.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Balazs Scheidler <bazsi77@gmail.com>
---

@Pablo: this contains the enum addition as well as the explicit check for IPv6

 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_socket.c               | 27 ++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 42f351c1f5c5..6e1dbdf1427f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1008,10 +1008,12 @@ enum nft_socket_attributes {
  *
  * @NFT_SOCKET_TRANSPARENT: Value of the IP(V6)_TRANSPARENT socket option
  * @NFT_SOCKET_MARK: Value of the socket mark
+ * @NFT_SOCKET_WILDCARD: Whether the socket is zero-bound (e.g. 0.0.0.0 or ::0)
  */
 enum nft_socket_keys {
 	NFT_SOCKET_TRANSPARENT,
 	NFT_SOCKET_MARK,
+	NFT_SOCKET_WILDCARD,
 	__NFT_SOCKET_MAX
 };
 #define NFT_SOCKET_MAX	(__NFT_SOCKET_MAX - 1)
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 637ce3e8c575..a28aca5124ce 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -14,6 +14,25 @@ struct nft_socket {
 	};
 };
 
+static void nft_socket_wildcard(const struct nft_pktinfo *pkt,
+				struct nft_regs *regs, struct sock *sk,
+				u32 *dest)
+{
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		nft_reg_store8(dest, inet_sk(sk)->inet_rcv_saddr == 0);
+		break;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+	case NFPROTO_IPV6:
+		nft_reg_store8(dest, ipv6_addr_any(&sk->sk_v6_rcv_saddr));
+		break;
+#endif
+	default:
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+}
+
 static void nft_socket_eval(const struct nft_expr *expr,
 			    struct nft_regs *regs,
 			    const struct nft_pktinfo *pkt)
@@ -59,6 +78,13 @@ static void nft_socket_eval(const struct nft_expr *expr,
 			return;
 		}
 		break;
+	case NFT_SOCKET_WILDCARD:
+		if (!sk_fullsock(sk)) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		nft_socket_wildcard(pkt, regs, sk, dest);
+		break;
 	default:
 		WARN_ON(1);
 		regs->verdict.code = NFT_BREAK;
@@ -97,6 +123,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 	priv->key = ntohl(nla_get_u32(tb[NFTA_SOCKET_KEY]));
 	switch(priv->key) {
 	case NFT_SOCKET_TRANSPARENT:
+	case NFT_SOCKET_WILDCARD:
 		len = sizeof(u8);
 		break;
 	case NFT_SOCKET_MARK:
-- 
2.17.1

