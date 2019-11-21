Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73111C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49C4B206D7
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:09:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFthtF6Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKURJz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:09:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31500 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726379AbfKURJz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:09:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574356193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DpAyIbv5BmYALkbecdV4rCRyVVygRG9wxu15MNzBzk=;
        b=QFthtF6QP4JkWiwb33+gTDXKj1t4zvLdQxiujIy1CoS66X8iTuHvhKVwbUr5ri+OYbXyqc
        YOyCHjd3QwWtQsCFPMxRMkppx9+Z82ZG5EDrWr8ZIHwzqFCogEhtu8nZ7scNH/qxB35kfP
        fxUioSv10GwQylzIgUs23UGn9a5uqjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-UzW22ftbNcqopsiMJui39g-1; Thu, 21 Nov 2019 12:09:47 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9862C8018A2;
        Thu, 21 Nov 2019 17:09:45 +0000 (UTC)
Received: from localhost (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 258DB6E3F9;
        Thu, 21 Nov 2019 17:09:42 +0000 (UTC)
Date:   Thu, 21 Nov 2019 18:09:38 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft 2/3] src: Add support for concatenated set ranges
Message-ID: <20191121180938.381eabab@redhat.com>
In-Reply-To: <20191120125308.GK8016@orbyte.nwl.cc>
References: <20191119010712.39316-1-sbrivio@redhat.com>
        <20191119010712.39316-3-sbrivio@redhat.com>
        <20191119221238.GF8016@orbyte.nwl.cc>
        <20191120124954.0740a1a5@redhat.com>
        <20191120125308.GK8016@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: UzW22ftbNcqopsiMJui39g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 20 Nov 2019 13:53:08 +0100
Phil Sutter <phil@nwl.cc> wrote:

> On Wed, Nov 20, 2019 at 12:49:54PM +0100, Stefano Brivio wrote:
>
> > On Tue, 19 Nov 2019 23:12:38 +0100
> > Phil Sutter <phil@nwl.cc> wrote:
> [...]
>
> > So, the whole thing would look like (together with the other change
> > you suggest):
> >=20
> > --
> > static int netlink_gen_concat_data_expr(const struct expr *i,
> > =09=09=09=09=09unsigned char *data)
> > {
> > =09if (i->etype =3D=3D EXPR_RANGE) {
> > =09=09const struct expr *e;
> >=20
> > =09=09if (i->flags & EXPR_F_INTERVAL_END)
> > =09=09=09e =3D i->right;
> > =09=09else
> > =09=09=09e =3D i->left;
> >=20
> > =09=09return netlink_export_pad(data, e->value, e);
> > =09}
> >=20
> > =09if (i->etype =3D=3D EXPR_PREFIX) {
> > =09=09if (i->flags & EXPR_F_INTERVAL_END) {
> > =09=09=09int count;
> > =09=09=09mpz_t v;
> >=20
> > =09=09=09mpz_init_bitmask(v, i->len - i->prefix_len);
> > =09=09=09mpz_add(v, i->prefix->value, v);
> > =09=09=09count =3D netlink_export_pad(data, v, i);
> > =09=09=09mpz_clear(v);
> > =09=09=09return count;
> > =09=09}
> >=20
> > =09=09return netlink_export_pad(data, i->prefix->value, i);
> > =09}
> >=20
> > =09assert(i->etype =3D=3D EXPR_VALUE);
> >=20
> > =09return netlink_export_pad(data, i->value, i);
> > } =20
>=20
> I would even:
>=20
> | static int
> | netlink_gen_concat_data_expr(const struct expr *i, unsigned char *data)
> | {
> | =09mpz_t *valp =3D NULL;
> |=20
> | =09switch (i->etype) {
> | =09case EXPR_RANGE:
> | =09=09i =3D (i->flags & EXPR_F_INTERVAL_END) ? i->right : i->left;
> | =09=09break;
> | =09case EXPR_PREFIX:
> | =09=09if (i->flags & EXPR_F_INTERVAL_END) {
> | =09=09=09int count;
> | =09=09=09mpz_t v;
> |=20
> | =09=09=09mpz_init_bitmask(v, i->len - i->prefix_len);
> | =09=09=09mpz_add(v, i->prefix->value, v);
> | =09=09=09count =3D netlink_export_pad(data, v, i);
> | =09=09=09mpz_clear(v);
> | =09=09=09return count;
> | =09=09}
> | =09=09valp =3D &i->prefix->value;
> | =09=09break;
> | =09case EXPR_VALUE:
> | =09=09break;
> | =09default:
> | =09=09BUG("invalid expression type '%s' in set", expr_ops(i)->name);
> | =09}
> |=20
> | =09return netlink_export_pad(data, valp ? *valp : i->value, i);
> | }
>=20
> But that's up to you. :)

I think it's nicer with a switch and that BUG() is more helpful than a
random assert, but I personally find that ternary condition on valp a
bit difficult to follow.

I'd recycle most of your function without that -- it's actually shorter
and still makes it clear enough what gets fed to netlink_export_pad().

Oh, and by the way, at this point we need to check flags on the 'key'
expression.

> > static void netlink_gen_concat_data(const struct expr *expr,
> > =09=09=09=09    struct nft_data_linearize *nld)
> > {
> > =09unsigned int len =3D expr->len / BITS_PER_BYTE, offset =3D 0;
> > =09unsigned char data[len];
> > =09const struct expr *i;
> >=20
> > =09memset(data, 0, len);
> >=20
> > =09list_for_each_entry(i, &expr->expressions, list)
> > =09=09offset +=3D netlink_gen_concat_data_expr(i, data + offset);
> >=20
> > =09memcpy(nld->value, data, len);
> > =09nld->len =3D len;
> > }
> > --
> >=20
> > Is that better? =20
>=20
> Looks great, thanks!
>=20
> [...]
>
> > > So this is the fifth copy of the same piece of code. :(
> > >=20
> > > Isn't there a better way to solve that? =20
> >=20
> > I couldn't think of any. =20
>=20
> I guess we would need an intermediate state which is 'multiton_rhs_expr
> DOT multiton_rhs_expr'. Might turn into a mess as well. :)

I just tried to add that, and kept losing myself in the middle of it.
It might be me, but it doesn't sound that promising when it comes to
readability later.

I guess we already have enough levels of indirection here -- I'd just
go with the compound_expr_alloc_or_add() you suggested.

> > > Intuitively, I would just:
> > >=20
> > > | int tmp =3D len;
> > > | while (start !=3D end && !(start & 1) && (end & 1) && tmp) {
> > > |=09start >>=3D 1;
> > > |=09end >>=3D 1;
> > > |=09tmp--;
> > > | }
> > > | return (tmp && start =3D=3D end) ? len - tmp : -1;
> > >=20
> > > Is that slow when dealing with gmp? =20
> >=20
> > I don't think so, it also avoid copies and allocations, while shifting
> > and setting bits have comparable complexities. I'd go with the gmp
> > version of this. =20

Actually, I need to preserve the original elements, so the two copies
are needed anyway -- other than that, I basically recycled your
function.

--=20
Stefano

