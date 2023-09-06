Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6963EE14C3
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 23:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244836AbjIFXZg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 19:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbjIFXZe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 19:25:34 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1FC173B
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 16:25:31 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-58cd9d9dbf5so4611137b3.0
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2023 16:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1694042730; x=1694647530; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2kBOi6TalS0ex+1SxjRU4auFtqoVkK5v83q8840CGQ=;
        b=HtisTxbg0/jXajMbSUaZGVb2Ex03a07U0XO8yugtpQ3KkpCRALHle3SRN97vmwyKKo
         D08w0DjWdj1N76/b1PW9reLFp5P4iw3Vg+u1bzo07ilxFvrS1eQmqGrw/kUJ8CMSf4os
         jU2w8B9F+1DMjyoSFgTAjKDyz45zsA7+rMrHfOtSEGapA78OdA918lfLqc9180/J3mFu
         o1g9dRAdQ9v6l59xd7e/uVKyw/Z5LpCWt+Uzk08+zP2rZDGhZj45MPkzucnCvrSUc5F7
         dx7TWZm4Ktx+dgV7V+JoSP0Feyq5HcSglpTWrdNn4H9QSUVLaQjhadijOxuJXqWp4VuE
         fN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694042730; x=1694647530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p2kBOi6TalS0ex+1SxjRU4auFtqoVkK5v83q8840CGQ=;
        b=XEur/jsrwx+OtoILbFeAd9weFvmQjopXQ0h4ZPPRRKHrh1IS5k47CcEVvCn0+OLTy5
         RgRHMeDiMPpLPsSglvpAPbWT2jEC4gwPQAltEVAu84knOllqQf9ZnG6AWbVwLMafg1Qy
         1ElZxzAgJPUniApZuElbqEvfzMMyrtz0KOtAOLAUOAndwSBQBqVRwiqr9RBPW4dEFoq6
         wceAhxMs1by+goAj0qepasT5nI3pq/6UbMikyBHLkWhlni0jHr/xK5Ay9j5t3g+nf9T0
         eLKl1EKv8YNJIiR8mRzijzLghhBl20Y3eqmjalnj/rFuzCr+RpaieFLOiwViVFqEek3Y
         fDnA==
X-Gm-Message-State: AOJu0Yy3aeUu1QAueN1xH/OKkluVqhDOZ63WOBNNjWASuLnTFH/EO/yl
        gLFIQTpZ2IFyFNocuXa7kJVQH53PKIbBqjMrctPECycHPFRisC4=
X-Google-Smtp-Source: AGHT+IGirEgrnhB2m61RbZ3m1ra5wEtE6paUBVAAeaCtiB5DDurzRuSARCNaPckFTCq44U4w9iqSZTXu1BGwNnra/Fw=
X-Received: by 2002:a0d:e249:0:b0:583:821b:603a with SMTP id
 l70-20020a0de249000000b00583821b603amr1175263ywe.20.1694042730594; Wed, 06
 Sep 2023 16:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230906094202.1712-1-pablo@netfilter.org> <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
 <ZPhm1mf0GaeQUr0e@calendula> <ZPiyGC+TfRgyOabJ@orbyte.nwl.cc>
 <ZPjJAicFFam5AFIq@calendula> <CAHC9VhQ0n8Ezef8wYC7uV-MHccqHobYxoB3VYoC9TaGiFm9noQ@mail.gmail.com>
 <ZPjxnSg3/gDy25r0@orbyte.nwl.cc> <ZPj7cbtvF5SdaWrx@calendula>
 <CAHC9VhR5Mq76TQj-zKn4Y2=ehrsmoXUvq=zaM=zY7E9S-tu3Ug@mail.gmail.com> <ZPkE1VyCX1BNc76q@calendula>
In-Reply-To: <ZPkE1VyCX1BNc76q@calendula>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 6 Sep 2023 19:25:19 -0400
Message-ID: <CAHC9VhTGhTdaRpQj8sQZLeibWAA=2_SyUkSwPQvp2BLSBy3JGg@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 6, 2023 at 7:01=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
> On Wed, Sep 06, 2023 at 06:41:13PM -0400, Paul Moore wrote:
> > On Wed, Sep 6, 2023 at 6:21=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilt=
er.org> wrote:
> > > On Wed, Sep 06, 2023 at 11:39:41PM +0200, Phil Sutter wrote:
> > > > On Wed, Sep 06, 2023 at 03:56:41PM -0400, Paul Moore wrote:
> > > [...]
> > > > > If it is a bug, please submit a fix for this as soon as possible =
Pablo.
> > > >
> > > > Thanks for your support, but I can take over, too. The number of
> > > > notifications emitted even for a small ruleset is not ideal, also. =
It's
> > > > just a bit sad that I ACKed the patch already and so it went out th=
e
> > > > door. Florian, can we still put a veto there?
> > >
> > > Phil, kernel was crashing after your patch, this was resulting in a
> > > kernel panic when running tests here. I had to revert your patches
> > > locally to keep running tests.
> > >
> > > Please, just send an incremental fix to adjust the idx, revert will
> > > leave things in worse state.
> >
> > If we can get a fix out soon then I'm fine with that, if we can't get
> > a fix out soon then a revert may be wise.
>
> I believe it should be possible to fix this in the next -rc, which
> should be quick. If Phil is busy I will jump on this and I will keep
> you on Cc so you and Richard can review.

Great, thank you.

> I apologize for forgetting to Cc you in first place.

No worries :)

> > > Audit does not show chains either, which is not very useful to locate
> > > what where exactly the rules have been reset, but that can probably
> > > discussed in net-next. Richard provided a way to extend this if audit
> > > maintainer find it useful too.
> >
> > Richard was correct in saying that new fields must be added to the end
> > of the record.  The only correction I would make to Richard's comments
> > is that we tend to prefer that if a field is present in a record, it
> > is always present in a record; if there is no useful information to
> > log in that field, a "?" can be substituted for the value (e.g.
> > "nftfield=3D?").
>
> Thanks for clarification, hopefully this will help to explore
> extensions to include chain information in the logs. I think that
> might help users to understand better the kind of updated that
> happened in the Netfilter subsystem.

Great, I'll look forward to the patches.

--=20
paul-moore.com
