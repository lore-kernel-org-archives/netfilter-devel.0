Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCC7CA0EC4
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Sep 2023 21:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240008AbjIKVgu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244429AbjIKUah (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2023 16:30:37 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEE2185
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2023 13:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NVepYDj4Obn1QAoZ6+kS/yBZp4Kgx015xfn6NjjmhIc=; b=SCt9vttXe8eHob8zsEE0Mw9Uqy
        5Dgn8noyRCRtMKdflxdO/4pjgWGCe2qDOeFNFWB5rRiLowdIvDr4nKzUUZhf4xsAEUPZ/8sWqUBBh
        PuaGg9wBfGmBnpxZ/k0+3iQh3cqpiGj+TxF1Di6NML7WIK6h6KuDdEYaxvK47Tk1ZQ+lDM2XKJ7Dm
        MQEFiofSkyDwGyHfSfXKaiUioEedr/3xKA4m12v/g/rxJT5G/fZcYFefGMjnKGZRkJQu9ygqtPK5v
        6aZiwRXvhHu2n72I/WKNR1tRZ7Lz5imop8qG1LFl731ZkDMPgqtWkS4MMgZONF2zo0AycXjphVFIv
        kOEgahVQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qfnYC-0016z7-2p;
        Mon, 11 Sep 2023 21:30:28 +0100
Date:   Mon, 11 Sep 2023 21:30:26 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] nlmsg, attr: fix false positives when validating
 buffer sizes
Message-ID: <20230911203026.GA772964@celephais.dreamlands>
References: <20230910203018.2782009-1-jeremy@azazel.net>
 <ZP9oyPItYTM2EVuw@calendula>
 <ZP9pVfzfv7SYYUM9@calendula>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wTxUJ5l14kDm027c"
Content-Disposition: inline
In-Reply-To: <ZP9pVfzfv7SYYUM9@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--wTxUJ5l14kDm027c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-09-11, at 21:24:05 +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 11, 2023 at 09:21:50PM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Sep 10, 2023 at 09:30:18PM +0100, Jeremy Sowden wrote:
> > > `mnl_nlmsg_ok` and `mnl_attr_ok` both expect a signed buffer
> > > length value, `len`, against which to compare the size of the
> > > object expected to fit into the buffer, because they are intended
> > > to validate the length and it may be negative in the case of
> > > malformed messages.  Comparing this signed value against unsigned
> > > operands leads to compiler warnings, so the unsigned operands are
> > > cast to `int`.  Comparing `len` to the size of the structure is
> > > fine, because the structures are only a few bytes in size.
> > > Comparing it to the length fields of `struct nlmsg` and `struct
> > > nlattr`, however, is problematic, since these fields may hold
> > > values greater than `INT_MAX`, in which case the casts will yield
> > > negative values and result in false positives.
> > >=20
> > > Instead, assign `len` to an unsigned local variable, check for
> > > negative values first, then use the unsigned local for the other
> > > comparisons, and remove the casts.
> > >=20
> > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=3D1691
> > > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > > ---
> > >  src/attr.c  | 9 +++++++--
> > >  src/nlmsg.c | 9 +++++++--
> > >  2 files changed, 14 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/src/attr.c b/src/attr.c
> > > index bc39df4199e7..48e95019d5e8 100644
> > > --- a/src/attr.c
> > > +++ b/src/attr.c
> > > @@ -97,9 +97,14 @@ EXPORT_SYMBOL void *mnl_attr_get_payload(const str=
uct nlattr *attr)
> > >   */
> > >  EXPORT_SYMBOL bool mnl_attr_ok(const struct nlattr *attr, int len)
> >=20
> > Maybe turn this into uint32_t ?
>=20
> Actually, attribute length field is 16 bits long, so it can never
> happen that nla_len will underflow.

Oh, yeah.  Sorry.  I Thought I'd checked that.  I think my version
without the casts is still tidier.  My preference would be to keep the
nlattr change but amend the commit message, but if you prefer I'll drop
it.

J.

--wTxUJ5l14kDm027c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmT/eNkACgkQKYasCr3x
BA3BCw/9E9h87QwOcBkipskTE7jCUDLVCFTUr0ukgi60K+1GCmAjSRLocSql2+aA
DoRfVybOlmZ8XD28pQDQySP4weleiSer/NV5KLQObX+WsaKHEtPsjDGIy7BvXtMO
1dZW5ut1wPSAeqx9iX88k+wOCsxDCcjF0fYyCTuU3CKXKklNB76u3FiFzLwNulkn
4r6iOOBnP3b6MBeOz5KLK7657kQQoXs/BCBG25zmzcVwiQF0BgXef5JihCgwh9ff
lJCqvNmXqBx7N3xDyQ5mZQXBt1BTVus4t8DslGbJ3CGDhf4EzHtQxmEYqi4yahS/
C+0cLkyUpkuVIQm0OgBY6ZLkrG1czyaNEhibzPAHKxUm7NNSgDk4xy+vGTn7KLJT
knBYuSD4E+qfs85klcLA0cQKYqXG11DuISSYCKVe4cz6GNbyjSve3xdqtvy92EY8
5TOZGmtXvxHFWBQr7O+xgjnCfhaiB09a5+ZTewbJ3Hz6UTglWUgarquEUHkgwzrq
mkOJKt7eEyXYfgHJKrKXyrOa1hnX/iEAFCUa7Fwtu6gQNu2ot1zo+KHtf7jqxZUJ
xck4VyQYSFK/aEaZGorZDQbE1rKBaCCMzNeH2smx2ncrvkIzwYgnz0hTarSS0vsj
RsKByrKn8Ftmkx9IywFShxNhY70K/EZTRe+U9F+RZOHpEnW7pVM=
=2AG/
-----END PGP SIGNATURE-----

--wTxUJ5l14kDm027c--
