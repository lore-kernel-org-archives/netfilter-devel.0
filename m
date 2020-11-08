Return-Path: <SRS0=tTqd=EO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2583AC388F9
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Nov 2020 22:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBC67206A5
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Nov 2020 22:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nhX4kGeq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgKHWBX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Nov 2020 17:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHWBW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Nov 2020 17:01:22 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBDAC0613CF
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Nov 2020 14:01:22 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id v92so306111ybi.4
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Nov 2020 14:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/VWvCCeEVbMZdq9UF5aG+wVC8fHZ26437znnIuTzxNk=;
        b=nhX4kGeqLPTyLBZshwviKp4YyeJd8bw2LyoDXsT5M6FDXv7pQEhR68tvv2YTdzR8+J
         Gh0RwYVNnDqHmn0Rib6pD14elREKLbBnJxC8w1k36gq2gAHHqD+cq6puVTrPyQuRNoVv
         v7/JzehJQ4duvGPJQDFuzY95cStPH/QQOh8x/xMeEsNqV/r/shAip25Pl+DGWuRQJ1dX
         m6EKEqaiv1Por4ODn2unnOywVC6Pnh/Em5uhndaXjPPAaCHp+xh+CR3w67P4ga3NpMXF
         dskYOMBH645Ef90CMhWH8T4Yg2FrEF20924DeU9gcZFKepRBEQxepMI3Muk/eQcXAAQk
         TJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/VWvCCeEVbMZdq9UF5aG+wVC8fHZ26437znnIuTzxNk=;
        b=rZRpnIN3J8J4NqmLUVzFbs6CA3wpuqrbUoSop6lrn+sRsvVm7b+UkcG0nSNcgT6ooa
         8npPFogZ6KC6h92HQq2oyqxiPFblPR2hzfn/hrnoMxeQU3zW44sJATIhsdgyxXxjZovk
         qnLbM6blYlFSYGZP/irC5DFCW4/Luz57m1P1fVPYqEKiN/SikmJFSz5NAxGnCtLdkBB9
         1B07MLlpivjv+rmfIrUYVbuweINtyj8HT4s1UBzUh7kb3Sg/GNGfTTm7HJeUEpk4F3NU
         XlUvo+a1gwPB+7IuuB3OG9u1KnYzDSm1yB/ycnRhJYWmoyzIu1SrW5H8hrPo9S+W3ZBG
         l6sg==
X-Gm-Message-State: AOAM53170jcACJV0Yp1BHVKqgn4q1RhODIoRTukh/X8/bdrn5Cbv0Fj4
        2s1/l9AV7IX50p6Fb9SO40ezzJOscY01Di4wjYU=
X-Google-Smtp-Source: ABdhPJz0uRzAQXChYGhq+4Phcs3KqURZNeS5zoMCy8d140AjuQF9k/Rue+Lw8/tFdmnc5sdl+9N7JBs2Ey+qJx1t8hQ=
X-Received: by 2002:a25:2f84:: with SMTP id v126mr14847319ybv.509.1604872880781;
 Sun, 08 Nov 2020 14:01:20 -0800 (PST)
MIME-Version: 1.0
References: <CAHOuc7N4gWZQmGaHdZ3oMt6S2PA-8JXTEabaybsH2bM9zHcBfA@mail.gmail.com>
 <alpine.DEB.2.23.453.2011020953550.16514@localhost> <CAHOuc7Ou_=rXSGCweVtN8QhMx8XaA9DPvBZBPHTe2SS05C0GsQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2011082203260.26301@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.23.453.2011082203260.26301@blackhole.kfki.hu>
From:   Oskar Berggren <oskar.berggren@gmail.com>
Date:   Sun, 8 Nov 2020 23:01:09 +0100
Message-ID: <CAHOuc7P+vHrPofOg9FHAUMhuDu=ewxgBp2h8TxmveNoZEayfkQ@mail.gmail.com>
Subject: Re: ipset 7.7 modules fail to build on kernel 4.19.152
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Den s=C3=B6n 8 nov. 2020 kl 22:27 skrev Jozsef Kadlecsik <kadlec@netfilter.=
org>:
>
> Hi Oskar,
>
> On Sun, 8 Nov 2020, Oskar Berggren wrote:
>
> > > > ip_set_core.c:90:40 macro list_for_each_entry_rcu passed 4 argument=
s
> > > > but takes just 3 ip_set_core.c:89:2 list_for_each_entry_rcu
> > > > undeclared
> > It fixes the problems listed for jhash.h, but unfortunately not for
> > ip_set_core.c.
>
> The backward compatibility for list_for_each_entry_rcu() with three args
> only was missing indeed, the patch below should fix it:

That took care of the problems in ip_set_core.c, now I got problems
with jhash.h again. Same problem, but different compile unit, and
despite having the additional include that you suggested.

WITHOUT including the compat layer the problem occurs here:
  CC [M]  /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/ip_set=
_core.o
In file included from
/usr/src/linux-headers-4.19.0-12-common/include/net/inet_sock.h:22,
                 from
/usr/src/linux-headers-4.19.0-12-common/include/net/inet_connection_sock.h:=
24,
                 from
/usr/src/linux-headers-4.19.0-12-common/include/linux/tcp.h:24,
                 from
/usr/src/linux-headers-4.19.0-12-common/include/linux/ipv6.h:87,
                 from
/home/oskar/Downloads/ipset-7.7/kernel/include/linux/netfilter/ipset/ip_set=
.h:11,
                 from
/home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/ip_set_core.c:23=
:
/home/oskar/Downloads/ipset-7.7/kernel/include/linux/jhash.h: In
function =E2=80=98jhash=E2=80=99:
/home/oskar/Downloads/ipset-7.7/kernel/include/linux/jhash.h:91:32:
error: =E2=80=98fallthrough=E2=80=99 undeclared (first use in this function=
)
  case 12: c +=3D (u32)k[11]<<24; fallthrough;
[...same on line 137...]


WITH the compat layer included (and the fix for
list_for_each_entry_rcu), the same error appears slightly later:
  CC [M]  /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/ip_set=
_core.o
  CC [M]  /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/ip_set=
_getport.o
  CC [M]  /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/pfxlen=
.o
In file included from
/usr/src/linux-headers-4.19.0-12-common/include/net/inet_sock.h:22,
                 from
/usr/src/linux-headers-4.19.0-12-common/include/net/inet_connection_sock.h:=
24,
                 from
/usr/src/linux-headers-4.19.0-12-common/include/linux/tcp.h:24,
                 from
/usr/src/linux-headers-4.19.0-12-common/include/net/tcp.h:24,
                 from
/home/oskar/Downloads/ipset-7.7/kernel/include/linux/netfilter/ipset/pfxlen=
.h:7,
                 from
/home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/pfxlen.c:4:
/home/oskar/Downloads/ipset-7.7/kernel/include/linux/jhash.h: In
function =E2=80=98jhash=E2=80=99:
/home/oskar/Downloads/ipset-7.7/kernel/include/linux/jhash.h:91:32:
error: =E2=80=98fallthrough=E2=80=99 undeclared (first use in this function=
)
  case 12: c +=3D (u32)k[11]<<24; fallthrough;
[...same on line 137...]

/Oskar
