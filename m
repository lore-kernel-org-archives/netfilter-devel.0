Return-Path: <SRS0=LWry=BF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F7EC433E1
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Jul 2020 13:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 298A8206E3
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Jul 2020 13:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgGZNeW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Jul 2020 09:34:22 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46579 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbgGZNeW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Jul 2020 09:34:22 -0400
Received: by mail-ot1-f66.google.com with SMTP id n24so10377579otr.13
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Jul 2020 06:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NoCMmJIvMhVHtDmzhJqMHikbGjbTnt3jp7c/6M+mqEM=;
        b=NKQrP20JHDYk/KLGacXWkfG3gBjeD/GZc4NSH+on0MOv5Qn1yK6VgsWW753bhQh6Co
         l++auzMc9OMrfnsjcPJjAX8XM7LNSLh4MuasEenfr/mBqfTogrMbglkeuPDepf4JUkSH
         EZlpSdzhar58zbp/LL/j0vXehm1+oBMCcGLNz+6s5R2Rg6/rSjOU/aaxPUQ/yQXo55zP
         t3ukKJvzoUzpkRTh5U1Q5QPNLsG8L3W6fT35GLfvJdtOMzRLI5BZWx29XwDR1GWNVOHQ
         MHNZ8V5Q7WmFZeApioiLam5wfN+hZyXxY0vEWwhZPvHjocb5NiI7XFDwtcvcp3b3gZVp
         mAxg==
X-Gm-Message-State: AOAM533n/Xeoi8oyknV34m6B7KVQUwsZhX1hAPR+PPnc4n1s8DL6lDMU
        NwQoVbiQTMwDwyffxV1Ay07vNyvKUmw=
X-Google-Smtp-Source: ABdhPJzB6EqokQOzgPa0++rpruocuuDwjVJEjXWQ+H5H+9OFCz/JGQ/dmcHSH5t1ejiaIwABn1iqLw==
X-Received: by 2002:a9d:3c6:: with SMTP id f64mr16998101otf.364.1595770461353;
        Sun, 26 Jul 2020 06:34:21 -0700 (PDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id q15sm1601110oij.54.2020.07.26.06.34.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2020 06:34:21 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id s144so2219778oie.3
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Jul 2020 06:34:20 -0700 (PDT)
X-Received: by 2002:a05:6808:486:: with SMTP id z6mr15600268oid.56.1595770460719;
 Sun, 26 Jul 2020 06:34:20 -0700 (PDT)
MIME-Version: 1.0
References: <159550068914.41232.11789462187226358215.stgit@endurance> <20200724104333.GA22517@salvia>
In-Reply-To: <20200724104333.GA22517@salvia>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Date:   Sun, 26 Jul 2020 15:34:09 +0200
X-Gmail-Original-Message-ID: <CAOkSjBhapST_3CX_Ain61KAdcvb1uHArH8U9FV_dATS8sBfS2A@mail.gmail.com>
Message-ID: <CAOkSjBhapST_3CX_Ain61KAdcvb1uHArH8U9FV_dATS8sBfS2A@mail.gmail.com>
Subject: Re: [nft PATCH] nft: rearrange help output to group related options together
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 24 Jul 2020 at 12:43, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi Arturo,
>
> On Thu, Jul 23, 2020 at 12:38:09PM +0200, Arturo Borrero Gonzalez wrote:
> [...]
> > After this patch, the help output is:
> >
> > === 8< ===
> > % nft --help
> > Usage: nft [ options ] [ cmds... ]
> >
> > Options (general):
> >   -h, help                      Show this help
> >   -v, version                   Show version information
> >   -V                            Show extended version information
> >
> > Options (with operative meaning):
> >   -c, check                     Check commands validity without actually applying the changes.
> >   -f, file <filename>           Read input from <filename>
> >   -i, interactive               Read input from interactive CLI
> >   -I, includepath <directory>   Add <directory> to the paths searched for include files. Defaul[..]
> >
> > Options (output text modifiers for data translation):
> >
> >   -N, reversedns                Translate IP addresses to names.
> >   -S, service                   Translate ports to service names as described in /etc/services.
> >   -u, guid                      Print UID/GID as defined in /etc/passwd and /etc/group.
> >   -n, numeric                   Print fully numerical output.
> >   -y, numeric-priority          Print chain priority numerically.
> >   -p, numeric-protocol          Print layer 4 protocols numerically.
> >   -T, numeric-time              Print time values numerically.
> >
> > Options (output text modifiers for parsing and other operations):
> >   -d, debug <level [,level...]> Specify debugging level (scanner, parser, eval, netlink, mnl, p[..]
> >   -e, echo                      Echo what has been added, inserted or replaced.
> >   -s, stateless                 Omit stateful information of ruleset.
> >   -a, handle                    Output rule handle.
> >   -j, json                      Format output in JSON
> >   -t, terse                     Omit contents of sets.
> > === 8< ===
>
> My proposal:
>
> % nft --help
> Usage: nft [ options ] [ cmds... ]
>
> Options (general):
>   -h, help                      Show this help
>   -v, version                   Show version information
>   -V                            Show extended version information
>
> Options (ruleset input handling):
>   -f, file <filename>           Read input from <filename>
>   -i, interactive               Read input from interactive CLI
>   -I, includepath <directory>   Add <directory> to the paths searched for include files. Defaul[..]
>   -c, check                     Check commands validity without actually applying the changes.
>
> Options (ruleset list formatting):
>   -a, handle                    Output rule handle.
>   -s, stateless                 Omit stateful information of ruleset.
>   -t, terse                     Omit contents of sets.
>   -S, service                   Translate ports to service names as described in /etc/services.
>   -N, reversedns                Translate IP addresses to names.
>   -u, guid                      Print UID/GID as defined in /etc/passwd and /etc/group.
>   -n, numeric                   Print fully numerical output.
>   -y, numeric-priority          Print chain priority numerically.
>   -p, numeric-protocol          Print layer 4 protocols numerically.
>   -T, numeric-time              Print time values numerically.
>
> Options (command output format):
>   -e, echo                      Echo what has been added, inserted or replaced.
>   -j, json                      Format output in JSON
>   -d, debug <level [,level...]> Specify debugging level (scanner, parser, eval, netlink, mnl, p[..]

That's OK.

I'm AFK, could you please amend and push the patch?

regards.
