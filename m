Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9847DC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 May 2022 22:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245245AbiEaWDF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 May 2022 18:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238588AbiEaWDF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 May 2022 18:03:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65A459A995;
        Tue, 31 May 2022 15:03:04 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/5] Netfilter fixes for net
Date:   Tue, 31 May 2022 23:58:34 +0200
Message-Id: <20220531215839.84765-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

1) Missing proper sanitization for nft_set_desc_concat_parse().

2) Missing mutex in nf_tables pre_exit path.

3) Possible double hook unregistration from clean_net path.

4) Missing FLOWI_FLAG_ANYSRC flag in flowtable route lookup.
   Fix incorrect source and destination address in case of NAT.
   Patch from wenxu.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 09e545f7381459c015b6fa0cd0ac6f010ef8cc25:

  xen/netback: fix incorrect usage of RING_HAS_UNCONSUMED_REQUESTS() (2022-05-31 12:22:22 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 97629b237a8cb7ac655c3969b8d5e57300ff6598:

  netfilter: flowtable: fix nft_flow_route source address for nat case (2022-05-31 23:32:53 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (3):
      netfilter: nf_tables: sanitize nft_set_desc_concat_parse()
      netfilter: nf_tables: hold mutex on netns pre_exit path
      netfilter: nf_tables: double hook unregistration in netns path

wenxu (2):
      netfilter: flowtable: fix missing FLOWI_FLAG_ANYSRC flag
      netfilter: flowtable: fix nft_flow_route source address for nat case

 net/netfilter/nf_tables_api.c    | 75 +++++++++++++++++++++++++++++++---------
 net/netfilter/nft_flow_offload.c |  6 ++--
 2 files changed, 62 insertions(+), 19 deletions(-)
