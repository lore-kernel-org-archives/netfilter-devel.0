Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F9FC432C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29D0022440
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfKSWGF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 17:06:05 -0500
Received: from correo.us.es ([193.147.175.20]:35128 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727038AbfKSWGF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 17:06:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 40D9D8C3C6B
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 23:06:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 326A3D2B1F
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 23:06:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 284CEDA3A9; Tue, 19 Nov 2019 23:06:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41B2EB8007;
        Tue, 19 Nov 2019 23:05:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 19 Nov 2019 23:05:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0B11942EE38E;
        Tue, 19 Nov 2019 23:05:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] nf_tables_offload: vlan matching support
Date:   Tue, 19 Nov 2019 23:05:51 +0100
Message-Id: <20191119220555.17391-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

The following patchset contains Netfilter support for vlan matching
offloads:

1) Constify nft_reg_load() as a preparation patch.
2) Restrict rule matching to ingress interface type ARPHRD_ETHER.
3) Add new vlan_tci field to flow_dissector_key_vlan structure,
   to allow to set up vlan_id, vlan_dei and vlan_priority in one go.
4) C-VLAN matching support.

Please, directly apply to net-next if you are OK with this batch.

Thank you.

Pablo Neira Ayuso (4):
  netfilter: nf_tables: constify nft_reg_load{8,16,64}()
  netfilter: nf_tables_offload: allow ethernet interface type only
  netfilter: nft_payload: add VLAN offload support
  netfilter: nft_payload: add C-VLAN offload support

 include/net/flow_dissector.h      | 11 ++++++++---
 include/net/netfilter/nf_tables.h |  6 +++---
 net/netfilter/nft_cmp.c           |  6 ++++++
 net/netfilter/nft_meta.c          |  4 ++++
 net/netfilter/nft_payload.c       | 38 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 59 insertions(+), 6 deletions(-)

-- 
2.11.0

