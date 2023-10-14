Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1F5CDB474
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Oct 2023 16:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbjJNQ7T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Oct 2023 12:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjJNQ7S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Oct 2023 12:59:18 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF69AD
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Oct 2023 09:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mmWtJtVCDdJc+QQbnfS8jv06pQ+t67Su0edaw98BzfY=; b=mAZEc86YmiU2HbYbDiYC8V8Jqc
        xEqb1H2USJ4mNXrbHyfnp7EuswLxq36Etc6MzjeJe1QByb3p1sVXOwZ4gqf34rIjL9o1ViCjenlcc
        4KKTPY8ck/NuADq4G9PSpLJfMWZ3LBMBBdt4PeAC7TDUNXe25TM1p1ULFSWRVWfae8j5+KOf215ce
        geyeeNJzEw7+om/Fv5WrCIbK09kMk16r8b8TVLKG34viSrYHWZ9pKrOrdCZVgFtc4KELvCOLivRFK
        +jSqVb8cto9uIAGlHfyw+kMFOFRwOP0cQhqC/YGFXH9YoYyAXoyd3+gKuPuxzlIPtTW5Sfl1CMnnk
        JSDne5xw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qrhyp-0062Ej-22;
        Sat, 14 Oct 2023 17:59:11 +0100
Date:   Sat, 14 Oct 2023 17:59:10 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] nlmsg, attr: fix false positives when validating
 buffer sizes
Message-ID: <20231014165910.GC1438255@celephais.dreamlands>
References: <20230910203018.2782009-1-jeremy@azazel.net>
 <ZP9oyPItYTM2EVuw@calendula>
 <ZP9pVfzfv7SYYUM9@calendula>
 <20230911203026.GA772964@celephais.dreamlands>
 <ZP+DzR3lgFd9wymG@calendula>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c05o6ef58eQ5TNm4"
Content-Disposition: inline
In-Reply-To: <ZP+DzR3lgFd9wymG@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--c05o6ef58eQ5TNm4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-09-11, at 23:17:01 +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 11, 2023 at 09:30:26PM +0100, Jeremy Sowden wrote:
> > On 2023-09-11, at 21:24:05 +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Sep 11, 2023 at 09:21:50PM +0200, Pablo Neira Ayuso wrote:
> > > > On Sun, Sep 10, 2023 at 09:30:18PM +0100, Jeremy Sowden wrote:
> > > > > `mnl_nlmsg_ok` and `mnl_attr_ok` both expect a signed buffer
> > > > > length value, `len`, against which to compare the size of the
> > > > > object expected to fit into the buffer, because they are intended
> > > > > to validate the length and it may be negative in the case of
> > > > > malformed messages.  Comparing this signed value against unsigned
> > > > > operands leads to compiler warnings, so the unsigned operands are
> > > > > cast to `int`.  Comparing `len` to the size of the structure is
> > > > > fine, because the structures are only a few bytes in size.
> > > > > Comparing it to the length fields of `struct nlmsg` and `struct
> > > > > nlattr`, however, is problematic, since these fields may hold
> > > > > values greater than `INT_MAX`, in which case the casts will yield
> > > > > negative values and result in false positives.
> > > > >=20
> > > > > Instead, assign `len` to an unsigned local variable, check for
> > > > > negative values first, then use the unsigned local for the other
> > > > > comparisons, and remove the casts.
> > > > >=20
> > > > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=3D1691
> > > > > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > > > > ---
> > > > >  src/attr.c  | 9 +++++++--
> > > > >  src/nlmsg.c | 9 +++++++--
> > > > >  2 files changed, 14 insertions(+), 4 deletions(-)
> > > > >=20
> > > > > diff --git a/src/attr.c b/src/attr.c
> > > > > index bc39df4199e7..48e95019d5e8 100644
> > > > > --- a/src/attr.c
> > > > > +++ b/src/attr.c
> > > > > @@ -97,9 +97,14 @@ EXPORT_SYMBOL void *mnl_attr_get_payload(const=
 struct nlattr *attr)
