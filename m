Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FADC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 17:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiF2RN7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiF2RN6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 13:13:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 204C33B3DC;
        Wed, 29 Jun 2022 10:13:58 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Wed, 29 Jun 2022 19:13:51 +0200
Message-Id: <20220629171354.208773-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Restore set counter when one of the CPU loses race to add elements
   to sets.

2) After NF_STOLEN, skb might be there no more, update nftables trace
   infra to avoid access to skb in this case. From Florian Westphal.

3) nftables bridge might register a prerouting hook with zero priority,
   br_netfilter incorrectly skips it. Also from Florian.

Florian Westphal (2):
  netfilter: nf_tables: avoid skb access on nf_stolen
  netfilter: br_netfilter: do not skip all hooks with 0 priority

Pablo Neira Ayuso (1):
  netfilter: nft_dynset: restore set element counter when failing to update

 include/net/netfilter/nf_tables.h | 16 ++++++-----
 net/bridge/br_netfilter_hooks.c   | 21 ++++++++++++---
 net/netfilter/nf_tables_core.c    | 24 ++++++++++++++---
 net/netfilter/nf_tables_trace.c   | 44 +++++++++++++++++--------------
 net/netfilter/nft_set_hash.c      |  2 ++
 5 files changed, 75 insertions(+), 32 deletions(-)

-- 
2.30.2

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit cb8092d70a6f5f01ec1490fce4d35efed3ed996c:

  tipc: move bc link creation back to tipc_node_create (2022-06-27 11:51:56 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to c2577862eeb0be94f151f2f1fff662b028061b00:

  netfilter: br_netfilter: do not skip all hooks with 0 priority (2022-06-27 19:23:27 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_tables: avoid skb access on nf_stolen
      netfilter: br_netfilter: do not skip all hooks with 0 priority

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: restore set element counter when failing to update

 include/net/netfilter/nf_tables.h | 16 ++++++++------
 net/bridge/br_netfilter_hooks.c   | 21 ++++++++++++++++---
 net/netfilter/nf_tables_core.c    | 24 ++++++++++++++++++---
 net/netfilter/nf_tables_trace.c   | 44 +++++++++++++++++++++------------------
 net/netfilter/nft_set_hash.c      |  2 ++
 5 files changed, 75 insertions(+), 32 deletions(-)
