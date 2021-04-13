Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C7BC433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Apr 2021 11:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1CE4613BA
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Apr 2021 11:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345307AbhDMLOQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Apr 2021 07:14:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51746 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244449AbhDMLOP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Apr 2021 07:14:15 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 379D362C1A;
        Tue, 13 Apr 2021 13:13:30 +0200 (CEST)
Date:   Tue, 13 Apr 2021 13:13:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/5] netfilter: conntrack: shrink size of
 netns_ct
Message-ID: <20210413111353.GA3934@salvia>
References: <20210412195544.417-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210412195544.417-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 12, 2021 at 09:55:39PM +0200, Florian Westphal wrote:
> v2: fix linker error when PROCFS=n. This only affects patch 4/5, no
> other changes.
> 
> This reduces size of the netns_ct structure, which itself is embedded
> in struct net.
> 
> First two patches move two helper related settings to net_generic,
> these are only accessed when a new connection is added.
> 
> Patches 3 and 4 move the ct and expect counter to net_generic too.
> While these are used from packet path, they are not accessed when
> conntack finds an existing entry.
> 
> This also makes netns_ct a read-mostly structure, at this time each
> newly accepted conntrack dirties the first netns_ct cacheline for other
> cpus.
> 
> Last patch converts a few sysctls to u8.  Most conntrack sysctls are
> timeouts, so these need to be kept as ints.

Series applied, thanks.
