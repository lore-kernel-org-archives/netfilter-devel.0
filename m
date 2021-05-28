Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD91C4708C
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 21:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13072613B6
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 21:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhE1Vbs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 May 2021 17:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhE1Vbr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 May 2021 17:31:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E38C061761
        for <netfilter-devel@vger.kernel.org>; Fri, 28 May 2021 14:30:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lmk3N-0003Db-PE; Fri, 28 May 2021 23:30:01 +0200
Date:   Fri, 28 May 2021 23:30:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     kernel test robot <lkp@intel.com>
Cc:     Florian Westphal <fw@strlen.de>, kbuild-all@lists.01.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next:master 4/14] net/netfilter/nft_set_pipapo.c:412:6:
 error: static declaration of 'nft_pipapo_lookup' follows non-static
 declaration
Message-ID: <20210528213001.GA10732@breakpoint.cc>
References: <202105290441.yixDLttm-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202105290441.yixDLttm-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

kernel test robot <lkp@intel.com> wrote:
> All errors (new ones prefixed by >>):
> 
> >> net/netfilter/nft_set_pipapo.c:412:6: error: static declaration of 'nft_pipapo_lookup' follows non-static declaration
>      412 | bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>          |      ^~~~~~~~~~~~~~~~~
>    In file included from net/netfilter/nft_set_pipapo.c:343:
>    net/netfilter/nft_set_pipapo.h:181:6: note: previous declaration of 'nft_pipapo_lookup' was here
>      181 | bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>          |      ^~~~~~~~~~~~~~~~~
> 
> 
> vim +/nft_pipapo_lookup +412 net/netfilter/nft_set_pipapo.c
> 
> 3c4287f62044a9 Stefano Brivio   2020-01-22  399  
> 3c4287f62044a9 Stefano Brivio   2020-01-22  400  /**
> 3c4287f62044a9 Stefano Brivio   2020-01-22  401   * nft_pipapo_lookup() - Lookup function
> 3c4287f62044a9 Stefano Brivio   2020-01-22  402   * @net:	Network namespace
> 3c4287f62044a9 Stefano Brivio   2020-01-22  403   * @set:	nftables API set representation
> 3db86c397f608b Andrew Lunn      2020-07-13  404   * @key:	nftables API element representation containing key data
> 3c4287f62044a9 Stefano Brivio   2020-01-22  405   * @ext:	nftables API extension pointer, filled with matching reference
> 3c4287f62044a9 Stefano Brivio   2020-01-22  406   *
> 3c4287f62044a9 Stefano Brivio   2020-01-22  407   * For more details, see DOC: Theory of Operation.
> 3c4287f62044a9 Stefano Brivio   2020-01-22  408   *
> 3c4287f62044a9 Stefano Brivio   2020-01-22  409   * Return: true on match, false otherwise.
> 3c4287f62044a9 Stefano Brivio   2020-01-22  410   */
> a890630241c76a Florian Westphal 2021-05-13  411  INDIRECT_CALLABLE_SCOPE

This line needs to be dropped after the nf merge.
