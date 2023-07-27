Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CC9C001DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jul 2023 13:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjG0NgS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 09:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjG0NgR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 09:36:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396D92728;
        Thu, 27 Jul 2023 06:36:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qP1A0-0003DR-Ir; Thu, 27 Jul 2023 15:36:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/5] netfilter updates for net-next
Date:   Thu, 27 Jul 2023 15:35:55 +0200
Message-ID: <20230727133604.8275-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

This batch contains a few updates for your *net-next* tree.
Note that this includes two patches that make changes to lib/.

1.  silence a harmless warning for CONFIG_NF_CONNTRACK_PROCFS=n builds,
from Zhu Wang.

2, 3:
Allow NLA_POLICY_MASK to be used with BE16/BE32 types, and replace a few
manual checks with nla_policy based one in nf_tables, from myself.

4: cleanup in ctnetlink to validate while parsing rather than
   using two steps, from Lin Ma.

5: refactor boyer-moore textsearch by moving a small chunk to
   a helper function, rom Jeremy Sowden.

The following changes since commit bc758ade614576d1c1b167af0246ada8c916c804:

  net/mlx4: clean up a type issue (2023-07-26 22:08:44 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-23-07-27

for you to fetch changes up to 86e9c9aa2358a74bcc5e63f9fc69c2d01e64c002:

  lib/ts_bm: add helper to reduce indentation and improve readability (2023-07-27 13:45:51 +0200)

----------------------------------------------------------------
netfilter net-next pull request 2023-07-27

----------------------------------------------------------------
Florian Westphal (2):
      netlink: allow be16 and be32 types in all uint policy checks
      netfilter: nf_tables: use NLA_POLICY_MASK to test for valid flag options

Jeremy Sowden (1):
      lib/ts_bm: add helper to reduce indentation and improve readability

Lin Ma (1):
      netfilter: conntrack: validate cta_ip via parsing

Zhu Wang (1):
      nf_conntrack: fix -Wunused-const-variable=

 include/net/netlink.h                   | 10 +++-----
 lib/nlattr.c                            |  6 +++++
 lib/ts_bm.c                             | 43 +++++++++++++++++++++++----------
 net/netfilter/nf_conntrack_netlink.c    |  8 ++----
 net/netfilter/nf_conntrack_proto_dccp.c |  2 ++
 net/netfilter/nft_fib.c                 | 13 +++++-----
 net/netfilter/nft_lookup.c              |  6 ++---
 net/netfilter/nft_masq.c                |  8 +++---
 net/netfilter/nft_nat.c                 |  8 +++---
 net/netfilter/nft_redir.c               |  8 +++---
 10 files changed, 61 insertions(+), 51 deletions(-)
