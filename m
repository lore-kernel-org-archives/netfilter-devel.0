Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8619C6FD20
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Mar 2023 18:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjCXSBV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjCXSBC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 14:01:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6781BAEB
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 11:00:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso5799020pjb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 11:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679680747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69kZjCFqfgDsB0os3LegZ2m2huNEmiLy51BF0KOvziE=;
        b=Nqim2SJDqfObRLry+wHE3Bp5ABXKeO9ezL6h6WUmMzzGcPLfOJU2DzwAOr/Mhdgnjn
         QocFwitvSPMB5gsxtWwkObMI89WQafi8S3sq2AZNMU/l/VvpPOq+T4BeOObF5CF4duae
         e98xnLAu6icEgynES3EPgNiVwmCQtcXLjbSvIwdWajt5HjsWwUbkEr4JziNYFp9kDkrB
         vFnhIWRw5yhibUdRuUiBWLtJHBgQnSO2H82TSGp7rFTnWhuXoNoswubpXuNRIsqXcYW6
         hrtSqhoD40+9zqxxq6yL5LX6zE5gCkNG/QAs3wriukj2rce+7/YJyTHhvTWpW3XnGil3
         aimg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69kZjCFqfgDsB0os3LegZ2m2huNEmiLy51BF0KOvziE=;
        b=zXzqXDG3oGXTUbVPKa4w+B4yOchAMel5LakPJdvW+Z2ALWAuuLIlRpNgrnvhgClU/0
         fyFjpEOclmlTahj/v2cHBR373OBE76WSWhMXLGbgX6lDnhCxaSlLXapQkXMITfJDx9yh
         XRor1cbXeN5OXzn3gdV+zd1tMO5fgoHil2te8gBc5SSr4HuxSgq3FqaxIszHLGXp7zfp
         DRCsUcDVul69NofBE9Wq1B5tW+hGeQtmEQJhvl4N3i5ssCUTRCkOXDIIBXOQof+LWgIV
         atCrb73hXtivUhpe/BUUpxi0YAa2u50Y+DGi4tHyS2cRxe2Otfbo2H2wNNnCn4dB9yQx
         1cWQ==
X-Gm-Message-State: AAQBX9ev6exXBShg0ZpC+1YpfVInixHDQvB0mw8CcVzjtD+nb6gf0tUr
        nJL9u3ScayuwTTJSODZ0tg3ZjP+RuXyGo6FjgiJ0jg==
X-Google-Smtp-Source: AKy350Z+07KziXQtt9fRVwUGh/R8wfqZQ4xqg/bHtVlp9oAxEBg82SpdlJm59hP+WlP+TspFaagqejcBPAASII/IIY8=
X-Received: by 2002:a17:903:186:b0:1a1:f70c:c800 with SMTP id
 z6-20020a170903018600b001a1f70cc800mr1180869plg.8.1679680746669; Fri, 24 Mar
 2023 10:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230302172757.9548-1-fw@strlen.de> <20230302172757.9548-2-fw@strlen.de>
 <ZAEG1gtoXl125GlW@google.com> <20230303002752.GA4300@breakpoint.cc>
 <20230323004123.lkdsxqqto55fs462@kashmir.localdomain> <CAKH8qBvw58QyazkSh2U80iVPmbMEOGY0T8dLKX5PWg4b+bxqMw@mail.gmail.com>
 <20230324173332.vt6wpjm4wqwcrdfs@kashmir.localdomain>
