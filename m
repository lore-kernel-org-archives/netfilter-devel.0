Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F0EC432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 19:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6182240C
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 19:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="dQzyiutW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKSTCW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 14:02:22 -0500
Received: from mail-ua1-f43.google.com ([209.85.222.43]:37617 "EHLO
        mail-ua1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfKSTCW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 14:02:22 -0500
Received: by mail-ua1-f43.google.com with SMTP id l38so6904136uad.4
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 11:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hZ/Tf6TUrj7eNYL495lCA0v/jHwjR8o8jHkZd5Hs7jg=;
        b=dQzyiutWtHfQPneS5F+vTPadk3KGcoZN+2MSQuuZfk2WeN4AhJzLWS57Jry17h+R5I
         6vBRUSEc2DuKObCtV5aTyxlXoIZcRsjosvbfsfePCproS1fxxUShckzDb1qVCcZJaqsU
         0QX3tWDNneRKiv1aEvjMcucz87PX/LX/pfupN2WufaCDoH3TVsAOoBTKFjW73KXXnIzo
         Qyo6V7qxTspAtISYpUGEdVh5ABF3Mvrnp7NpFTdBCaCl051Onyq1s1tuEK7MRf0/cFak
         57wj8jV/wrIWvkKg4kTc/QnbnhSOXfGd/IFKTTTH0oVj/nVxDB8KSGS0jy8XTXDPYCTA
         MEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hZ/Tf6TUrj7eNYL495lCA0v/jHwjR8o8jHkZd5Hs7jg=;
        b=boQ34ourJSLLYYVcexY8vUasZt6yDhQf7zyEYWFTUDqDI54Y2BnhmfaBCK3a9zRMfX
         8rArnzj3tBIyFfrBZvLdNK+LxAqeH/f0aKa+gfhkD9wPo6h5B/auLAX98NA0P2HtuDFB
         h4WMSIXE54zi/Dyd6ZSIym7qq00jm65BBYIJ0n0L2/voa/vIjAlYxI3NGGo9vckOC+6k
         j3jhqq93RehDxNMyeEn1lHbmZrmQMGzeMUbsHhSZjXf0zjI0v25WGNod462Xi6WV8jZy
         y6cWvTlOk4/oJDLNm9JDWeRRro4OUQPfd7C3LwRqg7i0LLqonBYu8afNwm9rgWNm2waI
         Lvug==
X-Gm-Message-State: APjAAAU4OzBsim2tI4A10XYg7bmd7l1lRsBfNab2cD4BOpu0UsTRtdgB
        AOYMXYKw3DO+Rzac8Q/dDpeviI93Zn5FoWb2dUESXbmh
X-Google-Smtp-Source: APXvYqy5e6LDs0ERql40svIH9f32O1us/lb7uFcbLOd//uiEbQr8yPkSI66Ws0Zm/FJvNcLJtelVDUZU0AoYXrHEOWc=
X-Received: by 2002:ab0:608b:: with SMTP id i11mr22574711ual.111.1574190141242;
 Tue, 19 Nov 2019 11:02:21 -0800 (PST)
MIME-Version: 1.0
References: <CAJ2a_DcUH1ZaovOTNS14Z64Bwj5R5y4LLmZUeEPWFaNKECS6mQ@mail.gmail.com>
 <20191022173411.zh3o2wnoqxpjhjkq@salvia> <CAJ2a_DdVOTDPpamh=DKcGde_8gp++xYPwBP=0gY3_GDqPFntrQ@mail.gmail.com>
 <CAJ2a_Df61oAEc4NSFZneThOpwQcsmmjf7_RiV9y-bePwYO-9Sw@mail.gmail.com>
 <20191118181849.k4tb5rnmcuzigbaw@salvia> <20191118183013.zaaupujid7pnmp33@salvia>
In-Reply-To: <20191118183013.zaaupujid7pnmp33@salvia>
From:   =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Date:   Tue, 19 Nov 2019 20:02:10 +0100
Message-ID: <CAJ2a_Dd5NTOorEuPHzsUvj8kOTQmGWw6z6fUydMqCYibgHo8QQ@mail.gmail.com>
Subject: Re: nftables: secmark support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> > 1) I would replace secmark_raw by secmark instead. I think we should
> >    hide this assymmetry to the user. I would suggest you also extend
> >    the evaluation phase, ie. expr_evaluate_meta() and expr_evaluate_ct()
> >    to bail out in case the user tries to match on the raw packet / ct
> >    secmark ID. IIRC, the only usecase for this raw ID is to save and
> >    to restore the secmark from/to the packet to/from the conntrack
> >    object.
> >
> > And a few minor issues:
> >
> > 2) Please remove meta_key_unqualified chunk.
> >
> >         meta_key_unqualified    SET stmt_expr
>
> I mean, this update (moving the location of this rule) is not
> necessary, right? Thanks.

Without these, I am stuck with

$ ./src/nft -c -f files/examples/secmark.nft
files/examples/secmark.nft:64:49-58: Error: Counter expression must be constant
                ct state established,related meta secmark set ct secmark
                                                              ^^^^^^^^^^

using https://salsa.debian.org/cgzones-guest/nftables/compare/master...secmark_v2
