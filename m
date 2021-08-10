Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4CCC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 15:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9D4060F56
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 15:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243010AbhHJPXZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 11:23:25 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42276 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243001AbhHJPXY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 11:23:24 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1F47960030;
        Tue, 10 Aug 2021 17:22:19 +0200 (CEST)
Date:   Tue, 10 Aug 2021 17:22:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] x_tables: never register tables by default
Message-ID: <20210810152256.GA2502@salvia>
References: <20210803144719.26735-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210803144719.26735-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 03, 2021 at 04:47:19PM +0200, Florian Westphal wrote:
> For historical reasons x_tables still register tables by default in the
> initial namespace.
> Only newly created net namespaces add the hook on demand.
> 
> This means that the init_net always pays hook cost, even if no filtering
> rules are added (e.g. only used inside a single netns).
> 
> Note that the hooks are added even when 'iptables -L' is called.
> This is because there is no way to tell 'iptables -A' and 'iptables -L'
> apart at kernel level.
> 
> The only solution would be to register the table, but delay hook
> registration until the first rule gets added (or policy gets changed).
> 
> That however means that counters are not hooked either, so 'iptables -L'
> would always show 0-counters even when traffic is flowing which might be
> unexpected.
> 
> This keeps table and hook registration consistent with what is already done
> in non-init netns: first iptables(-save) invocation registers both table
> and hooks.
> 
> This applies the same solution adopted for ebtables.
> All tables register a template that contains the l3 family, the name
> and a constructor function that is called when the initial table has to
> be added.

Applied to nf-next, thanks.
