Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67286C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 17:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50F832073B
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 17:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgE2Rue (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 May 2020 13:50:34 -0400
Received: from correo.us.es ([193.147.175.20]:58768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgE2Rue (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 May 2020 13:50:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C88F78140C
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 19:50:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B93FDDA71F
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 19:50:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AEEAFDA715; Fri, 29 May 2020 19:50:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B0D8DA71A;
        Fri, 29 May 2020 19:50:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 19:50:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3F14C42EE38E;
        Fri, 29 May 2020 19:50:29 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/9] Netfilter updates for net-next
Date:   Fri, 29 May 2020 19:50:17 +0200
Message-Id: <20200529175026.30541-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next
to extend ctnetlink and the flowtable infrastructure:

1) Extend ctnetlink kernel side netlink dump filtering capabilities,
   from Romain Bellan.

2) Generalise the flowtable hook parser to take a hook list.

3) Pass a hook list to the flowtable hook registration/unregistration.

4) Add a helper function to release the flowtable hook list.

5) Update the flowtable event notifier to pass a flowtable hook list.

6) Allow users to add new devices to an existing flowtables.

7) Allow users to remove devices to an existing flowtables.

8) Allow for registering a flowtable with no initial devices.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you!

----------------------------------------------------------------

The following changes since commit 626a83238e6a63d88a5b5291febe797b244b5f18:

  net: dsa: felix: accept VLAN config regardless of bridge VLAN awareness state (2020-05-27 11:39:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 5b6743fb2c2a1fcb31c8b227558f537095dbece4:

  netfilter: nf_tables: skip flowtable hooknum and priority on device updates (2020-05-27 22:20:35 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (8):
      netfilter: nf_tables: generalise flowtable hook parsing
      netfilter: nf_tables: pass hook list to nft_{un,}register_flowtable_net_hooks()
      netfilter: nf_tables: add nft_flowtable_hooks_destroy()
      netfilter: nf_tables: pass hook list to flowtable event notifier
      netfilter: nf_tables: add devices to existing flowtable
      netfilter: nf_tables: delete devices from flowtable
      netfilter: nf_tables: allow to register flowtable with no devices
      netfilter: nf_tables: skip flowtable hooknum and priority on device updates

Romain Bellan (1):
      netfilter: ctnetlink: add kernel side filtering for dump

 include/net/netfilter/nf_conntrack_l4proto.h       |   6 +-
 include/net/netfilter/nf_tables.h                  |   7 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |   9 +
 net/netfilter/nf_conntrack_core.c                  |  19 +-
 net/netfilter/nf_conntrack_netlink.c               | 334 ++++++++++++++++++---
 net/netfilter/nf_conntrack_proto_icmp.c            |  40 ++-
 net/netfilter/nf_conntrack_proto_icmpv6.c          |  42 ++-
 net/netfilter/nf_internals.h                       |  17 ++
 net/netfilter/nf_tables_api.c                      | 333 ++++++++++++++++----
 9 files changed, 670 insertions(+), 137 deletions(-)
