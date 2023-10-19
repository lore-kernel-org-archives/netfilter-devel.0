Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CEFCDB483
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 14:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345795AbjJSOUJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346021AbjJSOUI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 10:20:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2A1F132
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 07:20:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,RFC 0/8] nf_tables set updates
Date:   Thu, 19 Oct 2023 16:19:50 +0200
Message-Id: <20231019141958.653727-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This batch contains updates for set infrastructure in nf_tables.

Patch #1 no need to call pipapo_deactivate() from .flush path, instead
         use the e->ext that is passed as argument to make the element
	 inactive in the next generation.

Patch #2 turn set backend .flush to void, it always succeeds.

Patch #3 add struct nft_elem_priv placeholder and use it instead of
         void * to expose the opaque set element representation from
	 the nf_tables frontend.

Patch #4 use struct nft_elem_priv instead of struct nft_set_elem in
	 transactions, this shrinks set element transaction object
	 to fit into kmalloc-128.

Patch #5 pass struct nft_elem_priv instead of nft_set_ext to .insert,
         this is in preparation for set timeout updates support.

Patch #6 use timestamp to check if element has expired from transaction
	 path, that is .insert, .deactivate and sync gc paths. The
	 timestamp ensures that element are consistently evaluated
	 as alive / expired while handling the transaction.

Patch #7 always add timeout extensions to set elements that use default
	 set timeout, as with support to update set elements, element
	 timeout could be updated to use something different than default
	 set timeout.

Patch #8 Support for set element timeout updates. This requires no
         userspace updates. This calls .insert on the element, if it returns
	 EEXIST, then it creates a transaction using the existing
	 struct nft_elem_priv that represents the object.

This has survived 3+3 hours of 30s-stress and tests/shell runs with all
debugging instrumentation being enabled. I still have to modify existing tests
to make sure existing torture tests are exercising set element updates.

Batch can be splitted in three smaller batches to be upstreamed, because they
are unrelated although they all were made to clear the path to support for
element timeout updates.

Pablo Neira Ayuso (8):
  netfilter: nft_set_pipapo: no need to call pipapo_deactivate() from flush
  netfilter: nf_tables: set backend .flush always succeeds
  netfilter: nf_tables: expose opaque set element as struct nft_elem_priv
  netfilter: nf_tables: shrink memory consumption of set elements
  netfilter: nf_tables: set->ops->insert returns opaque set element in case of EEXIST
  netfilter: nf_tables: use timestamp to check for set element timeout
  netfilter: nf_tables: add timeout extension to elements to prepare for updates
  netfilter: nf_tables: set element timeout update support

 include/net/netfilter/nf_tables.h |  91 ++++++---
 net/netfilter/nf_tables_api.c     | 296 ++++++++++++++++--------------
 net/netfilter/nft_dynset.c        |  23 +--
 net/netfilter/nft_set_bitmap.c    |  51 +++--
 net/netfilter/nft_set_hash.c      | 113 ++++++------
 net/netfilter/nft_set_pipapo.c    |  86 ++++-----
 net/netfilter/nft_set_pipapo.h    |   4 +-
 net/netfilter/nft_set_rbtree.c    |  75 ++++----
 8 files changed, 406 insertions(+), 333 deletions(-)

-- 
2.30.2

