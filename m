Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A84C4321E
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 01:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A5C460E08
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 01:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbhIUB5R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 21:57:17 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39660 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237271AbhIUBxQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 21:53:16 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8EA5863EB5;
        Tue, 21 Sep 2021 03:50:27 +0200 (CEST)
Date:   Tue, 21 Sep 2021 03:51:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH nf] netfilter: conntrack: serialize hash resizes and
 cleanups
Message-ID: <YUk6rWNxqMi37N7K@salvia>
References: <20210917221556.1162846-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210917221556.1162846-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 17, 2021 at 03:15:56PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Syzbot was able to trigger the following warning [1]
> 
> No repro found by syzbot yet but I was able to trigger similar issue
> by having 2 scripts running in parallel, changing conntrack hash sizes,
> and:
> 
> for j in `seq 1 1000` ; do unshare -n /bin/true >/dev/null ; done
> 
> It would take more than 5 minutes for net_namespace structures
> to be cleaned up.
> 
> This is because nf_ct_iterate_cleanup() has to restart everytime
> a resize happened.
> 
> By adding a mutex, we can serialize hash resizes and cleanups
> and also make get_next_corpse() faster by skipping over empty
> buckets.
> 
> Even without resizes in the picture, this patch considerably
> speeds up network namespace dismantles.

Applied, thanks.
