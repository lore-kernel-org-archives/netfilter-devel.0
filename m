Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A394DC7EE23
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 May 2023 09:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjERJqz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 May 2023 05:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjERJqz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2023 05:46:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5B910DC
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2023 02:46:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pzaDd-0005b8-Th; Thu, 18 May 2023 11:46:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@breakpoint.cc
Cc:     Jakub Kicinski <kuba@kernel.org>, eric@breakpoint.cc,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/9] Netfilter updates for net-next
Date:   Thu, 18 May 2023 11:46:33 +0200
Message-Id: <20230518094642.84097-1-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

this PR contains updates for your *net-next* tree.

nftables updates:

1. Allow key existence checks with maps.
   At the moment the kernel requires userspace to pass a destination
   register for the associated value, make this optional so userspace
   can query if the key exists, just like with normal sets.

2. nftables maintains a counter per set that holds the number of
   elements.  This counter gets decremented on element removal,
   but its only incremented if the set has a upper maximum value.
   Increment unconditionally, this will allow us to update the
   maximum value later on.

3. At DCCP option maching, from Jeremy Sowden.

4. use struct_size macro, from Christophe JAILLET.

Conntrack:

5. Squash holes in struct nf_conntrack_expect, also Christophe JAILLET.

6. Allow clash resolution for GRE Protocol to avoid a packet drop,
   from Faicker Mo.

Flowtable:

Simplify route logic and split large functions into smaller
chunks, from Pablo Neira Ayuso.

The following changes since commit b50a8b0d57ab1ef11492171e98a030f48682eac3:

  net: openvswitch: Use struct_size() (2023-05-17 21:25:46 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-2023-05-18

for you to fetch changes up to e05b5362166b18a224c30502e81416e4d622d3e4:

  netfilter: flowtable: split IPv6 datapath in helper functions (2023-05-18 08:48:55 +0200)

----------------------------------------------------------------
Christophe JAILLET (2):
      netfilter: Reorder fields in 'struct nf_conntrack_expect'
      netfilter: nft_set_pipapo: Use struct_size()

Faicker Mo (1):
      netfilter: conntrack: allow insertion clash of gre protocol

Florian Westphal (2):
      netfilter: nf_tables: relax set/map validation checks
      netfilter: nf_tables: always increment set element count

Jeremy Sowden (1):
      netfilter: nft_exthdr: add boolean DCCP option matching

Pablo Neira Ayuso (3):
      netfilter: flowtable: simplify route logic
      netfilter: flowtable: split IPv4 datapath in helper functions
      netfilter: flowtable: split IPv6 datapath in helper functions

 include/net/netfilter/nf_conntrack_expect.h |  18 +--
 include/net/netfilter/nf_flow_table.h       |   4 +-
 include/uapi/linux/netfilter/nf_tables.h    |   2 +
 net/netfilter/nf_conntrack_proto_gre.c      |   1 +
 net/netfilter/nf_flow_table_core.c          |  24 +--
 net/netfilter/nf_flow_table_ip.c            | 231 ++++++++++++++++++----------
 net/netfilter/nf_tables_api.c               |  11 +-
 net/netfilter/nft_exthdr.c                  | 106 +++++++++++++
 net/netfilter/nft_flow_offload.c            |  12 +-
 net/netfilter/nft_lookup.c                  |  23 ++-
 net/netfilter/nft_set_pipapo.c              |   6 +-
 11 files changed, 303 insertions(+), 135 deletions(-)
