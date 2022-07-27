Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476C7C04A68
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jul 2022 11:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiG0LUO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jul 2022 07:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiG0LUN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jul 2022 07:20:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CFE2638
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2022 04:20:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oGf5F-0003bA-9v; Wed, 27 Jul 2022 13:20:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/7] really handle stacked l2 headers
Date:   Wed, 27 Jul 2022 13:19:56 +0200
Message-Id: <20220727112003.26022-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric Garver reported a number of issues when matching vlan headers:

In:  update @macset { ether saddr . vlan id timeout 5s }
Out: update @macset { @ll,48,48 . @ll,112,16 & 0xfff timeout 5s }

This is because of amnesia in nft during expression decoding:
When we encounter 'vlan id', the L2 protocl (ethernet) is replaced by
vlan, so we attempt to match @ll,48,48 vs. the vlan header and come up
empty.

The vlan decode fails because we can't handle '& 0xfff' in this
instance, so we can locate the right offset but the payload expression
length doesn't match the template length (16 vs 12 bits).


The main patch is patch 3, which adds a stack of l2 protocols to track
instead of only keeping the cumulative size.

The latter is ok for serialization (we have the expression tree, so its
enough to add the size of the 'previous' l2 headers to payload
expressions that match the new 'top' l2 header.

But for deserialization, we need to be able to search all protocols base
headers seen.

The remaining patches improve handling of 'integer base type'
expressions and add test cases.
