Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30123C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 13:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A1E361A7F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 13:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbhG0Ncy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 09:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbhG0Nct (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 09:32:49 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1775C0613C1
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 06:32:48 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id k4so7590048wms.3
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 06:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pv2Kr96fLteAlNp2/l7f5CHe0z5QYiMahXyKqjaVUfk=;
        b=UzUzVbmg9RenswInYAbhQzf5Otryjlw39xOdGhU01EIcoDs5PQXuWUHZLlk8wXGZWL
         O4+5ig1RVgQvcabYMhaBRCTGAtiyFB0iu0tjO1JJyna2Qw9kCJOBjRbHc6oysIjwRHn4
         BZfshBo/M/Gg73I8MGNPnNHX7nTbAGCStJQEvRdIeedH4M7lL10EUJmEtSnwXyVb4/aS
         mHX2Q8cHEZJ5VTujKFOHC1miPVYJOzhoLuDidg21+OWpGJsb93r5KX2ixCMb/LgZKOCW
         Koo7G4+wd5hW6DClz5TNsuZgH/Oe1jf7Z7c8aoK7PPeMnaNUUwaR+4xMBmtV4a4dLQR8
         vx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pv2Kr96fLteAlNp2/l7f5CHe0z5QYiMahXyKqjaVUfk=;
        b=r8NvzABhPVwatCabQcIwPvY6sL8UUq1VA6GeLSDAsyL9CRJPp/OUE8q3GcV+MnPrE5
         2YabKatcDy96K2hmfXnBHOe81+N7HeJvjV4VAbu/KhguVrT2DkYcBG8NAhKW04+lcVwc
         3VizjIZoUY4RCVtJeEcbuo8i6RomT4Abowt0TENCIALQBe0vHKBlgXpunNpxzuKi1SQ+
         2AXDYLFaC3UGVSIu68VVrvd+8iZzfDvtOto2RUP+z2h7ahDbNe5MdJfTf1CO/jez3y1L
         yLh311jxv9+hz5t3djPivgWNBrgAn23ypzBM3uGD++dRWOSo2mzTgnJepFgmjlrSAzFV
         R3NQ==
X-Gm-Message-State: AOAM533sA4q4Jikt53YsPn+1j3EthX+ahyHZnMlUSTDiBjsEgR9oyloq
        FSTZg5jUvL48+Gn6mXHSwYoha7J0o37HIZnli1I=
X-Google-Smtp-Source: ABdhPJztH5NqqOZ7IJWFYwmACBBkSSRaF5wXXPGSClTKgdkZHaRf0Hk+9LLLoB8UKwDj5UVmFy8Fu2ZYTYEstWr/BBs=
X-Received: by 2002:a1c:e90f:: with SMTP id q15mr4075402wmc.175.1627392767449;
 Tue, 27 Jul 2021 06:32:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPirA-gNiYRCoQR6-2fP80ESvvXKu7f0bVPT80FFxua6=g@mail.gmail.com>
 <17a7e7ed-f324-2a94-5f82-18c3850de6a@netfilter.org> <CAA5aLPgQj8wEbawg8u=UqJedTPWCdK5WiizwCpNxMp7Vg=-JgA@mail.gmail.com>
 <e38ddbe-a47-efb1-e56f-457f5e426b18@netfilter.org>
In-Reply-To: <e38ddbe-a47-efb1-e56f-457f5e426b18@netfilter.org>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Tue, 27 Jul 2021 19:02:35 +0530
Message-ID: <CAA5aLPgowRWm7JZm02LCGeOPz4E_dO+8FCCag+8aO4HDeLUQFQ@mail.gmail.com>
Subject: Re: Nf_nat_h323 module not working with Panasonic VCs
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

For the VC which is working (i.e. VC2, IP:172.16.1.120) following are
the generated debug log:

[Jul27 17:29] nf_nat_q931: expect H.245 172.16.1.100:0->172.16.1.120:5516
[  +0.249944] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
[  +0.000021] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
[  +0.003265] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
[  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
[  +0.007606] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
[  +0.000012] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
[  +0.000010] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5506
[  +0.000004] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5507
[  +0.004337] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
[  +0.000010] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
[  +0.000007] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5508
[  +0.000007] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5509
[  +0.006028] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
[  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
[  +0.001171] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
[  +0.000008] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
[  +0.000006] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5510
[  +0.000003] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5511
[  +0.003261] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
[  +0.000011] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
[  +0.000006] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
[  +0.000003] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513
[  +0.007889] nf_nat_h323: expect RTP 172.16.1.100:0->172.16.1.120:5512
[  +0.000012] nf_nat_h323: expect RTCP 172.16.1.100:0->172.16.1.120:5513


However, for the panasonic VC1 i.e. the VC which is having issue,
there are no debug log generated. absolutely nothing.

On Mon, Jul 26, 2021 at 1:13 PM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>
> On Mon, 26 Jul 2021, Akshat Kakkar wrote:
>
> > MCU is using IP only to dial to VC1 and not hostname.
> >
> > I went through packet capture and find everything in line with the
> > standard. Just that it is sending "CS : Call Proceeding" packet which
> > is an optional packet but it is part of standard.
> > I can share pcap file if needed.
>
> Could you enable dynamic debugging in the kernel and enable it for the
> nf_conntrack_h323 module? Then please repeate the testing with the
> working and not working VCs and send the generated kernel debug log
> messages.
>
> Best regards,
> Jozsef
> > On Mon, Jul 26, 2021 at 2:11 AM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > >
> > > Hello,
> > >
> > > On Sat, 24 Jul 2021, Akshat Kakkar wrote:
> > >
> > > > I have 2 vc endpoints VC1 (Make:Panasonic, IP:10.1.1.11),
> > > > VC2(make:Polycom,IP: 10.1.1.12) and 1 MCU (172.16.1.100).
> > > >
> > > > There is a Linux firewall between VCs and MCU.
> > > >
> > > > There is one to one nat configured for these 2 VCs (10.1.1.11  <-->
> > > > 172.16.1.110, 10.1.1.12  <--> 172.16.1.120)
> > > > There is no natting for MCU IP as it is routable.
> > > >
> > > > nf_nat_h323 and nf_conntrack_h323 module is enabled in the firewall.
> > > >
> > > > When VC1 and VC2 initiate call to MCU, everything works fine. Video
> > > > call is successful for both VC1 and VC2. h245 IP address for tcp in
> > > > h225: CS connect packet is correctly replaced by the natted IP.
> > > >
> > > > However, when there is a dial out from MCU to VCs (i.e. MCU initiate
> > > > call to the natted IP (i.e. 172.16.1.110 and 172.16.1.120 of VCs),
> > > > natting works fine but h245 IP address for tcp in h225:CS is replaced
> > > > correctly only for VC2 and not for VC1. For VC1, it is still its
> > > > actual IP (i.e. 10.1.1.12 and not 172.16.1.120).
> > > >
> > > > Because of this, video call is successful only with VC2 and not with
> > > > VC1, when initiated from MCU. I tried with another panasonic VC
> > > > hardware, there was no change.
> > > >
> > > > Further packet dump analysis showed that for VC1, there are 3 h225
> > > > packets (setup, call proceeding and alert) before Connect message but
> > > > for VC2 there are only 2 h225 packets (setup and alert) before connect
> > > > message.
> > > >
> > > > Is there a bug in nf_nat_h323 module or am I missing something?
> > >
> > > It can be a bug/incompatibility with the H.323 implementation in the
> > > Panasonic device. However, first I'd make sure the MCU does not use
> > > hostname for VC1 instead of its IP address. Hostnames in the calls are not
> > > supported.
> > >
> > > Best regards,
> > > Jozsef
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
