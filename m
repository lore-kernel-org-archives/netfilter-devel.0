Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76354C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 20:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345246AbiEZUyY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 May 2022 16:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349152AbiEZUyV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 May 2022 16:54:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAE2FE8B8C;
        Thu, 26 May 2022 13:54:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Thu, 26 May 2022 22:54:09 +0200
Message-Id: <20220526205411.315136-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix UAF when creating non-stateful expression in set.

2) Set limit cost when cloning expression accordingly, from Phil Sutter.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 6c465408a7709cf180cde7569e141191b67a175c:

  dt-bindings: net: adin: Fix adi,phy-output-clock description syntax (2022-05-25 22:03:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 558254b0b602b8605d7246a10cfeb584b1fcabfc:

  netfilter: nft_limit: Clone packet limits' cost value (2022-05-26 22:50:34 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: nf_tables: disallow non-stateful expression in sets earlier

Phil Sutter (1):
      netfilter: nft_limit: Clone packet limits' cost value

 net/netfilter/nf_tables_api.c | 19 ++++++++++---------
 net/netfilter/nft_limit.c     |  2 ++
 2 files changed, 12 insertions(+), 9 deletions(-)
