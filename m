Return-Path: <SRS0=2TpG=4X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E854C10F00
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 18:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3210C20674
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 18:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgCFSPU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 13:15:20 -0500
Received: from correo.us.es ([193.147.175.20]:40726 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCFSPT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 13:15:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4D73815AEA5
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2020 19:15:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FAF3DA3AA
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2020 19:15:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 353DCDA3A9; Fri,  6 Mar 2020 19:15:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4FB6DDA3C4;
        Fri,  6 Mar 2020 19:14:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 19:14:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2BAF14301DE0;
        Fri,  6 Mar 2020 19:14:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/11] Netfilter fixes for net
Date:   Fri,  6 Mar 2020 19:15:02 +0100
Message-Id: <20200306181513.656594-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Patches to bump position index from sysctl seq_next,
   from Vasilin Averin.

2) Release flowtable hook from error path, from Florian Westphal.

3) Patches to add missing netlink attribute validation,
   from Jakub Kicinski.

4) Missing NFTA_CHAIN_FLAGS in nf_tables_fill_chain_info().

5) Infinite loop in module autoload if extension is not available,
   from Florian Westphal.

6) Missing module ownership in inet/nat chain type definition.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit f8a0fea9518c5ff7c37679504bd9eeabeae8ee36:

  docs: networking: net_failover: Fix a few typos (2020-03-03 16:07:02 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 6a42cefb25d8bdc1b391f4a53c78c32164eea2dd:

  netfilter: nft_chain_nat: inet family is missing module ownership (2020-03-06 18:00:43 +0100)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_tables: free flowtable hooks on hook register error
      netfilter: nf_tables: fix infinite loop when expr is not available

Jakub Kicinski (3):
      netfilter: cthelper: add missing attribute validation for cthelper
      netfilter: nft_payload: add missing attribute validation for payload csum flags
      netfilter: nft_tunnel: add missing attribute validation for tunnels

Pablo Neira Ayuso (2):
      netfilter: nf_tables: dump NFTA_CHAIN_FLAGS attribute
      netfilter: nft_chain_nat: inet family is missing module ownership

Vasily Averin (4):
      netfilter: nf_conntrack: ct_cpu_seq_next should increase position index
      netfilter: synproxy: synproxy_cpu_seq_next should increase position index
      netfilter: xt_recent: recent_seq_next should increase position index
      netfilter: x_tables: xt_mttg_seq_next should increase position index

 net/netfilter/nf_conntrack_standalone.c |  2 +-
 net/netfilter/nf_synproxy_core.c        |  2 +-
 net/netfilter/nf_tables_api.c           | 22 ++++++++++++++--------
 net/netfilter/nfnetlink_cthelper.c      |  2 ++
 net/netfilter/nft_chain_nat.c           |  1 +
 net/netfilter/nft_payload.c             |  1 +
 net/netfilter/nft_tunnel.c              |  2 ++
 net/netfilter/x_tables.c                |  6 +++---
 net/netfilter/xt_recent.c               |  2 +-
 9 files changed, 26 insertions(+), 14 deletions(-)
