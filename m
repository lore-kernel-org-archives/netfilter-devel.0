Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14334C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Nov 2021 14:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhKWOEZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 09:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbhKWOEY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 09:04:24 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CF0C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Nov 2021 06:01:16 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id f9so26107290ybq.10
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Nov 2021 06:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KwhgAdRuWUDaJRJPRn7Ct7ty+cp26YDj3rojjlmxKZ8=;
        b=SuFNwqF2NSr3ed+9V4+tEAV95Vah0a2Q9i8OEGO4JPe7SZTNp43ZbmEW3k+LTzXkx3
         wS4TYXGm3vUsEXFhd+48LIZ8HNjWYjE0ng141NUt6wuZaTuDSAmY4n+zh7vN6K9yzo4Q
         NIThDTLaGzkSlfpN0OZY/hupBjGnnIIse9buj4+wcnkmIiOScBdER6SU5uLZYzPMjI+K
         e4fIcPbCKvZlJzUevZJDV7+6I/cd2N88mLn2GYqwhVno5XHux7RTIP0XpKGHxsnMULiT
         TJyDY3er3M4mzyntZmW83shQEwI5eM4TLQb+K5+6s3gurKDa3EdyyVIf8b0UjA4LNBlH
         F6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KwhgAdRuWUDaJRJPRn7Ct7ty+cp26YDj3rojjlmxKZ8=;
        b=rjPCiBCwT3EmhXK0Qjo3UVIwnCKKpoiM9ZVj6sc3EoQiaA78vpRoQb+VHXYeDVkQc7
         btrb4Mm3JGyxlv81kJd7LAU9NzPJvDHv3IkOg6sVG9EVL8LqofqKTbJBUXZOgLMtxB7A
         u9dvbWlXdko9o1qyqc83TMUi997f5iTP8B0st25XOyvfApra4SUXchiJ13lOy1b1KTiu
         oXjTOn2ldIAceL0ZSSOU9i6W9dbuc6It+yAjx8+HWuOYmE5RaOYZ1RygRdFUpiCJBf+x
         hlywFMmcZVym6r/pbK9kZyDPyVGHAEXtge5w7iBNQob9y7mhUykoaoydTh2pm8L844Uk
         JClQ==
X-Gm-Message-State: AOAM533dfWfSU05wiBubfnCwFalRL9OnDdwy2Jdjtf4c3shcN6qTx/Oh
        ppPJJ9YjDiI6m86tS//oDeIJz59MfBI7Cv6cl6I=
X-Google-Smtp-Source: ABdhPJwKXycDGsv99FEBhH3kuE6erwmQWtfy9evHvVRvJ6ynbXn22s/9qwGUoUqV39km/kVgJYn2HbGLn8ngRK75fhk=
X-Received: by 2002:a25:2412:: with SMTP id k18mr6532457ybk.121.1637676075400;
 Tue, 23 Nov 2021 06:01:15 -0800 (PST)
MIME-Version: 1.0
References: <20211121170514.2595-1-fw@strlen.de> <YZzrgVYskeXzLuM5@salvia>
In-Reply-To: <YZzrgVYskeXzLuM5@salvia>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 23 Nov 2021 16:01:04 +0200
Message-ID: <CAHsH6GvEWVTOxNGU1b3U5gcaZ=0oXSrANroaD_ZnrCOBr+37nQ@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: allow to tune gc behavior
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Karel Rericha <karel@maxtel.cz>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Nov 23, 2021 at 3:24 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi,
>
> On Sun, Nov 21, 2021 at 06:05:14PM +0100, Florian Westphal wrote:
> > as of commit 4608fdfc07e1
> > ("netfilter: conntrack: collect all entries in one cycle")
> > conntrack gc was changed to run periodically every 2 minutes.
> >
> > On systems where conntrack hash table is set to large value,
> > almost all evictions happen from gc worker rather than the packet
> > path due to hash table distribution.
> >
> > This causes netlink event overflows when the events are collected.
>
> If the issue is netlink, it should be possible to batch netlink
> events.
>
> > This change exposes two sysctls:
> >
> > 1. gc interval (milliseconds, default: 2 minutes)
> > 2. buckets per cycle (default: UINT_MAX / all)
> >
> > This allows to increase the scan intervals but also to reduce bustiness
> > by switching to partial scans of the table for each cycle.
>
> Is there a way to apply autotuning? I know, this question might be
> hard, but when does the user has update this new toggle? And do we
> know what value should be placed here?
>
> @Eyal: What gc interval you selected for your setup to address this
> issue? You mentioned a lot of UDP short-lived flows, correct?

Yes, we have a lot of short lived UDP flows related to a DNS server service.

We collect flow termination events using ulogd and forward them as JSON
messages over UDP to fluentd. Since these flows are reaped every 2 minutes,
we see spikes in UDP rx drops due to fluentd not keeping up with the bursts.

We planned to configure this to run every 10s or so, which should be
sufficient for our workloads, and monitor these spikes in order to tune
further as needed.

Eyal.
