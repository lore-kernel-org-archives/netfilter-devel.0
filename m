Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCA5EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 14:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjGJOln (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 10:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjGJOlm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 10:41:42 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A66ED7
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 07:41:41 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3fb4146e8fcso33826935e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 07:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1689000100; x=1691592100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8GuwJuOOZEg1/5PpxPFR2vnnRv3sKbbFroCSn0MhxRY=;
        b=jgayB28naWOZg+hEAOIyr9gRx+wApXDQEa59QsOcWG8LP6i4JzxHz0+Cg2y12wF5r6
         O5Z+6T+zFe7ZRSbN2RNStktmXIO1yaUWHatgNy0qQqH9gJVzFEtSNAHnEtStvtHPieI1
         sFKgjW9LWTtc8rk4QGwpqonf/xW/iZpnrQbm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689000100; x=1691592100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GuwJuOOZEg1/5PpxPFR2vnnRv3sKbbFroCSn0MhxRY=;
        b=WvakfTL4C/7PxoUn1eSgupdBma344dfcpYnsYd8HyBW1NQdWrJKCntNlRU8fRbl7Rp
         lWXEapsy8F4W2zhoFjZ5sxmZzzRuLhzCtEe5MbOksJcaq6gazE3UvfFhNDu0+zmhA2Kf
         8beTgaErzB2RBUSSfMxMoh5LQy5kPrhYLTl06fOm4BwKZgkqEXZv01sBBiHzfUGYPYHW
         SWY8B7Stz51jTNK0p/OPbeUvuyNulUTL4FT60AswcKsMiHjPuh/xpBmd/iO2ejXUhfXO
         VAdgqepBlXRyGiJfZDm2oktUNDwjs0qs72cmuuXyHNH4xfyQ4k0DsamaOY6iFeOpFjp1
         2wQA==
X-Gm-Message-State: ABy/qLaqAdfubYxkMvhHwx5Daqx35kxlcW/oCOTdoasz5XNfL5GbqIg8
        44nCU3RyLAEk9lMWBPz/ySKKhOlS+N3e8TDGFOJpdmxy1FzU3BU+
X-Google-Smtp-Source: APBJJlGy8ZviPj0wZzaDpk5kkOPgjOpSAP+nsQl+KZVpu5Bemx34mNZ2bsuxe5yGp8orWRisg/p8cuFLZRg69eU9d+0=
X-Received: by 2002:a7b:cd1a:0:b0:3fb:c075:b308 with SMTP id
 f26-20020a7bcd1a000000b003fbc075b308mr12148322wmj.12.1689000099753; Mon, 10
 Jul 2023 07:41:39 -0700 (PDT)
MIME-Version: 1.0
References: <CA+9S74jbOefRzu1YxUrXC7gbYY8xDKH6QNJBuAQoNnnLODxWrg@mail.gmail.com>
 <20230710112135.GA12203@breakpoint.cc> <20230710124950.GC12203@breakpoint.cc>
In-Reply-To: <20230710124950.GC12203@breakpoint.cc>
From:   Igor Raits <igor@gooddata.com>
Date:   Mon, 10 Jul 2023 16:41:27 +0200
Message-ID: <CA+9S74h4ME7sxt7L1VcU+hPXj1H-cWwTcrEsyyrjSAHx_UxCwA@mail.gmail.com>
Subject: Re: ebtables-nft can't delete complex rules by specifying complete
 rule with kernel 6.3+
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Florian,

On Mon, Jul 10, 2023 at 2:49=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Florian Westphal <fw@strlen.de> wrote:
> > Igor Raits <igor@gooddata.com> wrote:
> > > Hello,
> > >
> > > We started to observe the issue regarding ebtables-nft and how it
> > > can't wipe rules when specifying full rule. Removing the rule by inde=
x
> > > works fine, though. Also with kernel 6.1.y it works completely fine.
> > >
> > > I've started with 1.8.8 provided in CentOS Stream 9, then tried the
> > > latest git version and all behave exactly the same. See the behavior
> > > below. As you can see, simple DROP works, but more complex one do not=
.
> > >
> > > As bugzilla requires some special sign-up procedure, apologize for
> > > reporting it directly here in the ML.
> >
> > Thanks for the report, I'll look into it later today.
>
> Its a bug in ebtables-nft, it fails to delete the rule since
>
> 938154b93be8cd611ddfd7bafc1849f3c4355201,
> netfilter: nf_tables: reject unbound anonymous set before commit phase
>
> But its possible do remove the rule via
> nft delete rule .. handle $x
>
> so the breakge is limited to ebtables-nft.

Thanks for confirmation and additional information regarding where
exactly the issue was introduced.
The ebtables-nft (well, ebtables in general) is heavily used by the
OpenStack Neutron (in linuxbridge mode), so this breaks our setup
quite a bit. Would you recommend to revert kernel change or would you
have the actual fix soon (ebtables-nft or kernel)?
