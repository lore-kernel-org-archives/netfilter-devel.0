Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5292CC41513
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 12:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjJRM4W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 08:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjJRM4V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 08:56:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2590109;
        Wed, 18 Oct 2023 05:56:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qt65q-0008CF-3y; Wed, 18 Oct 2023 14:56:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 0/4] netfilter: updates for net
Date:   Wed, 18 Oct 2023 14:55:56 +0200
Message-ID: <20231018125605.27299-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

This series contains fixes for your *net* tree.
First patch, from Phil Sutter, reduces number of audit notifications
when userspace requests to re-set stateful objects.
This change also comes with a selftest update.

Second patch, also from Phil, moves the nftables audit selftest
to its own netns to avoid interference with the init netns.

Third patch, from Pablo Neira, fixes an inconsistency with the "rbtree"
set backend: When set element X has expired, a request to delete element
X should fail (like with all other backends).

Finally, patch four, also from Pablo, reverts a recent attempt to speed
up abort of a large pending update with the "pipapo" set backend.

It could cause stray references to remain in the set, which then
results in a double-free.

The following changes since commit 2915240eddba96b37de4c7e9a3d0ac6f9548454b:

  neighbor: tracing: Move pin6 inside CONFIG_IPV6=y section (2023-10-18 11:16:43 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-10-18

for you to fetch changes up to f86fb94011aeb3b26337fc22204ca726aeb8bc24:

  netfilter: nf_tables: revert do not remove elements if set backend implements .abort (2023-10-18 13:47:32 +0200)

----------------------------------------------------------------
netfilter pr 2023-18-10

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nft_set_rbtree: .deactivate fails if element has expired
      netfilter: nf_tables: revert do not remove elements if set backend implements .abort

Phil Sutter (2):
      netfilter: nf_tables: audit log object reset once per table
      selftests: netfilter: Run nft_audit.sh in its own netns

 net/netfilter/nf_tables_api.c                  | 55 ++++++++++++++------------
 net/netfilter/nft_set_rbtree.c                 |  2 +
 tools/testing/selftests/netfilter/nft_audit.sh | 52 ++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 26 deletions(-)
