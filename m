Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F67C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 06:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF156023B
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 06:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhGZGKg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 02:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhGZGKf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 02:10:35 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7C3C061757
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jul 2021 23:51:03 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k14-20020a05600c1c8eb02901f13dd1672aso7084292wms.0
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jul 2021 23:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lMyd+bPW1HKz2y0RLUVw1ywbizvsgmLFbjwEbrY2AQc=;
        b=a9phaS0xJriFrJ27/rCvUC7cJTuXG6P26rENMC2rMcDalPdw8Cs7am2QK4tnKt3boI
         4iwGNLLu0jC6/hDs7il1daBucJgKsE+Zj3lmNIk5CnZKg6ojAU8h+1GdSrkUKDNTaa7x
         CiD5gWTjdF66lq+hBvH2WKnDtj8iVR2y46bHDZCwmPrhvxmsIee3og3qK2g0nmS/7mrP
         wemqZgN0o8EtFPazBLC0mUyWUkwep07C0RjZcYS8Cje2nlPFGVXvsS09gahP5CTslvoO
         DEDCT8gAuuQcfARVTAokjscPk19F+6EMIeIjgDpevDr9d3mJUteryOa604GGlTlvE+mo
         KzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lMyd+bPW1HKz2y0RLUVw1ywbizvsgmLFbjwEbrY2AQc=;
        b=VyfXjIRH9Zzv0Hw80oDlIPvAf7KAa0cB2zOqhBHt2krj4Mloha7czEIysIz17hVHXd
         U5xWj+z+rwaw3DUApFdU0tSsJxCyq8c/vx/g/xQ5L8As/J/D81He+lPQRmAyb6VBn9Fi
         MFl7fIntUNBfmeC3H4G1xf4C594YRAhXVFGqvUMQsW/r7WtHf4RdQjbL8lL1D/6ABYCC
         48M3/LVBwi0bSFtg+0F0M2Rbz6seABOkHs6H1YXME1DRaxLhboUwY+Y7ASpA7blK0AAQ
         BTFoVQi0AGBoE0UG6unJuwRNGcLEW+n/QBYAc0+9Lh0TDUVdhAV00OOoD1igy2cWvg1t
         IvQw==
X-Gm-Message-State: AOAM531dq5D5iGhrKnnw8JSMnf9j823mZkO/jdOXfdpjOz/wFXfmUozf
        UD7+A5nAKBTDyvh4b2lvs+LujDXC0u6lZbXRJuU=
X-Google-Smtp-Source: ABdhPJyIpxj0/YG1nc3waR9OMdfWFN4NvoK1BIJU3GgP8JzezKqN8gEmTW38sIyxjrxU0e2yA4082+nsJ6BQdk+3a5s=
X-Received: by 2002:a05:600c:2197:: with SMTP id e23mr15647983wme.101.1627282262022;
 Sun, 25 Jul 2021 23:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPirA-gNiYRCoQR6-2fP80ESvvXKu7f0bVPT80FFxua6=g@mail.gmail.com>
 <17a7e7ed-f324-2a94-5f82-18c3850de6a@netfilter.org>
In-Reply-To: <17a7e7ed-f324-2a94-5f82-18c3850de6a@netfilter.org>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Mon, 26 Jul 2021 12:20:50 +0530
Message-ID: <CAA5aLPgQj8wEbawg8u=UqJedTPWCdK5WiizwCpNxMp7Vg=-JgA@mail.gmail.com>
Subject: Re: Nf_nat_h323 module not working with Panasonic VCs
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

MCU is using IP only to dial to VC1 and not hostname.

I went through packet capture and find everything in line with the
standard. Just that it is sending "CS : Call Proceeding" packet which
is an optional packet but it is part of standard.
I can share pcap file if needed.

On Mon, Jul 26, 2021 at 2:11 AM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>
> Hello,
>
> On Sat, 24 Jul 2021, Akshat Kakkar wrote:
>
> > I have 2 vc endpoints VC1 (Make:Panasonic, IP:10.1.1.11),
> > VC2(make:Polycom,IP: 10.1.1.12) and 1 MCU (172.16.1.100).
> >
> > There is a Linux firewall between VCs and MCU.
> >
> > There is one to one nat configured for these 2 VCs (10.1.1.11  <-->
> > 172.16.1.110, 10.1.1.12  <--> 172.16.1.120)
> > There is no natting for MCU IP as it is routable.
> >
> > nf_nat_h323 and nf_conntrack_h323 module is enabled in the firewall.
> >
> > When VC1 and VC2 initiate call to MCU, everything works fine. Video
> > call is successful for both VC1 and VC2. h245 IP address for tcp in
> > h225: CS connect packet is correctly replaced by the natted IP.
> >
> > However, when there is a dial out from MCU to VCs (i.e. MCU initiate
> > call to the natted IP (i.e. 172.16.1.110 and 172.16.1.120 of VCs),
> > natting works fine but h245 IP address for tcp in h225:CS is replaced
> > correctly only for VC2 and not for VC1. For VC1, it is still its
> > actual IP (i.e. 10.1.1.12 and not 172.16.1.120).
> >
> > Because of this, video call is successful only with VC2 and not with
> > VC1, when initiated from MCU. I tried with another panasonic VC
> > hardware, there was no change.
> >
> > Further packet dump analysis showed that for VC1, there are 3 h225
> > packets (setup, call proceeding and alert) before Connect message but
> > for VC2 there are only 2 h225 packets (setup and alert) before connect
> > message.
> >
> > Is there a bug in nf_nat_h323 module or am I missing something?
>
> It can be a bug/incompatibility with the H.323 implementation in the
> Panasonic device. However, first I'd make sure the MCU does not use
> hostname for VC1 instead of its IP address. Hostnames in the calls are not
> supported.
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary
