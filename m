Return-Path: <SRS0=GfVU=S6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5AEC43219
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 06:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 554EA20881
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 06:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bs1flYM7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfD1G3m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Apr 2019 02:29:42 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:45973 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfD1G3m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Apr 2019 02:29:42 -0400
Received: by mail-ed1-f53.google.com with SMTP id k92so3968374edc.12
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2019 23:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3e0g5ffscny9+7iA/ufskUH0sjdfsXg6kyTm5eUEp78=;
        b=bs1flYM724UxJZKv6TmAHCzEHfgpCuVkiaXcYwKZQNfE53SJyrykOavR/JO9VgCq0v
         X6SVoZtLnMjGcilTdl7iDZQLxb4dOTB3TNeVUpQ5BdXHdmdl7odfHnmep95GQg+HSE/Y
         iYp+7xgiZP/WZH4OwGMRYlbslD/eT3g4Jxlpa/EuuF0KyaUt7IayL5S5NtzB4TSyyZ0N
         DDza2TCePSRLz6M0Kf0cl8UbQTf33kw0x0Q5mV4ZrRMWOIgfWuUuWBPQtbWR8pTaHii/
         cF5msVZT1Jo8NB/MNpxr0hFzhrQenrZxxHCKNLv5J6YjRYnX1tWrrSUkcmsRTNMdWl0r
         6Vsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3e0g5ffscny9+7iA/ufskUH0sjdfsXg6kyTm5eUEp78=;
        b=J6nqkCyCQNHeFJWiCq8Ll47iQepj1Eb9StBoEreNWHv+iB+I3JkhluMo5xgINmfFxy
         a3Qiy5hkDWaqGwBNHmQsDga/v+3Qh5rizIPzyMm7cyRtOwbYlfzQ/5brRReW1E2zTRrq
         Xo30ZwCpzt9U0Sqlkayo+D4UMbMMI1GDtuLL5GQq6JSEEjCY/SIizottinzb8osP7Gu3
         c1ppw1GX05QS6pOV3dWyN2B+Ixle2H4fMabsh0nNPae+9DM+kH/sJlmwwCf/xHjCf1Is
         4oNhaze9Dfu/FiC4AFaYhRq+ZcQALbmUj6ksULKn68MiLE/kXvm+W6ZowySsiEboG/GA
         UpVg==
X-Gm-Message-State: APjAAAXsT2hMz/fBPKk2IJcUN5sYNMQbB0CG3sxGND8sdO/VHrJro3Ix
        shEFHahwJnUZs50NnR9b7nb1CCNVoU5dKJokdRU3zNYFeO0=
X-Google-Smtp-Source: APXvYqxr5jIqU65gn6y+8QSYlFCdbNc/9/ZeGGDwwGvmZKa5WbWHbppn8UMmMiMRG01phG0oLviI9ZtFTZIFDX20xRY=
X-Received: by 2002:a17:906:d0c7:: with SMTP id bq7mr12802002ejb.77.1556432980696;
 Sat, 27 Apr 2019 23:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
 <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com>
 <20190425224512.dz2fuwqrrq5hd2x6@salvia> <CABVi_EwbDf_tA8KdXU33nLgVdHpXNYPtqHGb5DadcL0tdVXAfQ@mail.gmail.com>
 <20190426193732.xk3aektc7fb4eg2h@salvia> <CABVi_Ex1KoK22m6cKsnCLaTC1gaFSUqX2a54m3H=dm8DZ9NFFQ@mail.gmail.com>
 <CABVi_ExHXzWui4g9YZUx2PdnXXfc-OPv_UY++0rvy3ymurki5w@mail.gmail.com>
 <20190427094323.enhkqeoeow4jgmlk@salvia> <CABVi_EwEc1x9dspiVHUKjoikvcCUTBMFbknFbR-yg+DaBcpAXw@mail.gmail.com>
In-Reply-To: <CABVi_EwEc1x9dspiVHUKjoikvcCUTBMFbknFbR-yg+DaBcpAXw@mail.gmail.com>
From:   Mojtaba <mespio@gmail.com>
Date:   Sun, 28 Apr 2019 10:59:27 +0430
Message-ID: <CABVi_EyY+6igxjkryojqKLiTeM=XEAAYg3G0B0+25HePkBRu2A@mail.gmail.com>
Subject: Re: Issue related to conntrack while insert new rule with conntrack
 command in linux
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Pablo,
Would you please let me know to make my own libnetfilter_queue
application ? I need a reference to read more about it and start
working on it?
With Best regards.Mojtaba

On Sat, Apr 27, 2019 at 4:00 PM Mojtaba <mespio@gmail.com> wrote:
>
> Thanks Pablo,
> Actually i need this feature for redirect  RTP-media packet beetwen
> two service. I want to optimize resource consumption by using this
> feature.
> All things works right, But i should find the right place to insert
> this rule in my code, Otherwise if the service got the first packet
> from end-point while i don't insert the rule,yet. I will face with
> problem, becasue of the rule was inserted before.
> Thanks with regards. Mojtaba
>
> On Sat, Apr 27, 2019 at 2:13 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Sat, Apr 27, 2019 at 01:31:40PM +0430, Mojtaba wrote:
> > > Hello Pablo,
> > > Just as better understanding, If i want to update using -U option, How
> > > can i do that?
> > > Suppose there is this rule in conntrack row:
> > > udp      17 29 src=192.168.122.242 dst=192.168.122.103 sport=5070
> > > dport=5005 [UNREPLIED] src=192.168.122.103 dst=192.168.122.242
> > > sport=5005 dport
> > > =5070 mark=0 use=1
> > >
> > > and i want to update it with this command:
> > > conntrack -U -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
> > > --dport 5005 --dst-nat 192.168.122.1:1111 --src-nat
> > > 192.168.122.103:2222 --timeout 30
> > > Actually it was not updated and this issue was raised:
> > > conntrack v1.4.2 (conntrack-tools): 0 flow entries have been updated.
> >
> > You cannot update an existing entry with NATs.
> >
> > You can probably make your own libnetfilter_queue application that
> > allows you to create conntrack entries from packets. If you want to do
> > custom NAT handling some certain traffic. You will only need to pass
> > the first packet of the flow to userspace to set up the NAT mangling
> > you need.
> >
> > I would need to learn more on your usecase for this.
>
>
>
> --
> --Mojtaba Esfandiari.S



-- 
--Mojtaba Esfandiari.S
