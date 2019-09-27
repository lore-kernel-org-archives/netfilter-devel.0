Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEB0C4CED1
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC4322146E
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfI0O1Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 10:27:16 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50316 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728004AbfI0O1Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 10:27:16 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iDrDG-0002ag-OW; Fri, 27 Sep 2019 16:27:14 +0200
Date:   Fri, 27 Sep 2019 16:27:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 06/24] xtables-restore: Minimize caching when
 flushing
Message-ID: <20190927142714.GG9938@breakpoint.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
 <20190925212605.1005-7-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925212605.1005-7-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Unless --noflush was given, xtables-restore merely needs the list of
> tables to decide whether to delete it or not. Introduce nft_fake_cache()
> function which populates table list, initializes chain lists (so
> nft_chain_list_get() returns an empty list instead of NULL) and sets
> 'have_cache' to turn any later calls to nft_build_cache() into nops.
> 
> If --noflush was given, call nft_build_cache() just once instead of for
> each table line in input.

LGTM.
Acked-by: Florian Westphal <fw@strlen.de>
