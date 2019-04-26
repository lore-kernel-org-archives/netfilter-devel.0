Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DDCC4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFB822146E
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfDZR2S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 13:28:18 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38612 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfDZR2S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 13:28:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hK4e0-0005gK-Hw; Fri, 26 Apr 2019 19:28:16 +0200
Message-ID: <5d2a03325b4121c2f91bc78bb0e44c3592af4220.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 26 Apr 2019 19:28:15 +0200
In-Reply-To: <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
References: <20180207013713.2432-1-pablo@netfilter.org>
         <20180207013713.2432-5-pablo@netfilter.org>
         <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
         <20190411192647.xsnhno6gcf5fen5u@salvia>
         <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
         <20190426164252.a2yxjxf3thotrqu3@salvia>
         <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2019-04-26 at 19:17 +0200, Johannes Berg wrote:
> 
> Ideally, we'd add this as
> 
> {
>   .cmd = XYZ,
>   .doit = do_xyz,
>   .dumpit = dump_xyz,
>   .attrs = { ATTR_A, ATTR_B, ATTR_C, ATTR_D },
> }
> 
> but of course there's no good way to express this in C, you'd have to
> build an out-of-line array and point to it.

Actually, it's possibly even more complicated. After all, it is possible
that you have an ATTR_N, that is nested, and that contains certain sub-
attributes (ATTR_N_A, ATTR_N_B, ...) of which only some are valid for
the operation X, but a different subset is valid for operation Y.

I'm sort of hoping we don't have enough of these cases to make it really
something we want to express, because that'll be really hard to express
in a way that we can validate and expose.

> The issue with C I noted above of course does lend itself really well to
> expressing it in a DSL and then generating the C code, but even *then* I
> would still argue that having all of this duplicated is a waste of
> memory since we need to have the same data already.

And also, in addition to this, I just realized that we really don't want
any sort of separate descriptions because we want to have the ability to
validate everything that we express to userspace.

IOW - if we tell userspace "this is valid" then we should at the same
time be able to use those description data structures to actually
validate that userspace isn't sending us something out of this spec.

So I guess that's just one more reason I think that we fundamentally
must provide to userspace exactly what we validate, and make the
validation data structures (or language) expressive enough to be able to
capture the real constraints.

johannes

