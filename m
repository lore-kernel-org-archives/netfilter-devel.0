Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068E7C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 08:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D488D600D1
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 08:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhHCIFO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 04:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbhHCIFM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 04:05:12 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51715C06175F
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Aug 2021 01:05:01 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z4so24313212wrv.11
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Aug 2021 01:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qMg/3UKVNJoAri4LrYKICxmIQUm6/E3qVDmA568yiYY=;
        b=Ttg3ahHAjQVPuTksSM3vrIXg693msc++kN1G3N7kA5C7UZrm9p85GoZXOpUZZnV9FR
         RRHkB7EoWzCD9nl03ylfM4N+h6FBXlmNRW4GoHOmOUvHQ2RY/ssVcV5l6/ZX7vWhjAWF
         fpIiJZQ/njc6ARK9LuCbspFrJQVXgkeXZp4Jd6JUqX4a+3oc+4qRdaCZ7w6vIWxUVSya
         n6cCjz6+iFqq7t6W7UARn4zYQefhO7DhdjD/JASsaLQWbOWli8PRk+dzgVnbOxMhkVHi
         VJhfoL1WXMfK4eDs36jvLBGeM5HCtIrreIGsS+kZHGn624Eh8S/LrEgY7NV7ZNIBZbxR
         c89w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qMg/3UKVNJoAri4LrYKICxmIQUm6/E3qVDmA568yiYY=;
        b=psECmTCDQv5x6mL5hcwOfBbN8zZ0Pe4VmhnPiUa3G7LNMuj9xU74PBXgkWK7fVImAD
         lnTiLJC2Ifj4oDQ9sAzRl+FKO+rdY1BtNDD5fnnCafh2XQegG+eQ14/JvLMRHURk1sje
         A+mYJprNOyrG0ZAgjHnzcGbWR6C8NvK4JgAF7SKY8f9bONw3g0x3+kJQIGxmKLnXWwm7
         T8/Yrs0yuUpTa7d5NKqrft9SACSgbeKy5d+BVnckBBeUUGlQRdjyG4cvNWgTlIahF/Ts
         1kFr5dFUOg62qm+iOooBPbDXC0cb93sqYTO3blnfBfEAx/FJYDqNitMkIczJGKdkeRVO
         qmKg==
X-Gm-Message-State: AOAM530u5tIuGkAqD3jD0HbfER5NrkcJ+mfZxEPMOW3DNCfwzcne7KEe
        wahsDbni60sgAUT8o3xk4fCaLawz80BKBUTCeWI=
X-Google-Smtp-Source: ABdhPJwsHL5XPaQjY3pACvNpdXrlJ61oCddBOahCAoLeTxdwUoct9lxDNZ6+jVFHf+FdEZgQCJhM7Fce7kr7HQjUl0k=
X-Received: by 2002:a05:6000:1149:: with SMTP id d9mr22292457wrx.26.1627977899888;
 Tue, 03 Aug 2021 01:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPirA-gNiYRCoQR6-2fP80ESvvXKu7f0bVPT80FFxua6=g@mail.gmail.com>
 <17a7e7ed-f324-2a94-5f82-18c3850de6a@netfilter.org> <CAA5aLPgQj8wEbawg8u=UqJedTPWCdK5WiizwCpNxMp7Vg=-JgA@mail.gmail.com>
 <e38ddbe-a47-efb1-e56f-457f5e426b18@netfilter.org> <CAA5aLPgowRWm7JZm02LCGeOPz4E_dO+8FCCag+8aO4HDeLUQFQ@mail.gmail.com>
 <CAA5aLPjqFgeDkOjXed=XOHksDZNmQw9EPSkx3pwASKFQ6oioiw@mail.gmail.com>
 <3556be79-66a2-9b12-7b7f-658a618690a8@netfilter.org> <CAA5aLPiO3CQxRwzhEU3tzG5xuLfqgnHN=7evixin68vEf2kH4w@mail.gmail.com>
 <6f7b4b8-fafb-d54f-6d58-70613b71908d@netfilter.org>
