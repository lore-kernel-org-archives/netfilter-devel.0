Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED0AC04FEE
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 19:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjITTtk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 15:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjITTtj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 15:49:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1184B9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 12:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695239324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l7hbhxXXZihpKGEVqyaXENrpfz6fNNLjTxE17Y/Ds6M=;
        b=JJrbismwVlvmeyYkhOsHt5x/sJbLnWKRqs9ev0v4JBwCyXa4fceNF1oMyCVF19pF7OImzq
        wC2MOZgFp0h3fmYinezn+RdQ5NXiIf+NOVKeHb1YT08G0FXNN8T5Q3pilk6b1uKG5Hwfzw
        bUxwYEroPvZXKlzsFbWLJV3DwYxPlAY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-1UG0t6TINFiIBpxDVPYbfg-1; Wed, 20 Sep 2023 15:48:43 -0400
X-MC-Unique: 1UG0t6TINFiIBpxDVPYbfg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40503cbb9b3so394445e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 12:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695239321; x=1695844121;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l7hbhxXXZihpKGEVqyaXENrpfz6fNNLjTxE17Y/Ds6M=;
        b=mHGzrJThW2zNXogU/T1gwg0XLWfspxvvcmOp0TKGwOTcMR/Dypp1/SIasHLVYVY/1K
         Zs9sXSj3N+4wPW1+y8VXUkn5quw/whwVCjWJFTQt3r8rtdcOlsTkPJHwVSrwLg6RUWby
         1hHktdUZaVu/xyAyY4mZwv/JCZRTi/+tWS6PwflDXZ7OaMKaQpY/1DTh4Ici12cR1r90
         asjYbTjCh5/mhY6fxiobZwUy20mNlhk133S/hpMpbm1Re8/kx6aIDEQuPhyrvJsyLcY4
         fSOzBMi8vry/CO58cs8UlNjVdGJBD+zBle1Euc5F6INhEReAtAumDnPGI9hJSIA0SF90
         5a2w==
X-Gm-Message-State: AOJu0Yx7TD7aaeTUEezy8yDVShDQfwi7WzusPbKNdWq7W+7FZ1HZ8a2k
        +GGAcZBn6nvttRBd7QBpU3vhVjheXzHHyj1vIlSvgu0bNi8SnWD9C6Yz43rghhIVg/DQtY83qXd
        GCeoK8G9Zf+YYBrl8DZ+mDj3Ab7Mv
X-Received: by 2002:a05:600c:4f12:b0:404:72f9:d59a with SMTP id l18-20020a05600c4f1200b0040472f9d59amr3384180wmq.0.1695239321451;
        Wed, 20 Sep 2023 12:48:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNC1I00DtluGVlHQga4fHLtft1Mp3/gt1r9wMXT1rmkfmzuDMMygOJgx29wIVuL/g1GZ1cKg==
X-Received: by 2002:a05:600c:4f12:b0:404:72f9:d59a with SMTP id l18-20020a05600c4f1200b0040472f9d59amr3384168wmq.0.1695239321129;
        Wed, 20 Sep 2023 12:48:41 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id m28-20020a05600c3b1c00b003ff013a4fd9sm2892991wms.7.2023.09.20.12.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 12:48:40 -0700 (PDT)
Message-ID: <f56d6b485b7154c8b8c24765ced9d222eabbd211.camel@redhat.com>
Subject: Re: [PATCH nft 3/4] all: add free_const() and use it instead of
 xfree()
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 20 Sep 2023 21:48:40 +0200
In-Reply-To: <ZQs4eu74k86+7FK0@orbyte.nwl.cc>
References: <20230920131554.204899-1-thaller@redhat.com>
         <20230920131554.204899-4-thaller@redhat.com>
         <ZQr+F7ChyFfArBYQ@orbyte.nwl.cc> <ZQsYf3moTtXQytXX@calendula>
         <ZQsitnx/cPf2cPk0@orbyte.nwl.cc>
         <754c07f7fc0a44d3619e51993c7a891a064ccdae.camel@redhat.com>
         <ZQs4eu74k86+7FK0@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-20 at 20:22 +0200, Phil Sutter wrote:
