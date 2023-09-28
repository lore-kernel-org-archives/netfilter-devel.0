Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A8BE732DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 14:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjI1Ot3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 10:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjI1Ot3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 10:49:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DBF195;
        Thu, 28 Sep 2023 07:49:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qlsKO-0005Ty-TE; Thu, 28 Sep 2023 16:49:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/4] netfilter updates for net-next
Date:   Thu, 28 Sep 2023 16:48:57 +0200
Message-ID: <20230928144916.18339-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

This small batch contains updates for the net-next tree.

First patch, from myself, is a bug fix. The issue (connect timeout) is
ancient, so I think its safe to give this more soak time given the esoteric
conditions needed to trigger this.
Also updates the existing selftest to cover this.

Add netlink extacks when an update references a non-existent
table/chain/set.  This allows userspace to provide much better
errors to the user, from Pablo Neira Ayuso.

Last patch adds more policy checks to nf_tables as a better
alternative to the existing runtime checks, from Phil Sutter.

The following changes since commit 19f5eef8bf732406415b44783ea623e3a31c34c9:

  MAINTAINERS: Add an obsolete entry for LL TEMAC driver (2023-09-28 15:55:14 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-23-09-28

for you to fetch changes up to 013714bf3e125a218bb02c938ff6df348dda743e:

  netfilter: nf_tables: Utilize NLA_POLICY_NESTED_ARRAY (2023-09-28 16:31:29 +0200)

----------------------------------------------------------------
netfilter pull request 2023-09-28

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_nat: undo erroneous tcp edemux lookup after port clash
      selftests: netfilter: test nat source port clash resolution interaction with tcp early demux

Pablo Neira Ayuso (1):
      netfilter: nf_tables: missing extended netlink error in lookup functions

Phil Sutter (1):
      netfilter: nf_tables: Utilize NLA_POLICY_NESTED_ARRAY

 net/netfilter/nf_nat_proto.c                       | 64 +++++++++++++++++++++-
 net/netfilter/nf_tables_api.c                      | 43 ++++++++++-----
 tools/testing/selftests/netfilter/nf_nat_edemux.sh | 46 +++++++++++++---
 3 files changed, 126 insertions(+), 27 deletions(-)
