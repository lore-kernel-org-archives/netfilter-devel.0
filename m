Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDB3C49EA7
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Jun 2021 10:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25D326143B
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Jun 2021 10:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhFYKXl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 06:23:41 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51340 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbhFYKXi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 06:23:38 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7E1FF607EB;
        Fri, 25 Jun 2021 12:21:15 +0200 (CEST)
Date:   Fri, 25 Jun 2021 12:21:13 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Walter Harms <wharms@bfs.de>
Cc:     Colin King <colin.king@canonical.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] netfilter: nf_tables: Fix dereference of null
 pointer flow
Message-ID: <20210625102113.GB32352@salvia>
References: <20210624195718.170796-1-colin.king@canonical.com>
 <b9c2377849aa4ac38ab0306589eb22d2@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b9c2377849aa4ac38ab0306589eb22d2@bfs.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 25, 2021 at 10:06:26AM +0000, Walter Harms wrote:
> hi Colin,
> most free_something_functions accept NULL
> these days, perhaps it would be more efficient
> to add a check in nft_flow_rule_destroy().
> There is a chance that this will catch the same
> mistake in future  also.

I'm fine with Colin patch.

Thanks.
