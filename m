Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E6CC433B4
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Apr 2021 22:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7499613C4
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Apr 2021 22:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhDEWfh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 18:35:37 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60808 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhDEWfe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 18:35:34 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7FD6963E3C;
        Tue,  6 Apr 2021 00:35:08 +0200 (CEST)
Date:   Tue, 6 Apr 2021 00:35:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 00/11] netfilter: reduce struct net size
Message-ID: <20210405223524.GA12019@salvia>
References: <20210401141114.24712-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210401141114.24712-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 01, 2021 at 04:11:03PM +0200, Florian Westphal wrote:
> This series moves part of netfilter related pernet data from
> struct net to net_generic() infrastructure.
> 
> All of these users can be modules, so if they are not loaded there
> is no need to waste space.
> 
> Also, none of the struct members that are (re)moved are used in packet
> path.
> 
> A followup patch series will also remove ebt/arp/ip/ip6tables xt_table
> anchors from struct net.
> 
> Size reduction is 7 cachelines on x86_64.

Applied, thanks.
