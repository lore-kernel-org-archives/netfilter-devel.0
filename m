Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E378C83F21
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbjH3Si5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242338AbjH3IJq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 04:09:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC241A2
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 01:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693382936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzXx3X9/khqwaFN35JNpDR6BNTwli+kLzXycUqcbgTo=;
        b=IW0Rua1lbidDFuZQDGHdRpWqw6NPHs8sYTSsF+0mFntYkmcDX8CPpH3ffUqtNzzFjLZf5S
        8RVcLbUlzWOLGDEgMGf4BXxZpfuGQN9994crj2P1zpRQN3EF9SORQJRffMNRyadW9N5gxv
        IxcMW1PgeEwpMPripdg1Yg+zrWqdPLg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-KrOS16DPNYOPnRfXxzqUoA-1; Wed, 30 Aug 2023 04:08:54 -0400
X-MC-Unique: KrOS16DPNYOPnRfXxzqUoA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-401d62c2de7so5726825e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 01:08:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693382933; x=1693987733;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hzXx3X9/khqwaFN35JNpDR6BNTwli+kLzXycUqcbgTo=;
        b=Krf1+WYJ95f+MpyfW/uyr1iXcLaE18HBBtL66qQHbvajyV8CKMHaTkINwiVkSRn8HB
         hpdBP0mxnHbnZlYs+73WrMiSUNhcwrMOoQxUjbfWbTv98r4FEL/zZ675VsN/KW/UD7l8
         2VK6WVIlP/bx9mJyZGtsML2KYopvyDRyQZdQT7OplKIxuQI7YQI+j+gmSuzo0WsJulix
         Rw6A8w05hYvxm45SfteVA19ERdO8oBc63vCLRo/Uqi+0SFIvq2ZH1TFNMe5gPFFij+c9
         hfyP2aXUnIy32nfem9hVhtoS7vxRce9AtnmAmbZsdqBFl/8A9RmAV2Namy0tdzaXTLJl
         M1Pw==
X-Gm-Message-State: AOJu0Ywi7BoxKsKfC3/eY3TgL+PWOFZxv70/iIzJQbpM6Irk/o4TXdg8
        RhIgwxqtscnYVuMTPnlcqz5Fq92WgyYXUcnLnJ1bYpPkUNC1uREo/M/2EVb5szaMpMzzI/bw3dq
        bWipKJfFsVkC1PgJcGknDALh/zdjg0enQrv+z
X-Received: by 2002:a05:600c:1d23:b0:401:b53e:6c3e with SMTP id l35-20020a05600c1d2300b00401b53e6c3emr1251314wms.1.1693382932887;
        Wed, 30 Aug 2023 01:08:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoX9WnfA6TeyCsbTIkzj1uqlSbGI/6xo9Xd5gk6D8xryOTNnxWZDxmU8CdTG0q6KWc9Y/MbQ==
X-Received: by 2002:a05:600c:1d23:b0:401:b53e:6c3e with SMTP id l35-20020a05600c1d2300b00401b53e6c3emr1251300wms.1.1693382932400;
        Wed, 30 Aug 2023 01:08:52 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id 19-20020a05600c235300b003feea62440bsm1416295wmq.43.2023.08.30.01.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 01:08:51 -0700 (PDT)
Message-ID: <29aee24e1fb3e7b273b48ee3d735f182c62a0d92.camel@redhat.com>
Subject: Re: [PATCH nft 5/5] datatype: check against negative "type"
 argument in datatype_lookup()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 30 Aug 2023 10:08:50 +0200
In-Reply-To: <ZO7zuKiWk3x7E5bS@calendula>
References: <20230829185509.374614-1-thaller@redhat.com>
         <20230829185509.374614-6-thaller@redhat.com> <ZO5Cnmck5tKCvVFE@calendula>
         <ZO5DsA4eCnYkEWxC@calendula>
         <c452805919f688f15a95e52139c8686e1a6571a1.camel@redhat.com>
         <ZO7zuKiWk3x7E5bS@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-08-30 at 09:46 +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 29, 2023 at 09:58:53PM +0200, Thomas Haller wrote:
> > On Tue, 2023-08-29 at 21:14 +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Aug 29, 2023 at 09:10:26PM +0200, Pablo Neira Ayuso
> > > wrote:
> > > > On Tue, Aug 29, 2023 at 08:54:11PM +0200, Thomas Haller wrote:
> > > > > An enum can be either signed or unsigned (implementation
> > > > > defined).
> > > > >=20
> > > > > datatype_lookup() checks for invalid type arguments. Also
> > > > > check,
> > > > > whether
> > > > > the argument is not negative (which, depending on the
> > > > > compiler it
> > > > > may
> > > > > never be).
> > > > >=20
> > > > > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > > > > ---
> > > > > =C2=A0src/datatype.c | 2 +-
> > > > > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/src/datatype.c b/src/datatype.c
> > > > > index ba1192c83595..91735ff8b360 100644
> > > > > --- a/src/datatype.c
> > > > > +++ b/src/datatype.c
> > > > > @@ -87,7 +87,7 @@ const struct datatype *datatype_lookup(enum
> > > > > datatypes type)
> > > > > =C2=A0{
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0BUILD_BUG_ON(TYPE=
_MAX & ~TYPE_MASK);
> > > > > =C2=A0
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (type > TYPE_MAX)
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if ((uintmax_t) type >=
 TYPE_MAX)
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
uint32_t ?
> >=20
> > The more straight forward way would be
> >=20
> > =C2=A0=C2=A0=C2=A0 if (type < 0 || type > TYPE_MAX)
> >=20
> > However, if the enum is unsigned, then the compiler might see that
> > the
> > condition is never true and warn against that. It does warn, if
> > "type"
> > were just an "unsigned int". I cannot actually reproduce a compiler
> > warning with the enum (for now).
>=20
> Then, better keep it back?
>=20
> > The size of the enum is most likely int/unsigned (or smaller, with
> > "-
> > fshort-enums" or packed). Is it on POSIX/Linux always guaranteed
> > that
> > an int is 32bit? I think not, but I cannot find an architecture
> > where
> > int is larger either. Also, if someone would add an enum value
> > larger
> > than the 32 bit range, then the behavior is compiler dependent, but
> > most likely the enum type would be a 64 bit integer and
> > "uint"/"uint32_t" would not be the right check.
>=20
> I don't expect to ever have such a large number of types.
> Specifically
> because there are API restrictions that apply in this case.
>=20
> > All of this is highly theoretical. But "uintmax_t" avoids all those
> > problems and makes fewer assumptions on what the enum actually is.
> > Is
> > there a hypothetical scenario where it wouldn't work correctly?
>=20
> I was trying to figure out what this is fixing.
>=20
> > > Another question: What warning does clang print on this one?
> > > Description does not specify.
> >=20
> > this one isn't about a compiler warning. Sorry, I should not have
> > included it in this set.
>=20
> This TYPE_MAX will not ever become very large to require 64-bits.

TYPE_MAX is not relevant.

> With an implementation where enum is taken as signed, then this
> should
> be sufficient too:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0 if (type > TYPE_MAX)
>=20
> If this is not fixing up anything right now, I would prefer to keep
> this back.

I don't think it suffices. The following fail the assertion (or would
access out of bounds).


diff --git c/include/datatype.h i/include/datatype.h
index 9ce7359cd340..7d3b6b20d27c 100644
--- c/include/datatype.h
+++ i/include/datatype.h
@@ -98,7 +98,8 @@ enum datatypes {
     TYPE_TIME_HOUR,
     TYPE_TIME_DAY,
     TYPE_CGROUPV2,
-    __TYPE_MAX
+    __TYPE_MAX,
+    __TYPE_FORCE_SIGNED =3D -1,
 };
 #define TYPE_MAX        (__TYPE_MAX - 1)
=20
diff --git c/src/datatype.c i/src/datatype.c
index ba1192c83595..1ff8a4a08551 100644
--- c/src/datatype.c
+++ i/src/datatype.c
@@ -89,6 +89,7 @@ const struct datatype *datatype_lookup(enum datatypes
type)
=20
     if (type > TYPE_MAX)
          return NULL;
+    assert(type !=3D (enum datatypes) -1);
     return datatypes[type];
 }
=20
diff --git c/src/libnftables.c i/src/libnftables.c
index 9c802ec95f27..7e60d1a18d39 100644
--- c/src/libnftables.c
+++ i/src/libnftables.c
@@ -203,6 +203,8 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 #endif
     }
=20
+    datatype_lookup(-1);
+
     ctx =3D xzalloc(sizeof(struct nft_ctx));
     nft_init(ctx);
=20



If you expect that "type" is always valid, then there is no need to
check against >TYPE_MAX. If you expect that it might be invalid, it
seems prudent to also check against negative values.



Thomas

