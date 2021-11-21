Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40455C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Nov 2021 17:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbhKURGP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Nov 2021 12:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhKURGO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Nov 2021 12:06:14 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE58C061574
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 09:03:09 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id e136so43400992ybc.4
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 09:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MKQJ0PV/G4SgjLvEDAFoE5mSkCKEJiBnA94UvSb7RyI=;
        b=lbDW97uUsj8e8RtU9fRT0mjmw90G1StI2+xau5aWrsHIMc2oZdNqrKYchZEvzgLVig
         //0lEm05xQUtcWYEMBNJWgrArqpVOHQvYMhdNPtbUIpSdcmqndTuJGNQdAblB5btRAhR
         58Cy4tK+e6SX8Rtp0L890u1VRv09jqGv6fDI4dGeXP6yrJIWCeGU7j0tZRCFJmrQFuGK
         hicgHLyUlmRmELVFw7SeuN5MEnNiPyS9S+yNcVBrPXG8uvKMxsBPTRXfTd0S2VPhpuz4
         Pyz9Sb8WU9GmtzL0VBzCy20EQ+iMQnslK1cDDO12fhPZuAHB65C6woIv/0aLR49BMsV4
         sq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MKQJ0PV/G4SgjLvEDAFoE5mSkCKEJiBnA94UvSb7RyI=;
        b=HKyhBCxZAYazIk3B1VwuTC4g2stLaislFIxOSGYLqmyHFGJz39GYdn2oTytoWa0WhP
         gl4RRz+KtnDSx8AoYpt6EIBS5Geyd9//vP20mnwBfimUosUtg9rWx++z3+ukliMhoLaz
         8vv0g1h5huDaAR4FKcIFcChdpdsE9pU6AonWRzHljEibpitbGCR7DSInlIvWwRgXMphr
         mnlW7L3UXB2q7RwAf5/UJsc0RfFe+qN+WUE4bV2J0Ms7e6mDGz75XFyn3foeRWD4TIYq
         8ThHI3ozSnprp4Lmx3bImXG0FYdD7lp4b9tigLaAul0BOcl/05jXB/lu2bKGfZ05Lbr/
         Kuow==
X-Gm-Message-State: AOAM531m62v8H7e238EKjIOsYR4DXjJIX1hFqIuWLJbvxjQyoLYQzFjZ
        jw7aaEx8BHAZAM2j7DmUNyxvwZmq0iK0vFHWTgk=
X-Google-Smtp-Source: ABdhPJzOsyS/qZWK0VSwHxYTHQZsG573vPqtjbaGXEOluRSx0nX3xq91F6gRefkc7HuXGHmWB+/wErfr0KvuKgWgB5U=
X-Received: by 2002:a25:e090:: with SMTP id x138mr7873132ybg.501.1637514188252;
 Sun, 21 Nov 2021 09:03:08 -0800 (PST)
MIME-Version: 1.0
References: <20211121105448.2756593-1-eyal.birger@gmail.com> <20211121165904.GK6326@breakpoint.cc>
In-Reply-To: <20211121165904.GK6326@breakpoint.cc>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Sun, 21 Nov 2021 19:02:57 +0200
Message-ID: <CAHsH6Gsh9zP6kNrSRaXcKNab56siRYE3mg7NMBFsJAzq+SXD=w@mail.gmail.com>
Subject: Re: [PATCH nf-next,v2] netfilter: conntrack: configurable conntrack
 gc scan interval
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, shmulik.ladkani@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Nov 21, 2021 at 6:59 PM Florian Westphal <fw@strlen.de> wrote:
>
> Eyal Birger <eyal.birger@gmail.com> wrote:
> > In Commit 4608fdfc07e1 ("netfilter: conntrack: collect all entries in one cycle")
> > conntrack gc was changed to run periodically every 2 minutes.
> >
> > On systems handling many UDP connections, this leads to bursts of session
> > termination handling.
> >
> > As suggested in the original commit, provide the ability to control the gc
> > interval using a sysctl knob.
>
> Apologies, I was afk and could not respond sooner.
>
> I'd like to propose an additional knob that allows to switch to partial
> scan to spread netlink event bursts.
>
> Its largely identical to this proposed change.
>
> Will submit a patch soon and put you on CC.

Sounds great. Thanks!
