Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2F4EB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 16:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjGTQv4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 12:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjGTQvz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 12:51:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F391E43;
        Thu, 20 Jul 2023 09:51:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qMWsV-0001LQ-TW; Thu, 20 Jul 2023 18:51:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 0/5] Netfilter fixes for net:
Date:   Thu, 20 Jul 2023 18:51:32 +0200
Message-ID: <20230720165143.30208-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following patchset contains Netfilter fixes for net:
1. Fix spurious -EEXIST error from userspace due to
   padding holes, this was broken since 4.9 days
   when 'ignore duplicate entries on insert' feature was
   added.

2. Fix a sched-while-atomic bug, present since 5.19.

3. Properly remove elements if they lack an "end range".
   nft userspace always sets an end range attribute, even
   when its the same as the start, but the abi doesn't
   have such a restriction. Always broken since it was
   added in 5.6, all three from myself.

4 + 5: Bound chain needs to be skipped in netns release
   and on rule flush paths, from Pablo Neira.

The following changes since commit ac528649f7c63bc233cc0d33cff11f767cc666e3:

  Merge branch 'net-support-stp-on-bridge-in-non-root-netns' (2023-07-20 10:46:33 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-07-20

for you to fetch changes up to 6eaf41e87a223ae6f8e7a28d6e78384ad7e407f8:

  netfilter: nf_tables: skip bound chain on rule flush (2023-07-20 17:21:11 +0200)

----------------------------------------------------------------
netfilter pull request 2023-07-20

----------------------------------------------------------------
Florian Westphal (3):
      netfilter: nf_tables: fix spurious set element insertion failure
      netfilter: nf_tables: can't schedule in nft_chain_validate
      netfilter: nft_set_pipapo: fix improper element removal

Pablo Neira Ayuso (2):
      netfilter: nf_tables: skip bound chain in netns release path
      netfilter: nf_tables: skip bound chain on rule flush

 net/netfilter/nf_tables_api.c  | 12 ++++++++++--
 net/netfilter/nft_set_pipapo.c |  6 +++++-
 2 files changed, 15 insertions(+), 3 deletions(-)
