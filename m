Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEE7C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 08:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8308222CF7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 08:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfIDINj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:13:39 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:50048 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfIDINj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 04:13:39 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1i5QQ5-0005Ww-IX; Wed, 04 Sep 2019 10:13:37 +0200
Date:   Wed, 4 Sep 2019 10:13:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft] tests: shell: check that rule add with index works
 with echo
Message-ID: <20190904081337.GH25650@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
References: <20190903232713.14394-1-eric@garver.life>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903232713.14394-1-eric@garver.life>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo,

On Tue, Sep 03, 2019 at 07:27:13PM -0400, Eric Garver wrote:
> If --echo is used the rule cache will not be populated. This causes
> rules added using the "index" keyword to be simply appended to the
> chain. The bug was introduced in commit 3ab02db5f836 ("cache: add
> NFT_CACHE_UPDATE and NFT_CACHE_FLUSHED flags").
> 
> Signed-off-by: Eric Garver <eric@garver.life>
> ---
> I think the issue is in cache_evaluate(). It sets the flags to
> NFT_CACHE_FULL and then bails early, but I'm not sure of the best way to
> fix it. So I'll start by submitting a test case. :)

In 3ab02db5f836a ("cache: add NFT_CACHE_UPDATE and NFT_CACHE_FLUSHED
flags"), you introduced NFT_CACHE_UPDATE to control whether
rule_evaluate() should call rule_cache_update(), probably assuming the
latter function merely changes cache depending on current command. In
fact, this function also links rules if needed (see call to
link_rules()).

The old code you replaced also did not always call rule_cache_update(),
but that was merely for sanity: If cache doesn't contain rules, there is
no point in updating it with added/replaced/removed rules. The implicit
logic is if we saw a rule command with 'index' reference, cache would be
completed up to rule level (because of the necessary index to handle
translation).

I'm not sure why you introduced NFT_CACHE_UPDATE in the first place, but
following my logic (and it seems to serve no other purpose) I would set
that flag whenever NFT_CACHE_RULE_BIT gets set. So IMHO,
NFT_CACHE_UPDATE is redundant.

Cheers, Phil
