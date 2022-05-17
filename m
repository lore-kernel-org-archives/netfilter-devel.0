Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7453FC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 17:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351445AbiEQRVZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 13:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351408AbiEQRVX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 13:21:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B5726ACC
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 10:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ofsihuGLrmTLjfHrp+OynnD6tO3VjrvNWUXx5rI+qOM=; b=U3wtZBnCXQZnYjZ0artlW5KCQL
        vk2Jur7QckdwwrYfVrFDVTJwPm1W4lgFlgfM4tKtz6WzPc8ayx5bJfma6b0bH4kNkS7vPxHOiK+L2
        jheNkrIl6yuMpC9DuERuIhQ5MSPoPYwoW5R2aCtp/5QUdMZ5tJxvU8lsvqG2plVS90oFxLBtXAzQN
        OBYwC3W9QLckKwmTevG0yR3mtAhkucxptZnPkxXAAU11J9oDMCFTqV8PKHgBoZyYCn63qZJo9t1gg
        O3KTXJ4Szl52apUu60J5VIGJ0SSL4H4o2kTBkWEg0Yn+pL4iTo9xy5Y0bD7l9tz3WIy6e1e/Tmy8V
        iOpDVWCw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nr0sl-0005oD-6R; Tue, 17 May 2022 19:21:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v4 0/4] nf_tables: Export rule optimizer results to user space
Date:   Tue, 17 May 2022 19:20:46 +0200
Message-Id: <20220517172050.32653-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes since v3:
- Add missing chunks to patch 1

Changes since v2:
- New patches 1 and 2

Changes since v1:
- Fixed two bugs in patch 2.

While transforming rules into binary blob, code checks if certain
expressions may be omitted. Any bugs in this code might lead to very
subtle breakage of firewall rulesets, so a way of asserting optimizer
correctness is highly necessary.

This series achieves this in the most minimal way by annotating omitted
expressions with a flag. Integrated into libnftnl print output,
testsuites in user space may verify optimizer effect and assert
correctness.

First patch prepares for a blob-specific variant of struct nft_expr
which is smaller than the original. Second patch introduces this
variant. Third patch extends struct nft_expr by a new field and finally
fourth patch populates it.

Phil Sutter (4):
  netfilter: nf_tables: Store net size in nft_expr_ops::size
  netfilter: nf_tables: Introduce struct nft_expr_dp
  netfilter: nf_tables: Introduce expression flags
  netfilter: nf_tables: Annotate reduced expressions

 include/net/netfilter/nf_tables.h        | 18 +++++++---
 include/uapi/linux/netfilter/nf_tables.h |  8 +++++
 net/netfilter/nf_tables_api.c            | 42 ++++++++++++++++--------
 3 files changed, 51 insertions(+), 17 deletions(-)

-- 
2.34.1

