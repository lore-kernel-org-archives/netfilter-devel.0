Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C09AC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 May 2022 14:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbiECOdL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 May 2022 10:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiECOdK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 May 2022 10:33:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18C231513
        for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2022 07:29:37 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nltWx-0005ik-Kv; Tue, 03 May 2022 16:29:35 +0200
Date:   Tue, 3 May 2022 16:29:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl,v3] src: add dynamic register allocation
 infrastructure
Message-ID: <YnE8T8ppW0BpxSFv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220502153149.173228-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502153149.173228-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, May 02, 2022 at 05:31:49PM +0200, Pablo Neira Ayuso wrote:
> Starting Linux kernel 5.18-rc, operations on registers that already
> contain the expected data are turned into noop.
> 
> Track operation on registers to use the same register through
> nftnl_reg_get(). This patch introduces an LRU eviction strategy when all
> the registers are in used.
> 
> nftnl_reg_get_scratch() is used to allocate a register as scratchpad
> area: no tracking is performed in this case, although register eviction
> might occur.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

This relies upon calling nftnl_reg_get() for supported expressions (meta
and payload) only, right?

Apart from that:

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
