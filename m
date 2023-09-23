Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83DACE7A8D
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 01:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjIWBiX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 21:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjIWBiW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 21:38:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AA1136
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 18:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wqJAhc6L7Q3wGCfusl40x5WDoQRqPteokzM2ZVb5fWA=; b=hKt8IPA1bQ1B2A6OrNDA5BlWjb
        QlFQfIHoROYw1F5+/ZwylXgahQPMRynwxZWZidbGjqVqGudCm7l+7oJRLVQ3feuUjXg5AoqpV/zxh
        t1Kd1e0ghDBShqbuOWbyF3wFBpprQm55xaBUXLedRYY2HqwIILo1AmCnv8xWq25Ju+hndm+7/0+pt
        p86QeLtzoIpdBVyBf1ez6VOctPgEEUGnJ0n5kxeg/4UkEi/e2E1sXIatKouh/ROgHKaFc4djZ91dp
        WxnLZa8tLvo6IPxOAhZkWK0GtGXJWgPj97v46nXnjWKbRZALpP/ZA6oFbwU2pi5LN7VUicu4nk3Uu
        McusQT9w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qjrb2-0001wD-Fv; Sat, 23 Sep 2023 03:38:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf PATCH 0/5] Introduce locking for reset requests
Date:   Sat, 23 Sep 2023 03:38:02 +0200
Message-ID: <20230923013807.11398-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce a spin lock to serialize expression reset operations as
concurrent resetting of the same expression may lead to unexpected
results.

Original approach coined by Pablo and Florian, a remaining puzzle to
solve was the claim to avoid conditional spinlock calls. To achieve
this, follow Florian's suggested way of introducing dedicated nfnetlink
callbacks for *_RESET requests.

Avoiding the check for whether reset operation being requested in
callbacks is a close call, but the info must be carried into the dump
callback as well. While doing this, refactor the touched dump start
routines to embed the context into struct netlink_callback::ctx instead
of allocating it.

Phil Sutter (5):
  netfilter: nf_tables: Don't allocate nft_rule_dump_ctx
  netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests
  netfilter: nf_tables: Introduce struct nft_obj_dump_ctx
  netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests
  netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET
    requests

 include/net/netfilter/nf_tables.h |   1 +
 net/netfilter/nf_tables_api.c     | 528 ++++++++++++++++++++----------
 2 files changed, 353 insertions(+), 176 deletions(-)

-- 
2.41.0

