Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104F3C32753
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 09:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6BFE204EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 09:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfHNJYv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 05:24:51 -0400
Received: from correo.us.es ([193.147.175.20]:42572 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfHNJYu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 05:24:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6EE80C40E6
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 11:24:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5DCEEDA704
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 11:24:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 52D9B7E063; Wed, 14 Aug 2019 11:24:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4252D50F3F;
        Wed, 14 Aug 2019 11:24:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 11:24:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EE7494265A2F;
        Wed, 14 Aug 2019 11:24:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/7] Netfilter fixes for net
Date:   Wed, 14 Aug 2019 11:24:33 +0200
Message-Id: <20190814092440.20087-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset contains Netfilter fixes for net:

1) Extend selftest to cover flowtable with ipsec, from Florian Westphal.

2) Fix interaction of ipsec with flowtable, also from Florian.

3) User-after-free with bound set to rule that fails to load.

4) Adjust state and timeout for flows that expire.

5) Timeout update race with flows in teardown state.

6) Ensure conntrack id hash calculation use invariants as input,
   from Dirk Morris.

7) Do not push flows into flowtable for TCP fin/rst packets.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 5e5412c365a32e452daa762eac36121cb8a370bb:

  net/socket: fix GCC8+ Wpacked-not-aligned warnings (2019-08-03 11:02:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to dfe42be15fde16232340b8b2a57c359f51cc10d9:

  netfilter: nft_flow_offload: skip tcp rst and fin packets (2019-08-14 11:09:07 +0200)

----------------------------------------------------------------
Dirk Morris (1):
      netfilter: conntrack: Use consistent ct id hash calculation

Florian Westphal (2):
      selftests: netfilter: extend flowtable test script for ipsec
      netfilter: nf_flow_table: fix offload for flows that are subject to xfrm

Pablo Neira Ayuso (4):
      netfilter: nf_tables: use-after-free in failing rule with bound set
      netfilter: nf_flow_table: conntrack picks up expired flows
      netfilter: nf_flow_table: teardown flow timeout race
      netfilter: nft_flow_offload: skip tcp rst and fin packets

 include/net/netfilter/nf_tables.h                  |  9 +++-
 net/netfilter/nf_conntrack_core.c                  | 16 ++++----
 net/netfilter/nf_flow_table_core.c                 | 43 +++++++++++++------
 net/netfilter/nf_flow_table_ip.c                   | 43 +++++++++++++++++++
 net/netfilter/nf_tables_api.c                      | 15 ++++---
 net/netfilter/nft_flow_offload.c                   |  9 ++--
 tools/testing/selftests/netfilter/nft_flowtable.sh | 48 ++++++++++++++++++++++
 7 files changed, 153 insertions(+), 30 deletions(-)