In-Reply-To: <20230324173332.vt6wpjm4wqwcrdfs@kashmir.localdomain>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 24 Mar 2023 10:58:55 -0700
Message-ID: <CAKH8qBtUD_Y=xwnwEmQ16rJBn7h+NQHL04YUyLAc5CGk1x1oNg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 bpf-next 1/3] bpf: add bpf_link support for
 BPF_NETFILTER programs
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 24, 2023 at 10:33=E2=80=AFAM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Hi Stan,
>
> On Thu, Mar 23, 2023 at 11:31:14AM -0700, Stanislav Fomichev wrote:
> > On Wed, Mar 22, 2023 at 5:41=E2=80=AFPM Daniel Xu <dxu@dxuuu.xyz> wrote=
:
> > >
> > > Hi Florian, Stan,
> > >
> > > On Fri, Mar 03, 2023 at 01:27:52AM +0100, Florian Westphal wrote:
> > > > Stanislav Fomichev <sdf@google.com> wrote:
> > > > > On 03/02, Florian Westphal wrote:
> > > > > > +                 struct {
> > > > > > +                         __u32           pf;
> > > > > > +                         __u32           hooknum;
> > > > > > +                         __s32           prio;
> > > > > > +                 } netfilter;
> > > > >
> > > > > For recent tc BPF program extensions, we've discussed that it mig=
ht be
> > > > > better
> > > > > to have an option to attach program before/after another one in t=
he chain.
> > > > > So the API essentially would receive a before/after flag + fd/id =
of the
> > > > >
> > > > > Should we do something similar here? See [0] for the original
> > > > > discussion.
> > > > >
> > > > > 0: https://lore.kernel.org/bpf/YzzWDqAmN5DRTupQ@google.com/
> > > >
> > > > Thanks for the pointer, I will have a look.
> > > >
> > > > The above exposes the "prio" of netfilter hooks, so someone
> > > > that needs their hook to run early on, say, before netfilters
> > > > nat engine, could just use INT_MIN.
> > > >
> > > > We could -- for nf bpf -- make the bpf_link fail if a hook
> > > > with the same priority already exists to avoid the "undefined
> > > > behaviour" here (same prio means register order decides what
> > > > hook function runs first ...).
> > > >
> > > > This could be relevant if you have e.g. one bpf program collecting
> > > > statistics vs. one doing drops.
> > > >
> > > > I'll dig though the thread and would try to mimic the tc link
> > > > mechanism as close as possible.
> > >
> > > While I think the direction the TC link discussion took is totally fi=
ne,
> > > TC has the advantage (IIUC) of being a somewhat isolated hook. Meanin=
g
> > > it does not make sense for a user to mix priority values && before/af=
ter
> > > semantics.
> > >
> > > Netfilter is different in that there is by default modules active wit=
h
> > > fixed priority values. So mixing in before/after semantics here could
> > > get confusing.
> >
> > I don't remember the details, so pls correct me, but last time I
> > looked, this priority was basically an ordering within a hook?
>
> Yeah, that is my understanding as well.
>
> > And there were a bunch of kernel-hardcoded values. So either that
> > whole story has to become a UAPI (so the bpf program knows
> > before/after which kernel hook it has to run), or we need some other
> > ordering mechanism.
>
> I'm not sure what you mean by "whole story" but netfilter kernel modules
> register via a priority value as well. As well as the modules the kernel
> ships. So there's that to consider.

Sorry for not being clear. What I meant here is that we'd have to
export those existing priorities in the UAPI headers and keep those
numbers stable. Otherwise it seems impossible to have a proper interop
between those fixed existing priorities and new bpf modules?
(idk if that's a real problem or I'm overthinking)

Because the problem as I see it is as follows:
Let's say I want to trigger before/after kernel module X. I need to
know its priority and it has to be stable.
Alternatively, there should be some way to query the priority of
module X so I can do +1/-1 (which is essentially "before X/after X"
semantics).

> (I'm not sure what's the story with bpf vs kernel
> > hooks interop, so maybe it's all moot?)
> > Am I missing something? Can you share more about why those fixed
> > priorities are fine?
>
> I guess I wouldn't say it's ideal (for all the reasons brought up in the
> previous discussion), but trying to use before/after semantics here
> would necessarily pull in a netfilter rework too, no? Or maybe there's
> some clever way to merge the two worlds and get both subsystems what
> they want.

Right, I don't have an answer here, just trying to understand whether
(as a side effect of those patches) we're really making those existing
priorities a UAPI or not :-)

> Thanks,
> Daniel
