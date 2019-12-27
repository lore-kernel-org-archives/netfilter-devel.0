Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECC0C2D0C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 01:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94AFF2080D
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 01:29:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+FQggo3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfL0B33 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 20:29:29 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43823 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfL0B32 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 20:29:28 -0500
Received: by mail-ed1-f67.google.com with SMTP id dc19so24060919edb.10;
        Thu, 26 Dec 2019 17:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IC0H80vQ0kKMc0pdVx0C918YUM93dqSy4Q9Uhj3rC3w=;
        b=O+FQggo3UXfvwpBJt1MN0sCGWw0v88OJyv94KUz4KfezFv8XoW8R8v20er3c0YBxe4
         wj2GkU/Gte7zvJs0gsxrJfaasTcfoOqCktNCwBLEEP3b9fHpwje13joy/vrBgee/RmG7
         RTUtKHrCE62GxdNbQ6rsYfYoN1aHAMoRarmnQbR0QZ/UbnGS/8yQXClU6QzpIm9odCQS
         hp8zgNZPkVw3rBiPdVQ1aalf+kzGKUSC9rjqBvPvZBfctbFodnLqwqiaJWqFBNjCyfRf
         FUUvX/NxRsiAtPpCwB2gj48aCdZOlyp9BNJemS6gzPMclArfzwHZvvsmFLD+0pgdHZl0
         jgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IC0H80vQ0kKMc0pdVx0C918YUM93dqSy4Q9Uhj3rC3w=;
        b=Ac7qDfwReyKpBKYkjc3T9ZxzzOHGFIZgpAVp6Z0RW3T3PCuI1fhlJJ4Ako+hHoYOg7
         AtyThJTAgbl3mre8Lxqu27qVCtU2kJnkY0LCIuTtNSq+BRgKCCIE/xwLbBM3MiWraPLw
         pQEcxjFNaOb9INLDsgkDraLZ12+tCnR1qXckdy8T3Eued9T3kJZDi2f1YQeJ5kI2grri
         QgISgmOE+vbxPhthfip7kZe+qkaep+AjNxxKqpnzWhT05G2AVPTNsZIcgmXZick9SWRl
         qKJUeYdzErhlLDXTbXkVCvaHYRtNjbATosaCPcDCxBvfUXTJTuMOIhyLpDNa82yWQ5pi
         5CEg==
X-Gm-Message-State: APjAAAVxvaeQjGzzrJ5YgsSwFWlXNvuEpweaU+iBuDUvvvsGyFzjVwwj
        RMBfowf3R/1CdMQShExgFRc3FBvsnc9sqW4/h2L92Q==
X-Google-Smtp-Source: APXvYqyMS3CbNod8i2vADIJt/0XQG09CkVN50IHu22VxNb8gUcqsoxlQrMNBN2weZ2ejYhFb+33x6HOErTHLJNBZmos=
X-Received: by 2002:a17:906:4d09:: with SMTP id r9mr50753606eju.175.1577410167163;
 Thu, 26 Dec 2019 17:29:27 -0800 (PST)
MIME-Version: 1.0
References: <CAGnHSEkvf0zieVJtPyneZ6PfnzeANmfFxTb=0JpgVb1FXVk0-w@mail.gmail.com>
 <20191226222923.GA32765@dimstar.local.net> <24814d60-92c1-6c7e-8eb5-e977e1c7c1d0@thelounge.net>
In-Reply-To: <24814d60-92c1-6c7e-8eb5-e977e1c7c1d0@thelounge.net>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Fri, 27 Dec 2019 09:29:16 +0800
Message-ID: <CAGnHSE=ztRxvUoaeCSp6u9bz21EcPrWLWTGMSDBCb_U7VespKQ@mail.gmail.com>
Subject: Re: Weird/High CPU usage caused by LOG target
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Reindl,

Hmm. Not sure I get what you mean. Are you saying that this could be a
"generic" kernel flaw (in handling logging / messages), instead of a
Netfilter-specific issue?

Regards,
Tom

On Fri, 27 Dec 2019 at 08:23, Reindl Harald <h.reindl@thelounge.net> wrote:
>
>
>
> Am 26.12.19 um 23:29 schrieb Duncan Roe:
> > On Thu, Dec 26, 2019 at 11:05:33AM +0800, Tom Yan wrote:
> >> Hi all,
> >>
> >> So I was trying to log all traffics in the FORWARD chain with the LOG
> >> target in iptables (while I say all, it's just some VPN server/client
> >> that is used by only me, and the tests were just opening some
> >> website).
> >>
> >> I notice that the logging causes high CPU usage (so it goes up only
> >> when there are traffics). In (h)top, the usage shows up as openvpn's
> >> if the forwarding involves their tuns. Say I am forwarding from one
> >> tun to another, each of the openvpn instance will max out one core on
> >> my raspberry pi 3 b+. (And that actually slows the whole system down,
> >> like ssh/bash responsiveness, and stalls the traffic flow.) If I do
> >> not log, or log with the NFLOG target instead, their CPU usage will be
> >> less than 1%.
> >>
> >> Interestingly, the problem seems to be way less obvious if I am using
> >> it on higher end devices (like my Haswell PC, or even a raspberry pi
> >> 4). There are still "spikes" as well, but it won't make me "notice"
> >> the problem, at least not when I am just doing some trivial web
> >> browsing.
> >>
> >> Let me know how I can further help debugging, if any of you are
> >> interested in fixing this.
> >>
> > Just in case you missed it, be sure that your logger is configured not to sync
> > the file system after every logging. That is the default action btw.
> >
> > I have used large-volume logging in the past and never encountered a CPU problem
> > (but had to run logrotate every minute to avoid filling the disk)
>
> the problem is "-j LOG" at it's own and not suprisingly after having
> enough of random crashes and kexec only spits the disk full of
> demsg-output from iptables "-j LOG" switching awy to NFLOG and ulogd and
> never ever faced antother crash
>
> "-j LOG" spits into kernel ring buffer and by it's own produces double
> load no matter what happns after the action
