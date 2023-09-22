Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAC1CD4F2B
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Sep 2023 08:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjIVIwd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 04:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjIVIwa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 04:52:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B05FB
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 01:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695372694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NPBJaC9yBqUsRJcMYe8ZhfE4OMgeBkzblHgrQ69SmPo=;
        b=gtyAZHu4LZ7m5lqubKXq1mSUa/nztupryZOLgQxmd1yurTjYWtGu8AQ5vWQYT3pPYP6I+G
        IgWdbjQ7WAhQQIK6xZM0n8MpExbUFgp+v178dakL9wn09wA4h2FZ+0JnCFe7Smy3yb+s5w
        j6FF0au4GN3OEdwoUzgDCOuBRDpE2S0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-Rzr5UaMJOaK6H9OIeOTNNw-1; Fri, 22 Sep 2023 04:51:32 -0400
X-MC-Unique: Rzr5UaMJOaK6H9OIeOTNNw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-320089dad3cso56034f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 01:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695372691; x=1695977491;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NPBJaC9yBqUsRJcMYe8ZhfE4OMgeBkzblHgrQ69SmPo=;
        b=D0N/cdNc+2gqkREIqiBEZ0PHV2Q2SOLuHFj7Wkn4yvDBDTgrIfROn9DEX6QHOL3gEE
         Es5WfSisMeivW6r0P2nb0mBvn1h6w4y+ToYG4GJNCLgSKyqVSeU+5e5SMxgYgFj8r6/9
         ykdJ6s5+2RKKxeH6oEOo0z6+ojUUrZxHiiLfe+rGIEDZspGqWytd7+K8qR8rCmwfiZ9Y
         sz44a37NiqfTI5lDj/clE7MF8+XRaRJsQz1wJ8gl7DqeLh17/k79zfhEi11Nzd96+gI3
         uAz3NuG3KMQWxKBczFnrObGvmTxY7HAL57kQUexruiVLC9XH8t1fSq2lbmb07qPGehgT
         RdaA==
X-Gm-Message-State: AOJu0YxQ3vRGEJJFlnKaxjq0j1FNqdHxMET4Il85Lv3P2IiNi/qkyIqq
        Gtfrs8su0PVRuYonwj4AZB6X+xSfNuJdipWKySYjBAEfM3uJ067I7qM5LUdAtkDbakYQJa4wWHI
        Y8Cc4vXAyPALNYSm51KKrTm598CoUrjxFISK7
X-Received: by 2002:a5d:500d:0:b0:317:3d36:b2c1 with SMTP id e13-20020a5d500d000000b003173d36b2c1mr7041104wrt.7.1695372691259;
        Fri, 22 Sep 2023 01:51:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQ0YAAyV0gyP+nP0lp3L6/pijQBfQ3+yq+9B4axCXmxdGKxHNwcJEiKGOL5f2pb7RASp6tIA==
X-Received: by 2002:a5d:500d:0:b0:317:3d36:b2c1 with SMTP id e13-20020a5d500d000000b003173d36b2c1mr7041088wrt.7.1695372690827;
        Fri, 22 Sep 2023 01:51:30 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id l16-20020a5d4bd0000000b003216a068d2csm3908217wrt.24.2023.09.22.01.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 01:51:30 -0700 (PDT)
Message-ID: <b23b4f63e2a5a5296820c66262c16b824ea1b6fe.camel@redhat.com>
Subject: Re: [PATCH nft 3/9] datatype: drop flags field from datatype
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 22 Sep 2023 10:51:29 +0200
In-Reply-To: <ZQxRziOfXho5SZ7e@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
         <20230920142958.566615-4-thaller@redhat.com> <ZQs1msEk15D687Rn@calendula>
         <546258d1a67ca455e0f7fdcce4c58c587324e798.camel@redhat.com>
         <ZQxRziOfXho5SZ7e@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-09-21 at 16:23 +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 20, 2023 at 09:23:46PM +0200, Thomas Haller wrote:
> > On Wed, 2023-09-20 at 20:10 +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Sep 20, 2023 at 04:26:04PM +0200, Thomas Haller wrote:
> > > > Flags are not always bad. For example, as a function argument
> > > > they
> > > > allow
> > > > easier extension in the future. But with datatype's "flags"
> > > > argument and
> > > > enum datatype_flags there are no advantages of this approach.
> > > >=20
> > > > - replace DTYPE_F_PREFIX with a "bool f_prefix" field. This
> > > > could
> > > > even
> > > > =C2=A0 be a bool:1 bitfield if we cared to represent the informatio=
n
> > > > with
> > > > =C2=A0 one bit only. For now it's not done because that would not
> > > > help
> > > > reducing
> > > > =C2=A0 the size of the struct, so a bitfield is less preferable.
> > > >=20
> > > > - instead of DTYPE_F_ALLOC, use the refcnt of zero to represent
> > > > static
> > > > =C2=A0 instances. Drop this redundant flag.
> > >=20
> > > Not sure I want to rely on refcnt to zero to identify dynamic
> > > datatypes. I think we need to consolidate datatype_set() to be
> > > used
> > > not only where this deals with dynamic datatypes, it might help
> > > improve traceability of datatype assignment.
> >=20
> > I don't understand. Could you elaborate about datatype_set()?
>=20
> I wonder if we could use datatype_set() to attach static datatypes
> too, instead of manually attaching datatypes, such as:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 expr->dtype =3D &integer_type;
>=20
> in case of future extensions, using consistently this helper function
> will help to identify datatype attachments.

I think `expr->dtype =3D &integer_type` is fine, if

- expr->dtype doesn't previously point to a datatype that requires
datatype_free() (e.g. because it's NULL).

- the new datatype requires no datatype_get() (e.g. because it's
static).

>=20
> > Btw, for dynamically allocated instances the refcnt is always
> > positive,
> > and for static ones it's always zero. The DTYPE_F_ALLOC flag is
> > redundant.
>=20
> That is a correct observation, but a (hipothetical) subtle bug in
> refcnt might lead to a dynamic datatype get to refcnt to zero, and
> that might be harder to track?
>=20
> Let me have a look if I can come up with some counter proposal to get
> rid of this flag, I would prefer not to infer the datatype class from
> reference counter value.

If the reference counting is messed up, there is either a leak, a use-
after-free or modification of static data. These are all bad bugs that
needs fixing and are avoided by best practices and testing.

IMO keeping redundant state does not help with that or with
readability.



I'd like to replace the "unsigned int flags" field with individual
boolean fields like "bool f_prefix" or "bool f_alloc".

Dropping DTYPE_F_ALLOC/f_alloc flag altogether can be done (or not
done) independently from that.


Thomas

