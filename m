Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A08C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 843246196C
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbhCaNfh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 09:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbhCaNfN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 09:35:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B379CC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 06:35:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lRb02-0003Bh-4u; Wed, 31 Mar 2021 15:35:10 +0200
Date:   Wed, 31 Mar 2021 15:35:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: iptables-nft fails to restore huge rulesets
Message-ID: <20210331133510.GF17285@breakpoint.cc>
References: <20210331091331.GE7863@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331091331.GE7863@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Hi,
> 
> I'm currently trying to fix for an issue in Kubernetes realm[1]:
> Baseline is they are trying to restore a ruleset with ~700k lines and it
> fails. Needless to say, legacy iptables handles it just fine.
> 
> Meanwhile I found out there's a limit of 1024 iovecs when submitting the
> batch to kernel, and this is what they're hitting.
> 
> I can work around that limit by increasing each iovec (via
> BATCH_PAGE_SIZE) but keeping pace with legacy seems ridiculous:
> 
> With a scripted binary-search I checked the maximum working number of
> restore items of:
> 
> (1) User-defined chains
> (2) rules with merely comment match present
> (3) rules matching on saddr, daddr, iniface and outiface
> 
> Here's legacy compared to nft with different factors in BATCH_PAGE_SIZE:
> 
> legacy		32 (stock)	  64		   128          256
> ----------------------------------------------------------------------
> 1'636'799	1'602'202	- NC -		  - NC -       - NC -
> 1'220'159	  302'079	604'160		1'208'320      - NC -
> 3'532'040	  242'688	485'376		  971'776    1'944'576

Can you explain that table? What does 1'636'799 mean? NC?
