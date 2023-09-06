Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58F6EE14AA
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240981AbjIFWl3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 18:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236638AbjIFWl2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 18:41:28 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0B119AE
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 15:41:25 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3ab2436b57dso232573b6e.0
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2023 15:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1694040084; x=1694644884; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JGcf3/jy/OL1kTP468GnbAL98Xlte4ztv4Gx1oQ5nJo=;
        b=NNH5uApljeB3i3cR5Xt6q1z0z8OocAwc7WfmbaLdHMF/75M4YqN1bgB039o5Es2NYv
         lXodYBM7LMRh6NkMcE/8fiMKKnkrptYZ/9wcpBQ8Wud3oEQQVffAO8FPgY69hTKevSP3
         DWRm15EctHMD5SodrUHQaF/TG9nN40GeUnxdRjf4ZaX+nQBlJNHbYbxPPyWngeMwCFJ5
         2Fe/iosTjsEidnG1Ypk89jBDd9ivxxysbVUpBVaGII1xtbUnFavpHwqEgCDMIOW5nBJZ
         2FGTnaJ7jNV5PYpk5aEBwcDk/TQK0bLOTXvneZEk9Ggo+Y04F6sg9NhIgY5KXt4xe33o
         ThxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694040084; x=1694644884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JGcf3/jy/OL1kTP468GnbAL98Xlte4ztv4Gx1oQ5nJo=;
        b=fFBJXUjOBbS3+7K7xFw71VFriHlRKaD42yjRS4WlZdJSBLQbmGAII/o/eDuUfm/vRE
         O+Tl2Vx+BjOlnrU9dFlsxztqakDIoKb0fV28Nbjcs/Yfp4YNWqCL02ErPPgFnNebH2jp
         Q6fi2/kJzglsPQISglYJ234jwBiuxDVGScnQP6pvqLlUBnF33FdEwHL2EZc2bVuqoIKh
         vdIZyWMmLbqsvUpLUBbjrX/q+oLZm4YfLDBrfz2uweKWYJvKpEPaJDaKPKzy26qDyHt8
         F0pm1fT58t3Yk84+XVLKVdkf6UKuAX+rGrgjjmeEKi4LxAHqfG6yHvaEbk5aVz5emduA
         5SiA==
X-Gm-Message-State: AOJu0YxJ9TvdrCkywV8PpBzhfrafTIc9siBagQZkl5Nbk/D5C4xywBO2
        mtfxhDySRqkXNkbDIbpgq4SdBJU1npLCCnMMsT96CBuHnIUEAQg=
X-Google-Smtp-Source: AGHT+IEQENZ2guEQYdVu0iK8eBS0yfPpL9NuTs5TnE1jOjBy/twYvy5fULgxhBCFEQuQAVsZkr8Fc+7BRQH9R7y4oh4=
X-Received: by 2002:a05:6358:990e:b0:139:b4c0:93c with SMTP id
 w14-20020a056358990e00b00139b4c0093cmr4987577rwa.5.1694040084494; Wed, 06 Sep
 2023 15:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230906094202.1712-1-pablo@netfilter.org> <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
 <ZPhm1mf0GaeQUr0e@calendula> <ZPiyGC+TfRgyOabJ@orbyte.nwl.cc>
 <ZPjJAicFFam5AFIq@calendula> <CAHC9VhQ0n8Ezef8wYC7uV-MHccqHobYxoB3VYoC9TaGiFm9noQ@mail.gmail.com>
 <ZPjxnSg3/gDy25r0@orbyte.nwl.cc> <ZPj7cbtvF5SdaWrx@calendula>
In-Reply-To: <ZPj7cbtvF5SdaWrx@calendula>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 6 Sep 2023 18:41:13 -0400
Message-ID: <CAHC9VhR5Mq76TQj-zKn4Y2=ehrsmoXUvq=zaM=zY7E9S-tu3Ug@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
To:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 6, 2023 at 6:21=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
> On Wed, Sep 06, 2023 at 11:39:41PM +0200, Phil Sutter wrote:
> > On Wed, Sep 06, 2023 at 03:56:41PM -0400, Paul Moore wrote:
> [...]
> > > If it is a bug, please submit a fix for this as soon as possible Pabl=
o.
> >
> > Thanks for your support, but I can take over, too. The number of
> > notifications emitted even for a small ruleset is not ideal, also. It's
> > just a bit sad that I ACKed the patch already and so it went out the
> > door. Florian, can we still put a veto there?
>
> Phil, kernel was crashing after your patch, this was resulting in a
> kernel panic when running tests here. I had to revert your patches
> locally to keep running tests.
>
> Please, just send an incremental fix to adjust the idx, revert will
> leave things in worse state.

If we can get a fix out soon then I'm fine with that, if we can't get
a fix out soon then a revert may be wise.

> Audit does not show chains either, which is not very useful to locate
> what where exactly the rules have been reset, but that can probably
> discussed in net-next. Richard provided a way to extend this if audit
> maintainer find it useful too.

Richard was correct in saying that new fields must be added to the end
of the record.  The only correction I would make to Richard's comments
is that we tend to prefer that if a field is present in a record, it
is always present in a record; if there is no useful information to
log in that field, a "?" can be substituted for the value (e.g.
"nftfield=3D?").

--=20
paul-moore.com
