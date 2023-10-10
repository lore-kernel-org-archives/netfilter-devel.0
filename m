Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC3ACD8C99
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 14:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbjJJOyD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 10:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbjJJOyB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 10:54:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5699DAC;
        Tue, 10 Oct 2023 07:53:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqE7H-0001Ne-Lp; Tue, 10 Oct 2023 16:53:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/8] netfilter updates for next
Date:   Tue, 10 Oct 2023 16:53:30 +0200
Message-ID: <20231010145343.12551-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

The following request contains updates for your *net-next* tree.

First 5 patches, from Phil Sutter, clean up nftables dumpers to
use the context buffer in the netlink_callback structure rather
than a kmalloc'd buffer.

Patch 6, from myself, zaps dead code and replaces the helper function
with a small inlined helper.

Patch 7, also from myself, removes another pr_debug and replaces it
with the existing nf_log-based debug helpers.

Last patch, from George Guo, gets nft_table comments back in
sync with the structure members.

The following changes since commit f0107b864f004bc6fa19bf6d5074b4a366f3e16a:

  atm: fore200e: Drop unnecessary of_match_device() (2023-10-10 12:41:17 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-23-10-10

for you to fetch changes up to 94ecde833be5779f8086c3a094dfa51e1dbce75f:

  netfilter: cleanup struct nft_table (2023-10-10 16:34:28 +0200)

----------------------------------------------------------------
netfilter net-next pull request 2023-10-10

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: conntrack: simplify nf_conntrack_alter_reply
      netfilter: conntrack: prefer tcp_error_log to pr_debug

George Guo (1):
      netfilter: cleanup struct nft_table

Phil Sutter (5):
      netfilter: nf_tables: Always allocate nft_rule_dump_ctx
      netfilter: nf_tables: Drop pointless memset when dumping rules
      netfilter: nf_tables: Carry reset flag in nft_rule_dump_ctx
      netfilter: nf_tables: Carry s_idx in nft_rule_dump_ctx
      netfilter: nf_tables: Don't allocate nft_rule_dump_ctx

 include/net/netfilter/nf_conntrack.h   | 14 ++++--
 include/net/netfilter/nf_tables.h      |  5 ++-
 net/netfilter/nf_conntrack_core.c      | 18 --------
 net/netfilter/nf_conntrack_helper.c    |  7 +--
 net/netfilter/nf_conntrack_proto_tcp.c |  7 +--
 net/netfilter/nf_tables_api.c          | 80 +++++++++++++---------------------
 6 files changed, 50 insertions(+), 81 deletions(-)