> > > > >   */
> > > > >  EXPORT_SYMBOL bool mnl_attr_ok(const struct nlattr *attr, int le=
n)
> > > >=20
> > > > Maybe turn this into uint32_t ?
> > >=20
> > > Actually, attribute length field is 16 bits long, so it can never
> > > happen that nla_len will underflow.
> >=20
> > Oh, yeah.  Sorry.  I Thought I'd checked that.  I think my version
> > without the casts is still tidier.  My preference would be to keep the
> > nlattr change but amend the commit message, but if you prefer I'll drop
> > it.
>=20
> I would prefer to update documentation and drop the change for nlattr.

No problem. I'll drop it.

> For mnl_attr_ok(), this should be sufficient?
>=20
>         if (len < 0)
>                 return false;
>=20
> to reject buffer larger that 2^31 (2 GBytes) or when length goes
> negative (malformed netlink message in the buffer).
>=20
> BTW, this _trivial_ function is modeled after nlmsg_ok() in the
> kernel...
>=20
> On Sun, Sep 10, 2023 at 09:30:18PM +0100, Jeremy Sowden wrote:
> > `mnl_nlmsg_ok` and `mnl_attr_ok` both expect a signed buffer length
> > value, `len`, against which to compare the size of the object expected
> > to fit into the buffer, because they are intended to validate the lengt=
h      =20
> > and it may be negative in the case of malformed messages.  Comparing   =
       =20
> > this signed value against unsigned operands leads to compiler warnings,=
       =20
> > so the unsigned operands are cast to `int`.
>=20
> Did you see such compiler warning? If so, post it in commit
> description.
>=20
> > Comparing `len` to the size of the structure is fine, because
> > the structures are only a few bytes in size. Comparing it to
> > the length fields of `struct nlmsg` and `struct nlattr`,
> > however, is problematic, since these fields may hold values greater
> > than `INT_MAX`, in which case the casts will yield negative values
> > and result in false positives.
>=20
> Yes, but the early check for negative length prevents this after this
> patch, correct?

The problem arises if `len` is positive and `nlh->nlmsg_len` is larger
than INT_MAX.  In that case:

  len >=3D (int)sizeof(struct nlmsghdr)

succeeds because `len` is positive, and:

  (int)nlh->nlmsg_len <=3D len

succeeds because the cast yields a negative value, so we get a false
positive.

> > Instead, assign `len` to an unsigned local variable, check for negative=
       =20
> > values first, then use the unsigned local for the other comparisons, an=
d      =20
> > remove the casts.
>=20
> Makes sense.
>=20
> Probably I'm getting confused with this large patch description :)

I'll trim it down. :)

J.

--c05o6ef58eQ5TNm4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmUqyNEACgkQKYasCr3x
BA005RAAn85wr5VlhdZ2OHNKHDio8sVwfubLHDi7ULEt9ey8O9eBNdYCZQgzKNZE
HbKzQORDWyJDqqc9SmCMobZ10sFNMwiXeOR5QT9yNgqMPF46HuwYhsTTl8AY8p1o
uYRTCjBFYWtPvae+mlwoBl6eW8hp1I6hrKW8u8zrAKSF0olmGA9w5MTjYVUdhulz
dzjtso59oeiZiNcApW2d/EmERxE0xU9qURjOPiy8n7cwH9BvFtTx23ZEexGAhsvL
50K7DY5unCSXJ4Im5Qp0xo9TDM0gbv92iJnvvFyOMoVoJT1QjXDKFGKLRo4aA5ll
GN2nUet60/61LMY6soHbVAbdnPVniUdP4w5hzRscXRHPB/Mk9KFpL4ONCJKY844q
5WyA95mv5M0VSxGeKaR98sDZp0708i7oDUZORfFeb+42qrHoffkKdaePZwEt36Rk
2elPZBnkp06o4y7cujnCdpxSV2NQEkweNfTa9xRtrRq9AyWbnU5tjg+aSeWCIRGA
MhF1kd+qPSU6felNBnDFWN+IJk1Zzl9PtAYWMkD/BCW8F5gtly032Oh0jvAaWaqz
BkG/tL1BynjeMV/VJmiFjCBuNXgoErFubPfMK1W6RGRkejEP9TQG9sMS1yyJ+rIR
DHGRi5XHwYVQfXCEPHDDxOHPoOpDvowMUKDYyC5GbotAr9pVHM0=
=xzbX
-----END PGP SIGNATURE-----

--c05o6ef58eQ5TNm4--
