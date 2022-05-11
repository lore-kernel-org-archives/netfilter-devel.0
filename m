Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87E5C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 May 2022 16:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345184AbiEKQzI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 May 2022 12:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345187AbiEKQzF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 May 2022 12:55:05 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A74E44C8
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 09:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EUWWXE+lPfUw2VZumBOUAFzLif0zr9UdzfRlJTLANSU=; b=XI7cYRC8iZRocFm9+uVRhLuKb7
        dRAeRivVkEjjbkL4YP+SCH1hJMyUzHUgrFpjgZrru8lOl2bvtITqkiPm2OMCiOrYJr1T2xy4OHemt
        WjAZBrhzF2GzfjkLTEFpCOlrTBj/jUgD8rkionSAf3pfmYxmSSxM5xHqmHPsFCJAdSD3J7+7R4dXF
        cEGq5ecLAHZ8Vg/+SCkBpKt0zXD8o0257uR47RliNUAeJwF0q90IRIgbe4ptdchvmD6tOpKiInbwo
        lApIQUYAD0JQ52LAd73mCNq4Pz/vVFYKlnhnSKC60yLu3G4rQ2eY5Hz/GUd5MepxhZqOqw8aFr1N6
        bRqkWPRw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nopc5-0005jE-Ry; Wed, 11 May 2022 18:55:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 0/2] nf_tables: Export rule optimizer results to user space
Date:   Wed, 11 May 2022 18:54:51 +0200
Message-Id: <20220511165453.22425-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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

 include/net/netfilter/nf_tables.h        | 3 ++-
 include/uapi/linux/netfilter/nf_tables.h | 8 ++++++++
 net/netfilter/nf_tables_api.c            | 7 ++++++-
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.34.1

