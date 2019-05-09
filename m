Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13090C04AB2
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 16:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E502D21019
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 16:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfEIQkS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 12:40:18 -0400
Received: from mail.us.es ([193.147.175.20]:35262 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbfEIQkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 12:40:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8A33A1C4449
        for <netfilter-devel@vger.kernel.org>; Thu,  9 May 2019 18:40:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78C7CDA781
        for <netfilter-devel@vger.kernel.org>; Thu,  9 May 2019 18:40:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 69F02DA79C; Thu,  9 May 2019 18:40:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1DB5DA701;
        Thu,  9 May 2019 18:40:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 May 2019 18:40:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.199.18])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C95724265A32;
        Thu,  9 May 2019 18:40:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com
Subject: [PATCH net-next,RFC 0/2] netfilter: add hardware offload infrastructure
Date:   Thu,  9 May 2019 18:39:49 +0200
Message-Id: <20190509163954.13703-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset adds initial hardware offload support for nftables through
the existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
classifier and the flow rule API.

Patch 1 move the flow block callback infrastructure to
	net/core/flow_offload.c. More structure and enumeration definitions
	currently in include/net/pkt_cls.h can be also there to reuse this from
	the netfilter codebase.

Patch 2 adds hardware offload support for nftables.

This patchset depends on a previous patchset:

	[PATCH net-next,RFC 0/9] net: sched: prepare to reuse per-block callbacks from netfilter

More information at: https://marc.info/?l=netfilter-devel&m=155623884016026&w=2

Comments welcome, thanks.

Pablo Neira Ayuso (2):
  net: flow_offload: add flow_block_cb API
  netfilter: nf_tables: add hardware offload support

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  22 +--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  54 +++---
 drivers/net/ethernet/netronome/nfp/abm/cls.c       |   2 +-
 drivers/net/ethernet/netronome/nfp/abm/main.h      |   2 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  18 +-
 include/net/flow_offload.h                         |  48 +++++
 include/net/netfilter/nf_tables.h                  |  13 ++
 include/net/netfilter/nf_tables_offload.h          |  76 ++++++++
 include/net/pkt_cls.h                              |  40 +---
 include/uapi/linux/netfilter/nf_tables.h           |   2 +
 net/core/flow_offload.c                            |  77 ++++++++
 net/dsa/slave.c                                    |   2 +-
 net/netfilter/Makefile                             |   2 +-
 net/netfilter/nf_tables_api.c                      |  16 +-
 net/netfilter/nf_tables_offload.c                  | 216 +++++++++++++++++++++
 net/netfilter/nft_cmp.c                            |  53 +++++
 net/netfilter/nft_immediate.c                      |  31 +++
 net/netfilter/nft_meta.c                           |  27 +++
 net/netfilter/nft_payload.c                        | 187 ++++++++++++++++++
 net/sched/cls_api.c                                | 140 +++----------
 20 files changed, 827 insertions(+), 201 deletions(-)
 create mode 100644 include/net/netfilter/nf_tables_offload.h
 create mode 100644 net/netfilter/nf_tables_offload.c

-- 
2.11.0


