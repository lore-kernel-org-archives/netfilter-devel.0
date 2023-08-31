Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07F3C83F37
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 21:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbjHaVa3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 17:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbjHaVa3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 17:30:29 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E8AB8
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 14:30:25 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id a1e0cc1a2514c-78a5384a5daso490845241.0
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 14:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693517425; x=1694122225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mDKMZNcgrOBvXUIw6JM96uGXU4DFGYixOh67YQFtGjw=;
        b=KKWgCOxPL42g38ar3W15ci4AzgDrAGl2fddB902eKZvfI+Z1F84vw977c/arlVE+JX
         PQIApy0qkTo15s1WIt3cZy+w17vr4EA2pkk43G9Q+v4aI+mG8NfNhmTn2TCYYAHWWQgq
         IXSCClp4kJTN84FGumxrko56xt7g7DYBaMyXwwd7DrjUaD+gpcnnMRnCo7h+glGU8PIv
         q+R2DCIhrzL1tIygz4yIiat95q9ofbzDQC9KTUzwS1lP+E//rSLwCSP0SDNusn0SozOE
         NVNEnLk+X4WdQ1PtDHZKdaz/ujObfm8RtEI4uA4NJjpauw3qs0rS/7vBDoRMDxvzN4WN
         rKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693517425; x=1694122225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mDKMZNcgrOBvXUIw6JM96uGXU4DFGYixOh67YQFtGjw=;
        b=WY4KoB0WoKCnMGmGqPXef7zgeknTPIXHXJBAdXB3sYBWVZ2a3W1sU2Cs4KFnnQQIy1
         fGKg0XVYymyM0kMJdAlpX5BCJaWvW6N+v/ccuJMWiMpoG9lJdWnYGvv1IoUEQ+Bk6n09
         kBmaSFfJyp7BY+gJ7tI5oqiJnLuX6s9AyVCzBVfd6q9omH7IVJr9hofVVVomiZ+5Twt6
         EaHeIXGvFRpQALxheQbsgd3vu5J5/Kjat8SCFmsIudQt55ReqkJqQ4GwpllPTrYbl72a
         eWJrI/FvSuT8xN41Jq4z/kgNTeAcmQuRz3P55J14CH6fweM1/iolBSt5hXIeNg8NjW7L
         CSzg==
X-Gm-Message-State: AOJu0Yw8pvYDRRMdI+GVXFjvFGqxKlaBMr8KKAE/bbnj755X7bARpasz
        5BRpErhbBwhrPwX4STPFIuzJbIbOgWCjwhuHWuc=
X-Google-Smtp-Source: AGHT+IGXHj+Vi/6U9zr01FSdulvFIoBmrkoii8IqlfxanNesy788wwQBj3p4kxzjW0peudu91oThgm3Fqhbi6+qmY30=
X-Received: by 2002:a67:e3b7:0:b0:44d:3d2c:2a1a with SMTP id
 j23-20020a67e3b7000000b0044d3d2c2a1amr825799vsm.9.1693517424646; Thu, 31 Aug
 2023 14:30:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZsLFsThq4jz1gx0UZj5ab+6SUbhPxy+gsM1d7o2S49LdA@mail.gmail.com>
 <86o37onn-8431-noor-1p0p-8764n0855n74@vanv.qr> <CAA85sZvuN5f4Lf3VxOe1Dj9-gq=gD9z4_DwPN_CedJiNeviNsg@mail.gmail.com>
 <47p877oo-o3q5-55q4-03s4-110290n2oq70@vanv.qr> <CAA85sZsQtX_D3_FsRe9QteCRvyX177zdaHFeAkP9o+9KDquRQw@mail.gmail.com>
In-Reply-To: <CAA85sZsQtX_D3_FsRe9QteCRvyX177zdaHFeAkP9o+9KDquRQw@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Thu, 31 Aug 2023 23:30:12 +0200
Message-ID: <CAA85sZsdp1Ep7XBFo7annr2hQ1GE8M5bi1CPOJuf8QJ+B4D+JQ@mail.gmail.com>
Subject: Re: MASQ leak?
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some of the packets that was routed instead of masqued:
00:21:25.721875 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 45804, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.213.42938 > 35.224.170.84.80: Flags [F.], cksum 0x6a63
(correct), seq 3548801895, ack 3655548521, win 501, options
[nop,nop,TS val 1914199063 ecr 1522403623], length 0
00:21:26.268459 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 45805, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.213.42938 > 35.224.170.84.80: Flags [F.], cksum 0x6823
(correct), seq 0, ack 1, win 501, options [nop,nop,TS val 1914199639
ecr 1522403623], length 0
00:21:27.421368 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 45806, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.213.42938 > 35.224.170.84.80: Flags [F.], cksum 0x63a3
(correct), seq 0, ack 1, win 501, options [nop,nop,TS val 1914200791
ecr 1522403623], length 0
00:21:29.693301 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 45807, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.213.42938 > 35.224.170.84.80: Flags [F.], cksum 0x5ac3
(correct), seq 0, ack 1, win 501, options [nop,nop,TS val 1914203063
ecr 1522403623], length 0
00:21:34.302634 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 45808, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.213.42938 > 35.224.170.84.80: Flags [F.], cksum 0x48bf
(correct), seq 0, ack 1, win 501, options [nop,nop,TS val 1914207675
ecr 1522403623], length 0
00:21:38.272384 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 42256, offset 0, flags
[none], proto TCP (6), length 52)
    10.0.0.26.61981 > 142.250.74.99.80: Flags [F.], cksum 0xed07
