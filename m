Return-Path: <SRS0=e21D=3L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83718C32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 22:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B5D2465A
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 22:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgAVW2K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 17:28:10 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41830 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgAVW2K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 17:28:10 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iuOTo-0002rF-Og; Wed, 22 Jan 2020 23:28:08 +0100
Date:   Wed, 22 Jan 2020 23:28:08 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: autoload modules from the
 abort path
Message-ID: <20200122222808.GR795@breakpoint.cc>
References: <20200122211706.150042-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122211706.150042-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +	list_for_each_entry(req, &net->nft.module_list, list) {
> +		if (!strcmp(req->module, module_name) && req->done)
> +			return 0;
> +	}

If the module is already on this list, why does it need to be
added a second time?

Other than that I like this idea as it avoids the entire "drop
transaction mutex while inside a transaction" mess.

