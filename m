From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] [NETFILTER] nf_conntrack: clean up to reduce size of
	'struct nf_conn'
Date: Tue, 31 Jan 2006 10:20:43 +0100
Message-ID: <20060131092043.GK4603@sunbeam.de.gnumonks.org>
References: <20060130232644.GI4603@sunbeam.de.gnumonks.org>
	<200601310509.k0V59g1R001069@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hZmpNjgL9fMFo2cm"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200601310509.k0V59g1R001069@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--hZmpNjgL9fMFo2cm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31, 2006 at 02:09:42PM +0900, Yasuyuki KOZAKAI wrote:

> > Please review the following patch.  I'm currently working on
> > nf_conntrack based NAT, and this patch is a minor preparation to it.
>=20
> Great!

I knew you would like that ;)

> Totally no objection. Some comments are...
>=20
> - nice cleanup. But I don't know trade off between
> 	- calculate the pointer to help at initialization and keep it.
>   and
> 	- don't keep the pointer for dieting. Instead re-calculate
> 	  when it's necessary.

The rationale is:

Recalculating the pointer is supposed to be cheap, since the offset only
depends on nf_conn.features, and the few instructions of the inlined
nf_conn_help(), both of which are very likely already in cache (because
nf_conn members are dereferenced frequently, and the nf_conn_help() code
will be prefetched by the instruction prefetcher).

Arithmetic operations are cheap, they can execute at cpu clock rate [yes
I know, x86 is not RISC, but anyway, additions are cheap].
More cache misses due to bloated data structures waste way more CPU
cycles by stalling the cpu and waiting for data to come from RAM.

However, adding the pointer to the structure itself leads to a lot of
(unnecessary) memory usage, e.g. on 64bit we have 8 bytes helper pointer
and 8 bytes nat pointer, for data structures that are only something
like 16-24 bytes.  That's a 30-50% overhead in size.

Also, the concept of putting a 'private' data structure at the end of
another structure is commonly used throughout the kernel.  The only
thing that nf_conntrack does differently, is that those offsets are not
a static 'sizeof(struct nf_conn)', but a bit more dynamic (in the end,
there's only two for both helper and nat).

>   Then let's use your patch and we can change just only nf_conn_help()
>   if and when necessary.

ok.

> - Just question. How will you make conntrack keep the pointer to
>   NAT related area ?

a) features =3D=3D 0
   no helper and no nat pointer
b) features =3D HELP
   help =3D ct + sizeof(nf_conn);
c) features =3D NAT
   help =3D NULL
   nat =3D ct + sizeof(nf_conn);
d) features =3D NAT + help
   nat =3D ct + sizeof(nf_conn);
   help =3D ct + sizeof(nf_conn) + sizeof(nf_conn_nat);
   nat_help =3D ct + sizeof(nf_conn) + sizeof(nf_conn_nat) + sizeof(nf_conn=
_help);

what is probably missing is adding the __alignof__() to the values.

> - minor fixes are as follows.

thanks.

> > @@ -842,8 +836,9 @@ __nf_conntrack_alloc(const struct nf_con
> >  {
> >  	struct nf_conn *conntrack =3D NULL;
> >  	u_int32_t features =3D 0;
> > +	void *helper;
>=20
> 'struct nf_conntrack_helper *helper' ?

yes ;)

> > @@ -1309,8 +1291,7 @@ int nf_conntrack_helper_register(struct=20
> >  	ret =3D nf_conntrack_register_cache(NF_CT_F_HELP, "nf_conntrack:help",
> >  					  sizeof(struct nf_conn)
> >  					  + sizeof(union nf_conntrack_help)
> > -					  + __alignof__(union nf_conntrack_help),
> > -					  init_conntrack_for_helper);
> > +					  + __alignof__(union nf_conntrack_help));
>=20
> The 3rd argument should be
> 	sizeof(struct nf_conn) + __alignof__(struct nf_conn_help)

good catch, fixed.

> > @@ -165,15 +165,16 @@ static inline int
> >  ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
> >  {
> >  	struct nfattr *nest_helper;
> > +	const struct nf_conn_help *help =3D nfct_help(ct);
> > =20
> > -	if (!ct->helper)
> > +	if (!help)
> >  		return 0;
>=20
> I think checking "!help->helper" is necessary, too.
> Even if nf_conntrack_helper_unregister() is called, nfct_help(ct) will re=
turns
> the valid pointer after that. But help->helper will be NULL.

applied to my tree, too.

I'll submit this for net-2.6.17 now.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--hZmpNjgL9fMFo2cm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD3yvrXaXGVTD0i/8RAhQLAJ9UBkYnAYMEn1jn8RGR7tRlafDPdACfYeCh
76uHpf0xZkkDURyLF99/WkQ=
=/cKt
-----END PGP SIGNATURE-----

--hZmpNjgL9fMFo2cm--
