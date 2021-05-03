Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A8BC433ED
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 21:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A0A46135F
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 21:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhECVBW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 May 2021 17:01:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40990 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhECVBV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 May 2021 17:01:21 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 27BDE63087;
        Mon,  3 May 2021 22:59:45 +0200 (CEST)
Date:   Mon, 3 May 2021 23:00:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+dcccba8a1e41a38cb9df@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: arptables: use pernet ops struct during
 unregister
Message-ID: <20210503210024.GA13361@salvia>
References: <20210503115115.30856-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210503115115.30856-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 03, 2021 at 01:51:15PM +0200, Florian Westphal wrote:
> Like with iptables and ebtables, hook unregistration has to use the
> pernet ops struct, not the template.
> 
> This triggered following splat:
>   hook not found, pf 3 num 0
>   WARNING: CPU: 0 PID: 224 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
> [..]
>  nf_unregister_net_hook net/netfilter/core.c:502 [inline]
>  nf_unregister_net_hooks+0x117/0x160 net/netfilter/core.c:576
>  arpt_unregister_table_pre_exit+0x67/0x80 net/ipv4/netfilter/arp_tables.c:1565

Applied, thanks.
