Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F9FC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 09:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1CFA2074B
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 09:47:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HBGOD+tz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgE2JrD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 May 2020 05:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2JrD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 May 2020 05:47:03 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40EAC03E969
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 02:47:02 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id 1so1114220vsl.9
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 02:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hNSOdp+tCwXsNVP+ronIK/K1Dv1IUjZLw2DjiJFVRmE=;
        b=HBGOD+tzwTsBsNNONPdafV9dkfRjZAHOxxNKdRzb1bjkbNm4SnHHPUjIb9w6sdY+Sy
         ECEEKm03LLbjB4Fj4MDnADZICitjjtWJqvA0vMAs7pG3E10TCDOlPOeLk5REtnRlP4+z
         Jyt96PRl9M8HDlYxQnaLpQb+/26KZKN7ObQaZMaivEXT1z7FUYFbX32YNx/NsyHX3QEI
         U5Lk1pkiUXhQfQO1xOleIQsXf5RglaQ/DP4D3U3HfjYVScLey1dNoAdnL8iqUDmnCdSi
         pdWZwrKEnz9PNo3HmDUt52XyfcWUsaaND1roExJKNsWiizbFYxDVhdZYy7qpLwqEPUMu
         kocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hNSOdp+tCwXsNVP+ronIK/K1Dv1IUjZLw2DjiJFVRmE=;
        b=JwCVofuHF4ScfL7Am1aMpVJbA7f8yBhOmamgvWjcKa41qLzpmxpHleQs6kZdkBlWzQ
         46H1QImgIPbykhKuSfco66GGfSK8OwwuOHFdlstVv12EbO5NIjdnwaX/Ntq1Zl950qwJ
         JSlq2OzHAotsyPxCY7IbE01aWZzItI4zGnFRWuxN7RgnhhN80fvmP/YJ7tKGNTMDiT/4
         RQN3HhSYQUP9QtPwIJvirxk4RGOUNgHrRUoQn6NaOlDvECx7gLHfOJe8Yt3bhqkRXiFd
         WjK+lmg7l4vv4A+QqCoEtl2yvsCwklA3xe6Xrx35lre4Ctk+pxrkXJoYokInRnj4Ricu
         Dong==
X-Gm-Message-State: AOAM533BO9MH6xYVYdwgw3LSaZek/PkFPMvqYe6JttakKR1Yu9j9w95m
        WIAOV3syD+Rcot5vAglUCLtD1M2xv7QYEKLLeJNcN3ML9+Q=
X-Google-Smtp-Source: ABdhPJzmyBQjPFaP+2mthvjeaWDQispAgrTew0Py29I5ev5gbiNyCheEFsQCjrCO8qK0eDmrZl+th8MMW7Pd4o3WMGM=
X-Received: by 2002:a67:ff89:: with SMTP id v9mr5483253vsq.55.1590745622126;
 Fri, 29 May 2020 02:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200528171438.GA27622@nevthink> <81ee4469-c88e-d7c9-0826-9531cff20907@thelounge.net>
In-Reply-To: <81ee4469-c88e-d7c9-0826-9531cff20907@thelounge.net>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Fri, 29 May 2020 11:46:50 +0200
Message-ID: <CAF90-Wi42vikbattLORW_qhBDhM378J91Ht=RJ1uv5=nspLJVw@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: introduce support for reject at
 prerouting stage
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, devel@zevenet.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 29, 2020 at 10:47 AM Reindl Harald <h.reindl@thelounge.net> wrote:
>
> Am 28.05.20 um 19:14 schrieb Laura Garcia Liebana:
> > REJECT statement can be only used in INPUT, FORWARD and OUTPUT
> > chains. This patch adds support of REJECT, both icmp and tcp
> > reset, at PREROUTING stage.
> >
> > The need for this patch becomes from the requirement of some
> > forwarding devices to reject traffic before the natting and
> > routing decisions.
>
> on the other hand you shoot yourself in the foot if you REJECT in
> response of "ctstate INVALID" which is a such better place in "-t mangle
> PREROUTING" because the reject to out of order re-transmit will kill
> your connections
>
> in the worst case you even send ICMP responses back to a forged source

The main use case is to be able to send a graceful termination to
legitimate clients that, under any circumstances, the NATed endpoints
are not available. This option allows clients to decide either to
perform a reconnection or manage the error in their side, instead of
just dropping the connection and let them die due to timeout.

Thanks for your comments.
