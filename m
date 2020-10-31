Return-Path: <SRS0=mmf4=EG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03678C388F9
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Oct 2020 00:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6EAA208B6
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Oct 2020 00:05:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BVea4vIH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgJaAFS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Oct 2020 20:05:18 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:59375 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgJaAFS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Oct 2020 20:05:18 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ba88ee7e;
        Sat, 31 Oct 2020 00:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=NPBfg4ApTqVyAYhGQrqly0owwA4=; b=BVea4v
        IHRs7aS0fC9YvGdn2SB00C7HUCfdrNchTG12gcOkjoGHzrnP+f36TiljP5pcm5Tw
        1jHzK1uidyXxWYtmUvx1qEfk19l7cXrnr4iLz/oi2/R/94EsLKkarw/4nsmqRhms
        +kr0x1O2ZAeCCCoZZq62/uZn92MMJsn/1o1vsmTrFclnhwHolNyRqkFRYgqLKacv
        DjXQZv3q5dhFlcmy4xm38hUK5C1OGn6WmcV5liSJ5hqg+ryFUuzTmH4oXx8xrZpH
        CPR2mPSN9mw4e5q9XLfeDzkYQ2BLYK1HJ1BDUSMEJvCbqL54lebD6DCtKqhE49st
        BDswvI7N3ZfN237Q==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 469881f8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 31 Oct 2020 00:03:40 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id f6so6571580ybr.0;
        Fri, 30 Oct 2020 17:05:14 -0700 (PDT)
X-Gm-Message-State: AOAM530Dmj6CCnEfuNlZu1VWWmXDNUZc10yGy/F9l98aBlkFXo3CuxlQ
        Fduv6Frw5fvmjmTkiQnIEROo0BKlci2JUaCuPm0=
X-Google-Smtp-Source: ABdhPJxbo1skH4KC8Pq63zT8HL5RAX1jmOYWBJ41hp0DHKBOhSGfYriSD6fx+ZS4nvKASqla7w0O/W1/4WRW+kcISb8=
X-Received: by 2002:a5b:c4a:: with SMTP id d10mr7249986ybr.123.1604102713734;
 Fri, 30 Oct 2020 17:05:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201029025606.3523771-1-Jason@zx2c4.com> <20201030192301.GA19199@salvia>
In-Reply-To: <20201030192301.GA19199@salvia>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 31 Oct 2020 01:05:03 +0100
X-Gmail-Original-Message-ID: <CAHmME9qs0h6SaKFrDR18wH2=vCBC9YpOKCBnZzbjQb69SEDB0g@mail.gmail.com>
Message-ID: <CAHmME9qs0h6SaKFrDR18wH2=vCBC9YpOKCBnZzbjQb69SEDB0g@mail.gmail.com>
Subject: Re: [PATCH nf 0/2] route_me_harder routing loop with tunnels
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 30, 2020 at 8:23 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Thu, Oct 29, 2020 at 03:56:04AM +0100, Jason A. Donenfeld wrote:
> > Hi Pablo,
> >
> > This series fixes a bug in the route_me_harder family of functions with
> > regards to tunnel interfaces. The first patch contains an addition to
> > the wireguard test suite; I normally send my wireguard patches through
> > Dave's tree, but I thought it'd be nice to send these together here
> > because the test case is illustrative of the issue. The second patch
> > then fixes the issue with a lengthy explanation of what's going on.
> >
> > These are intended for net.git/nf.git, not the -next variety, and to
> > eventually be backported to stable. So, the second patch has a proper
> > Fixes: line on it to help with that.
>
> Series applied, thanks.

To nf.git? Did you forget to git-push perhaps?

Jason
