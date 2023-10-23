Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 008F3CDB474
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 10:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjJWKN6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 06:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbjJWKN5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 06:13:57 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA147FC;
        Mon, 23 Oct 2023 03:13:55 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2c509f2c46cso43975661fa.1;
        Mon, 23 Oct 2023 03:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698056034; x=1698660834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mNU60dxivZEz1APAp606jj7FRVqLDh+eZpfh4xl2HDg=;
        b=fnPrDuUOfzP8fPO89n7/Eil21LcUifdFRmfIxwB53YckVKT5YZDgTqWtv9SHua5utA
         ZT9iSNgMnuFJWlJQtdNwgUvNi7YaUohWGVZn7tqEkmL7Xv68TLlHb7CnRoZVcNOy02z5
         Ou6aqFGODBBFgDbZdrRUOkUsqINApo4UFrsbLLHvpf6fJpxVbQKoBg4CAx+fAfq8B2pO
         cwtTstCmCtErEHHog1pbLEb13BtIxhm4e2tURO1OaqDrWvGnPuNoucwcL5XTLobtSwhM
         usOoNUpLS45ByTZ/NRAbVSDMaqqTmqS57XbWbs3wX66RvBc3kaZRqT8yLjH8x0bzqbrT
         +aEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698056034; x=1698660834;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mNU60dxivZEz1APAp606jj7FRVqLDh+eZpfh4xl2HDg=;
        b=A3dNfxNIf6iCuITMIXB/KniMa7yotM95H1X5EQGMVE6v6H4sGveh3BVrwJ5wFsw2zd
         f3g2Dx2hakON8fp6P/2Z0wAmVWjATdHsmvH1bqm0zNo4YNrLIfHBNt5GycPwKt60FOzU
         2u47u1f71dkA7fb65+U53pWdKXEC/Ju4Wv4v7dErIajs0AvqzPt3IVUB2sY8+gmwQGyq
         CSZN+0bpNerh+nQBIP79Wjb65VejnnmaE6lmzFVbdFYWUxdMxcb7U0pzNThuPD1xJQyv
         gVi7yQwggKtIPLf5PBroPGgUMgBSUuI+1cTWD/2BldFswjQ8HdAxcL2Tntjztl1q4KpC
         UQVQ==
X-Gm-Message-State: AOJu0YydVPHoYih/GK+0ZPQTVkZYGZl2QqiON43Is2ML4E3xIkiUIF0a
        Vh44QGKsihC2U3wr6XOLFfk=
X-Google-Smtp-Source: AGHT+IHEJMft9coezCXeOxs7c/T+h3FRH0NJRj6UVmYhqpVbCAeIhpZNqGrGX1OdH/e8o+kuvjO9Gg==
X-Received: by 2002:a05:651c:b20:b0:2c5:2298:d44e with SMTP id b32-20020a05651c0b2000b002c52298d44emr7046916ljr.5.1698056033748;
        Mon, 23 Oct 2023 03:13:53 -0700 (PDT)
Received: from tosh.fritz.box ([2a02:8010:60a0:0:e92:71d3:1965:88e1])
        by smtp.gmail.com with ESMTPSA id h12-20020adff18c000000b0032d402f816csm7355058wro.98.2023.10.23.03.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 03:13:53 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH netfilter] Fix hw flow offload from nftables
Date:   Mon, 23 Oct 2023 11:13:47 +0100
Message-ID: <20231023101347.564898-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The NF_FLOW_HW_ESTABLISHED bit was not getting set in any nftables code
paths. It seems that the state was never correctly maintained but there
was no negative side-effect until commit 41f2c7c342d3 ("net/sched:
act_ct: Fix promotion of offloaded unreplied tuple") which uses it as
part of a flow outdated check. The net result is repeated cycles of
FLOW_CLS_REPLACE / FLOW_CLS_DESTROY commands and never getting any
FLOW_CLS_STATS commands for a flow.

This patch sets and clears the NF_FLOW_HW_ESTABLISHED bit for nftables.

Note that I don't have hardware to test this with. I have observed
the behaviour and verified the fix with modified veth code.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Fixes: 41f2c7c342d3 ("net/sched: act_ct: Fix promotion of offloaded unreplied tuple")
---
 net/netfilter/nf_flow_table_offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 1c26f03fc661..1d017191af80 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -918,6 +918,7 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 		goto out;
 
 	set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+	set_bit(NF_FLOW_HW_ESTABLISHED, &offload->flow->flags);
 
 out:
 	nf_flow_offload_destroy(flow_rule);
@@ -925,6 +926,7 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 
 static void flow_offload_work_del(struct flow_offload_work *offload)
 {
+	clear_bit(NF_FLOW_HW_ESTABLISHED, &offload->flow->flags);
 	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
-- 
2.41.0

