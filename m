Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C50C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Jan 2021 11:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 629D02395B
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Jan 2021 11:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbhAHLzj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Jan 2021 06:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbhAHLzj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Jan 2021 06:55:39 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2D2C0612F4;
        Fri,  8 Jan 2021 03:54:58 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kxqM3-0000Qq-Dw; Fri, 08 Jan 2021 12:54:55 +0100
Date:   Fri, 8 Jan 2021 12:54:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: conntrack: fix reading
 nf_conntrack_buckets
Message-ID: <20210108115455.GC19605@breakpoint.cc>
References: <161010627346.3858336.14321264288771872662.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161010627346.3858336.14321264288771872662.stgit@firesoul>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> The old way of changing the conntrack hashsize runtime was through changing
> the module param via file /sys/module/nf_conntrack/parameters/hashsize. This
> was extended to sysctl change in commit 3183ab8997a4 ("netfilter: conntrack:
> allow increasing bucket size via sysctl too").
> 
> The commit introduced second "user" variable nf_conntrack_htable_size_user
> which shadow actual variable nf_conntrack_htable_size. When hashsize is
> changed via module param this "user" variable isn't updated. This results in
> sysctl net/netfilter/nf_conntrack_buckets shows the wrong value when users
> update via the old way.

Oh, right!

Acked-by: Florian Westphal <fw@strlen.de>
