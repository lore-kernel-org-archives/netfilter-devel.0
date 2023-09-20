Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F068CC04EB5
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 18:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjITSEg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 14:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjITSEg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 14:04:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70223B9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 11:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695233026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JlWY0iLpNB1o+3WA404OFt+JMpHRndNbyhdEkwQwG3M=;
        b=aSV5PYJqHzSjtl862DMIVgY2EmXn4wivsTQMKpcBHKFA3gqD/g9+lpH9td3eFlAW9zIAfX
        xZawqAAj6WDNFZpvDo4wVfvorMl6YKfN8xD/6DvIAlF6/TH96L99jdJSuCRtvShd0EcC8y
        Ktkpl3m0/99wzFIOMMeKYH1yC5q3hw0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-ckx-wE__OlWtWFLn6SmMCA-1; Wed, 20 Sep 2023 14:03:30 -0400
X-MC-Unique: ckx-wE__OlWtWFLn6SmMCA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3214d1d4bbcso5860f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 11:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695232999; x=1695837799;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JlWY0iLpNB1o+3WA404OFt+JMpHRndNbyhdEkwQwG3M=;
        b=oahsxbN97vXigqv/cB06LEe2rft9pTrgKQkenRdTgj6qnJRUnanqMrdC43eFGGP+Oh
         7yLrLRfeRBH2NxiwZuzk0KCScidALCSFppFD//Ei3zJQPGxRjvUVeCEM4vvVQzuWSy3j
         52/0kcsnbpxtRSsWzpyHiJDw7XxxZ27kbx2vD5j5uVoAs09PQGElP3qPAi3mUbYTJu9A
         Zp7ns8Eli0XM7Z8FQta4mA8VKqa9OxxzoIdmD0nkzbQBTWSGeiybOdfqjCsPZ+vmfKXM
         sw1Yah6MwBYggj40In9aYR00JFJOF8WhsaSgViFFWmY7G9e7DIR0n663OvROe5l/+xnM
         3gLA==
X-Gm-Message-State: AOJu0Yzr5GzGmJCr5I6kOKOjafYaYMt0zMtqBIyal43z44knMSpLJI7o
        X6zffrq1AQbPN200Huv6u7K2D+He7cR7U8p7rmwdW5WmQpJi7lUwb0NYew3zD9mBsfJjokHL+Fx
        C0TDgCmsq5KE+cXtfGmhr1WNaAoNV
X-Received: by 2002:adf:ec48:0:b0:317:630d:1e8e with SMTP id w8-20020adfec48000000b00317630d1e8emr2746328wrn.2.1695232998946;
        Wed, 20 Sep 2023 11:03:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7IkU29k3TAhFAuNbwZTVjxSPauYmLFZWedIWySi0h6LytSNOlJSc04D5OM36wiu7oqEJ5zw==
X-Received: by 2002:adf:ec48:0:b0:317:630d:1e8e with SMTP id w8-20020adfec48000000b00317630d1e8emr2746308wrn.2.1695232998597;
        Wed, 20 Sep 2023 11:03:18 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id r4-20020adfdc84000000b0031753073abcsm19043557wrj.36.2023.09.20.11.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 11:03:18 -0700 (PDT)
Message-ID: <754c07f7fc0a44d3619e51993c7a891a064ccdae.camel@redhat.com>
Subject: Re: [PATCH nft 3/4] all: add free_const() and use it instead of
 xfree()
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 20 Sep 2023 20:03:17 +0200
In-Reply-To: <ZQsitnx/cPf2cPk0@orbyte.nwl.cc>
References: <20230920131554.204899-1-thaller@redhat.com>
         <20230920131554.204899-4-thaller@redhat.com>
         <ZQr+F7ChyFfArBYQ@orbyte.nwl.cc> <ZQsYf3moTtXQytXX@calendula>
         <ZQsitnx/cPf2cPk0@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-20 at 18:49 +0200, Phil Sutter wrote:
> On Wed, Sep 20, 2023 at 06:06:23PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 20, 2023 at 04:13:43PM +0200, Phil Sutter wrote:
> > > On Wed, Sep 20, 2023 at 03:13:40PM +0200, Thomas Haller wrote:
> > > [...]
> > > > There are many places that rightly cast away const during free.
> > > > But not
> > > > all of them. Add a free_const() macro, which is like free(),
> > > > but accepts
> > > > const pointers. We should always make an intentional choice
> > > > whether to
> > > > use free() or free_const(). Having a free_const() macro makes
> > > > this very
> > > > common choice clearer, instead of adding a (void*) cast at many
> > > > places.
> > >=20
> > > I wonder whether pointers to allocated data should be const in
> > > the first
> > > place. Maybe I miss the point here? Looking at flow offload
> > > statement
> > > for instance, should 'table_name' not be 'char *' instead of
> > > using this
> > > free_const() to free it?
> >=20
> > The const here tells us that this string is set once and it gets
> > never
> > updated again, which provides useful information when reading the
> > code IMO.
>=20
> That seems like reasonable rationale. I like to declare function
> arguments as const too in order to mark them as not being altered by
> the
> function.
>=20
> With strings, I find it odd to do:
>=20
> const char *buf =3D strdup("foo");
> free((void *)buf);
>=20
> > I interpret from Phil's words that it would be better to
> > consolidate
> > this to have one single free call, in that direction, I agree.
>=20
> No, I was just wondering why we have this need for free_const() in
> the
> first place (i.e., why we declare pointers as const if we
> allocate/free
> them).


I think that we use free_const() is correct.


Look at "struct datatype", which are either immutable global instances,
or heap allocated (and ref-counted). For the most part, we want to
treat these instances (both constant and allocated) as immutable, and
the "const" specifier expresses that well.

Except, we still want to use ref/unref operations (which are called
datatype_get()/datatype_free()). Those operate on "const struct
datatype *", otherwise they would require a cast all the time (which is
cumbersome and on the contrary decreases type-safety).

It also means, the "refcnt" field of a "const struct datatype *" gets
mutated by ref/unref, and that's correct. See also, C++'s "mutable"
type qualifiers.

The free_const() usage is a consequence of that, and in many cases
correct. There might be places where we wrongly treat mutable data via
const-pointers. Those should be fixed. See "[PATCH nft 1/4] datatype:
don't return a const string from cgroupv2_get_path()" for an example.


Thomas

