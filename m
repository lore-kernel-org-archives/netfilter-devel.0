Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE64C77B7D
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Apr 2023 14:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjDROu4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Apr 2023 10:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDROuz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2023 10:50:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 298F45FC0;
        Tue, 18 Apr 2023 07:50:54 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/5] Netfilter fixes for net
Date:   Tue, 18 Apr 2023 16:50:43 +0200
Message-Id: <20230418145048.67270-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Unbreak br_netfilter physdev match support, from Florian Westphal.

2) Use GFP_KERNEL_ACCOUNT for stateful/policy objects, from Chen Aotian.

3) Use IS_ENABLED() in nf_reset_trace(), from Florian Westphal.

4) Fix validation of catch-all set element.

5) Tighten requirements for catch-all set elements.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 24e3fce00c0b557491ff596c0682a29dee6fe848:

  net: stmmac: Add queue reset into stmmac_xdp_open() function (2023-04-05 19:02:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to d4eb7e39929a3b1ff30fb751b4859fc2410702a0:

  netfilter: nf_tables: tighten netlink attribute requirements for catch-all elements (2023-04-18 09:30:21 +0200)

----------------------------------------------------------------
Chen Aotian (1):
      netfilter: nf_tables: Modify nla_memdup's flag to GFP_KERNEL_ACCOUNT

Florian Westphal (2):
      netfilter: br_netfilter: fix recent physdev match breakage
      netfilter: nf_tables: fix ifdef to also consider nf_tables=m

Pablo Neira Ayuso (2):
      netfilter: nf_tables: validate catch-all set elements
      netfilter: nf_tables: tighten netlink attribute requirements for catch-all elements

 include/linux/skbuff.h            |  5 +--
 include/net/netfilter/nf_tables.h |  4 +++
 net/bridge/br_netfilter_hooks.c   | 17 ++++++----
 net/netfilter/nf_tables_api.c     | 69 ++++++++++++++++++++++++++++++++++-----
 net/netfilter/nft_lookup.c        | 36 +++-----------------
 5 files changed, 83 insertions(+), 48 deletions(-)
