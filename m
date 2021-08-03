Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E5FC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 06:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F3DE60E09
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 06:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbhHCGeX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 02:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbhHCGeW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 02:34:22 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44FAC061764
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Aug 2021 23:34:09 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so918857wms.2
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Aug 2021 23:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w6eRJWDc4oy8zddsasRGU8OUgJHyiOXoDPQTeQayYU8=;
        b=rQlAQ1qpJ5Qwev2cvmUA1uEZ0bgn8yy63WJrpy2D5RoewIsC4Tk77bIeqYTfxpiRrf
         nhwcEQFmOSuJF8j1J1n63VVrMRnU32NBtluySmSlAPigGoZ0PsYZYf8vFe1zr40aInc5
         YYoCG2Q4wFElUSjiv8CDO5/dBJGsbqfGpSf/K7UiJPYPtKw5XjcVSZDR+KcpjLgx5hNA
         m1CN0VdfpsLrRh7/ckVyaJOYem5PQZUgk03U2pq+/vdB3I+p9mYzfiJ9JrPeDnqUSc73
         N/kV3Ml40FdshplEAvoPovlOWLsP53wY7BFcp8ZkofKm1R8JpdOgrMXQ71JsuMlCnkg4
         viXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w6eRJWDc4oy8zddsasRGU8OUgJHyiOXoDPQTeQayYU8=;
        b=I61Zmvq0EKKMG/EScJuyxsLtSIOWyzsnmVpxbSSyGmR/U8QcNrN6MdgOXJJ+YzGJ8c
         WMelhkFv02uYPaS8zpPuyzdjtpIFfAw98fbxHYPvAEB61Vw8f0+1vepJX/yhMF9m6qZJ
         roNmYvSuoSZ2NhdX0h0nRLSfDv21gMjGBLiOn8dHnHad1rHAcTzpBQJP8w9RRbiUlbMs
         nmsD3QUsXk8PZbnJjJqyvyRtrCfW3EpJtY+G+BA/TM/UWbxJj2Wn0mFqBssnSl2CY2Y4
         IzdERLxEa8KUg/j6e4RVUwzVJxeDKPO1J2IqFhk69TDjaM5TxzXQftdOtJHY9qdzr3i2
         KLcw==
X-Gm-Message-State: AOAM533HutjMQXPz6G9GUfEixFLwJm2WFcq/TcDo6t35JJFEyCwe+ifb
        Cl3/U4RFj5FOh+69T7TD06dO9xurju59irtNdPg=
X-Google-Smtp-Source: ABdhPJzh3aw7EMlmCAXFECzhEhZlYs5Ga1R2lJ5GGlLz8FDPp2Swz32KJFhqZE0wooOm4btt3nOHu6J/0fjnkgygZEg=
X-Received: by 2002:a1c:e90f:: with SMTP id q15mr2471260wmc.175.1627972448334;
 Mon, 02 Aug 2021 23:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPirA-gNiYRCoQR6-2fP80ESvvXKu7f0bVPT80FFxua6=g@mail.gmail.com>
 <17a7e7ed-f324-2a94-5f82-18c3850de6a@netfilter.org> <CAA5aLPgQj8wEbawg8u=UqJedTPWCdK5WiizwCpNxMp7Vg=-JgA@mail.gmail.com>
 <e38ddbe-a47-efb1-e56f-457f5e426b18@netfilter.org> <CAA5aLPgowRWm7JZm02LCGeOPz4E_dO+8FCCag+8aO4HDeLUQFQ@mail.gmail.com>
 <CAA5aLPjqFgeDkOjXed=XOHksDZNmQw9EPSkx3pwASKFQ6oioiw@mail.gmail.com> <3556be79-66a2-9b12-7b7f-658a618690a8@netfilter.org>
In-Reply-To: <3556be79-66a2-9b12-7b7f-658a618690a8@netfilter.org>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Tue, 3 Aug 2021 12:03:56 +0530
Message-ID: <CAA5aLPiO3CQxRwzhEU3tzG5xuLfqgnHN=7evixin68vEf2kH4w@mail.gmail.com>
Subject: Re: Nf_nat_h323 module not working with Panasonic VCs
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

My kernel is 4.4.82. It may be demotivating, I know.

However, the logs shared by me, though very less, still shows clearly
that for Panasonic VC packets the module isn't treating this as a q931
packet (or cs:connect of h.225) and hence not processed.

As far as output of the command is concerned, there is no .c file with
that name.

when I try to find files having 323 in the name in /usr/src path using
following command

        find . -name *323*

Following is the output:
./kernels/4.4.82-1.el7.elrepo.x86_64/include/linux/netfilter/nf_conntrack_h323.h
./kernels/4.4.82-1.el7.elrepo.x86_64/include/linux/netfilter/nf_conntrack_h323_types.h
./kernels/4.4.82-1.el7.elrepo.x86_64/include/linux/netfilter/nf_conntrack_h323_asn1.h
./kernels/4.4.82-1.el7.elrepo.x86_64/include/linux/i2c/lm8323.h
./kernels/4.4.82-1.el7.elrepo.x86_64/include/config/rtc/drv/ds3234.h
./kernels/4.4.82-1.el7.elrepo.x86_64/include/config/rtc/drv/ds3232.h
./kernels/4.4.82-1.el7.elrepo.x86_64/include/config/nf/conntrack/h323.h
./kernels/4.4.82-1.el7.elrepo.x86_64/include/config/nf/nat/h323.h
./kernels/4.4.82-1.el7.elrepo.x86_64/include/config/cm3232.h


