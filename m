Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38631C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 12:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345192AbiELMaU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 08:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbiELMaT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 08:30:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF80218
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 05:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6DPS/8MMdW7Eg6Ti8ToqBUQx+jheuoZtc8O9CQLHTUE=; b=bbnX6fzJGFlSlfMxeyFHZ/u22O
        vhpou7SCn3+BbYMzlsEJbyxXnCyXoCmy4tomhknoqQ8DdFOw9k69H2QPZ6Fr19XsSJA5yzahTgTzp
        qQ7fDdI2chHlLwkhfFxtwVG+y0HsT/eTQPrUIM4oB3ymZNYn/63uFQU0YwPgGh5DFN9Z9Eqp+qRww
        2booTCIRMBgwfMmI86mXcVDpydvRlaQFTlLrCTbqi7vH04oRL6FC/0p1zmacrX1VusA/8E75eVHww
        9Qgeij6YAH+hwbKGT1bzOlByIY6oJmzYHu4fXnQc4nFPGBSFKmrk5TyOgw2kLx/QTI2t5MMPBIoKo
        YUg3ZIsA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1np7xR-0000wJ-8Y; Thu, 12 May 2022 14:30:17 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v2 0/2] nf_tables: Export rule optimizer results to user space
Date:   Thu, 12 May 2022 14:30:01 +0200
Message-Id: <20220512123003.29903-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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

First patch introduces an expression flags attribute, second patch
implements the annotation itself.

Phil Sutter (2):
  netfilter: nf_tables: Introduce expression flags
  netfilter: nf_tables: Annotate reduced expressions

 include/net/netfilter/nf_tables.h        |  1 +
 include/uapi/linux/netfilter/nf_tables.h |  8 ++++++++
 net/netfilter/nf_tables_api.c            | 12 ++++++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

-- 
2.34.1

