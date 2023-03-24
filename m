Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED7BC6FD20
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Mar 2023 19:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCXTXV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCXTXU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 15:23:20 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF20212A2
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 12:22:33 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso6027944pjb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 12:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679685751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VqxBHFb8x/8JNWgeaFZniBeMJ12zPyls6Kd42EZTElk=;
        b=KzjEr/4Kl8bJBJ34jl+I6X0JpHeOQeyXcQmp1YkRvkVFjii47COUim497MZOezPFEZ
         N1gkG7t1V2UApGL6PtMWpd8tRN09Yer/ZFvB0wgBpZrOsRllMbPg+req9iv6r0wwSeIO
         mv3XzFWnOGpIif2Ae3q/Ru9bOnv0JLUd+F1kSG86+GHN6VnEv3MSjZI30zWz4L0V4NXl
         q0x787XoHUDF7VUlm+RMUPaP2VJXwvP1FUEO3v+QZLIWyyedQOXWVHundBQ705io8RYJ
         XYxMfEcfZ2jI9ta6sLP5JVzBK3zgZL7S1fFWlkuQEiG3ztMUHJmMuJmrJConNtGiGqYE
         oUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679685751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VqxBHFb8x/8JNWgeaFZniBeMJ12zPyls6Kd42EZTElk=;
        b=xO1zFEtp+V03i1NmZeJ5WH7dYdFjUTXiDup5DEsMSB0Pdb8DHMaUmh2piBun28guis
         LCpByITRLPmHW5aQ6bqEPzv+BfQXevb4CrVhcWCIpoeCNOqStbT0oJuK9cywc+oS8NZd
         npjTGgPnskbmZ2oYej4i6wBZh6B0Q1fbFRrMjVTwy6uJMdsv3jHu+B0FcrCg8NUn/zmi
         ObmXR7OkORAIPJchG5Bnx0yIAJbskfREHTnaDeZeTEJEVagbjc45PzgUMqtyoo2XxL1+
         z5bz3Q1oMLbP8Zz00p9n53T7W/3Afkbv8PjvCRB9B42ki7u3ikCz2y1nsEVUL9NRErf3
         5r2w==
X-Gm-Message-State: AAQBX9fdHmzM8RnNvx81XG2iTz/tDaVJqaGQ4rrBeSW9MDE4VBbOuwaU
        aQtE4YTEdAlj536aXS5loSKQYq2Wo2WW86BnAgnmVA==
X-Google-Smtp-Source: AKy350YCYtZ/ouwU/kWynPR+Rl0rMZ9us/VOaWvC3GDv91wk/nstknCZAQn/3dRPOWD3ad0/6Ph2Fjoyc4x+Yjg65fo=
X-Received: by 2002:a17:902:da8e:b0:19f:28f4:1db with SMTP id
 j14-20020a170902da8e00b0019f28f401dbmr1319044plx.8.1679685750996; Fri, 24 Mar
 2023 12:22:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230302172757.9548-1-fw@strlen.de> <20230302172757.9548-2-fw@strlen.de>
 <ZAEG1gtoXl125GlW@google.com> <20230303002752.GA4300@breakpoint.cc>
 <20230323004123.lkdsxqqto55fs462@kashmir.localdomain> <CAKH8qBvw58QyazkSh2U80iVPmbMEOGY0T8dLKX5PWg4b+bxqMw@mail.gmail.com>
 <20230324173332.vt6wpjm4wqwcrdfs@kashmir.localdomain> <CAKH8qBtUD_Y=xwnwEmQ16rJBn7h+NQHL04YUyLAc5CGk1x1oNg@mail.gmail.com>
 <20230324182225.GC1871@breakpoint.cc>
In-Reply-To: <20230324182225.GC1871@breakpoint.cc>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 24 Mar 2023 12:22:19 -0700
Message-ID: <CAKH8qBt-CoXcf-z_eO3dhPapLHE8Vd9sSQ2jfrCnktZ1q_2_2g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 bpf-next 1/3] bpf: add bpf_link support for
 BPF_NETFILTER programs
To:     Florian Westphal <fw@strlen.de>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 24, 2023 at 11:22=E2=80=AFAM Florian Westphal <fw@strlen.de> wr=
ote:
>
> Stanislav Fomichev <sdf@google.com> wrote:
> > > I'm not sure what you mean by "whole story" but netfilter kernel modu=
les
> > > register via a priority value as well. As well as the modules the ker=
nel
> > > ships. So there's that to consider.
> >
> > Sorry for not being clear. What I meant here is that we'd have to
> > export those existing priorities in the UAPI headers and keep those
> > numbers stable. Otherwise it seems impossible to have a proper interop
> > between those fixed existing priorities and new bpf modules?
> > (idk if that's a real problem or I'm overthinking)
>
> They are already in uapi and exported.

Oh, nice, then probably keeping those prios is the way to go. Up to
you on whether to explore the alternative (before/after) or not. Agree
with Daniel that it probably requires reworking netfilter internals
and it's not really justified here.
