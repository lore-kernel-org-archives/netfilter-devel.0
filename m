Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618D5C6FA8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 20:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbjH2UAJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 16:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbjH2T7s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 15:59:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92D01B7
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 12:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693339139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QgQIdqJCKkSKgIzoz+//exMK2LEKeRgpHJoIJVOxDxM=;
        b=X3RPw+pc4Le9tVpPBR7Gjz7CWX2JizhX4Yu9NqM4n2cUgGYSBy4ssI1/jEkmWzENzDMvOi
        SN4bKMdbEfig5tA+8spwWNN8jLIBE2NVE5zEL+YHFq6E67bmHWOLPUKTE8R/KUb5B3oZUl
        ZjdjByvFrC/Sq/pauIuZ+reUdl80b7Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5--_parW9GM9OBepkxI1MOPQ-1; Tue, 29 Aug 2023 15:58:57 -0400
X-MC-Unique: -_parW9GM9OBepkxI1MOPQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-401d62c2de7so3819755e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 12:58:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693339136; x=1693943936;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QgQIdqJCKkSKgIzoz+//exMK2LEKeRgpHJoIJVOxDxM=;
        b=V7S3obUMt0npDeLlWgAqL0suARyZE6KofN+vlW481aPZhSR2XJdOGmce+iKKZ+zU0/
         nqsEEYLMWyKuSSNiKMHDeaO/V5j56MRGjRk9V29l6Oimf44VQmSSmt/H3MPqrM4HNdO7
         AMWmmixCFHJzIMifBaT7HQaC5u1hqY1SHGtBB3htcp1zlFQ1/Y3KANsPNK3wGpW8AOBQ
         9VJg4OXYWJ8hjx3aeUcaFNSoAucSbOq2jUYK+Z/q7TIZO+jhMrqKINHGu88t59wXbxsm
         GJqv/vzXBAZ0/YnrFdrmKJN0eON8AzvsgUs8/Bu9MB1COuAsmseUNrE6Pp2LGXkWjAvK
         kmSQ==
X-Gm-Message-State: AOJu0Yz+QJzB23vmEH8jMQet7+kXWBtPy0sJ2ec+ywxGxxMWs9kL6Clh
        mGbnXajDtxqisgow3FCTF/09bqunrxAjRr+qC2tp8vQrg6ejBjigUREO24VI5Yhmt15u1iqVYoz
        stq11t4cQywk3/dmEtxGnSU9NUWk9gFHYU1F6
X-Received: by 2002:a05:600c:5113:b0:3ff:8617:672b with SMTP id o19-20020a05600c511300b003ff8617672bmr238929wms.2.1693339135781;
        Tue, 29 Aug 2023 12:58:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFt7LdLL1QaMMDvoArXl98N4ALCihOg/FUkQpntlDTqb9kWS9GVzccYA0ZsnOdyfDIrpK4lkg==
X-Received: by 2002:a05:600c:5113:b0:3ff:8617:672b with SMTP id o19-20020a05600c511300b003ff8617672bmr238927wms.2.1693339135502;
        Tue, 29 Aug 2023 12:58:55 -0700 (PDT)
Received: from [10.0.0.168] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c1d9000b00401d8810c8bsm2548065wms.15.2023.08.29.12.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 12:58:54 -0700 (PDT)
Message-ID: <c452805919f688f15a95e52139c8686e1a6571a1.camel@redhat.com>
Subject: Re: [PATCH nft 5/5] datatype: check against negative "type"
 argument in datatype_lookup()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 29 Aug 2023 21:58:53 +0200
In-Reply-To: <ZO5DsA4eCnYkEWxC@calendula>
References: <20230829185509.374614-1-thaller@redhat.com>
         <20230829185509.374614-6-thaller@redhat.com> <ZO5Cnmck5tKCvVFE@calendula>
         <ZO5DsA4eCnYkEWxC@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-08-29 at 21:14 +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 29, 2023 at 09:10:26PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Aug 29, 2023 at 08:54:11PM +0200, Thomas Haller wrote:
> > > An enum can be either signed or unsigned (implementation
> > > defined).
> > >=20
> > > datatype_lookup() checks for invalid type arguments. Also check,
> > > whether
> > > the argument is not negative (which, depending on the compiler it
> > > may
> > > never be).
> > >=20
> > > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > > ---
> > > =C2=A0src/datatype.c | 2 +-
> > > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/src/datatype.c b/src/datatype.c
> > > index ba1192c83595..91735ff8b360 100644
> > > --- a/src/datatype.c
> > > +++ b/src/datatype.c
> > > @@ -87,7 +87,7 @@ const struct datatype *datatype_lookup(enum
> > > datatypes type)
> > > =C2=A0{
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0BUILD_BUG_ON(TYPE_MAX=
 & ~TYPE_MASK);
> > > =C2=A0
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (type > TYPE_MAX)
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if ((uintmax_t) type > TYP=
E_MAX)
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint=
32_t ?

The more straight forward way would be

    if (type < 0 || type > TYPE_MAX)

However, if the enum is unsigned, then the compiler might see that the
condition is never true and warn against that. It does warn, if "type"
were just an "unsigned int". I cannot actually reproduce a compiler
warning with the enum (for now).

The size of the enum is most likely int/unsigned (or smaller, with "-
fshort-enums" or packed). Is it on POSIX/Linux always guaranteed that
an int is 32bit? I think not, but I cannot find an architecture where
int is larger either. Also, if someone would add an enum value larger
than the 32 bit range, then the behavior is compiler dependent, but
most likely the enum type would be a 64 bit integer and
"uint"/"uint32_t" would not be the right check.

All of this is highly theoretical. But "uintmax_t" avoids all those
problems and makes fewer assumptions on what the enum actually is. Is
there a hypothetical scenario where it wouldn't work correctly?

>=20
> Another question: What warning does clang print on this one?
> Description does not specify.

this one isn't about a compiler warning. Sorry, I should not have
included it in this set.


Thomas