> On Wed, Sep 20, 2023 at 08:03:17PM +0200, Thomas Haller wrote:
> > On Wed, 2023-09-20 at 18:49 +0200, Phil Sutter wrote:
> > > On Wed, Sep 20, 2023 at 06:06:23PM +0200, Pablo Neira Ayuso
> > > wrote:
> > > > On Wed, Sep 20, 2023 at 04:13:43PM +0200, Phil Sutter wrote:
> > > > > On Wed, Sep 20, 2023 at 03:13:40PM +0200, Thomas Haller
> > > > > wrote:
> > > > > [...]
> > > > > > There are many places that rightly cast away const during
> > > > > > free.
> > > > > > But not
> > > > > > all of them. Add a free_const() macro, which is like
> > > > > > free(),
> > > > > > but accepts
> > > > > > const pointers. We should always make an intentional choice
> > > > > > whether to
> > > > > > use free() or free_const(). Having a free_const() macro
> > > > > > makes
> > > > > > this very
> > > > > > common choice clearer, instead of adding a (void*) cast at
> > > > > > many
> > > > > > places.
> > > > >=20
> > > > > I wonder whether pointers to allocated data should be const
> > > > > in
> > > > > the first
> > > > > place. Maybe I miss the point here? Looking at flow offload
> > > > > statement
> > > > > for instance, should 'table_name' not be 'char *' instead of
> > > > > using this
> > > > > free_const() to free it?
> > > >=20
> > > > The const here tells us that this string is set once and it
> > > > gets
> > > > never
> > > > updated again, which provides useful information when reading
> > > > the
> > > > code IMO.
> > >=20
> > > That seems like reasonable rationale. I like to declare function
> > > arguments as const too in order to mark them as not being altered
> > > by
> > > the
> > > function.
> > >=20
> > > With strings, I find it odd to do:
> > >=20
> > > const char *buf =3D strdup("foo");
> > > free((void *)buf);
> > >=20
> > > > I interpret from Phil's words that it would be better to
> > > > consolidate
> > > > this to have one single free call, in that direction, I agree.
> > >=20
> > > No, I was just wondering why we have this need for free_const()
> > > in
> > > the
> > > first place (i.e., why we declare pointers as const if we
> > > allocate/free
> > > them).
> >=20
> >=20
> > I think that we use free_const() is correct.
> >=20
> >=20
> > Look at "struct datatype", which are either immutable global
> > instances,
> > or heap allocated (and ref-counted). For the most part, we want to
> > treat these instances (both constant and allocated) as immutable,
> > and
> > the "const" specifier expresses that well.
>=20
> So why doesn't datatype_get() return a const pointer then?

Good point.

Also compare with=20

  char *strchr(const char *s, int c);

where it makes sense.

For datatype_get() it makes less sense. I will send a patch.


>  I don't find
> struct datatype a particularly good example here: datatype_free()
> does
> not require free_const() at all.

datatype_free() in the patch uses+requires free_const() twice:

=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7free_const(dtype->name);
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7free_const(dtype->desc);
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7free(dtype);


Maybe instead it should do:


void datatype_free(const struct datatype *dtype)
{
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7if (!dtype)
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=
=B7=C2=B7=C2=B7=C2=B7return;=20
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7if (!(dtype->flags & DTYPE_=
F_ALLOC))
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=
=B7=C2=B7=C2=B7=C2=B7return;

=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7assert(dtype->refcnt !=3D 0=
);

=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7if (--((struct datatype *)d=
type)->refcnt > 0)
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=
=B7=C2=B7=C2=B7=C2=B7return;

=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7free_const(dtype->name);
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7free_const(dtype->desc);
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7free_const(dtype);
}

but the principle is still the same.

>=20
> BTW: I found two lines in src/netlink.c reading:
>=20
> > datatype_free(datatype_get(dtype));
>=20
> Aren't those just fancy nops?

Indeed. Already fixed by
https://git.netfilter.org/nftables/commit/src/netlink.c?id=3D8519ab031d8022=
999603a69ee9f18e8cfb06645d




Thomas

