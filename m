Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7B2C83000
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 19:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C764921775
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 19:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgD2Ts0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 15:48:26 -0400
Received: from correo.us.es ([193.147.175.20]:50158 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgD2TsJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 15:48:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 855C5E1707
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 21:42:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77F99DA736
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 21:42:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 774A7BAC2F; Wed, 29 Apr 2020 21:42:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E2BCDA736;
        Wed, 29 Apr 2020 21:42:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 21:42:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4897D42EF9E0;
        Wed, 29 Apr 2020 21:42:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/6] Netfilter updates for net-next
Date:   Wed, 29 Apr 2020 21:42:37 +0200
Message-Id: <20200429194243.22228-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

The following patchset contains Netfilter updates for nf-next:

1) Add IPS_HW_OFFLOAD status bit, from Bodong Wang.

2) Remove 128-bit limit on the set element data area, rise it
   to 64 bytes.

3) Report EOPNOTSUPP for unsupported NAT types and flags.

4) Set up nft_nat flags from the control plane path.

5) Add helper functions to set up the nf_nat_range2 structure.

6) Add netmap support for nft_nat.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit 3fd8dc269ff0647819589c21b2ce60af6fc0a455:

  net: hns3: remove an unnecessary check in hclge_set_umv_space() (2020-04-25 20:56:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 3ff7ddb1353da9b535e65702704cbadea1da9a00:

  netfilter: nft_nat: add netmap support (2020-04-28 00:53:54 +0200)

----------------------------------------------------------------
Bodong Wang (1):
      netfilter: nf_conntrack: add IPS_HW_OFFLOAD status bit

Pablo Neira Ayuso (5):
      netfilter: nf_tables: allow up to 64 bytes in the set element data area
      netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported
      netfilter: nft_nat: set flags from initialization path
      netfilter: nft_nat: add helper function to set up NAT address and protocol
      netfilter: nft_nat: add netmap support

 include/net/netfilter/nf_tables.h                  |   4 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |   8 +-
 include/uapi/linux/netfilter/nf_nat.h              |   4 +-
 net/netfilter/nf_conntrack_standalone.c            |   4 +-
 net/netfilter/nf_flow_table_offload.c              |   3 +
 net/netfilter/nf_tables_api.c                      |  38 ++++---
 net/netfilter/nft_nat.c                            | 110 ++++++++++++++++-----
 7 files changed, 129 insertions(+), 42 deletions(-)
