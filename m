Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D25EB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 19:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjGJTFl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 15:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjGJTFk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 15:05:40 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A707911A
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 12:05:39 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-314313f127fso5030053f8f.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 12:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1689015938; x=1691607938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yoz5iX38+zrNIZmukBIeMJYTjQEZUs+tD+XsJ+C2OOs=;
        b=ko5k37do5xcwat8m4LB8Qbz2C+f5/PIt7rU6ysoRkJUxAyDKfhojZwrBQ2z102FCIb
         IU8sIKhuMRvJN2GUIJ9F40pUi49v1f9AaJkQWZLKv2rtcnPBn9CdThxuHUD4EwpJkFOn
         HG3/GVSgnNBOxQgj2/ir9YmUwioFXN5ye8TEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689015938; x=1691607938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yoz5iX38+zrNIZmukBIeMJYTjQEZUs+tD+XsJ+C2OOs=;
        b=Uw6alAseaYrzRoy515Q1j14mNsBxyncNlXsp/2fGfmqqqcj1pADLUhqp5pqL4hilvQ
         gfFA7oV4tG4I3ghGljzv73GbXlqAb5D9tl0obqD+LwNS+9vIQ9d2VzraKgC3r46Yj+O3
         wsSyy6DlPMg3P12GeT7bnZ0A1h80H+p0WeejrZCy2DStDsfB7zMbVfzF9DJWqJB2/tAj
         YrfDaKscCq36VEBgH8PdWhnTLQj7S1IWxDt3CgrJbYBz+qcds0IotdlvNMxFhxmEpYol
         lE3yzz2JcYCoCuYWu3C0hwJGPD4lNEnxNbtiCm2bbl1O4wq0/Phye0KjfVvzA+nnKN6g
         DtrA==
X-Gm-Message-State: ABy/qLaGCprccqa8CQgKxVh4jl20CsUG+8Zdo3DdY/X9xSC4znSV3Lao
        rAlzZ1qGy48zanH5foq0PyfUL44FXcp0GAREeMKvIA==
X-Google-Smtp-Source: APBJJlEJPRbA+4lQ3SeJ7gBI/WOH9HfBEvwrQkuNLYuy60ilqM/dgaLLq/ME+8K3cIeANTGwKM+Dtm7AtnCtENGpJHc=
X-Received: by 2002:adf:e504:0:b0:314:248d:d9df with SMTP id
 j4-20020adfe504000000b00314248dd9dfmr11866907wrm.13.1689015938076; Mon, 10
 Jul 2023 12:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <CA+9S74jbOefRzu1YxUrXC7gbYY8xDKH6QNJBuAQoNnnLODxWrg@mail.gmail.com>
 <20230710112135.GA12203@breakpoint.cc> <20230710124950.GC12203@breakpoint.cc>
 <CA+9S74h4ME7sxt7L1VcU+hPXj1H-cWwTcrEsyyrjSAHx_UxCwA@mail.gmail.com>
 <ZKxH1eNXcI5k9oJq@calendula> <ZKxIYuw8z4KqkQaA@calendula>
In-Reply-To: <ZKxIYuw8z4KqkQaA@calendula>
From:   Igor Raits <igor@gooddata.com>
Date:   Mon, 10 Jul 2023 21:05:26 +0200
Message-ID: <CA+9S74gxkooWxoT94h-kBncv0Y1KerYNVtME7dbwXmV+u7QT+A@mail.gmail.com>
Subject: Re: ebtables-nft can't delete complex rules by specifying complete
 rule with kernel 6.3+
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

On Mon, Jul 10, 2023 at 8:05=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Mon, Jul 10, 2023 at 08:03:04PM +0200, Pablo Neira Ayuso wrote:
> > Hi,
> >
> > On Mon, Jul 10, 2023 at 04:41:27PM +0200, Igor Raits wrote:
> > > Hello Florian,
> > >
> > > On Mon, Jul 10, 2023 at 2:49=E2=80=AFPM Florian Westphal <fw@strlen.d=
e> wrote:
> > > >
> > > > Florian Westphal <fw@strlen.de> wrote:
> > > > > Igor Raits <igor@gooddata.com> wrote:
> > > > > > Hello,
> > > > > >
> > > > > > We started to observe the issue regarding ebtables-nft and how =
it
> > > > > > can't wipe rules when specifying full rule. Removing the rule b=
y index
> > > > > > works fine, though. Also with kernel 6.1.y it works completely =
fine.
> > > > > >
> > > > > > I've started with 1.8.8 provided in CentOS Stream 9, then tried=
 the
> > > > > > latest git version and all behave exactly the same. See the beh=
avior
> > > > > > below. As you can see, simple DROP works, but more complex one =
do not.
> > > > > >
> > > > > > As bugzilla requires some special sign-up procedure, apologize =
for
> > > > > > reporting it directly here in the ML.
> > > > >
> > > > > Thanks for the report, I'll look into it later today.
> > > >
> > > > Its a bug in ebtables-nft, it fails to delete the rule since
> > > >
> > > > 938154b93be8cd611ddfd7bafc1849f3c4355201,
> > > > netfilter: nf_tables: reject unbound anonymous set before commit ph=
ase
> > > >
> > > > But its possible do remove the rule via
> > > > nft delete rule .. handle $x
> > > >
> > > > so the breakge is limited to ebtables-nft.
> > >
> > > Thanks for confirmation and additional information regarding where
> > > exactly the issue was introduced.
> > > The ebtables-nft (well, ebtables in general) is heavily used by the
> > > OpenStack Neutron (in linuxbridge mode), so this breaks our setup
> > > quite a bit. Would you recommend to revert kernel change or would you
> > > have the actual fix soon (ebtables-nft or kernel)?
> >
> > Just to make sure this bug is not caused by something else.
> >
> > Could you cherry-pick this kernel patch? It is currently missing 6.1.38=
:
> >
> > commit 3e70489721b6c870252c9082c496703677240f53
> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date:   Mon Jun 26 00:42:18 2023 +0200
> >
> >     netfilter: nf_tables: unbind non-anonymous set if rule construction=
 fails
> >
> >     Otherwise a dangling reference to a rule object that is gone remain=
s
> >     in the set binding list.
> >
> > I have requested included to -stable already.
>
> Oh wait, you mentioned this works fine for you with 6.1.x.

I should have mentioned that we've tested 6.1.32 where it worked and
my colleague has tested 6.1.38 today where it is broken.
