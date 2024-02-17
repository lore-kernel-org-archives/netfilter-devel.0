Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBE27BAE7
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Feb 2024 20:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708201637; cv=none; b=kjAIyhtDMN34eRqrDx/KzxXnoDqE/aP2PIfBa2oQVRsOIGCET+E9N1xrZrU/IVfNecR9F7r/AOaXWGc8k+srP+fbuPYoo6e/rowts4kSXJyViCGsnw7o+CKpZDV9pLZfIfXzJYCMKdcmgTDAZe7hI/BsVCjwWoz8G0WRdl5eb04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708201637; c=relaxed/simple;
	bh=HEv55xzSDQQc/FoTPZG8NCyrVGv7alE03npF+zUZpDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3I7vFhPWKlxB74LsWOuAvFixiqY1fq5wMwzidnAoyef+E0w/A6kuawoueSpR9kxw6G3/6Bd/ly666jX2iLnRMoFUTVdRF/bCJZx7vRmQ0CysaEaLwTlVTETQ5Ki6DmVxm0s018/eKquPbsHfZ/Go6qcPdrgD9jX9AyfcVt3ock=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=dPRQEHap; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="dPRQEHap"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lwI7MQDe9SRRMare8rBrtAoXodtev8JQG5IePEskVyw=; b=dPRQEHapm4siBbOsJ3ul0PAbIY
	wjJQP+hsALNu9regpagDon57cPBxFSWwQdS4Oypvn9XJmqjqkjUQ7Tq2ZFXc7IJGqov9rfSaeWU8U
	jqBIcf3CzRBuicqbIJPJzpclTt/3VixWbV+JOo+N4tkInfAXrLT8e2to55cdsSLFDbigbvPFcM4Bh
	vS1xmzAvHjLKlhAC6o+bmLFelFenKk3oSjsrip9hnYzaQSUaOCsjYzCQ+u45zEp9AlBHD6rE2WRlE
	yI+7zQPh1xGUc8kUe8k2DOpDzSDRJi7qftECjjjg5EBkvBeyLQP84rGT3PAziQMSUkA8tzgbPKFci
	e5RyWd5A==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rbR2E-006A51-2l;
	Sat, 17 Feb 2024 20:11:42 +0000
Date: Sat, 17 Feb 2024 20:11:41 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [RFC] nftables 0.9.8 -stable backports
Message-ID: <20240217201141.GA3416036@celephais.dreamlands>
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSPltyxV10hYvsr+@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Sh3RySdl5z99/S/h"
Content-Disposition: inline
In-Reply-To: <ZSPltyxV10hYvsr+@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--Sh3RySdl5z99/S/h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi, Pablo.

