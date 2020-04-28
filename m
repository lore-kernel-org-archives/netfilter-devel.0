Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EE6C83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 13:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB3F206B9
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 13:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HDVep3t+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgD1N4p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 09:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgD1N4p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 09:56:45 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61048C03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 06:56:45 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c16so20307930ilr.3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 06:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rAuUm2tG8Fod5yx3o3ZknjJtm7IV7G+SCLrjuVhy588=;
        b=HDVep3t+TcGXmewFfMPidyysz5GUNAWx0WK5HaFmJLUcVdUeiHQVKYw+vqr3fh2rRR
         7gArnL/R4jwTtTY6S0KzdifH+qv/Npu1I1i2/mZiU9/cW4ADcSO8RtUAFUTMn0Ru+nTo
         HBbFbRmGfLXZ72yx9H+e3t0dSDa5TJ5o6r09TqubOyLIdctJS9yYwAJBzQDhhVxw2fVP
         zhRLBSuAREfx/pyuoXpI3jwUzAxJiEdD0pP5tfkfA7GjhemLLADO3p2WONZR8qwPaB9r
         A4YiATEBXf1/H9y6ar4tVU2KIMNr4mGVnkonkH5Yi//up1ARlwphpwnYZ/hHJVgYV9yD
         hihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rAuUm2tG8Fod5yx3o3ZknjJtm7IV7G+SCLrjuVhy588=;
        b=m4buBX0INi8kDM8zu3XLsdaLj6DQ+C+NH4ueFNKe3gGe5Rp/+r95OLWEz9r7OA09j6
         7LPdA5mZNlQJ+n8XTDMDAUL1GpK576BlvtAfnH/Bri+5ou/Dpfoo5f4VrckK/vBmCa+N
         qVnFTvBwrFx1KtFtddpEn0YPl22YmTpDgVikEXhDq3tAmiBqAwnzHL/uh9Jvs4S8b7Gh
         T0WVMcdnt/+7Lag2MsNGb5WybFntW7O3+LxFaklMf4XGFtNTA0cbVqMdWFKhH1Ovw/Hk
         IY5badVCGQ/1cfdX1Xoyvnp1RoQoEuEU80tftvP3oLPoH8yAp17r3JsRVyFehXlPkleU
         LWMA==
X-Gm-Message-State: AGi0Puao+9uz8IFvgN2/gHh1UlU10i4dArwe6nlM0NJX9HOo6Gb9AApM
        DMAuMAtTFic2kOIrA6Wj76aiddXOU2/yVwNP2qaXoQ==
X-Google-Smtp-Source: APiQypKUHgr8t44xtwYuvkxAsFuenVa0Lr8s4NNMl4IfnE0edlsVLN7byh4NWz3EReDiEKKa0R+jyw1Lk/b804TVpkQ=
X-Received: by 2002:a05:6e02:5c5:: with SMTP id l5mr18338754ils.170.1588082204710;
 Tue, 28 Apr 2020 06:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200407180124.19169-1-ydahhrk@gmail.com> <CAF90-Wg=uGXVOPu-OXupkFYYL0xDYTfV8vTNRvUQgspFMamL=w@mail.gmail.com>
 <CAA0dE=XPuEv=Gye9MXz+aC9s8=izd066+=yJfYTe9vtZgQtLnA@mail.gmail.com>
 <CAF90-WhkRhsY6D+NgUCjVxaT2G+hzfgaP_UP4_MUusADUPA1xQ@mail.gmail.com>
 <CAA0dE=VK=YusbgKS3O_h2N2YQ-edCdPFHtmDn_y4h57A64StmQ@mail.gmail.com> <CAF90-Wi3d-CGqQO=PsfXdi6OAAABahcd2edp2Tru=UMmrJV7Sw@mail.gmail.com>
In-Reply-To: <CAF90-Wi3d-CGqQO=PsfXdi6OAAABahcd2edp2Tru=UMmrJV7Sw@mail.gmail.com>
From:   Alberto Leiva <ydahhrk@gmail.com>
Date:   Tue, 28 Apr 2020 08:56:33 -0500
Message-ID: <CAA0dE=UF=im6J2-j6RUxM+hvnr56sK0U2K9yKGLMMkC5DjaM7A@mail.gmail.com>
Subject: Re: [nft PATCH 2/2] expr: add jool expressions
To:     Laura Garcia <nevola@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ok, understood.
Thank you.

On Tue, Apr 28, 2020 at 3:10 AM Laura Garcia <nevola@gmail.com> wrote:
>
> On Tue, Apr 28, 2020 at 2:29 AM Alberto Leiva <ydahhrk@gmail.com> wrote:
> >
> > Ok. This looks doable. I expect to run into trouble along the way, but
> > I don't have any more objections for now.
> >
> > Did you receive my second mail from that day?
> > (https://marc.info/?l=netfilter-devel&m=158700165716521&w=2)
> > I won't hold it against you if you refuse the bridge, I just need
> > something to tell my users.
> >
>
> Hi Alberto,
>
> Please don't get me wrong, I'm not refusing anything. Just expressing
> my opinion. The coreteam is who had to decide.
>
> I truly want NAT64/46 to be implemented in Netfilter but in a
> definitive way, not something temporary.
>
> I got your second email but I had nothing to add. I consider it very
> unlikely to integrate an API that you already know that could be
> obsolete anytime soon.
>
> Cheers.
