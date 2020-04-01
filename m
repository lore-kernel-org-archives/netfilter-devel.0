Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_ABUSE_SURBL,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FFAC43331
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 08:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79CDB215A4
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 08:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KCFQS6qB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgDAInO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 04:43:14 -0400
Received: from mail-vk1-f173.google.com ([209.85.221.173]:42637 "EHLO
        mail-vk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgDAInO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 04:43:14 -0400
Received: by mail-vk1-f173.google.com with SMTP id e20so6471080vke.9;
        Wed, 01 Apr 2020 01:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jXR2E2G3mZit3j+uzZvnM1yUospYVHdXzs9QT/f76BY=;
        b=KCFQS6qB8cChh1dQalOfDS098YWvbIWh/RiIFJ0vE/uMNAmzWFC0p01wmzz0mQXEu5
         LpOIx6v2fTDPQId3IbPXMEyVD9B7SqZDQG7L3BTogYuZl4MXiBq2x3s/TkJsiPD0rO8M
         XyYmrncKptrhQqwmV7xLE1CBZ05r2VHI9MLsfIWHmjpfotK/YU6NxEDXxdP+dHY4Y81X
         aJ4OIdkFiJgDe76SVozfK3k1r61XcEKNxbH2HkzGHFrq1l1EFDglCxokzjEDpZiAdm5q
         I8h4/HYzT5mmKgnx14IxBKS2vz6gEzcbyzEAfKyhRautkBaYuXXszWV+zYnsROPmtaAx
         x+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jXR2E2G3mZit3j+uzZvnM1yUospYVHdXzs9QT/f76BY=;
        b=dRw35Wye+LlTIU/F47s/FsadXQjgnFTXJiWmgYWHgvYuDp9x03YMcwx+K6cA291JWA
         vfYyLP/kDvmUxMUiG8ai4YHhAWc0ZTmqxS6/u4/JMMjXn/7wkZg6T5PQ1BX+yqKlJRqZ
         C4kDvpwuETTcT/BpeMbxmjG8ZtAHnE/BMpEOZNCfXGdyBT2Sea/NHLoPWPIZQ649CZ0f
         2xBvXJKq2J476KpGtxU8ooNygj4vhRyPaQUKOY5caJc/DWcJVs7PVh/+5Vam76W4gsZr
         i8DCGkxp9RwfoKbdBsBriKpKT88hq7zWm0o+ZLUKjs42kzNk9m0LHrAXQXcEOz8x47cG
         uHdQ==
X-Gm-Message-State: AGi0PubKS1fcSpvg400eIaNkkyH+qgdcX1o2+Q0rPtBY+pHLZQnjyJFV
        7qDnoIi42o8+jKk58PUmhCDSHk14rYVLC5lz+zLOAGqeFRI=
X-Google-Smtp-Source: APiQypLVF1yTMphTXyA8DmvaNv1Fy+u8PQMYFalvncCL8jWSPH4VL3JMwLB5c6IThoxC5kpi2LO8+g5+AwwRXjxNsmE=
X-Received: by 2002:a1f:c188:: with SMTP id r130mr14542928vkf.94.1585730591321;
 Wed, 01 Apr 2020 01:43:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAF90-WgSo3SbBR4zsXH99380r5rSpZRGrpbKbh3oSRa9Qr8C6w@mail.gmail.com>
 <87ftdnu82e.fsf@goll.lan>
In-Reply-To: <87ftdnu82e.fsf@goll.lan>
From:   Laura Garcia <nevola@gmail.com>
Date:   Wed, 1 Apr 2020 10:42:59 +0200
Message-ID: <CAF90-WhdQ_GL8QYsQcNzLhQQAfrfd42t9oOSNW4E9D4YSS1DWA@mail.gmail.com>
Subject: Re: [ANNOUNCE] nftlb 0.6 release
To:     "Trent W. Buck" <trentbuck@gmail.com>
Cc:     Mail List - Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 1, 2020 at 6:50 AM Trent W. Buck <trentbuck@gmail.com> wrote:
>
> Laura Garcia <nevola@gmail.com> writes:
>
> > nftlb stands for nftables load balancer, a user-space tool
> > that builds a complete load balancer and traffic distributor
> > using the nft infrastructure.
> >
> > nftlb is a nftables rules manager that creates virtual services
> > for load balancing at layer 2, layer 3 and layer 4, minimizing
> > the number of rules and using structures to match efficiently the
> > packets. It comes with an easy JSON API service to control,
> > to monitor and automate the configuration.
> > [...]
> > https://github.com/zevenet/nftlb
>
> This is really cool, thanks!
>

Appreciated!

> A couple of dumb comments (I hope that's OK):
>
> | Note 2: Before executing nftlb, ensure you have empty nft rules by
> | executing "nft flush ruleset"
>
> Does this mean nftlb needs exclusive control over the entire nft
> ruleset?  It's not immediately obvious to me if it can peacefully
> coexist with e.g. sshguard's nft rules, or even a simple handwritten
> "tcp dport { ssh, https } accept; drop" input filter.
>
> If it's best practice to flush ruleset when nftlb starts,
> why not make that an argument?  i.e. nftlb --[no-]flush-ruleset-on-start
>

That point should be extended in the documentation, for sure:

nftlb daemon has exclusivity to the tables named with "nftlb": ip
nftlb, ip6 nftlb, netdev nftlb...

Only in that scope, nftlb will manage automatically the rules so the
admin shouldn't modify them manually (unless you know what you're
doing :). In regards to the flushing behavior, nftlb already checks if
the tables exist and then flush them if required, so the "flush
ruleset" is no longer needed. For more info, see this issue [0].

Said that, you're indeed able to integrate nftlb with your firewall or
clustering rules, creating your own table and playing with chain
priorities. Please refer to the developers guide to know the
priorities for every stage of nftlb [1].

So, if you want to place a firewall rule before a nat-based virtual
service, you've to use a priority less than -150 in prerouting. I'll
extend the documentation in that matter.

>
> | nftlb uses a quite new technology that requires:
> | nf-next: [...]
> | nftables: [...]
>
> Does it need bleeding-edge git versions, or are latest stable releases OK?
> You could add something reassuring like:
>
>     nftlb 0.6 definitely works with mainline linux 5.6 and nft 0.9.1.
>

At the beginning of the project it was needed, but not today. With
stable releases should work pretty fine. I'll update it.

>
> Finally, I think README.md should link to the nft docs for curious
> people like me, e.g.:
>
>     # How does it work?
>
>     The main "active ingredient" is numgen, see here for handwritten examples:
>
>     https://wiki.nftables.org/wiki-nftables/index.php/Load_balancing
>     https://www.netfilter.org/projects/nftables/manpage.html
>
> ...although AFAICT the "man nft" doesn't yet mention numgen AT ALL :-(
>

In regards to the manual, probably my fault :)

Well, numgen is one of them but not the only one. Hash expressions are
also helping in all of this. I'll update it for sure in the README.

Thank you for your comments!

[0] https://github.com/zevenet/nftlb/issues/14
[1] https://www.zevenet.com/knowledge-base/nftlb/nftlb-developers-guide/
