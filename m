Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C6D6BB49
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Feb 2024 13:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708264573; cv=none; b=Q8Yg8dDIybxLY/q+DqouxvICQW83WDnaxvGAt6F1q6PX2JNNrX37BhsTijBp2WzoAA60FUv/Tx+PwpBBp2zSA0PR/nyJvOKIS2Jp5YpbPkDE9zJGLywGFbjWZe2SDM+X+EX5wW/JpNme783N431CR+/6wllAptBisOElRkXObgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708264573; c=relaxed/simple;
	bh=s35ZpOPsx4NdN3ZVvmix53q3XfT/RafrK6/gB0DBgEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=reuRf2MLgUH4j8fo3dMrQ6gkivElORvgS34BFzLAI6KiBZk5N8eTsD6cUEAeEqz6WYCFdxwrGn/zOT9UYW6qIe1NZhcOJ1ct0+F9RnExP7I02dGqzU+hIUzlmtp5QzjyhEXu2/zc/lzdZJfpz9QPOZ/22LuSJsIVrRA2BCQsMoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=SiEDGT8O; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="SiEDGT8O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=skLmyIoFlgw8XjzUpm9dZRWBWOe3/s8yGEosDomoALo=; b=SiEDGT8OtKhxyIgLLj09zZmjsj
	JA5JykDlzR7+8IVv53fMadX1ElmfP4uad19dnhIzv2BM1plj8crG+By8TH1FM39ZbTMF97PdKN5EN
	WRbD/kpJ6a0ylVQvMpFeW9gqhYoI/eIPhczLuaApVZdUOM/TVSt/kFa8tt/LVIsiK0lzqkedJsSqz
	2/v8dOVeh6TCER7z91gTniHtcHge1KR0uePb1hQ4CDXMC9IZFwLnjxeo3NLYOldj/plUfJ95DS+Fo
	AFcg7cMmTFkUFxQeXFSbJs53KMfNOhvZFeI3SG9/Uf+XtFHOyAkGr05ZgPGQYkAZbQzxYGR9h2xTZ
	G8t5i75A==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rbheD-0070yI-1h;
	Sun, 18 Feb 2024 13:56:01 +0000
Date: Sun, 18 Feb 2024 13:56:00 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [RFC] nftables 0.9.8 -stable backports
Message-ID: <20240218135600.GA4998@celephais.dreamlands>
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSPltyxV10hYvsr+@calendula>
 <20240217201141.GA3416036@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xKhQ2PKjEJBVe/UV"
