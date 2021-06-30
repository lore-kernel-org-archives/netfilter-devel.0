Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3380C11F65
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Jun 2021 12:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850A361992
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Jun 2021 12:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhF3MMT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 08:12:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36466 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbhF3MMT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 08:12:19 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 24E9460777;
        Wed, 30 Jun 2021 14:09:44 +0200 (CEST)
Date:   Wed, 30 Jun 2021 14:09:47 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Taehee Yoo <ap420073@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH NETFILTER] netfilter: nfnetlink: suspicious RCU usage in
 ctnetlink_dump_helpinfo
Message-ID: <20210630120947.GA12739@salvia>
References: <65205a04-f1a3-9901-f6b7-eab8f482f37f@virtuozzo.com>
 <20210630094949.GA18022@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210630094949.GA18022@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wed, Jun 30, 2021 at 11:49:49AM +0200, Florian Westphal wrote:
> Vasily Averin <vvs@virtuozzo.com> wrote:
> > Two patches listed below removed ctnetlink_dump_helpinfo call from under
> > rcu_read_lock. Now its rcu_dereference generates following warning:
> > =============================
> > WARNING: suspicious RCU usage
> > 5.13.0+ #5 Not tainted
> > -----------------------------
> > net/netfilter/nf_conntrack_netlink.c:221 suspicious rcu_dereference_check() usage!
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

I don't see this patch in netfilter's patchwork nor in
netfilter-devel@vger.kernel.org

Where did they go?
