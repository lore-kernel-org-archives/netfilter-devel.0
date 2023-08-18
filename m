Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EE3EE4982
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 17:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379146AbjHRRjt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 13:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379152AbjHRRjl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 13:39:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5001F30F1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 10:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692380332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VN8fgf/+CvrqGmSLQ2M1vHanKTTIUU+/SxN1vM6YLpE=;
        b=dSKvREZXQiG4WyjhNxFj/e/aD8ZIbLPiam7qpzNoQ/EN/Kyhe8oa5ngThbyYbaAIHAuNlV
        X0pu7mzDycHVzHTgKZqJiH2JGA2MCdSyGI2FXdgQxexVsyN3XAWmeX5k66KgF3Llpqta+n
        doAXaFlCT8/DwA3uxXow7gNWetQxEwM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-V4S7puC9MXeZaK6bBHStdQ-1; Fri, 18 Aug 2023 13:38:50 -0400
X-MC-Unique: V4S7puC9MXeZaK6bBHStdQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fe14dc8d7aso2530795e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 10:38:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692380329; x=1692985129;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VN8fgf/+CvrqGmSLQ2M1vHanKTTIUU+/SxN1vM6YLpE=;
        b=U2LqTGU6VdPqpRnmWHmCPwSO4E+9t2ywFWB6DK5mJyzVXZ86OdH7iCuVBpkaPXEojP
         GRTWq2Cx89UJ9/5Z4t8tYRbjYpEGIdsJUW3ivR7bs3gn/DItrFTNmRlo4dp1tbNBBPt1
         XkZzS5OJ6tokeMYPHQcjdrK8Pf78ktIIhpSReVKXpckgCNFaxohHz4RR/bzBZCVFMEnD
         TfqgBW9sKA56iR1Hd7tkPZVkxcS45UZuyhT181foiKbIZ6OO8MlcBP2kDUMr5DTF7mKY
         0JCn3Y+LlReN1QRhpR6ZJwY6w/FoPOrchY0Gz3tcJX7kOlzd0WvIg33InmKaoByJSud7
         JWCg==
X-Gm-Message-State: AOJu0YxfTIcc0dvBMhjy0agrCXpHHkFnxJdFouz4ObMb8sgfAi3Q7soC
        Da//URC7gXwGXwet9ef8/g2cjHKAtn5B6H+k7ouUKGewLTAwbutYAHZOu0JsPXsvUxXxXlIBuoZ
        /A45OjhjCVjrUx++ZZeN4gIUgX967KmL37t55
X-Received: by 2002:a05:600c:4fce:b0:3fb:aadc:41dc with SMTP id o14-20020a05600c4fce00b003fbaadc41dcmr2719666wmq.4.1692380329175;
        Fri, 18 Aug 2023 10:38:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEWrBu0KOVNmws6qn9JeTgjjoN0HSpVuvOmYdTTQJw8qkj0SOknUWQexlH5uvL7DpS9XLLNg==
X-Received: by 2002:a05:600c:4fce:b0:3fb:aadc:41dc with SMTP id o14-20020a05600c4fce00b003fbaadc41dcmr2719654wmq.4.1692380328818;
        Fri, 18 Aug 2023 10:38:48 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id j16-20020a056000125000b0031779a6b451sm3427718wrx.83.2023.08.18.10.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 10:38:48 -0700 (PDT)
Message-ID: <33dc05e3d619161d8a28cb6b0216a7c61489ea80.camel@redhat.com>
Subject: Re: [nft PATCH v2] src: use reentrant
 getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 18 Aug 2023 19:38:47 +0200
In-Reply-To: <ZN+X76/KObT2EOrg@calendula>
References: <20230810123035.3866306-1-thaller@redhat.com>
         <20230818091926.526246-1-thaller@redhat.com> <ZN9AnetYNCRBODhb@calendula>
         <5541fc793b4346e2f00eaf3e7f18c754053d8d00.camel@redhat.com>
         <ZN+X76/KObT2EOrg@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-08-18 at 18:10 +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 18, 2023 at 04:14:01PM +0200, Thomas Haller wrote:
> > Hi Pablo,
> >=20
> > On Fri, 2023-08-18 at 11:57 +0200, Pablo Neira Ayuso wrote:
> > >=20
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct protoent *p;
> > > > -
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!nft_output_num=
eric_proto(octx)) {
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0p =3D getprotobynumber(mpz_get_uint8(expr-
> > > > >value));
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (p !=3D NULL) {
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0nft=
_print(octx, "%s", p->p_name);
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0char name[1024];
> > >=20
> > > Is there any definition that could be used instead of 1024. Same
> > > comment for all other hardcoded buffers. Or maybe add a
> > > definition
> > > for
> > > this?
> >=20
> > Added defines instead. See v3.
> >=20
> > [...]
> >=20
> > > > =C2=A0#include <nftables.h>
> > > > =C2=A0#include <utils.h>
> > > > @@ -105,3 +106,90 @@ int round_pow_2(unsigned int n)
> > > > =C2=A0{
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 1UL << fls(n=
 - 1);
> > > > =C2=A0}
> > > > +
> > >=20
> > > Could you move this new code to a new file instead of utils.c? We
> > > are
> > > slowing moving towards GPLv2 or any later for new code. Probably
> > > netdb.c or pick a better name that you like.
> >=20
> > This request leaves me with a lot of choices. I made them, but I
> > guess
> > you will have something to say about it. See v3.
> >=20
> > >=20
> > > > +bool nft_getprotobynumber(int proto, char *out_name, size_t
> > > > name_len)
> > > > +{
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const struct protoent *r=
esult;
> > > > +
> > > > +#if HAVE_DECL_GETPROTOBYNUMBER_R
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct protoent result_b=
uf;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0char buf[2048];
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int r;
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0r =3D getprotobynumber_r=
(proto,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &result_buf,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 buf,
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(buf),
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (struct protoent **) &result);
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (r !=3D 0 || result !=
=3D &result_buf)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0result =3D NULL;
> > > > +#else
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0result =3D getprotobynum=
ber(proto);
> > > > +#endif
> > >=20
> > > I'd suggest wrap this code with #ifdef's in a helper function.
> >=20
> > I don't understand. nft_getprotobynumber() *is* that helper
> > function to
> > wrap the #if. This point is not addressed by v3 (??).
>=20
> I mean, something like a smaller function:
>=20
> static struct __nft_getprotobynumber(...)
>=20
> that is wraps this code above and it returns const struct protoent.
> This helper function is called from nft_getprotobynumber().
>=20
> But it is fine as it is, this is just a bit of bike shedding.
>=20

I see. Yes, possible.

I don't find that very useful, because the idea is that
nft_getprotobyname() etc. wraps the underlying libc functions and
contains the #if parts. And there shall be no other place that directly
call getprotobyname()/getprotobyname_r(). So `__nft_getprotobynumber()`
would be a static function with only one caller (and no plan to ever
have more).


Thomas

