Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983B7C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Mar 2022 11:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiCILLx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Mar 2022 06:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbiCILLw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Mar 2022 06:11:52 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA7C1704C9
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2022 03:10:53 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nRuDT-0001KO-Ae; Wed, 09 Mar 2022 12:10:51 +0100
Date:   Wed, 9 Mar 2022 12:10:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] nfct: remove lazy binding
Message-ID: <YiiLO9t/sQ7nk29b@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220308221620.128180-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308221620.128180-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 08, 2022 at 11:16:20PM +0100, Pablo Neira Ayuso wrote:
> Since cd5135377ac4 ("conntrackd: cthelper: Set up userspace helpers when
> daemon starts"), userspace conntrack helpers do not depend on a previous
> invocation of nfct to set up the userspace helpers.
> 
> Move helper definitions to nfct-extensions/helper.c since existing
> deployments might still invoke nfct, even if not required anymore.
> 
> This patch was motivated by the removal of the lazy binding.
> 
> Phil Sutter says:
> 
> "For security purposes, distributions might want to pass -Wl,-z,now
> linker flags to all builds, thereby disabling lazy binding globally.
> 
> In the past, nfct relied upon lazy binding: It uses the helper objects'
> parsing functions without but doesn't provide all symbols the objects
> use."
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks!
