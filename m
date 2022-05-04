Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B9FC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 May 2022 11:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245620AbiEDLfx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 May 2022 07:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbiEDLfx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 May 2022 07:35:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BDF11A826
        for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2022 04:32:16 -0700 (PDT)
Date:   Wed, 4 May 2022 13:32:13 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl,v3] src: add dynamic register allocation
 infrastructure
Message-ID: <YnJkPTa+sHjRyNRJ@salvia>
References: <20220502153149.173228-1-pablo@netfilter.org>
 <YnE8T8ppW0BpxSFv@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnE8T8ppW0BpxSFv@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 03, 2022 at 04:29:35PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Mon, May 02, 2022 at 05:31:49PM +0200, Pablo Neira Ayuso wrote:
> > Starting Linux kernel 5.18-rc, operations on registers that already
> > contain the expected data are turned into noop.
> > 
> > Track operation on registers to use the same register through
> > nftnl_reg_get(). This patch introduces an LRU eviction strategy when all
> > the registers are in used.
> > 
> > nftnl_reg_get_scratch() is used to allocate a register as scratchpad
> > area: no tracking is performed in this case, although register eviction
> > might occur.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This relies upon calling nftnl_reg_get() for supported expressions (meta
> and payload) only, right?

Yes, I'll follow up to add remaining expressions, when adding support
for dynamic register allocation for nft.
