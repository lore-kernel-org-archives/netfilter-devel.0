From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2,nf-next 00/11] nf_tables: add stateful objects
Date: Fri,  2 Dec 2016 19:08:30 +0100
Message-ID: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47508 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750750AbcLBSJX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 13:09:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D3463D1633
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C41B4DA38B
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8FDC4DA38B
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:49 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is the v2 of the stateful object patchset that was posted earlier
this week:

	http://marc.info/?l=netfilter-devel&m=148029128323837&w=2

Tentative userspace patchsets are available at:

http://git.netfilter.org/libnftnl/log/?h=stateful
http://git.netfilter.org/nftables/log/?h=stateful

I may still revisit userspace before upstream merge, this may result in
syntax changes, so consider the userspace patchset work-in-progress.

Comments welcome,
Thanks.

Pablo Neira Ayuso (11):
  netfilter: nf_tables: add stateful objects
  netfilter: nft_counter: add stateful object type
  netfilter: nft_quota: add stateful object type
  netfilter: nf_tables: add stateful object reference expression
  netfilter: nf_tables: atomic dump and reset for stateful objects
  netfilter: nf_tables: notify internal updates of stateful objects
  netfilter: nft_quota: dump consumed quota
  netfilter: nft_quota: add depleted flag for objects
  netfilter: nf_tables: add stateful object reference to set elements
  netfilter: nft_objref: support for stateful object maps
  netfilter: nf_tables: allow to filter stateful object dumps by type

 include/net/netfilter/nf_tables.h        |  95 +++++
 include/uapi/linux/netfilter/nf_tables.h |  64 +++
 net/netfilter/Kconfig                    |   6 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nf_tables_api.c            | 661 ++++++++++++++++++++++++++++++-
 net/netfilter/nft_counter.c              | 163 ++++++--
 net/netfilter/nft_objref.c               | 226 +++++++++++
 net/netfilter/nft_quota.c                | 147 ++++++-
 8 files changed, 1298 insertions(+), 65 deletions(-)
 create mode 100644 net/netfilter/nft_objref.c

-- 
2.1.4

