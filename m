Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F29CC433ED
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Apr 2021 19:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F249561186
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Apr 2021 19:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhDJTPo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Apr 2021 15:15:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44942 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJTPo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Apr 2021 15:15:44 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5CE4062C0E;
        Sat, 10 Apr 2021 21:15:05 +0200 (CEST)
Date:   Sat, 10 Apr 2021 21:15:25 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netfilter: nft_limit: avoid possible divide error in
 nft_limit_init
Message-ID: <20210410191525.GA17033@salvia>
References: <20210409154939.43020-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210409154939.43020-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 09, 2021 at 08:49:39AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> div_u64() divides u64 by u32.
> 
> nft_limit_init() wants to divide u64 by u64, use the appropriate
> math function (div64_u64)
> 
> divide error: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 8390 Comm: syz-executor188 Not tainted 5.12.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:div_u64_rem include/linux/math64.h:28 [inline]
> RIP: 0010:div_u64 include/linux/math64.h:127 [inline]
> RIP: 0010:nft_limit_init+0x2a2/0x5e0 net/netfilter/nft_limit.c:85

Applied to nf.git, thanks
