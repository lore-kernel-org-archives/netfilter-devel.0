Return-Path: <SRS0=T2b5=XN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CF2C4CEC9
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Sep 2019 11:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD4CC21897
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Sep 2019 11:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfIRLx1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Sep 2019 07:53:27 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42492 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726038AbfIRLx1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Sep 2019 07:53:27 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iAYWT-0006DK-E0
        for netfilter-devel@vger.kernel.org; Wed, 18 Sep 2019 13:53:25 +0200
Date:   Wed, 18 Sep 2019 13:53:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190918115325.GM6961@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi.

Following example loads fine:
table ip NAT {
  set set1 {
    type ipv4_addr
    size 64
    flags dynamic,timeout
    timeout 1m
  }

  chain PREROUTING {
     type nat hook prerouting priority -101; policy accept;
  }
}

But adding/using this set doesn't work:
nft -- add rule NAT PREROUTING tcp dport 80 ip saddr @set1 counter
Error: Could not process rule: Operation not supported

This is because the 'dynamic' flag sets NFT_SET_EVAL.

According to kernel comment, that flag means:
 * @NFT_SET_EVAL: set can be updated from the evaluation path

The rule add is rejected from the lookup expression (nft_lookup_init)
which has:

if (set->flags & NFT_SET_EVAL)
    return -EOPNOTSUPP;

From looking at the git history, the NFT_SET_EVAL flag means that the
set contains expressions (i.e., a meter).

And I can see why doing a lookup on meters isn't meaningful.

Can someone please explain the exact precise meaning of 'dynamic'?
Was it supposed to mean 'set can be updated from packet path'?
Or was it supposed to mean 'set contains expressions'?

If its the latter, do we need a new NFT_SET flag to convey 'set
needs to support updates from packet path'?

Thanks.
