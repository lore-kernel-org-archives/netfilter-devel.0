Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6C6C76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB756218DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbfGVMuf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 08:50:35 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53272 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727890AbfGVMuf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 08:50:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hpXlx-0002f6-OM; Mon, 22 Jul 2019 14:50:33 +0200
Date:   Mon, 22 Jul 2019 14:50:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 00/11] Larger xtables-save review
Message-ID: <20190722125033.uxpo2dnzdolsaks5@breakpoint.cc>
References: <20190722101628.21195-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722101628.21195-1-phil@nwl.cc>
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
> Patch three unifies the header/footer comments in all the *-save tools
> and also drops the extra newline printed in ebtables- and arptables-save
> output, so test scripts need adjustments beyond dropping the new comment
> lines from output.
> 
> Patch four fixes the table compatibility check in ip{6,}tables-nft-save.
> 
> Patches five and seven to nine prepare for integrating arptables- and
> ebtables-save into the xtables-save code.
> 
> Patch six merely fixes a minor coding-style issue.
> 
> Patches ten and eleven finally perform the actual merge.
> 
> Changes since v1:
> - Rebased onto current master branch.
> - Improved commit message in patch eight.

Thanks, this looks good to me.