(correct), seq 0, ack 1, win 4096, options [nop,nop,TS val 96358724
ecr 2670615284], length 0
00:21:43.517286 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 45809, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.213.42938 > 35.224.170.84.80: Flags [F.], cksum 0x24c3
(correct), seq 0, ack 1, win 501, options [nop,nop,TS val 1914216887
ecr 1522403623], length 0
00:22:01.947697 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 45810, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.213.42938 > 35.224.170.84.80: Flags [F.], cksum 0xdcc2
(correct), seq 0, ack 1, win 501, options [nop,nop,TS val 1914235319
ecr 1522403623], length 0
00:22:38.811738 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 45811, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.213.42938 > 35.224.170.84.80: Flags [F.], cksum 0x4cc2
(correct), seq 0, ack 1, win 501, options [nop,nop,TS val 1914272183
ecr 1522403623], length 0
00:23:43.034245 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 32008, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.57832 > 142.250.74.132.443: Flags [F.], cksum 0x492f
(correct), seq 3484918907, ack 446014897, win 291, options [nop,nop,TS
val 1179797395 ecr 3393378316], length 0
00:23:43.202140 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 32009, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.57832 > 142.250.74.132.443: Flags [F.], cksum 0x4852
(correct), seq 0, ack 1, win 291, options [nop,nop,TS val 1179797616
ecr 3393378316], length 0
00:23:43.425577 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 32010, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.57832 > 142.250.74.132.443: Flags [F.], cksum 0x4772
(correct), seq 0, ack 1, win 291, options [nop,nop,TS val 1179797840
ecr 3393378316], length 0
00:23:43.897195 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 32011, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.57832 > 142.250.74.132.443: Flags [F.], cksum 0x459a
(correct), seq 0, ack 1, win 291, options [nop,nop,TS val 1179798312
ecr 3393378316], length 0
00:23:44.799626 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 32012, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.57832 > 142.250.74.132.443: Flags [F.], cksum 0x421a
(correct), seq 0, ack 1, win 291, options [nop,nop,TS val 1179799208
ecr 3393378316], length 0
00:23:46.641107 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 32013, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.57832 > 142.250.74.132.443: Flags [F.], cksum 0x3b1a
(correct), seq 0, ack 1, win 291, options [nop,nop,TS val 1179801000
ecr 3393378316], length 0
00:23:50.327206 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 32014, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.57832 > 142.250.74.132.443: Flags [F.], cksum 0x2cba
(correct), seq 0, ack 1, win 291, options [nop,nop,TS val 1179804680
ecr 3393378316], length 0
00:23:57.495718 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 32015, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.57832 > 142.250.74.132.443: Flags [F.], cksum 0x10ba
(correct), seq 0, ack 1, win 291, options [nop,nop,TS val 1179811848
ecr 3393378316], length 0
00:24:52.551099 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 32016, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.57832 > 142.250.74.132.443: Flags [F.], cksum 0xd8b9
(correct), seq 0, ack 1, win 291, options [nop,nop,TS val 1179826184
ecr 3393378316], length 0
00:25:55.448896 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 653, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.46524 > 35.244.164.0.443: Flags [F.], cksum 0x8297
(correct), seq 1286551392, ack 3788831873, win 360, options
[nop,nop,TS val 1121640525 ecr 756790798], length 0
00:25:57.751375 0c:c4:7a:fa:3d:4c > e0:ac:f1:12:c1:6a, ethertype IPv4
(0x0800), length 66: (tos 0x0, ttl 63, id 32017, offset 0, flags [DF],
proto TCP (6), length 52)
    10.0.0.153.57832 > 142.250.74.132.443: Flags [F.], cksum 0x62b9
(correct), seq 0, ack 1, win 291, options [nop,nop,TS val 1179856392
ecr 3393378316], length 0

On Thu, Aug 31, 2023 at 12:46=E2=80=AFPM Ian Kumlien <ian.kumlien@gmail.com=
> wrote:
>
> On Thu, Aug 31, 2023 at 11:53=E2=80=AFAM Jan Engelhardt <jengelh@inai.de>=
 wrote:
> > On Thursday 2023-08-31 11:40, Ian Kumlien wrote:
> > >> >               type filter hook forward priority 0
> > >> >                ct state invalid counter drop # <- this one
> > >> >
> > >> >It just seems odd to me that traffic can go through without being N=
AT:ed
> > >>
> > >> MASQ requires connection tracking; if tracking is disabled for a con=
nection,
> > >> addresses cannot be changed.
> > >
> > >I don't disable connection tracking - this is most likely a expired
> > >session that is reused and IMHO it should just be added
> >
> > "invalid" is not just invalid but also untracked (or untrackable)
> > CTs, and icmpv6-NDISC is not tracked for example (icmpv6-PING is).
>
> This was normal udp and tcp traffic...
>
> > Expired (forgotten) CTs are automatically recreated in the middle by de=
fault,
> > one needs extra rules to change the behavior (e.g. `tcp syn` test when
> > ctstate=3D=3DNEW).
>
> I can do more debugging about the traffic that goes haywire, I have
> all the logs at home.
>
> But with:
> nf_conntrack_tcp_loose - BOOLEAN
> 0 - disabled
> not 0 - enabled (default)
>
> If it is set to zero, we disable picking up already established
> connections.
>
> Which is the default value:
> cat /proc/sys/net/netfilter/nf_conntrack_tcp_loose
> 1
>
> IMHO iI shouldn't have to fudge things to make conntrack pick things up a=
gain.
