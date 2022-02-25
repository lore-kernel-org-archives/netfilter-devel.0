Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F63C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Feb 2022 01:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbiBYBym (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 20:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbiBYByj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 20:54:39 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534552763F1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 17:54:08 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id u16so3416605pfg.12
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 17:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LxP5tpOV8FqlZiHtnELklFPMas5mkUqgG+0aKi0/t1Q=;
        b=eZdrWhSDBu6s4j/oeIcyi6Ip+7cik2yoeXRV/zl34NEvKZDdBbwKnTBmy93gKdqmBI
         ZAElNnh3PGKAhe6ztigo+bKTivjb6pbBMGIkwQNjkVbwioMZgOc3SEH7HMewspUKteZ0
         0cjVwpG+oufJP4uAChYbrMW8wowFTYqD9GjytRU8qptjwKoZs6u6tl3xyKpWBZ/i+Dye
         qB0NYka1ssRUpae9GCHjqm1GIJmKKGXXU9Z74fsaA83BYgLtMvxJ5QUweuxyWrDAyaFn
         imcRlrXEa2RYXgvcPlcJ+G8RmyLmIGvdAdRc/mTgPIeOnTntfFCUoyoiD9oHgb3eBVln
         1piw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LxP5tpOV8FqlZiHtnELklFPMas5mkUqgG+0aKi0/t1Q=;
        b=6xW4MY8rku8oWRTVVOi1xBYjjvyFXPLsPyR74xvLmT42117cK0niI1OlDhRsLhcitj
         ztA8U8jQAN8ujd6Cz5Wo3Ly2KeGJsSQCdlOjjGchVv+QF3GUt2qOkMvxY8mpzb00/PMp
         e0QlgxCyBI1zvnW1/0MxQ7Kvy+D+xDep+Ea/Hb2cUt0GZSJ63qBRaW+sjVtsJ5qkIrB6
         0OMO7uUW0kalhXvj9jmqz0FvNix3jmwrtOjwRppGX+i12OWOmUWDrkp9tGMdWsWy6RDX
         sh3PJORcstaNBurCc84YRdH7El+0KEW53pMqCM79cFIFHhfKX2TrDk1iOIp+c7CErbE6
         XrfQ==
X-Gm-Message-State: AOAM53021wWYaYn0fHeWWXOUMxM5nlYxzu+NvpHLb8xF3wPudlkDcprH
        j6K5atuiSswd/jUIB0VwmLk=
X-Google-Smtp-Source: ABdhPJyJNdyFswdrk1HPSVd6EZRhgtxnJT0BHw/CeDRMUz++7Z7nJc0cvBfj4sEcKM+AQb3v+OcAeA==
X-Received: by 2002:a63:e44e:0:b0:374:a41b:a621 with SMTP id i14-20020a63e44e000000b00374a41ba621mr4231015pgk.455.1645754047841;
        Thu, 24 Feb 2022 17:54:07 -0800 (PST)
Received: from e30-rocky8.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id a15-20020a637f0f000000b00372e075b2efsm710980pgd.30.2022.02.24.17.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 17:54:07 -0800 (PST)
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
Subject: [PATCH nf-next v2 0/3] Conntrack GRE offload
Date:   Fri, 25 Feb 2022 10:53:06 +0900
Message-Id: <20220225015309.2576980-1-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Conntrack offload currently only supports TCP and UDP.
Thus TC/nftables/OVS cannot offload GRE packets.

However, GRE is widely used so some users create gre devices in VMs,
and in that case host OVS forwards GRE packets from/to VMs.

In order to offload GRE packets in OVS with stateful firewall support,
we need act_ct GRE offload support.

This patch set adds GRE offload support for act_ct and mlx5 conntrack.
Currently only GREv0 and no NAT support.

- Patch 1: flow_offload/flowtable GRE support.
- Patch 2: act_ct GRE offload support.
- Patch 3: mlx5 conntrack GRE offload support.

Tested with ConnectX-6 Dx 100G NIC and netperf TCP_STREAM.

                      +------------------------------------+
                      |                        +-----------+
                      |                        |(namespace)|
  +---------+         |                        | netserver |
  |         |  wire   +----+  tc   +--------+  +-------+   |
  | netperf |-------->|mlx5|------>|mlx5 rep|--|mlx5 vf|   |
  |         |         +----+       +--------+  +-------+---+
  +---------+         +------------------------------------+

- No offload (TC skip_hw): 8.5 Gbps
- Offload    (act_ct)    : 22 Gbps

v2:
 - Replace if-else with switch in patch 1 and 2

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Toshiaki Makita (3):
  netfilter: flowtable: Support GRE
  act_ct: Support GRE offload
  net/mlx5: Support GRE conntrack offload

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  21 ++--
 net/netfilter/nf_flow_table_core.c                 |  10 +-
 net/netfilter/nf_flow_table_ip.c                   |  62 +++++++++--
 net/netfilter/nf_flow_table_offload.c              |  22 ++--
 net/netfilter/nft_flow_offload.c                   |  13 +++
 net/sched/act_ct.c                                 | 115 ++++++++++++++++-----
 6 files changed, 194 insertions(+), 49 deletions(-)

-- 
1.8.3.1

