Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A968AC433ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 01:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 848E761157
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 01:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhDZBZM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Apr 2021 21:25:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49786 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhDZBZL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Apr 2021 21:25:11 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C7D19605A8;
        Mon, 26 Apr 2021 03:23:53 +0200 (CEST)
Date:   Mon, 26 Apr 2021 03:24:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next] netfilter: disable defrag once its no longer
 needed
Message-ID: <20210426012426.GA30996@salvia>
References: <20210421074540.18983-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210421074540.18983-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 21, 2021 at 09:45:40AM +0200, Florian Westphal wrote:
> When I changed defrag hooks to no longer get registered by default I
> intentionally made it so that registration can only be un-done by unloading
> the nf_defrag_ipv4/6 module.
> 
> In hindsight this was too conservative; there is no reason to keep defrag
> on while there is no feature dependency anymore.
> 
> Moreover, this won't work if user isn't allowed to remove nf_defrag module.
> 
> This adds the disable() functions for both ipv4 and ipv6 and calls them
> from conntrack, TPROXY and the xtables socket module.
> 
> ipvs isn't converted here, it will behave as before this patch and
> will need module removal.

Applied, thanks.
