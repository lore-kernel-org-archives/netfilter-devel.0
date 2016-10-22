From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 0/3] netfilter: nf_tables: fix some bugs related to dynset
Date: Sat, 22 Oct 2016 18:51:23 +0800
Message-ID: <1477133486-60686-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:33169 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936667AbcJVKwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2016 06:52:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Suppose that the user input the following nft rules, then a dynset expr is
created:
  # nft add rule filter output flow table test { ip daddr counter }

But actually, there are some bugs exist in kernel:
1. If CONFIG_NFT_SET_HASH is not enabled, kernel panic will happen
2. In extreme case, i.e. memory is exhausted, then expr clone will
   fail, this will cause module refcnt leak, memory leak and incorrect
   set's nelems
3. Packets may race when create the new element, and these *racing*
   packets will not be handled properly.

This patch set is aimed to fix these problems.

Liping Zhang (3):
  netfilter: nft_dynset: fix panic if NFT_SET_HASH is not enabled
  netfilter: nf_tables: fix *leak* when expr clone fail
  netfilter: nf_tables: fix race when create new element in dynset

 include/net/netfilter/nf_tables.h |  6 ++++--
 net/netfilter/nf_tables_api.c     | 11 ++++++-----
 net/netfilter/nft_dynset.c        | 19 +++++++++++++------
 net/netfilter/nft_set_hash.c      | 19 ++++++++++++++-----
 net/netfilter/nft_set_rbtree.c    |  2 +-
 5 files changed, 38 insertions(+), 19 deletions(-)

-- 
2.5.5