On 2023-10-09, at 13:36:23 +0200, Pablo Neira Ayuso wrote:
> This is a small batch offering fixes for nftables 0.9.8. It only
> includes the fixes for the implicit chain regression in recent
> kernels.
>=20
> This is a few dependency patches that are missing in 0.9.8 are
> required:
>=20
>         3542e49cf539 ("evaluate: init cmd pointer for new on-stack contex=
t")
>         a3ac2527724d ("src: split chain list in table")
>         4e718641397c ("cache: rename chain_htable to cache_chain_ht")
>=20
> a3ac2527724d is fixing an issue with the cache that is required by the
> fixes. Then, the backport fixes for the implicit chain regression with
> Linux -stable:
>=20
>         3975430b12d9 ("src: expand table command before evaluation")
>         27c753e4a8d4 ("rule: expand standalone chain that contains rules")
>         784597a4ed63 ("rule: add helper function to expand chain rules in=
to commands")
>=20
> I tested with tests/shell at the time of the nftables 0.9.8 release
> (*I did not use git HEAD tests/shell as I did for 1.0.6*).
>=20
> I have kept back the backport of this patch intentionally:
>=20
>         56c90a2dd2eb ("evaluate: expand sets and maps before evaluation")
>=20
> this depends on the new src/interval.c code, in 0.9.8 overlap and
> automerge come a later stage and cache is not updated incrementally,
> I tried the tests coming in this patch and it works fine.
>=20
> I did run a few more tests with rulesets that I have been collecting
> from people that occasionally send them to me for my personal ruleset
> repo.
>=20
> I: results: [OK] 266 [FAILED] 0 [TOTAL] 266
>=20
> This has been tested with latest Linux kernel 5.10 -stable.
>=20
> I can still run a few more tests, I will get back to you if I find any
> issue.
>=20
> Let me know, thanks.

A new version of nftables containing these fixes was released as part of
the Debian 11.9 point release, which happened a week ago.  Since then,
we've had a couple of bug-reports:

  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1063690
  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1063769

The gist of them is that if nft processes a file containing multiple
table-blocks for the same table, and there is a set definition in one of
the non-initial ones, e.g.:

  table inet t {
  }
  table inet t {
    set s {
      type inet_service
      elements =3D { 42 }
    }
  }

it crashes with a seg-fault.

The bison parser creates two `CMD_ADD` commands and allocates two
`struct table` objects (which I shall refer to as `t0` and `t1`).  When
it creates the second command, it also allocates a `struct set` object,
`s`, which it adds to `t1->sets`.  After the `CMD_ADD` commands for `t0`
and `t1` have been expanded, when the new `CMD_ADD` command for `s` is
evaluated, `set_evaluate` does this (evaluate.c, ll. 3686ff.):

	table =3D table_lookup_global(ctx);
	if (table =3D=3D NULL)
		return table_not_found(ctx);

and later this (evaluate.c, ll. 3762f.):

	if (set_lookup(table, set->handle.set.name) =3D=3D NULL)
		set_add_hash(set_get(set), table);

The `struct table` object returned by `table_lookup_global` is `t0`,
since this was evaluated first and cached by `table_evaluate`, not `t1`.
Therefore, `set_lookup` returns `NULL`, `set_add_hash` is called, `s` is
added to `t0->sets`, and `t1->sets` is effectively corrupted.  It now
contains two elements which point to each other, and one of them is not
a set at all, but `t0->sets`.  This results in a seg-fault when nft
tries to free `t1`.

I _think_ that the following is all that is needed to fix it:

  @@ -3759,7 +3759,8 @@ static int set_evaluate(struct eval_ctx *ctx, struc=
t set *set)
          }
          ctx->set =3D NULL;
  =20
  -       if (set_lookup(table, set->handle.set.name) =3D=3D NULL)
  +       if (set_lookup(table, set->handle.set.name) =3D=3D NULL &&
  +           list_empty(&set->list))
                  set_add_hash(set_get(set), table);
  =20
          return 0;

Does this look good to you?

J.

--Sh3RySdl5z99/S/h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmXREv0ACgkQKYasCr3x
BA1BGBAAqTqlSC85hjD+sJTdSCRaBsmZ5xS0vAU+Giv1Z6FkpBNcIwg+bJLU0vnf
2rYEDyiHu8dG/AAOaSrAsgh2Jt4tH38EOrbGKMQfpIqAcO4Bgy2ZxMLJVB9wObRE
/oqgYXcKiJ/quDxSlSWWT7qVtrtvFt/adXbM6ORF6xDN4b/LZtzTu+SCN5uBpnyo
tavFr41js1DhObOk3bXzeqigT1GkAoDpTmZ8n81O03uvoE8zQqXcwbL9tkRAYQ2Y
RNcHX0BeK+d4MFLvmDDtuEjhmwWbfzomATwYV0QGMGwqkmmrDAoqUYafpbf10hGi
VUb6lFQ8nk0lpJjHjyYrbmmvpanrqk5mUJL0y1LViWHz38MGBVx71IV+TZ1phvQW
oxF4mAQEbgyDv2QxLeyRxAKsA08tm5yGRsfHelhxKxbMZxLGFVfAiEsMNpDuqKFT
QNtmnW3jl6BRph7R9g2NCly3TgMrV7MAS2Mo3gDhx59xL0wMCccZlqK3aoSdN4m6
SKn5h9Ml73qy58Yg2IZRlKd18f6S80zHxzw/4zZeCwN5hMtkpJgsBn1nWFx0VM9I
q8gRSsV8W3jha6UtHqkIi8Jy0wLg45GcJ1DaiC+S16UHzhkKX4/8xnif1+cx5mLG
W/M27KFobxt+c/Ke6eMb/XKNgdlqNWEY8gl466V1XNW4Oj4E96Y=
=KTbU
-----END PGP SIGNATURE-----

--Sh3RySdl5z99/S/h--
