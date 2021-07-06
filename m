Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC319C07E96
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 23:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC70B61CAA
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 23:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhGFXJY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 19:09:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52846 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhGFXJY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 19:09:24 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 423736164E;
        Wed,  7 Jul 2021 01:06:33 +0200 (CEST)
Date:   Wed, 7 Jul 2021 01:06:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netfilter-devel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E . McKenney" <paulmck@kernel.org>, 1vier1@web.de
Subject: Re: [PATCH 1/2] net/netfilter/nf_conntrack_core: Mark access for
 KCSAN
Message-ID: <20210706230641.GA13147@salvia>
References: <20210627161919.3196-1-manfred@colorfullife.com>
 <20210627161919.3196-2-manfred@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210627161919.3196-2-manfred@colorfullife.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 27, 2021 at 06:19:18PM +0200, Manfred Spraul wrote:
> KCSAN detected an data race with ipc/sem.c that is intentional.
> 
> As nf_conntrack_lock() uses the same algorithm: Update
> nf_conntrack_core as well:
> 
> nf_conntrack_lock() contains
>   a1) spin_lock()
>   a2) smp_load_acquire(nf_conntrack_locks_all).
> 
> a1) actually accesses one lock from an array of locks.
> 
> nf_conntrack_locks_all() contains
>   b1) nf_conntrack_locks_all=true (normal write)
>   b2) spin_lock()
>   b3) spin_unlock()
> 
> b2 and b3 are done for every lock.
> 
> This guarantees that nf_conntrack_locks_all() prevents any
> concurrent nf_conntrack_lock() owners:
> If a thread past a1), then b2) will block until that thread releases
> the lock.
> If the threat is before a1, then b3)+a1) ensure the write b1) is
> visible, thus a2) is guaranteed to see the updated value.
> 
> But: This is only the latest time when b1) becomes visible.
> It may also happen that b1) is visible an undefined amount of time
> before the b3). And thus KCSAN will notice a data race.
> 
> In addition, the compiler might be too clever.
> 
> Solution: Use WRITE_ONCE().

Applied, thanks.
