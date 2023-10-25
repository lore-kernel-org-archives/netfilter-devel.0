Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0816DC0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 20:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjJYUIn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 16:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJYUIm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 16:08:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8886D12A
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 13:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PuD7rPQ75Lo30dI49h5W0WiO/ZE/8OZ4ylwoJYjbSA0=; b=XrFHUwJ41po24gh9Np5NMM5nv5
        kIC0nFu12DsuwWIAoNk/q6sbk5Vo2Qq+qdumhrrPV7gbR/rlzsmuKuqWBnRG0opG0mxw7Nmp6xiB2
        OYrlNFT1IeP6qHkSwHzqH9iRuCJah9GvUq3UqPhn5zMbm5rLpB+lofL0Kcz7PI+Kvkm9oG+bHq6+p
        xT0cq6W2ZPgi0ZgLHJ9hphFqD7/GE4sF9t0+nULeSwlnAqgpWkLwGSxlzeHbpJoSIk54pmwTqQ+lw
        JWi1ZcggoN2DeVlZ7DaY/XaQW28Jd5clN6QzvwPHSX0lrztdKuGZ0gpp56zA8rZvEVLR4ACWInclU
        05L12xFA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qvkBB-0003cT-G1; Wed, 25 Oct 2023 22:08:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v3 0/3] Add locking for NFT_MSG_GETOBJ_RESET requests
Date:   Wed, 25 Oct 2023 22:08:25 +0200
Message-ID: <20231025200828.5482-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Analogous to getrule reset locking, prevent concurrent resetting of
named objects' state.

Changes since v2:
- New patch 1 to sort audit logging.
- Remaining patches rebased onto patch 1.

Phil Sutter (3):
  netfilter: nf_tables: Audit log dump reset after the fact
  netfilter: nf_tables: Introduce nf_tables_getobj_single
  netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests

 net/netfilter/nf_tables_api.c | 147 +++++++++++++++++++++++-----------
 1 file changed, 102 insertions(+), 45 deletions(-)

-- 
2.41.0

