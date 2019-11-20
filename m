Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58425C432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 12:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DB9C22419
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 12:02:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iXGjBngM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfKTMCF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 07:02:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48685 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727791AbfKTMCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 07:02:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574251323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m2QjWaXF88uBUsZzukOp8YyE3z6+gfObe/Jq59P/wak=;
        b=iXGjBngMKTCuwiijzdPLktyHJHDxyj/rAwWpn4eecG6NNPXXCYzv2QbDbGLYz1DXpc2Xzc
        Uk/3c3xK1hOqvbvbaTA/VzoWolV8amnpsy7FPNJiD6N+DUZPlmGG/PR96v0ZouPKSi4sXf
        mm5xxkDbmrL+iiDU6XPsZ5dgYKLc4Fc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-KYjkfB6GMd2MbYm06QC79g-1; Wed, 20 Nov 2019 07:02:00 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1593911E8;
        Wed, 20 Nov 2019 12:01:58 +0000 (UTC)
Received: from localhost (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F93F600C9;
        Wed, 20 Nov 2019 12:01:56 +0000 (UTC)
Date:   Wed, 20 Nov 2019 13:01:52 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH libnftnl] set: Add support for NFTA_SET_SUBKEY
 attributes
Message-ID: <20191120130152.7d4d3ca8@redhat.com>
In-Reply-To: <20191120112448.GI8016@orbyte.nwl.cc>
References: <20191119010723.39368-1-sbrivio@redhat.com>
        <20191120112448.GI8016@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: KYjkfB6GMd2MbYm06QC79g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 20 Nov 2019 12:24:48 +0100
Phil Sutter <phil@nwl.cc> wrote:

> Hi,
>=20
> On Tue, Nov 19, 2019 at 02:07:23AM +0100, Stefano Brivio wrote:
> [...]
> > diff --git a/src/set.c b/src/set.c
> > index 78447c6..60a46d8 100644
> > --- a/src/set.c
> > +++ b/src/set.c =20
> [...]
> > @@ -361,6 +366,23 @@ nftnl_set_nlmsg_build_desc_payload(struct nlmsghdr=
 *nlh, struct nftnl_set *s)
> >  =09mnl_attr_nest_end(nlh, nest);
> >  }
> > =20
> > +static void
> > +nftnl_set_nlmsg_build_subkey_payload(struct nlmsghdr *nlh, struct nftn=
l_set *s)
> > +{
> > +=09struct nlattr *nest;
> > +=09uint32_t v;
> > +=09uint8_t *l;
> > +
> > +=09nest =3D mnl_attr_nest_start(nlh, NFTA_SET_SUBKEY);
> > +=09for (l =3D s->subkey_len; l - s->subkey_len < NFT_REG32_COUNT; l++)=
 { =20
>=20
> While I like pointer arithmetics, too, I don't think it's much use here.
> Using good old index variable even allows to integrate the zero value
> check:
>=20
> |=09for (i =3D 0; i < NFT_REG32_COUNT && s->subkey_len[i]; i++)

Oh, yes, better. I'll change this in v2.

> > +=09=09if (!*l)
> > +=09=09=09break;
> > +=09=09v =3D *l;
> > +=09=09mnl_attr_put_u32(nlh, NFTA_SET_SUBKEY_LEN, htonl(v)); =20
>=20
> I guess you're copying the value here because how htonl() is declared,
> but may it change the input value non-temporarily? I mean, libnftnl is
> in control over the array so from my point of view it should be OK to
> directly pass it to htonl().

It won't change the input value at all, but that's not the point: I'm
reading from an array of 8-bit values and attributes are 32 bits. If I
htonl() directly on the input array, it's going to use 24 bits around
those 8 bits.

--=20
Stefano

