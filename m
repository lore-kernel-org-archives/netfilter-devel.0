Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3646C77B7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 May 2023 12:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjEQMiM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 May 2023 08:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjEQMiL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 May 2023 08:38:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745A6468D;
        Wed, 17 May 2023 05:38:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pzGPo-0004TC-My; Wed, 17 May 2023 14:38:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Wed, 17 May 2023 14:37:53 +0200
Message-Id: <20230517123756.7353-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This PR has three patches for your *net* tree:

1. Silence warning about unused variable when CONFIG_NF_NAT=n, from Tom Rix.
2. nftables: Fix possible out-of-bounds access, from myself.
3. nftables: fix null deref+UAF during element insertion into rbtree,
   also from myself.

The following changes since commit ab87603b251134441a67385ecc9d3371be17b7a7:

  net: wwan: t7xx: Ensure init is completed before system sleep (2023-05-17 13:02:25 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-05-17

for you to fetch changes up to 61ae320a29b0540c16931816299eb86bf2b66c08:

  netfilter: nft_set_rbtree: fix null deref on element insertion (2023-05-17 14:18:28 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_tables: fix nft_trans type confusion
      netfilter: nft_set_rbtree: fix null deref on element insertion

Tom Rix (1):
      netfilter: conntrack: define variables exp_nat_nla_policy and any_addr with CONFIG_NF_NAT

 net/netfilter/nf_conntrack_netlink.c |  4 ++++
 net/netfilter/nf_tables_api.c        |  4 +---
 net/netfilter/nft_set_rbtree.c       | 20 +++++++++++++-------
-- 
2.39.3

