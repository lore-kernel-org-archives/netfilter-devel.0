Return-Path: <SRS0=keFs=CC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82601C433E3
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Aug 2020 11:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67DC020774
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Aug 2020 11:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgHXLj4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Aug 2020 07:39:56 -0400
Received: from correo.us.es ([193.147.175.20]:41588 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbgHXLjt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Aug 2020 07:39:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18D71130E30
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2020 13:39:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F914DA73F
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2020 13:39:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7DA9FDA72F; Mon, 24 Aug 2020 13:39:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEF0EDA730;
        Mon, 24 Aug 2020 13:39:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 24 Aug 2020 13:39:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 131C742EE38E;
        Mon, 24 Aug 2020 13:39:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/6] Netfilter fixes for net
Date:   Mon, 24 Aug 2020 13:39:35 +0200
Message-Id: <20200824113941.25423-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Don't flag SCTP heartbeat as invalid for re-used connections,
   from Florian Westphal.

2) Bogus overlap report due to rbtree tree rotations, from Stefano Brivio.

3) Detect partial overlap with start end point match, also from Stefano.

4) Skip netlink dump of NFTA_SET_USERDATA is unset.

5) Incorrect nft_list_attributes enumeration definition.

6) Missing zeroing before memcpy to destination register, also
   from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit cf96d977381d4a23957bade2ddf1c420b74a26b6:

  net: gemini: Fix missing free_netdev() in error path of gemini_ethernet_port_probe() (2020-08-19 16:37:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 1e105e6afa6c3d32bfb52c00ffa393894a525c27:

  netfilter: nf_tables: fix destination register zeroing (2020-08-21 19:00:33 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: conntrack: allow sctp hearbeat after connection re-use
      netfilter: nf_tables: fix destination register zeroing

Pablo Neira Ayuso (2):
      netfilter: nf_tables: add NFTA_SET_USERDATA if not null
      netfilter: nf_tables: incorrect enum nft_list_attributes definition

Stefano Brivio (2):
      netfilter: nft_set_rbtree: Handle outcomes of tree rotations in overlap detection
      netfilter: nft_set_rbtree: Detect partial overlap with start endpoint match

 include/linux/netfilter/nf_conntrack_sctp.h |  2 +
 include/net/netfilter/nf_tables.h           |  2 +
 include/uapi/linux/netfilter/nf_tables.h    |  2 +-
 net/netfilter/nf_conntrack_proto_sctp.c     | 39 ++++++++++++++++++--
 net/netfilter/nf_tables_api.c               |  3 +-
 net/netfilter/nft_payload.c                 |  4 +-
 net/netfilter/nft_set_rbtree.c              | 57 ++++++++++++++++++++++++-----
 7 files changed, 92 insertions(+), 17 deletions(-)