In-Reply-To: <6f7b4b8-fafb-d54f-6d58-70613b71908d@netfilter.org>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Tue, 3 Aug 2021 13:34:48 +0530
Message-ID: <CAA5aLPhuyt1qni+gQWi-avk9pA82MR2Xo6_z62vKckJHG-h_xg@mail.gmail.com>
Subject: Re: Nf_nat_h323 module not working with Panasonic VCs
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For me also its same. only header files.

On Tue, Aug 3, 2021 at 1:33 PM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>
> On Tue, 3 Aug 2021, Akshat Kakkar wrote:
>
> > My kernel is 4.4.82. It may be demotivating, I know.
> >
> > However, the logs shared by me, though very less, still shows clearly
> > that for Panasonic VC packets the module isn't treating this as a q931
> > packet (or cs:connect of h.225) and hence not processed.
> >
> > As far as output of the command is concerned, there is no .c file with
> > that name.
>
> Then do you have the full source code of the running kernel? Or do you
> have only the header files? At the moment I have got an 4.4.244 kernel
> tree and it does contain net/netfilter/nf_conntrack_h323_main.c.
>
> Best regards,
> Jozsef
>
> > when I try to find files having 323 in the name in /usr/src path using
> > following command
> >
> >         find . -name *323*
> >
> > Following is the output:
> > ./kernels/4.4.82-1.el7.elrepo.x86_64/include/linux/netfilter/nf_conntrack_h323.h
> > ./kernels/4.4.82-1.el7.elrepo.x86_64/include/linux/netfilter/nf_conntrack_h323_types.h
> > ./kernels/4.4.82-1.el7.elrepo.x86_64/include/linux/netfilter/nf_conntrack_h323_asn1.h
> > ./kernels/4.4.82-1.el7.elrepo.x86_64/include/linux/i2c/lm8323.h
> > ./kernels/4.4.82-1.el7.elrepo.x86_64/include/config/rtc/drv/ds3234.h
> > ./kernels/4.4.82-1.el7.elrepo.x86_64/include/config/rtc/drv/ds3232.h
> > ./kernels/4.4.82-1.el7.elrepo.x86_64/include/config/nf/conntrack/h323.h
> > ./kernels/4.4.82-1.el7.elrepo.x86_64/include/config/nf/nat/h323.h
> > ./kernels/4.4.82-1.el7.elrepo.x86_64/include/config/cm3232.h
> >
> >
> > On Mon, Aug 2, 2021 at 11:50 PM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > >
> > > Hi Akshat,
> > >
> > > On Mon, 2 Aug 2021, Akshat Kakkar wrote:
> > >
> > > > > For the VC which is working (i.e. VC2, IP:172.16.1.120) following are
> > > > > the generated debug log:
> > >
> > > That can't be the full debug log, lines are missing/left out. What is the
> > > kernel version? Isn't there any output from the command
> > >
> > > $ grep 'pr_debug("nf_ct_q931' net/netfilter/nf_conntrack_h323_main.c
> > >
> > > > > [Jul27 17:29] nf_nat_q931: expect H.245 172.16.1.100:0->172.16.1.120:5516
> > > > > [  +0.249944] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
> > > > > [  +0.000021] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
> > > > > [  +0.003265] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
> > > > > [  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
> > > > > [  +0.007606] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
> > > > > [  +0.000012] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
> > > > > [  +0.000010] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
> > > > > [  +0.000004] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
> > > > > [  +0.004337] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
> > > > > [  +0.000010] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
> > > > > [  +0.000007] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
> > > > > [  +0.000007] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
> > > > > [  +0.006028] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
> > > > > [  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
> > > > > [  +0.001171] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
> > > > > [  +0.000008] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
> > > > > [  +0.000006] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
> > > > > [  +0.000003] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
> > > > > [  +0.003261] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
> > > > > [  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
> > > > > [  +0.000006] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
> > > > > [  +0.000003] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
> > > > > [  +0.007889] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
> > > > > [  +0.000012] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
> > > > >
> > > > > However, for the panasonic VC1 i.e. the VC which is having issue,
> > > > > there are no debug log generated. absolutely nothing.
> > >
> > > Best regards,
> > > Jozsef
> > >
> > > > > On Mon, Jul 26, 2021 at 1:13 PM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > > > >
> > > > > > On Mon, 26 Jul 2021, Akshat Kakkar wrote:
> > > > > >
> > > > > > > MCU is using IP only to dial to VC1 and not hostname.
> > > > > > >
> > > > > > > I went through packet capture and find everything in line with the
> > > > > > > standard. Just that it is sending "CS : Call Proceeding" packet which
> > > > > > > is an optional packet but it is part of standard.
> > > > > > > I can share pcap file if needed.
> > > > > >
> > > > > > Could you enable dynamic debugging in the kernel and enable it for the
> > > > > > nf_conntrack_h323 module? Then please repeate the testing with the
> > > > > > working and not working VCs and send the generated kernel debug log
> > > > > > messages.
> > > > > >
> > > > > > Best regards,
> > > > > > Jozsef
> > > > > > > On Mon, Jul 26, 2021 at 2:11 AM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > > > > > >
> > > > > > > > Hello,
> > > > > > > >
> > > > > > > > On Sat, 24 Jul 2021, Akshat Kakkar wrote:
> > > > > > > >
> > > > > > > > > I have 2 vc endpoints VC1 (Make:Panasonic, IP:10.1.1.11),
> > > > > > > > > VC2(make:Polycom,IP: 10.1.1.12) and 1 MCU (172.16.1.100).
> > > > > > > > >
> > > > > > > > > There is a Linux firewall between VCs and MCU.
> > > > > > > > >
> > > > > > > > > There is one to one nat configured for these 2 VCs (10.1.1.11  <-->
> > > > > > > > > 172.16.1.110, 10.1.1.12  <--> 172.16.1.120)
> > > > > > > > > There is no natting for MCU IP as it is routable.
> > > > > > > > >
> > > > > > > > > nf_nat_h323 and nf_conntrack_h323 module is enabled in the firewall.
> > > > > > > > >
> > > > > > > > > When VC1 and VC2 initiate call to MCU, everything works fine. Video
> > > > > > > > > call is successful for both VC1 and VC2. h245 IP address for tcp in
> > > > > > > > > h225: CS connect packet is correctly replaced by the natted IP.
> > > > > > > > >
> > > > > > > > > However, when there is a dial out from MCU to VCs (i.e. MCU initiate
> > > > > > > > > call to the natted IP (i.e. 172.16.1.110 and 172.16.1.120 of VCs),
> > > > > > > > > natting works fine but h245 IP address for tcp in h225:CS is replaced
> > > > > > > > > correctly only for VC2 and not for VC1. For VC1, it is still its
> > > > > > > > > actual IP (i.e. 10.1.1.12 and not 172.16.1.120).
> > > > > > > > >
> > > > > > > > > Because of this, video call is successful only with VC2 and not with
> > > > > > > > > VC1, when initiated from MCU. I tried with another panasonic VC
> > > > > > > > > hardware, there was no change.
> > > > > > > > >
> > > > > > > > > Further packet dump analysis showed that for VC1, there are 3 h225
> > > > > > > > > packets (setup, call proceeding and alert) before Connect message but
> > > > > > > > > for VC2 there are only 2 h225 packets (setup and alert) before connect
> > > > > > > > > message.
> > > > > > > > >
> > > > > > > > > Is there a bug in nf_nat_h323 module or am I missing something?
> > > > > > > >
> > > > > > > > It can be a bug/incompatibility with the H.323 implementation in the
> > > > > > > > Panasonic device. However, first I'd make sure the MCU does not use
> > > > > > > > hostname for VC1 instead of its IP address. Hostnames in the calls are not
> > > > > > > > supported.
> > > > > > > >
> > > > > > > > Best regards,
> > > > > > > > Jozsef
> > > > > > > > -
> > > > > > > > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > > > > > > > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > > > > > > > Address : Wigner Research Centre for Physics
> > > > > > > >           H-1525 Budapest 114, POB. 49, Hungary
> > > > > > >
> > > > > >
> > > > > > -
> > > > > > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > > > > > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > > > > > Address : Wigner Research Centre for Physics
> > > > > >           H-1525 Budapest 114, POB. 49, Hungary
> > > >
> > >
> > > -
> > > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > > Address : Wigner Research Centre for Physics
> > >           H-1525 Budapest 114, POB. 49, Hungary
> >
>
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary
