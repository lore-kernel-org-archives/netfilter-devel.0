Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1121C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 08:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BADBD60F36
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 08:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhHBImc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhHBImc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 04:42:32 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E38C0613D5
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Aug 2021 01:42:21 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m12so15717292wru.12
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Aug 2021 01:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vr8iPPiu2PoX5b0moJyvVm3isZsmHsKoO+m+7Db4rJU=;
        b=k5rUR6xDTW/kk8UCFpCgtih8yQMR8JEWYkUp7f2JjLV7xb9F+m9YlnZXEHwHTmAKnX
         bjoDolE3h0ELHoId8nB46zT5aXK/VYVeY3loWC0b8tBHiVyu6zBmc9ip5pthzHMYK8UI
         vfU6P+EKzu+IZ+51xbexdcHA8V4+I2bGvnH/QdqRO263A4eZ9S5RIYPHeAw9WSzKtWgI
         T2/UY94Cu8l0bkRlsBTpSfyxbzkQ6foKP3OgHQ0rTiyFzAd38qyRExVw8E7gS2FLBgve
         cKrg4lT+VP6oESuerZGYq6NgDHZBAZX9Jiijy30kIT4hwBtpphFaaZX1/coRhgV4ua/m
         fN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vr8iPPiu2PoX5b0moJyvVm3isZsmHsKoO+m+7Db4rJU=;
        b=W73ix22epTQqCquRzgmJ0pfsQRQEdTuMIMNe6NkuPeo+EkxL1PIGHmbOctS/o1kS3m
         V9Vm3uOGuwyacvkLCL0XDK6aVRrjPVEoyZFLIiRmGS4LFr2jRj1QnpaNcAuEUk8xLZiY
         mwJOjHkSdhAIXbbMj5qkD9QxCNT5Mv2KFWNDJOPqYWaiW8rG/4d1ocPLgEd9V6v/+KZs
         0wd5mk8y2v/wRzwZDxVheaLWe6yfmT6b5Y6Ab+vHFCaLJrTzZIEl7sGKeQlIdZAwztw3
         KalZ6pBf8q8MAH07O06vitJ+vWG2fPoPYFiOqso1SGXI0Hz/imh4d/LhRu0wKzX38iWD
         GQGQ==
X-Gm-Message-State: AOAM53315LmL0wzPUnXKbJBjHir3IyGvzit4qOMUt7eGxlHoGVrPdAfN
        2nQDmu0aDQbMZXSWnBmjtFraM2PQ9vSOP0HVpgM=
X-Google-Smtp-Source: ABdhPJxUa7yz2AMV/UjsMQfS1AiYPjse1gq2DkwAMh1H/gfOizmIN3h7J1Zb9RdSncsI9BFXkkfqKJHxbQ7CFSpehPg=
X-Received: by 2002:a05:6000:10d0:: with SMTP id b16mr16537609wrx.332.1627893740546;
 Mon, 02 Aug 2021 01:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPirA-gNiYRCoQR6-2fP80ESvvXKu7f0bVPT80FFxua6=g@mail.gmail.com>
 <17a7e7ed-f324-2a94-5f82-18c3850de6a@netfilter.org> <CAA5aLPgQj8wEbawg8u=UqJedTPWCdK5WiizwCpNxMp7Vg=-JgA@mail.gmail.com>
 <e38ddbe-a47-efb1-e56f-457f5e426b18@netfilter.org> <CAA5aLPgowRWm7JZm02LCGeOPz4E_dO+8FCCag+8aO4HDeLUQFQ@mail.gmail.com>
In-Reply-To: <CAA5aLPgowRWm7JZm02LCGeOPz4E_dO+8FCCag+8aO4HDeLUQFQ@mail.gmail.com>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Mon, 2 Aug 2021 14:12:09 +0530
Message-ID: <CAA5aLPjqFgeDkOjXed=XOHksDZNmQw9EPSkx3pwASKFQ6oioiw@mail.gmail.com>
Subject: Re: Nf_nat_h323 module not working with Panasonic VCs
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

Any idea how to go about?

On Tue, Jul 27, 2021 at 7:02 PM Akshat Kakkar <akshat.1984@gmail.com> wrote:
>
> Hi Jozsef,
>
> For the VC which is working (i.e. VC2, IP:172.16.1.120) following are
> the generated debug log:
>
> [Jul27 17:29] nf_nat_q931: expect H.245 172.16.1.100:0->172.16.1.120:5516
> [  +0.249944] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
> [  +0.000021] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
> [  +0.003265] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
> [  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
> [  +0.007606] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
> [  +0.000012] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
> [  +0.000010] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
> [  +0.000004] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
> [  +0.004337] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
> [  +0.000010] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
> [  +0.000007] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
> [  +0.000007] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
> [  +0.006028] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
> [  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
> [  +0.001171] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
> [  +0.000008] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
> [  +0.000006] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
> [  +0.000003] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
> [  +0.003261] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
> [  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
> [  +0.000006] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
> [  +0.000003] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
> [  +0.007889] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
> [  +0.000012] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
>
>
> However, for the panasonic VC1 i.e. the VC which is having issue,
> there are no debug log generated. absolutely nothing.
>
> On Mon, Jul 26, 2021 at 1:13 PM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> >
> > On Mon, 26 Jul 2021, Akshat Kakkar wrote:
> >
> > > MCU is using IP only to dial to VC1 and not hostname.
> > >
> > > I went through packet capture and find everything in line with the
> > > standard. Just that it is sending "CS : Call Proceeding" packet which
> > > is an optional packet but it is part of standard.
> > > I can share pcap file if needed.
> >
> > Could you enable dynamic debugging in the kernel and enable it for the
> > nf_conntrack_h323 module? Then please repeate the testing with the
> > working and not working VCs and send the generated kernel debug log
> > messages.
> >
> > Best regards,
> > Jozsef
> > > On Mon, Jul 26, 2021 at 2:11 AM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > >
> > > > Hello,
> > > >
> > > > On Sat, 24 Jul 2021, Akshat Kakkar wrote:
> > > >
> > > > > I have 2 vc endpoints VC1 (Make:Panasonic, IP:10.1.1.11),
> > > > > VC2(make:Polycom,IP: 10.1.1.12) and 1 MCU (172.16.1.100).
> > > > >
> > > > > There is a Linux firewall between VCs and MCU.
> > > > >
> > > > > There is one to one nat configured for these 2 VCs (10.1.1.11  <-->
> > > > > 172.16.1.110, 10.1.1.12  <--> 172.16.1.120)
> > > > > There is no natting for MCU IP as it is routable.
> > > > >
> > > > > nf_nat_h323 and nf_conntrack_h323 module is enabled in the firewall.
> > > > >
> > > > > When VC1 and VC2 initiate call to MCU, everything works fine. Video
> > > > > call is successful for both VC1 and VC2. h245 IP address for tcp in
> > > > > h225: CS connect packet is correctly replaced by the natted IP.
> > > > >
> > > > > However, when there is a dial out from MCU to VCs (i.e. MCU initiate
> > > > > call to the natted IP (i.e. 172.16.1.110 and 172.16.1.120 of VCs),
> > > > > natting works fine but h245 IP address for tcp in h225:CS is replaced
> > > > > correctly only for VC2 and not for VC1. For VC1, it is still its
> > > > > actual IP (i.e. 10.1.1.12 and not 172.16.1.120).
> > > > >
> > > > > Because of this, video call is successful only with VC2 and not with
> > > > > VC1, when initiated from MCU. I tried with another panasonic VC
> > > > > hardware, there was no change.
> > > > >
> > > > > Further packet dump analysis showed that for VC1, there are 3 h225
> > > > > packets (setup, call proceeding and alert) before Connect message but
> > > > > for VC2 there are only 2 h225 packets (setup and alert) before connect
> > > > > message.
> > > > >
> > > > > Is there a bug in nf_nat_h323 module or am I missing something?
> > > >
> > > > It can be a bug/incompatibility with the H.323 implementation in the
> > > > Panasonic device. However, first I'd make sure the MCU does not use
> > > > hostname for VC1 instead of its IP address. Hostnames in the calls are not
> > > > supported.
> > > >
> > > > Best regards,
> > > > Jozsef
> > > > -
> > > > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > > > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > > > Address : Wigner Research Centre for Physics
> > > >           H-1525 Budapest 114, POB. 49, Hungary
> > >
> >
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics
> >           H-1525 Budapest 114, POB. 49, Hungary
