Return-Path: <SRS0=iLnO=B5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE12C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 10:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 116352072D
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 10:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgHSKhb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Aug 2020 06:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgHSKh3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 06:37:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004FFC061757
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2020 03:37:28 -0700 (PDT)
Received: from localhost ([::1]:38128 helo=minime)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1k8LT8-0000EO-UF; Wed, 19 Aug 2020 12:37:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/4] ordered chain listing fallout
Date:   Wed, 19 Aug 2020 12:37:08 +0200
Message-Id: <20200819103712.12974-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following four patches were partially contained within my ordered
chain listing series but unrelated. Submitting them separately to reduce
the actual series' size.

Phil Sutter (4):
  nft: cache: Check consistency with NFT_CL_FAKE, too
  nft: Extend use of nftnl_chain_list_foreach()
  nft: Fold nftnl_rule_list_chain_save() into caller
  nft: Use nft_chain_find() in nft_chain_builtin_init()

 iptables/nft-cache.c |   4 +-
 iptables/nft.c       | 210 ++++++++++++++++++++-----------------------
 2 files changed, 99 insertions(+), 115 deletions(-)

-- 
2.27.0