On Mon, Aug 2, 2021 at 11:50 PM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>
> Hi Akshat,
>
> On Mon, 2 Aug 2021, Akshat Kakkar wrote:
>
> > > For the VC which is working (i.e. VC2, IP:172.16.1.120) following are
> > > the generated debug log:
>
> That can't be the full debug log, lines are missing/left out. What is the
> kernel version? Isn't there any output from the command
>
> $ grep 'pr_debug("nf_ct_q931' net/netfilter/nf_conntrack_h323_main.c
>
> > > [Jul27 17:29] nf_nat_q931: expect H.245 172.16.1.100:0->172.16.1.120:5516
> > > [  +0.249944] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
> > > [  +0.000021] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
> > > [  +0.003265] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
> > > [  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
> > > [  +0.007606] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
> > > [  +0.000012] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
> > > [  +0.000010] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
> > > [  +0.000004] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
> > > [  +0.004337] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
> > > [  +0.000010] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
> > > [  +0.000007] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
> > > [  +0.000007] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
> > > [  +0.006028] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
> > > [  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
> > > [  +0.001171] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
> > > [  +0.000008] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
> > > [  +0.000006] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
> > > [  +0.000003] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
> > > [  +0.003261] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
> > > [  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
> > > [  +0.000006] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
> > > [  +0.000003] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
> > > [  +0.007889] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
> > > [  +0.000012] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
> > >
> > > However, for the panasonic VC1 i.e. the VC which is having issue,
> > > there are no debug log generated. absolutely nothing.
>
> Best regards,
> Jozsef
>
> > > On Mon, Jul 26, 2021 at 1:13 PM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > >
> > > > On Mon, 26 Jul 2021, Akshat Kakkar wrote:
> > > >
> > > > > MCU is using IP only to dial to VC1 and not hostname.
> > > > >
> > > > > I went through packet capture and find everything in line with the
> > > > > standard. Just that it is sending "CS : Call Proceeding" packet which
> > > > > is an optional packet but it is part of standard.
> > > > > I can share pcap file if needed.
> > > >
> > > > Could you enable dynamic debugging in the kernel and enable it for the
> > > > nf_conntrack_h323 module? Then please repeate the testing with the
> > > > working and not working VCs and send the generated kernel debug log
> > > > messages.
> > > >
> > > > Best regards,
> > > > Jozsef
> > > > > On Mon, Jul 26, 2021 at 2:11 AM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > On Sat, 24 Jul 2021, Akshat Kakkar wrote:
> > > > > >
> > > > > > > I have 2 vc endpoints VC1 (Make:Panasonic, IP:10.1.1.11),
> > > > > > > VC2(make:Polycom,IP: 10.1.1.12) and 1 MCU (172.16.1.100).
> > > > > > >
> > > > > > > There is a Linux firewall between VCs and MCU.
> > > > > > >
> > > > > > > There is one to one nat configured for these 2 VCs (10.1.1.11  <-->
> > > > > > > 172.16.1.110, 10.1.1.12  <--> 172.16.1.120)
> > > > > > > There is no natting for MCU IP as it is routable.
> > > > > > >
> > > > > > > nf_nat_h323 and nf_conntrack_h323 module is enabled in the firewall.
> > > > > > >
> > > > > > > When VC1 and VC2 initiate call to MCU, everything works fine. Video
> > > > > > > call is successful for both VC1 and VC2. h245 IP address for tcp in
> > > > > > > h225: CS connect packet is correctly replaced by the natted IP.
> > > > > > >
> > > > > > > However, when there is a dial out from MCU to VCs (i.e. MCU initiate
> > > > > > > call to the natted IP (i.e. 172.16.1.110 and 172.16.1.120 of VCs),
> > > > > > > natting works fine but h245 IP address for tcp in h225:CS is replaced
> > > > > > > correctly only for VC2 and not for VC1. For VC1, it is still its
> > > > > > > actual IP (i.e. 10.1.1.12 and not 172.16.1.120).
> > > > > > >
> > > > > > > Because of this, video call is successful only with VC2 and not with
> > > > > > > VC1, when initiated from MCU. I tried with another panasonic VC
> > > > > > > hardware, there was no change.
> > > > > > >
> > > > > > > Further packet dump analysis showed that for VC1, there are 3 h225
> > > > > > > packets (setup, call proceeding and alert) before Connect message but
> > > > > > > for VC2 there are only 2 h225 packets (setup and alert) before connect
> > > > > > > message.
> > > > > > >
> > > > > > > Is there a bug in nf_nat_h323 module or am I missing something?
> > > > > >
> > > > > > It can be a bug/incompatibility with the H.323 implementation in the
> > > > > > Panasonic device. However, first I'd make sure the MCU does not use
> > > > > > hostname for VC1 instead of its IP address. Hostnames in the calls are not
> > > > > > supported.
> > > > > >
> > > > > > Best regards,
> > > > > > Jozsef
> > > > > > -
> > > > > > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > > > > > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > > > > > Address : Wigner Research Centre for Physics
> > > > > >           H-1525 Budapest 114, POB. 49, Hungary
> > > > >
> > > >
> > > > -
> > > > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > > > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > > > Address : Wigner Research Centre for Physics
> > > >           H-1525 Budapest 114, POB. 49, Hungary
> >
>
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary
