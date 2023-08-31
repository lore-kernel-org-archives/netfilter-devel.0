Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D191C83F10
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 14:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245046AbjHaOqU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 10:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbjHaOqT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 10:46:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5EFCC5
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 07:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693493137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BTd3wy/OVxecIaD6rgBVuZb82dl7b8CuRSfdLyU+dL4=;
        b=KwGexeiPGOc5l+qD+8EfWDiRF+a/Z9VlI8mahCpDJlnmOtPkPXshSoJ4syKxiKxdNKh61R
        7UqmBcl8rixEyIGAO7jXuuObpFkuZbCdwsZjJBnC6wEj5GorEB1dfCIpDCDKxlXQYc8y1V
        PMhX2jDl3Bn7VQJl5wgE5vsM7OhT8OI=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-OicYewdoNxG0-xBinaGJ4A-1; Thu, 31 Aug 2023 10:45:35 -0400
X-MC-Unique: OicYewdoNxG0-xBinaGJ4A-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6bc4dfb93cbso1140256a34.1
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 07:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693493134; x=1694097934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BTd3wy/OVxecIaD6rgBVuZb82dl7b8CuRSfdLyU+dL4=;
        b=DUZb4x3NZZDsvBZq6zbwljpI4d4n3I2yof3JUiwWnQ3A+2Oj1Nmb1pZwsFBVyx0BgM
         D79NcEOLCwlI+GQObz6OgHAyaZObvJpicMoTj5RWFaa97TZJrFnKd0RMoWBUHY7EIKnw
         xpGI6PgBGQ4qM8pNh/WpL9od1Ax/IyuGeLaSuCmEd+XRpvKRA2pDPsVWAtn/H5QVpH1u
         jlusKhXtjNzMPDbI+sCebn3zcvjZ8cFKVVRAdzafNYCFmRa+yuhNvpwX/CrDA8QCIWtC
         2TfN2LlDrlm5e7eb9o7dukM9M1TfZihzTHNuSX0KR4+gUURu/1NvO4fusF/+4fbJ9uHO
         5ISg==
X-Gm-Message-State: AOJu0YxRgYsoh6arcPh97MO5vuAUyMduvZtIgG4EN1Vs0WwKgA/F/f1f
        Ve25QgdpS8BbitCyomvR31tC3/D1SV/z9ky2wWWphujCrwbJdNFu3JnD9ZzPTpDwQCVy8ZedmDj
        HyVKL8SrEDKHJjswis8T5lOjfFKzmeBjWui9ksRRqtdBm
X-Received: by 2002:a05:6830:1692:b0:6b2:91c9:8e1e with SMTP id k18-20020a056830169200b006b291c98e1emr6023704otr.2.1693493134751;
        Thu, 31 Aug 2023 07:45:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0pI9uK2ToEtl8xqf16/qumOaryQOQqIewGouu2F54UiswiP68mqZsTvi5SjT3LsoV6gI2LE+dETgXBTmSrRc=
X-Received: by 2002:a05:6830:1692:b0:6b2:91c9:8e1e with SMTP id
 k18-20020a056830169200b006b291c98e1emr6023690otr.2.1693493134533; Thu, 31 Aug
 2023 07:45:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230831123931.60606-1-wander@redhat.com> <20230831133750.GB15759@breakpoint.cc>
In-Reply-To: <20230831133750.GB15759@breakpoint.cc>
From:   Wander Lairson Costa <wander@redhat.com>
Date:   Thu, 31 Aug 2023 11:45:23 -0300
Message-ID: <CAAq0SU=nesniZCLBa7xoqJ853sk2_+LaBhenVSZeYoe=82Syow@mail.gmail.com>
Subject: Re: [PATCH nf v2] netfilter/osf: avoid OOB read
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 31, 2023 at 10:37=E2=80=AFAM Florian Westphal <fw@strlen.de> wr=
ote:
>
> Wander Lairson Costa <wander@redhat.com> wrote:
> >
> > diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_os=
f.c
> > index 8f1bfa6ccc2d..13fedf2aaa0f 100644
> > --- a/net/netfilter/nfnetlink_osf.c
> > +++ b/net/netfilter/nfnetlink_osf.c
> > @@ -315,6 +315,9 @@ static int nfnl_osf_add_callback(struct sk_buff *sk=
b,
> >
> >       f =3D nla_data(osf_attrs[OSF_ATTR_FINGER]);
> >
> > +     if (f->opt_num > ARRAY_SIZE(f->opt))
> > +             return -EINVAL;
> > +
>
> Hmm, this isn't enough; as far as I can see there is no validation
> whatsoever.
>

I didn't get it. It guarantees there is no OOB read of the opt array.

> This should also check that all of:
>
>  char    genre[MAXGENRELEN];
>  char    version[MAXGENRELEN];
>  char    subtype[MAXGENRELEN];
>
> ... have a NUL byte. You could use strnlen() =3D=3D ARRAY_SIZE() -> EINVA=
L
> for those.
>

I think the correct way would be memchr(genre/version/subtype, 0, MAXGENREL=
EN).

> Maybe there is more to be validated. I did not followup with all the
> nested structures buried in user_finger struct.
>

I focused on the reported issue mainly because I am unfamiliar with
the Netfilter layer. Let me take a deeper look.

