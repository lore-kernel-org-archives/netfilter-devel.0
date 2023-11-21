Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F48C61D92
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbjKUM20 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjKUM2Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:28:25 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DE2E7;
        Tue, 21 Nov 2023 04:28:22 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r5PrY-0005Ax-Sz; Tue, 21 Nov 2023 13:28:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     lorenzo@kernel.org, <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/8] netfilter: make nf_flowtable lifetime differ from container struct
Date:   Tue, 21 Nov 2023 13:27:43 +0100
Message-ID: <20231121122800.13521-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series detaches nf_flowtable from the two existing container
structures.

Allocation and freeing is moved to the flowtable core.
Then, memory release is changed so it passes through another
synchronize_rcu() call.

Next, a new nftables flowtable flag is introduced to mark a flowtable
for explicit XDP-based offload.

Such flowtables have more restrictions,
in particular, if two flowtables are tagged as 'xdp offloaded', they
cannot share any net devices.

It would be possible to avoid such new 'xdp flag', but I see no way
to do so without breaking backwards compatbility: at this time the same
net_device can be part of any number of flowtables, this is very
inefficient from an XDP point of view: it would have to perform lookups
in all associated flowtables in a loop until a match is found.

This is hardly desirable.

Last two patches expose the hash table mapping and make utility
function available for XDP.

The XDP kfunc will be added in a followup patch.

Florian Westphal (8):
  netfilter: flowtable: move nf_flowtable out of container structures
  netfilter: nf_flowtable: replace init callback with a create one
  netfilter: nf_flowtable: make free a real free function
  netfilter: nf_flowtable: delay flowtable release a second time
  netfilter: nf_tables: reject flowtable hw offload for same device
  netfilter: nf_tables: add xdp offload flag
  netfilter: nf_tables: add flowtable map for xdp offload
  netfilter: nf_tables: permit duplicate flowtable mappings

 include/net/netfilter/nf_flow_table.h    |  15 ++-
 include/net/netfilter/nf_tables.h        |  15 ++-
 include/uapi/linux/netfilter/nf_tables.h |   5 +-
 net/netfilter/nf_flow_table_core.c       |  39 ++++--
 net/netfilter/nf_flow_table_inet.c       |   6 +-
 net/netfilter/nf_flow_table_offload.c    | 157 ++++++++++++++++++++++-
 net/netfilter/nf_tables_api.c            | 113 +++++++++++-----
 net/netfilter/nft_flow_offload.c         |   4 +-
 net/sched/act_ct.c                       |  37 +++---
 9 files changed, 315 insertions(+), 76 deletions(-)

-- 
2.41.0

