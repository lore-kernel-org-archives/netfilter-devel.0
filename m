Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0EB9C3A589
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 01:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE3002089E
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 01:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfHPBYS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Aug 2019 21:24:18 -0400
Received: from correo.us.es ([193.147.175.20]:42212 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfHPBYS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Aug 2019 21:24:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7BE9DA7F0
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Aug 2019 03:24:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8E32A6B2
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Aug 2019 03:24:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AC2ACD2B1B; Fri, 16 Aug 2019 03:24:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7898ED2F9B;
        Fri, 16 Aug 2019 03:24:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 16 Aug 2019 03:24:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E43164265A2F;
        Fri, 16 Aug 2019 03:24:12 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        marcelo.leitner@gmail.com, jiri@resnulli.us, wenxu@ucloud.cn,
        saeedm@mellanox.com, paulb@mellanox.com, gerlitz.or@gmail.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net,v5 0/2] flow_offload hardware priority fixes
Date:   Fri, 16 Aug 2019 03:24:08 +0200
Message-Id: <20190816012410.31844-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset contains two updates for the flow_offload users:

1) Pass the major tc priority to drivers so they do not have to
   lshift it. This is a preparation patch for the fix coming in
   patch #2.

2) Set the hardware priority from the netfilter basechain priority,
   some drivers break when using the existing hardware priority
   number that is set to zero.

v5: fix patch 2/2 to address a clang warning and to simplify
    the priority mapping.

Please, apply.

Pablo Neira Ayuso (2):
  net: sched: use major priority number as hardware priority
  netfilter: nf_tables: map basechain priority to hardware priority

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c   |  2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c            | 12 +++---------
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c      |  2 +-
 include/net/netfilter/nf_tables_offload.h            |  2 ++
 include/net/pkt_cls.h                                |  2 +-
 net/netfilter/nf_tables_api.c                        |  4 ++++
 net/netfilter/nf_tables_offload.c                    | 17 ++++++++++++++---
 9 files changed, 28 insertions(+), 17 deletions(-)

-- 
2.11.0

