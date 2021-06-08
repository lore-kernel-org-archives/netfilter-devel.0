Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2F3C47082
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 20:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94029613AE
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 20:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhFHUNO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 16:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbhFHUNO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 16:13:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64347C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Jun 2021 13:11:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lqi4E-0004fm-9z; Tue, 08 Jun 2021 22:11:18 +0200
Date:   Tue, 8 Jun 2021 22:11:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH nf-next] nfilter: nf_hooks: fix build failure with
 NF_TABLES=n
Message-ID: <20210608201118.GI20020@breakpoint.cc>
References: <202106082146.9TmnLWJk-lkp@intel.com>
 <20210608144237.5813-1-fw@strlen.de>
 <20210608154646.GA983@salvia>
 <20210608155326.GH20020@breakpoint.cc>
 <20210608160325.GA1531@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608160325.GA1531@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Jun 08, 2021 at 05:53:26PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Maybe from Kconfig, select CONFIG_NF_TABLES from NFNETLINK_HOOK to
> > > reduce ifdef pollution?
> > 
> > Why? It doesn't depend on nftables?
> 
> From kernelside, yes. But you have to compile userspace nftables to
> use this infra, unless there is separated tooling, userspace library
> or you code your own netlink userspace code.
> 
> Adding the "depends on" might also help signal distros that this
> subsystem is useful to be turned on.
> 
> The #ifdef is perfectly fine to fix the kbuild robot issue, I was just
> thinking if it is probably better a different path when looking at the
> whole picture.

Fair enough, please discard this, I will send the depends-on patch then.