Content-Disposition: inline
In-Reply-To: <20240217201141.GA3416036@celephais.dreamlands>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--xKhQ2PKjEJBVe/UV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-02-17, at 20:11:42 +0000, Jeremy Sowden wrote:
> On 2023-10-09, at 13:36:23 +0200, Pablo Neira Ayuso wrote:
> > This is a small batch offering fixes for nftables 0.9.8. It only
> > includes the fixes for the implicit chain regression in recent
> > kernels.
> >=20
> > This is a few dependency patches that are missing in 0.9.8 are
> > required:
> >=20
> >         3542e49cf539 ("evaluate: init cmd pointer for new on-stack cont=
ext")
> >         a3ac2527724d ("src: split chain list in table")
> >         4e718641397c ("cache: rename chain_htable to cache_chain_ht")
> >=20
> > a3ac2527724d is fixing an issue with the cache that is required by the
> > fixes. Then, the backport fixes for the implicit chain regression with
> > Linux -stable:
> >=20
> >         3975430b12d9 ("src: expand table command before evaluation")
> >         27c753e4a8d4 ("rule: expand standalone chain that contains rule=
s")
> >         784597a4ed63 ("rule: add helper function to expand chain rules =
into commands")
> >=20
> > I tested with tests/shell at the time of the nftables 0.9.8 release
> > (*I did not use git HEAD tests/shell as I did for 1.0.6*).
> >=20
> > I have kept back the backport of this patch intentionally:
> >=20
> >         56c90a2dd2eb ("evaluate: expand sets and maps before evaluation=
")
> >=20
> > this depends on the new src/interval.c code, in 0.9.8 overlap and
> > automerge come a later stage and cache is not updated incrementally,
> > I tried the tests coming in this patch and it works fine.
> >=20
> > I did run a few more tests with rulesets that I have been collecting
> > from people that occasionally send them to me for my personal ruleset
> > repo.
> >=20
> > I: results: [OK] 266 [FAILED] 0 [TOTAL] 266
> >=20
> > This has been tested with latest Linux kernel 5.10 -stable.
> >=20
> > I can still run a few more tests, I will get back to you if I find any
> > issue.
> >=20
> > Let me know, thanks.
>=20
> A new version of nftables containing these fixes was released as part of
> the Debian 11.9 point release, which happened a week ago.  Since then,
> we've had a couple of bug-reports:
>=20
>   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1063690
>   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1063769
>=20
> The gist of them is that if nft processes a file containing multiple
> table-blocks for the same table, and there is a set definition in one of
> the non-initial ones, e.g.:
>=20
>   table inet t {
>   }
>   table inet t {
>     set s {
>       type inet_service
>       elements =3D { 42 }
>     }
>   }
>=20
> it crashes with a seg-fault.
>=20
> The bison parser creates two `CMD_ADD` commands and allocates two
> `struct table` objects (which I shall refer to as `t0` and `t1`).  When
> it creates the second command, it also allocates a `struct set` object,
> `s`, which it adds to `t1->sets`.  After the `CMD_ADD` commands for `t0`
> and `t1` have been expanded, when the new `CMD_ADD` command for `s` is
> evaluated, `set_evaluate` does this (evaluate.c, ll. 3686ff.):
>=20
> 	table =3D table_lookup_global(ctx);
> 	if (table =3D=3D NULL)
> 		return table_not_found(ctx);
>=20
> and later this (evaluate.c, ll. 3762f.):
>=20
> 	if (set_lookup(table, set->handle.set.name) =3D=3D NULL)
> 		set_add_hash(set_get(set), table);
>=20
> The `struct table` object returned by `table_lookup_global` is `t0`,
> since this was evaluated first and cached by `table_evaluate`, not `t1`.
> Therefore, `set_lookup` returns `NULL`, `set_add_hash` is called, `s` is
> added to `t0->sets`, and `t1->sets` is effectively corrupted.  It now
> contains two elements which point to each other, and one of them is not
> a set at all, but `t0->sets`.  This results in a seg-fault when nft
> tries to free `t1`.
>=20
> I _think_ that the following is all that is needed to fix it:
>=20
>   @@ -3759,7 +3759,8 @@ static int set_evaluate(struct eval_ctx *ctx, str=
uct set *set)
>           }
>           ctx->set =3D NULL;
>   =20
>   -       if (set_lookup(table, set->handle.set.name) =3D=3D NULL)
>   +       if (set_lookup(table, set->handle.set.name) =3D=3D NULL &&
>   +           list_empty(&set->list))
>                   set_add_hash(set_get(set), table);
>   =20
>           return 0;
>=20
> Does this look good to you?

Forgot to run the test-suite.  Doing so revealed that this doesn't quite
work because `set_alloc` doesn't initialize `s->list`.  This, however,
does:

  diff --git a/src/evaluate.c b/src/evaluate.c
  index 232ae39020cc..c58e37e14064 100644
  --- a/src/evaluate.c
  +++ b/src/evaluate.c
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
  diff --git a/src/rule.c b/src/rule.c
  index c23f87f47ae2..365feec08c32 100644
  --- a/src/rule.c
  +++ b/src/rule.c
  @@ -339,6 +339,7 @@ struct set *set_alloc(const struct location *loc)
          if (loc !=3D NULL)
                  set->location =3D *loc;
  =20
  +       init_list_head(&set->list);
          init_list_head(&set->stmt_list);
  =20
          return set;
  @@ -360,6 +361,7 @@ struct set *set_clone(const struct set *set)
          new_set->policy         =3D set->policy;
          new_set->automerge      =3D set->automerge;
          new_set->desc           =3D set->desc;
  +       init_list_head(&new_set->list);
          init_list_head(&new_set->stmt_list);
  =20
          return new_set;

Alternatively, we could continue adding the set to the cached table, but
without the seg-fault:

  diff --git a/src/evaluate.c b/src/evaluate.c
  index 232ae39020cc..23ff982b73f0 100644
  --- a/src/evaluate.c
  +++ b/src/evaluate.c
  @@ -3760,7 +3760,7 @@ static int set_evaluate(struct eval_ctx *ctx, struc=
t set *set)
          ctx->set =3D NULL;
  =20
          if (set_lookup(table, set->handle.set.name) =3D=3D NULL)
  -               set_add_hash(set_get(set), table);
  +               set_add_hash(set, table);
  =20
          return 0;
   }
  diff --git a/src/rule.c b/src/rule.c
  index c23f87f47ae2..0aaefc54c30d 100644
  --- a/src/rule.c
  +++ b/src/rule.c
  @@ -339,6 +339,7 @@ struct set *set_alloc(const struct location *loc)
          if (loc !=3D NULL)
                  set->location =3D *loc;
  =20
  +       init_list_head(&set->list);
          init_list_head(&set->stmt_list);
  =20
          return set;
  @@ -360,6 +361,7 @@ struct set *set_clone(const struct set *set)
          new_set->policy         =3D set->policy;
          new_set->automerge      =3D set->automerge;
          new_set->desc           =3D set->desc;
  +       init_list_head(&new_set->list);
          init_list_head(&new_set->stmt_list);
  =20
          return new_set;
  @@ -391,7 +393,10 @@ void set_free(struct set *set)
  =20
   void set_add_hash(struct set *set, struct table *table)
   {
  -       list_add_tail(&set->list, &table->sets);
  +       if (list_empty(&set->list))
  +               list_add_tail(&set_get(set)->list, &table->sets);
  +       else
  +               list_move_tail(&set->list, &table->sets);
   }
  =20
   struct set *set_lookup(const struct table *table, const char *name)
 =20
J.

--xKhQ2PKjEJBVe/UV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmXSDFoACgkQKYasCr3x
BA29fw//fU+vb7Pxjg0zG1WZTCj5AZr3UGnKFKOw0/lzSb/yIbdyke3Upbni0ccp
XpYukqaP530GV7EK2OyMApnkUG+/53TtXFaBJdLETPMIp4FlKzGvnE8Pwudy03BQ
sEld9OZIWyyk7ZJS/9aL6QfdsRe4NXQcdfK5vVCX8L2GoDLGKTwt028CJMBm/XgV
FqgFTz1jiAGqtQGLRke9wY+nhHkub98a4rgjG5jVYhCFknDZTYFqwdacCp70yNnB
w0z4f4a5ZciA0lxROuCwJE60xbcxMdPpTB7tG/TPzolvzm12RA+TMr0ZI7WtSic3
PEaVPELNvyoclWtnuCUiHEGgx4bCIbPBiCeruFmu1XiWL0f2+4hzce6sdD4JfDCY
AY1VlUwfagl7ZPsw/5slk6IHLJ+QvoXZpU1kj5xJ10n7uRzGcQBelFWYhxMzPW9E
6mwEwYAaFwQeUNa0NhyQON3WejbAqi9vdf/y5Kic3zHRdNOnYy3qbAa28roAvLjV
xsSGzMTOVjJ7MEPCp/ncWpITqUEDjzgu406/Xgj9a4/eYX08q0t67cYZBswL23Lt
14X+cXdHZgS3G3EUEmlwb1SWRp9ScsgrVgRWDpxKzv90g4tigGSTs99MHp6q0zqj
8/w+lXJDVqHyIt/CrkHqeAozNsTXOqfSnIfQg0iYSIqn0+OjmSQ=
=lziy
-----END PGP SIGNATURE-----

--xKhQ2PKjEJBVe/UV--
