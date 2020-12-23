Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2ECC433E6
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Dec 2020 11:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D17223DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Dec 2020 11:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgLWL0Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Dec 2020 06:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgLWL0Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Dec 2020 06:26:16 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCC6C061793
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2020 03:25:35 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id w79so14584840qkb.5
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2020 03:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mih3zdmMFaoRMuxqceFLQMdjm46eO32W/WpvGGFu29A=;
        b=Zju0KZKIMoE5gTdV4iSMFl27LmL9bQ/nJv7OmQVVioq/LiiYkYXxqe3sdhMMZOi4O9
         pP4NJ77XHbLvD3mwmJR9OgrfXV2wGUMdVEfm83FX45Kt+MKvwNQHgwWF8G0UycS9a41c
         nIut6/TlrtbYj3Gqd/78K6oOIGLh05cbkHZDAh0rgDawzcKXxF0/L/ieM7gXPA8NsedM
         Oh8CkljKfvI9M4AACY8hTbalqeNATI2ycuNlcRqsaKGkXdk287uhcasf7FERumCTByfz
         CKPkAMCpWH6qwssegTGS6BF2QYNVtpH1AmfjbMDRIMsxHi5E/MiVM+rMLQuqOdY+vbls
         +bQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mih3zdmMFaoRMuxqceFLQMdjm46eO32W/WpvGGFu29A=;
        b=OsT7/E/5QhrOXMmaCL5wiZkbK/tity08nT8hfwCbfenuGALIVNtfj7lJj+KDUbPyN4
         vmlKZ1GpjjAUec5Jo4nScUZM/11GfTeoctCEEfxjZ4jBixTM9f0ubkzFSqa6XDZyMzLo
         KnBCHOso55QO7SZYdKMgvdi8Z0eUygwztc1vP5bhDpKg2qlgOYUTwi+4Y7OT3Nea/XV3
         BGS6hYXErQ/Xgp5McacbV0EcBkG5kzs1NxqzOcDHqODronJ+JVtfltbcn6v7OdLAQ/GJ
         Q5QDXFXyFQ+EK14fuaxXOHBwDSZMpWbTyGK59Lxrf4gBckD3kEf9HKLDsxIPLDo3P/yA
         MXGQ==
X-Gm-Message-State: AOAM530z2zgU4DRUep6RY5TxjRq2JkEne/yBlycNjHYIvDReS61J11li
        U1yyq0tkv6nsz9xJqdlmf0enJtl8ir81325oayo5JQ==
X-Google-Smtp-Source: ABdhPJyC6wxz1ef07cHlZ4ks61+5QGostwMFhtssMRDvHrjmIhcCBqZVeibY17JBLGIn6XWBHO5OiOBdoFjIWwBo2LE=
X-Received: by 2002:a37:4285:: with SMTP id p127mr9869581qka.501.1608722734822;
 Wed, 23 Dec 2020 03:25:34 -0800 (PST)
MIME-Version: 1.0
References: <000000000000fcbe0705b70e9bd9@google.com> <CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com>
 <20201222220719.GB9639@breakpoint.cc>
In-Reply-To: <20201222220719.GB9639@breakpoint.cc>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 23 Dec 2020 12:25:23 +0100
Message-ID: <CACT4Y+Z65uJgMETo-rpu0HbvbSOBRqO0+606UsvdGN=AxNQD+Q@mail.gmail.com>
Subject: Re: kernel BUG at lib/string.c:LINE! (6)
To:     Florian Westphal <fw@strlen.de>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        syzbot <syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 22, 2020 at 11:07 PM Florian Westphal <fw@strlen.de> wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Tue, Dec 22, 2020 at 6:44 AM syzbot
> > <syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com> wrote:
> > >
> > > The issue was bisected to:
> > >
> > > commit 2f78788b55ba ("ilog2: improve ilog2 for constant arguments")
> >
> > That looks unlikely, although possibly some constant folding
> > improvement might make the fortify code notice something with it.
> >
> > > detected buffer overflow in strlen
> > > ------------[ cut here ]------------
> > > kernel BUG at lib/string.c:1149!
> > > Call Trace:
> > >  strlen include/linux/string.h:325 [inline]
> > >  strlcpy include/linux/string.h:348 [inline]
> > >  xt_rateest_tg_checkentry+0x2a5/0x6b0 net/netfilter/xt_RATEEST.c:143
> >
> > Honestly, this just looks like the traditional bug in "strlcpy()".
>
> Yes, thats exactly what this is, no idea why the bisection points
> at ilog2 changes.

The end result is usually clear from the bisection log:

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1584f137500000

In this case it looks like the most common cause of diverted bisection
-- interference from other kernel bugs, this __queue_work issue that
happened on ilog2 commit:

[03f4935135b9efeb780b970ba023c201f81cf4e6] checkpatch: fix unescaped left brace
testing commit 03f4935135b9efeb780b970ba023c201f81cf4e6 with gcc (GCC) 8.1.0
all runs: crashed: kernel BUG at lib/string.c:LINE!
# git bisect bad 03f4935135b9efeb780b970ba023c201f81cf4e6

Bisecting: 21 revisions left to test after this (roughly 5 steps)
[2f78788b55baa3410b1ec91a576286abe1ad4d6a] ilog2: improve ilog2 for
constant arguments
testing commit 2f78788b55baa3410b1ec91a576286abe1ad4d6a with gcc (GCC) 8.1.0
run #0: crashed: WARNING in __queue_work
# git bisect bad 2f78788b55baa3410b1ec91a576286abe1ad4d6a




> > That BSD function is complete garbage, exactly because it doesn't
> > limit the source length. People tend to _think_ it does ("what's that
> > size_t argument for?") but strlcpy() only limits the *destination*
> > size, and the source is always read fully.
>
> Right, I'll send a patch shortly.
