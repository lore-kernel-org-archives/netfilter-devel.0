Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF13AC7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 01:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A874B20659
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 01:27:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z+iDl3zb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbfGPB06 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 21:26:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39860 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730607AbfGPB06 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 21:26:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so19009050wrt.6;
        Mon, 15 Jul 2019 18:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OJKGfm4zPYEeDJ64R4ToC+PbXLnEzfGrEQo6pdlpNP8=;
        b=Z+iDl3zbbSqm+cZ1DbJoZQ4JVZrZS+3NgT6IUkEHLJYLGXYwGLpulc8+qBb5BZMFMx
         xPbMTzvoEFGE5/p+TG1HXN9HNt5MMfiecWwVQrpA0q8VAssMLnAX/1lr0xHHdr+NxpBg
         Av/GC8PPSRpyiUDPwNs3PKrgquTN7eSZcc5tMJmyENceBnEonRJZAstLHmsUS3huTSvy
         +9gAVtOHgCKcHVpyHFXDIem/J5FR+Hos5iDX33J7ejTKL4cHat6reDmk8g3kWxSoUk+q
         O1dLwAoE2HUNQG9N4PgtU8r6gN6fgdfjWccc4AKPBuzdgEThe5+wpafY1Mr0H3ZfCQlY
         jP2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OJKGfm4zPYEeDJ64R4ToC+PbXLnEzfGrEQo6pdlpNP8=;
        b=iYw/L/exr+4nf0PcMknar1gI/R8UJAIqYrwSJV2wbw3eRJeF9QSEIKrMRm8EaMiulg
         L4pWPPFEDHvmpEACEwaK2ESSyNfSarMOCQIewgZ78ZgdMFk61lQMbxoTnNo0cRi7lEei
         dqbBR9v5ZLBe9iRLa3lsJ7U8gm0HTIrC/yk1Asaq2AWjqxbORlCcPenCnKGqjdY22No3
         cwepusymDSQrW7JJd8QXmYkgzmBx6VqncxpTECyVgZTomhLRAa8hvhu0krGqN86EBJxz
         Kz9axBLn4guQ6zC9uGUSJkES3O7rf0fdyOh52Nps+OBpVIG5R7Xo6WECXTT1Ghs0/yio
         bFoA==
X-Gm-Message-State: APjAAAUEvgSim3jmV45piuwZ5WS0k+C2OqjpJs5szU4f151sbubObXbJ
        gI+7Ut5hEs2+KkB08Yame1acO7hl4JUZP3uP0ng=
X-Google-Smtp-Source: APXvYqxiCotRSbNaIj7YIiRueXmmYF/HgKhYYs5qxUmBp/UJ2YY1WlBJJqvTEjy9YMhV82itYVDWY0KlsOJ+T9qD5Kw=
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr30984868wrr.70.1563240415647;
 Mon, 15 Jul 2019 18:26:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190710074552.74394-1-xingwu.yang@gmail.com> <20190710080609.smxjqe2d5jyro4hv@verge.net.au>
 <20190715082747.fdlpvekbqyhwx724@salvia>
In-Reply-To: <20190715082747.fdlpvekbqyhwx724@salvia>
From:   yangxingwu <xingwu.yang@gmail.com>
Date:   Tue, 16 Jul 2019 09:26:44 +0800
Message-ID: <CA+7U5JvJMTjCuxo8Mf7tiXZADe-q4covYxX7NsG8EMCcJh5mtA@mail.gmail.com>
Subject: Re: [PATCH] ipvs: remove unnecessary space
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Simon Horman <horms@verge.net.au>, wensong@linux-vs.org, ja@ssi.bg,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ok

I will remove all unnecessary spaces and send the v2 patch

Thansk Pablo

Pablo Neira Ayuso <pablo@netfilter.org> =E4=BA=8E2019=E5=B9=B47=E6=9C=8815=
=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=884:27=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On Wed, Jul 10, 2019 at 10:06:09AM +0200, Simon Horman wrote:
> > On Wed, Jul 10, 2019 at 03:45:52PM +0800, yangxingwu wrote:
> > > ---
> > >  net/netfilter/ipvs/ip_vs_mh.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs=
_mh.c
> > > index 94d9d34..98e358e 100644
> > > --- a/net/netfilter/ipvs/ip_vs_mh.c
> > > +++ b/net/netfilter/ipvs/ip_vs_mh.c
> > > @@ -174,8 +174,8 @@ static int ip_vs_mh_populate(struct ip_vs_mh_stat=
e *s,
> > >             return 0;
> > >     }
> > >
> > > -   table =3D  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> > > -                    sizeof(unsigned long), GFP_KERNEL);
> > > +   table =3D kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> > > +                   sizeof(unsigned long), GFP_KERNEL);
>
> May I ask one thing? :-)
>
> Please, remove all unnecessary spaces in one go, search for:
>
>         git grep "=3D  "
>
> in the netfilter tree, and send a v2 for this one.
>
> Thanks.
