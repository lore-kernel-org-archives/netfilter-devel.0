Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D68E82CD0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 20:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjI0UMH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 16:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjI0UMG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 16:12:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1716193
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695845480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l8EGaTStu6LM7m93NsT2Q3Jg9KkD7+mkkXvbRdbXkj0=;
        b=Ifb1lh5phofR3G1C/zyRbiEpPHFLnZEitKPK6za85Gv6KorI2BsGaS/Dv+2TyOdtqP4y5J
        WYc6Bp0Ur+3Pnzuz4GZDy4jpJn79w3LPMLlSy+yxzrxjAopjVBWpkGMTnQxyf5wmE/x6jn
        9oNHPITC4iEFdhIHpX+Atn5cqr7QHR8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-CONbV5ASPim4g5KFzE3iaA-1; Wed, 27 Sep 2023 16:11:18 -0400
X-MC-Unique: CONbV5ASPim4g5KFzE3iaA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9ae660b4e41so268534566b.1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695845477; x=1696450277;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l8EGaTStu6LM7m93NsT2Q3Jg9KkD7+mkkXvbRdbXkj0=;
        b=GHoE5VS8sBaAegraClEBfTwD14hK8zFmL4QAH4748HDt/qxtwq9p/TmalXxWLoESRA
         tlqtf8CUfwE3HANfRCikyQC+Kdod1XePh2Q0+eE/iFxqRFc39eOenasfLk8JEry0dn0M
         AEBBgy0wuLWfAiGnSGlV93r+jVRcKTQfnnZ9BYWWgEybdY0LLlBd3OxfvziyJGsnxj9U
         TN/pu7VriB0hKFlHJScfzKb5XGtv1qEZLfWkHdjnFH6mSXoCDiqTdUQeLH/QP4nUVD09
         XaxhYuTqbPntFwcl7ejI0w4PB61bWf++B08hKCzCy0lcGo8thBN1ClkoBp7j7t1cTqma
         aEmg==
X-Gm-Message-State: AOJu0YxtCSQEuziai0DWKsxhqH8YFGgvZ69FDl6qdtNMzNGL4QW0wgjh
        eU1m8h2DMRXpPCoSDXTsJeMNR5xs8waw7JEMFEGUYB8Q69GvyouKXV2O+xR0BwUu312hd4P016/
        fMzcRoPUOkGpQE0K9LKSIo2IYofHLMTKhiawy
X-Received: by 2002:a17:906:73db:b0:9a6:5340:c331 with SMTP id n27-20020a17090673db00b009a65340c331mr2770349ejl.2.1695845477127;
        Wed, 27 Sep 2023 13:11:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUywgVeLi5aaPubD4bgh2m8KYroU1S7s2MRlO/MOYgINdzDMpRgZf5rBiw4bHkjDecocgejA==
X-Received: by 2002:a17:906:73db:b0:9a6:5340:c331 with SMTP id n27-20020a17090673db00b009a65340c331mr2770335ejl.2.1695845476768;
        Wed, 27 Sep 2023 13:11:16 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id ez23-20020a1709070bd700b009b285351817sm3425812ejc.116.2023.09.27.13.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 13:11:15 -0700 (PDT)
Message-ID: <c234813727e4cd5bf5fc4a5b4d4d80b0863c47f0.camel@redhat.com>
Subject: Re: [PATCH nft 2/3] nfnl_osf: rework nf_osf_parse_opt() and avoid
 "-Wstrict-overflow" warning
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 27 Sep 2023 22:11:15 +0200
In-Reply-To: <ZRR/lx1S3kPdk6Vu@calendula>
References: <20230927122744.3434851-1-thaller@redhat.com>
         <20230927122744.3434851-3-thaller@redhat.com> <ZRRbgRny2AHfvV5H@calendula>
         <07bdaa70fcecb26fe6638e10152d41239068571d.camel@redhat.com>
         <ZRRiK70d4FJUJgsP@calendula>
         <c746f59f24efcc610a883795c834728bfb86d651.camel@redhat.com>
         <ZRR/lx1S3kPdk6Vu@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-27 at 21:16 +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 27, 2023 at 07:50:27PM +0200, Thomas Haller wrote:
>=20
>=20
> > IMO the netfilter projects should require contributors to provide
> > tests
> > (as sensible). That is, tests that are simply invoked via `make
> > check`
> > and don't require to build special features in the kernel
> > (CONFIG_NFT_OSF).
>=20
> You mean, some way to exercise userspace code without involving the
> kernel at all.

Yes, the relevant part is parsing some strings. That should be tested
in isolation. Or just to validate the pf.os file...

>=20
> > I have patches that would add unit tests to the project (merely as
> > a
> > place where more unit tests could be added). I will add a test
> > there.
>=20
> We have tests/py/ as unit tests, if that might look similar to what
> you have in mind? Or are you thinking of more tests/shell/ scripts?

Those only use the public API of libnftables.so. What would be also
useful, is to statically link against the code and have more immediate
access.

Also, currently they don't unshare and cannot run rootless. That should
be fixed by extending tests/shell/run-tests.sh script. Well, you
already hack that via `./tests/shell/run-tests.sh ./tests/py/nft-
test.py`, but this should integrate better.

It's waiting on the WIP branch:
https://gitlab.freedesktop.org/thaller/nftables/-/commits/th/no-recursive-m=
ake
https://gitlab.freedesktop.org/thaller/nftables/-/blob/545f40babb90584fd188=
ebe80a1103b93ba49707/tests/unit/test-libnftables-static.c#L177

>=20

> > But that is based on top of "no recursive make", and I'd like to
> > get
> > that changed first.
>=20
> I would like to make a release before such change is applied, build
> infrastructure and python support was messy in the previous release.
> Then we look into this, OK?

Sounds great. Thank you.


Thomas

