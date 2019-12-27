Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1F9C2D0C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 01:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FEC52080D
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 01:25:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VKFpiDhZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfL0BZa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 20:25:30 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46874 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0BZa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 20:25:30 -0500
Received: by mail-ed1-f66.google.com with SMTP id m8so24060149edi.13;
        Thu, 26 Dec 2019 17:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=jh37alzJ5pbjEn7tPzQbndRQZ16ga31e96pQwqXXDJI=;
        b=VKFpiDhZrN/waJIXVgWgEz1fuNEAKh44Xf/q0/VMYsJ3Bi8H+0vaMiwDfAFwkQAlcB
         rhiarc0KUds69t4WkWdHrJemZ8aZU2a6HIzHvppAHqpABdUk45MLIRCCaFqb0oHxzQZd
         B+5AkgtZhCWlvdcjY6+vFOgEf5BijSrELM0aYtxccYeg4kshCesKtNCp/eQLTroN4jae
         dl6+t1Rhdc7iuzwPVOPyTI6RED5B0CdTICcwMLnkqL9sp+7jztyjqb5hysQAUPdgXTZY
         nEn0C7nDlaM2TewGaM2vcF5tMJB3JqkB4Zi/tcck0mtd9lzV7uT6/pHt9eotC21CQsKX
         ojCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=jh37alzJ5pbjEn7tPzQbndRQZ16ga31e96pQwqXXDJI=;
        b=akMJa7TjzoyLM74gMnMiIcPoBImODXhQRkiiNVRT3DaY9hy6ws/pIqswr2Kw3xqJsh
         GE2nentrsdzoRwoi8Dw5oXyJnPcblysHx0axzFeTcsNOcuitvatzNTVNTcDiu75O2++R
         q6rpdZEUyCfShCD6ilqnj3ANK1MjWYCdMelhSxV8UpgVp+aI636GfmX46/2LwdgpHx1O
         qtHUKriK9EvD6BfIs6dOqWPtBts1Qo0+Dky2+0nB1p0Zk9O0ftd47Zx07k+splGujFJn
         WXjCKXkQu7J+UIjed+V6yLp9ryL1fh3QTbee+ezZ0lWsa8fs/zgy9ZvZIEe6lpyVnIB2
         v0Sw==
X-Gm-Message-State: APjAAAUnDLnjiPjEdgItyDDhVGvsVmqqaDRgs0Hd8rrepV2JqrPxn2HC
        tj7sag2lXiUnycY+Qk0plt8AmYTVsx1EBCtylTgnwA==
X-Google-Smtp-Source: APXvYqwDdnyecjZtIkCufPDR9NS8LKZlinB4F5rv0pTS8W+tE+zstfQBi91aSNZkodlXtA2D+ipGxXRMJxg6HpFQgMk=
X-Received: by 2002:a17:906:5a8a:: with SMTP id l10mr38491953ejq.18.1577409928493;
 Thu, 26 Dec 2019 17:25:28 -0800 (PST)
MIME-Version: 1.0
References: <CAGnHSEkvf0zieVJtPyneZ6PfnzeANmfFxTb=0JpgVb1FXVk0-w@mail.gmail.com>
 <20191226222923.GA32765@dimstar.local.net>
In-Reply-To: <20191226222923.GA32765@dimstar.local.net>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Fri, 27 Dec 2019 09:25:17 +0800
Message-ID: <CAGnHSEnnCbZwgm=vb2zV7duLPf=8RO8uX=tQTtm8K6OO6xV=fA@mail.gmail.com>
Subject: Re: Weird/High CPU usage caused by LOG target
To:     Tom Yan <tom.ty89@gmail.com>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Duncan,

Not sure what default action you are referring to. If you are talking
about ulogd (hence NFLOG), as I said, I don't experience similar issue
with them. For the record, I tried to set `Storage=` in journald.conf
to volatile / none when I was using LOG. It didn't help avoiding the
high usage. (The usage doesn't reflect as systemd-journald's anyway.)
And I don't have any syslog installed.

Also, the CPU problem seems to be specific to low-end devices. The
"line" even seem to just draw between a raspberry pi 3 b+ and 4. So it
wouldn't surprise me if one cannot reproduce/notice it easily on some
"server server" or even just some old Nehalem desktop. By the way, I
tested with both a mainline aarch64 kernel build (5.4.6) and a
raspberrypi armv7 kernel build (4.19.88). The issue was reproducible
with either of them. (The distro was Arch Liunx ARM, if that matters.)

For the record, I am not writing because I "need to" use LOG and/or
log everything. I am writing just because I noticed the issue and felt
like I should report it. But thank you for you attention anyway.

Regards,
Tom

On Fri, 27 Dec 2019 at 06:51, Duncan Roe <duncan_roe@optusnet.com.au> wrote:
>
> On Thu, Dec 26, 2019 at 11:05:33AM +0800, Tom Yan wrote:
> > Hi all,
> >
> > So I was trying to log all traffics in the FORWARD chain with the LOG
> > target in iptables (while I say all, it's just some VPN server/client
> > that is used by only me, and the tests were just opening some
> > website).
> >
> > I notice that the logging causes high CPU usage (so it goes up only
> > when there are traffics). In (h)top, the usage shows up as openvpn's
> > if the forwarding involves their tuns. Say I am forwarding from one
> > tun to another, each of the openvpn instance will max out one core on
> > my raspberry pi 3 b+. (And that actually slows the whole system down,
> > like ssh/bash responsiveness, and stalls the traffic flow.) If I do
> > not log, or log with the NFLOG target instead, their CPU usage will be
> > less than 1%.
> >
> > Interestingly, the problem seems to be way less obvious if I am using
> > it on higher end devices (like my Haswell PC, or even a raspberry pi
> > 4). There are still "spikes" as well, but it won't make me "notice"
> > the problem, at least not when I am just doing some trivial web
> > browsing.
> >
> > Let me know how I can further help debugging, if any of you are
> > interested in fixing this.
> >
> > Regards,
> > Tom
> >
> Hi Tom,
>
> Just in case you missed it, be sure that your logger is configured not to sync
> the file system after every logging. That is the default action btw.
>
> I have used large-volume logging in the past and never encountered a CPU problem
> (but had to run logrotate every minute to avoid filling the disk).
>
> Cheers ... Duncan.
