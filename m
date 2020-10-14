Return-Path: <SRS0=zc7w=DV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDC6C43457
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 18:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 566C42072D
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 18:43:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="aofWv/lf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388755AbgJNSnH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 14:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730039AbgJNSnH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 14:43:07 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C646C0613D2
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 11:43:07 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id h19so62614qtq.4
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 11:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nzVrMLIzd2NJNSjMO8OI5J6MD83xLrIUxyRA9FG2Fjs=;
        b=aofWv/lfQ8/pgq5zty/oAa21hlSmBDFeBCQpAR+UxhKj0jeQBAqt68YgYBHt647D0q
         +CYkdC7RFnWLh4yMn9AsxHQ5Hzm2kbUt+KbUwJ79/S98rsYrmN1sy7ffaQeuYxsi8VpL
         RdOkrnRJcCvJVvxzTTCCNjR9w08nHxwajbjDHRDczK+SW99MiOLZVSTstqCW3FVQyXvx
         0fV2r/3Wb9cDScjSI7eO5Dola4zPddt3aiLpnm/EJBYv0Jo8wGTlUIQaCuVsqNMUHhtp
         aeTY+c/IHbKZ9Y12o+Hx+ci5UlBzj2WRSq42MoCWknNnCE/gGhbv7jDm+6WSISMKjRCu
         nMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nzVrMLIzd2NJNSjMO8OI5J6MD83xLrIUxyRA9FG2Fjs=;
        b=iMBw2y+r6E7Ne0WPTN7Bx9T38Uuqkht4wPJPZ9f0KGU2fW9kPEiiYAi2sqX7Y464HN
         bNoLWs+7n6INOYKwT13hHi1lHTIwHqvpnyhzmzfLrpYKA+6rayXzq+hox7/6jNaJsB/A
         m6StmFNa7o7kT1D+zPTNUtkTx+hM53GFYxtlZmWDrEb43ya72V4WZHA5DGUKlsQGziGl
         Tt6KlJvFFJmhni9zxxY41hDze5UIRHU8gInRHdkcjQK+Fa2cE2pTIDKZlT7v/j1FE4jh
         weCW8014EErOtN6O4jrE1s+VqmkvG1MvOxi/JR0D9YgvnZCA8+Y6hwiPIq4wJBE+Mfda
         xV7g==
X-Gm-Message-State: AOAM532ncnIIvFILDcSOf5rTUH7ImBMyJxH3SZTbQdc+lW0ArGjAByZz
        KdwvdsB/5NDcGbrdZ4L7JCz8v+aBQrEWxQ9+p6hrrw==
X-Google-Smtp-Source: ABdhPJy6flg32KXdLkVk6jzhjFGS0Gauxnhmm9hmKniaVFJ0cku7KIRdl6QimQqYL0sH2zSbXU8AA35mCvlRgY9o+K0=
X-Received: by 2002:ac8:bc9:: with SMTP id p9mr596373qti.50.1602700986146;
 Wed, 14 Oct 2020 11:43:06 -0700 (PDT)
MIME-Version: 1.0
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
 <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
 <20201009110323.GC5723@breakpoint.cc> <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu>
 <20201009185552.GF5723@breakpoint.cc> <alpine.DEB.2.23.453.2010092132220.19307@blackhole.kfki.hu>
 <20201009200548.GG5723@breakpoint.cc> <20201014000628.GA15290@salvia> <20201014082341.GA16895@breakpoint.cc>
In-Reply-To: <20201014082341.GA16895@breakpoint.cc>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Wed, 14 Oct 2020 11:42:55 -0700
Message-ID: <CA+HUmGij2kddxovowfK=Wt=SB6N2sTLTb1Hs+65MfrZGpv=YWg@mail.gmail.com>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after re-register
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 14, 2020 at 1:23 AM Florian Westphal <fw@strlen.de> wrote:
>
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Legacy would still be flawed though.
>
> Its fine too, new rule blob gets handled (and match/target checkentry
> called) before old one is dismantled.
>
> We only have a 0 refcount + hook unregister when rules get
> flushed/removed explicitly.

Should the patch be used in the meantime while this gets
worked out?

Francesco
