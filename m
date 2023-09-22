Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFB6CD4846
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Sep 2023 17:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbjIVRBa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 13:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjIVRB3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 13:01:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B7C2F1;
        Fri, 22 Sep 2023 10:01:24 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,5.10 00/17] Netfilter stable fixes for 5.10
Date:   Fri, 22 Sep 2023 19:01:01 +0200
Message-Id: <20230922170118.152420-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

The following list shows the backported patches, this batch is targeting
at garbage collection (GC) / set timeout fixes that address possible UaF
and memleaks. I am using original commit IDs for reference:

1) 212ed75dc5fb ("netfilter: nf_tables: integrate pipapo into commit protocol")

2) 24138933b97b ("netfilter: nf_tables: don't skip expired elements during walk")

3) 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")

4) f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")

5) c92db3030492 ("netfilter: nft_set_hash: mark set element as dead when deleting from packet path")

6) a2dd0233cbc4 ("netfilter: nf_tables: remove busy mark and gc batch API")

7) 7845914f45f0 ("netfilter: nf_tables: don't fail inserts if duplicate has expired")

8) 6a33d8b73dfa ("netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path")

9) 02c6c24402bf ("netfilter: nf_tables: GC transaction race with netns dismantle")

10) 720344340fb9 ("netfilter: nf_tables: GC transaction race with abort path")

11) 8357bc946a2a ("netfilter: nf_tables: use correct lock to protect gc_list")

12) 8e51830e29e1 ("netfilter: nf_tables: defer gc run if previous batch is still pending")

13) 2ee52ae94baa ("netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction")

14) 96b33300fba8 ("netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention")

15) 6d365eabce3c ("netfilter: nft_set_pipapo: stop GC iteration if GC transaction allocation fails")

16) b079155faae9 ("netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration")

17) cf5000a7787c ("netfilter: nf_tables: fix memleak when more than 255 elements expired")

Please, apply.

Thanks.

Florian Westphal (4):
  netfilter: nf_tables: don't skip expired elements during walk
  netfilter: nf_tables: don't fail inserts if duplicate has expired
  netfilter: nf_tables: defer gc run if previous batch is still pending
  netfilter: nf_tables: fix memleak when more than 255 elements expired

Pablo Neira Ayuso (13):
  netfilter: nf_tables: integrate pipapo into commit protocol
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
  netfilter: nft_set_pipapo: stop GC iteration if GC transaction allocation fails
  netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration

 include/net/netfilter/nf_tables.h | 125 +++++------
 net/netfilter/nf_tables_api.c     | 341 +++++++++++++++++++++++++++---
 net/netfilter/nft_set_hash.c      |  87 +++++---
 net/netfilter/nft_set_pipapo.c    | 115 ++++++----
 net/netfilter/nft_set_rbtree.c    | 157 ++++++++------
 5 files changed, 589 insertions(+), 236 deletions(-)

-- 
2.30.2

