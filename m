Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B0EC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Feb 2022 01:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbiBYBys (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 20:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbiBYBys (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 20:54:48 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF452763F1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 17:54:17 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c9so3529785pll.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 17:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MWNavJRjkzos/WzLGU7D6BYFeXcQfplW3w67gFXJqJA=;
        b=LEnE5CKmwKDulssSh0/zJbNwLfhi5ca2MaLevu1qAsf8bRsAa/bmZsmovDiozkUZsO
         1esVoeGEm6VVTRPq2vAu9mSfR9zIteQTcNaSCiDeSewVgdgoFG9cH2C9GiihjtaOWpB6
         NP2mXjQng+zG2vIJdp5k8qXEmVF7c2cOocSiDaFUgBKHuqR3kcDu7YMRGsjueuBWs8lJ
         CZwe2maonGqnwnSksyxGjXDLZzUUMeK3kNZ/gtHo43DoluAWnKSMLMIasRuNx3J+UdNv
         jaRbRLUTAna7FlK+29bQCiOFodOo8LqUX/+1y+4v0TT88yROvZ6PvbzH9lIEyF96aBmZ
         oFRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MWNavJRjkzos/WzLGU7D6BYFeXcQfplW3w67gFXJqJA=;
        b=J5e/BA9Ss5bBw8A7egCJkdSo58QR2tlsVqfS9B369uigJME5cnL6O47FDp9MQ3RsNr
         mol5TXJvhWvXo8sNBewcMewIIo4pUiduoc6oUvyhuwgNnXdI1UVEVnW52mtwcyAUnhVU
         2DE/LhIHGBo0+ef3R8+WTpepj5+N1YzZPkjvrh81uVJNi15nPQtcWPi2Ek8pmdvRcRJl
         9AZLfEymmSpk5b28snAjPeObIhVJjaQQlYbNPVMHWW3rgxAj68e9O6pcXjE8ZGkCHZUS
         WTgcu4NbJHMEV+Ilx79LBJFOPboNRL8uSFhrw8H6XTA50Y+v2G6qaYnpt0QLJo1wH81A
         xI5Q==
X-Gm-Message-State: AOAM533ccKqOiCiFE6ZOFBz3q4cPBW6/nrMrZ0RabwRqkeHP1bTSGoSE
        fXgCMQ6Dxxpq+iRQ7QZ9YSq3+vcTQaY=
X-Google-Smtp-Source: ABdhPJwXCBPaUsi4k69XMuvIvper0FHB4lCqx9nLnZwWZJTgD1usmf4ricro2MNS2iUGwonwRrtAZw==
X-Received: by 2002:a17:90a:581:b0:1b9:b85e:94df with SMTP id i1-20020a17090a058100b001b9b85e94dfmr877564pji.195.1645754056995;
        Thu, 24 Feb 2022 17:54:16 -0800 (PST)
Received: from e30-rocky8.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id a15-20020a637f0f000000b00372e075b2efsm710980pgd.30.2022.02.24.17.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 17:54:16 -0800 (PST)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     "Saeed Mahameed" <saeedm@nvidia.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Paul Blakey <paulb@nvidia.com>
Subject: [PATCH nf-next v2 3/3] net/mlx5: Support GRE conntrack offload
Date:   Fri, 25 Feb 2022 10:53:09 +0900
Message-Id: <20220225015309.2576980-4-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220225015309.2576980-1-toshiaki.makita1@gmail.com>
References: <20220225015309.2576980-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support GREv0 without NAT.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Acked-by: Paul Blakey <paulb@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 875e77a..675bd6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -258,7 +258,8 @@ struct mlx5_ct_entry {
 			return -EOPNOTSUPP;
 		}
 	} else {
-		return -EOPNOTSUPP;
+		if (tuple->ip_proto != IPPROTO_GRE)
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
@@ -807,7 +808,11 @@ struct mlx5_ct_entry {
 	attr->dest_chain = 0;
 	attr->dest_ft = mlx5e_tc_post_act_get_ft(ct_priv->post_act);
 	attr->ft = nat ? ct_priv->ct_nat : ct_priv->ct;
-	attr->outer_match_level = MLX5_MATCH_L4;
+	if (entry->tuple.ip_proto == IPPROTO_TCP ||
+	    entry->tuple.ip_proto == IPPROTO_UDP)
+		attr->outer_match_level = MLX5_MATCH_L4;
+	else
+		attr->outer_match_level = MLX5_MATCH_L3;
 	attr->counter = entry->counter->counter;
 	attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
 	if (ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB)
@@ -1224,16 +1229,20 @@ static void mlx5_tc_ct_entry_del_work(struct work_struct *work)
 	struct flow_keys flow_keys;
 
 	skb_reset_network_header(skb);
-	skb_flow_dissect_flow_keys(skb, &flow_keys, 0);
+	skb_flow_dissect_flow_keys(skb, &flow_keys, FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP);
 
 	tuple->zone = zone;
 
 	if (flow_keys.basic.ip_proto != IPPROTO_TCP &&
-	    flow_keys.basic.ip_proto != IPPROTO_UDP)
+	    flow_keys.basic.ip_proto != IPPROTO_UDP &&
+	    flow_keys.basic.ip_proto != IPPROTO_GRE)
 		return false;
 
-	tuple->port.src = flow_keys.ports.src;
-	tuple->port.dst = flow_keys.ports.dst;
+	if (flow_keys.basic.ip_proto == IPPROTO_TCP ||
+	    flow_keys.basic.ip_proto == IPPROTO_UDP) {
+		tuple->port.src = flow_keys.ports.src;
+		tuple->port.dst = flow_keys.ports.dst;
+	}
 	tuple->n_proto = flow_keys.basic.n_proto;
 	tuple->ip_proto = flow_keys.basic.ip_proto;
 
-- 
1.8.3.1

