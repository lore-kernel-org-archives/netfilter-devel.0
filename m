Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C72B2C61D93
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjKUMNq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjKUMNq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:13:46 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F79D131;
        Tue, 21 Nov 2023 04:13:42 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.4 00/26] Netfilter stable fixes for 5.4
Date:   Tue, 21 Nov 2023 13:13:07 +0100
Message-Id: <20231121121333.294238-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

The batch contains Netfilter fixes for -stable 5.4. This batch is
targeting at garbage collection (GC) / set timeout fixes that address
possible UaF and memleaks as well as assorted bugs.

I am using original commit IDs for reference:

1) 0c2a85edd143 ("netfilter: nf_tables: pass context to nft_set_destroy()")

2) f8bb7889af58 ("netfilter: nftables: rename set element data activation/deactivation functions")

3) 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")

4) c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to node list walk for overlap detection")

5) 61ae320a29b0 ("netfilter: nft_set_rbtree: fix null deref on element insertion")

6) f718863aca46 ("netfilter: nft_set_rbtree: fix overlap expiration walk")

7) 24138933b97b ("netfilter: nf_tables: don't skip expired elements during walk")

8) 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")

9) f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")

10) c92db3030492 ("netfilter: nft_set_hash: mark set element as dead when deleting from packet path")

11) a2dd0233cbc4 ("netfilter: nf_tables: remove busy mark and gc batch API")

12) 6a33d8b73dfa ("netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path")

13) 02c6c24402bf ("netfilter: nf_tables: GC transaction race with netns dismantle")

14) 720344340fb9 ("netfilter: nf_tables: GC transaction race with abort path")

15) 8357bc946a2a ("netfilter: nf_tables: use correct lock to protect gc_list")

16) 8e51830e29e1 ("netfilter: nf_tables: defer gc run if previous batch is still pending")

17) 2ee52ae94baa ("netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction")

18) 96b33300fba8 ("netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention")

19) b079155faae9 ("netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration")

20) cf5000a7787c ("netfilter: nf_tables: fix memleak when more than 255 elements expired")

21) 6069da443bf6 ("netfilter: nf_tables: unregister flowtable hooks on netns exit")

22) f9a43007d3f7 ("netfilter: nf_tables: double hook unregistration in netns path")

23) 0ce7cf4127f1 ("netfilter: nftables: update table flags from the commit phase")

24) 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")

25) c9bd26513b3a ("netfilter: nf_tables: disable toggling dormant table state more than once")

26) ("netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush (for 5.4)")
    does not exist in any tree, but it is required to fix a bogus EBUSY error in 5.4.
    This bug was implicitly fixed by 3f0465a9ef02 ("netfilter: nf_tables: dynamically
    allocate hooks per net_device in flowtables").

Please apply,
Thanks.

Florian Westphal (4):
  netfilter: nft_set_rbtree: fix null deref on element insertion
  netfilter: nft_set_rbtree: fix overlap expiration walk
  netfilter: nf_tables: don't skip expired elements during walk
  netfilter: nf_tables: defer gc run if previous batch is still pending

Pablo Neira Ayuso (22):
  netfilter: nf_tables: pass context to nft_set_destroy()
  netfilter: nftables: rename set element data activation/deactivation functions
  netfilter: nf_tables: drop map element references from preparation phase
  netfilter: nft_set_rbtree: Switch to node list walk for overlap detection
  netfilter: nf_tables: GC transaction API to avoid race with control plane
  netfilter: nf_tables: adapt set backend to use GC transaction API
  netfilter: nft_set_hash: mark set element as dead when deleting from packet path
  netfilter: nf_tables: remove busy mark and gc batch API
  netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path
  netfilter: nf_tables: GC transaction race with netns dismantle
  netfilter: nf_tables: GC transaction race with abort path
  netfilter: nf_tables: use correct lock to protect gc_list
  netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction
  netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention
  netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration
  netfilter: nf_tables: fix memleak when more than 255 elements expired
  netfilter: nf_tables: unregister flowtable hooks on netns exit
  netfilter: nf_tables: double hook unregistration in netns path
  netfilter: nftables: update table flags from the commit phase
  netfilter: nf_tables: fix table flag updates
  netfilter: nf_tables: disable toggling dormant table state more than once
  netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush (for 5.4)

 include/net/netfilter/nf_tables.h        | 129 +++---
 include/uapi/linux/netfilter/nf_tables.h |   1 +
 net/netfilter/nf_tables_api.c            | 512 +++++++++++++++++++----
 net/netfilter/nft_chain_filter.c         |   3 +
 net/netfilter/nft_set_bitmap.c           |   5 +-
 net/netfilter/nft_set_hash.c             | 110 +++--
 net/netfilter/nft_set_rbtree.c           | 375 +++++++++++++----
 7 files changed, 867 insertions(+), 268 deletions(-)

-- 
2.30.2

