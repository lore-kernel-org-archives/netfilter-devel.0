Return-Path: <SRS0=YHPx=VR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB06C76195
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 19:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 061DD2085A
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 19:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfGTTfE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 15:35:04 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48656 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbfGTTfE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 15:35:04 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hov8I-0000nI-P9; Sat, 20 Jul 2019 21:35:02 +0200
Date:   Sat, 20 Jul 2019 21:35:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 00/12] Larger xtables-save review
Message-ID: <20190720193502.znmofw2h4ntvluw4@breakpoint.cc>
References: <20190720163026.15410-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190720163026.15410-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> This series started as a fix to program names mentioned in *-save
> outputs and ended in merging ebtables-save and arptables-save code into
> xtables_save_main used by ip{6,}tables-nft-save.
> 
> The first patch is actually unrelated but was discovered when testing
> counter output - depending on environment, ebtables-nft might segfault.
> 
> The second patch fixes option '-c' of ebtables-nft-save which enables
> counter prefixes in dumped rules but failed to disable the classical
> ebtables-style counters.
> 
> Patch three sorts program names quoted in output of any of the *-save
> programs, patch four unifies the header/footer comments in the same. The
> latter also drops the extra newline printed in ebtables- and
> arptables-save output, so test scripts need adjustments beyond dropping
> the new comment lines from output.
> 
> Patch five fixes the table compatibility check in ip{6,}tables-nft-save.
> 
> Patches six and eight to ten prepare for integrating arptables- and
> ebtables-save into the xtables-save code.
> 
> Patch seven merely fixes a minor coding-style issue.
> 
> Patches eleven and twelve finally perform the actual merge.

Looks good, feel free to rebase this on top of master and
then you can push this out.

In case my comment wrt. 'COMMIT line optional' is right, consider
ammending the commit message so that this reasoning is recorded
in the changelog.

Thanks!
