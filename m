From: Harald Welte <laforge@netfilter.org>
Subject: Re: Function pointers in conntrack structures
Date: Fri, 5 Sep 2003 14:10:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030905121012.GE665@obroa-skai.de.gnumonks.org>
References: <20030902131616.GA3235@sch.bme.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6e7ZaeXHKrTJCxdu"
Cc: Kovacs Krisztian <piglet@sch.bme.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030902131616.GA3235@sch.bme.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 02, 2003 at 03:16:16PM +0200, Kovacs Krisztian wrote:
>=20
>   Hi,
>=20
>   I've found a weird looking function pointer in the connection tracking
> system: the expectfn member of struct ip_conntrack_expect. AFAIK, this
> function would be called by conntrack when a matching connection is found
> for the registered expectation. However, I was unable to find any
> conntrack helpers which use this functionality.

There are at least three users... a quick grep in patch-o-matic/extra
gives:
ip_conntrack_h323.c in function h245_help()
ip_conntrack_pptp.c in function exp_gre()
ip_conntrack_talk.c in function talk_help_response()

>   My problem with this function pointer is that it cannot be replicated:
> you cannot just send the function pointer over the wire, because on the
> other nodes it may have completely different address. While there are
> other pointers in the conntrack structures as well, all of them have some
> kind of associated data which can be used as an ID. (For example: although
> helpers -- which are function pointers of some kind -- are associated with
> conntrack entries, however, they have to be registered, and the conntrack
> entry is associated with the registered helper structure instead of just =
the
> callback function. This is very important, because these structures all
> contain a "name" field, which can be used as an ID.

yes.  The expectfn is also associated with the conntrack helper (it is
part of the conntrack helper module).   However, there can be multiple
expectfn()'s in a single helper, and some expectations are dealt with
one expectfn(), other expectations [of the same connection] are dealth
with the other expectfn().

This exactly resembles the protocol-stacks used in protocols like H.323
or SIP.  You have a single control session that spawns multiple other
sessions.  for SIP you have the SIP session, and you spawn usually one
or more pairs of RTP/RTCP data sessions.  So depending of the kind of
'sibling', you want different expectfn's to be called.

>   So, the only problem point I've found is the expectfn field of struct
> ip_conntrack_expect, for which I've no idea how that could be handled. Is
> the possibility of having more than one kind of callback function for
> expectation creation really so important? (If only one kind of function
> would be usable by conntrack helpers, its address could be stored in
> struct ip_conntrack_helper, and we didn't have the whole problem.)

Yes, it is important.  I doubt we can support the more complex protocols
without it.

Maybe we'd have to introduce an API to register expectfn's with the
core (including a name).  And then we store a pointer to the registered
structure (much like the 'helper' field currently) and you can replicate
the name.

I still don't like this approach - but it's viable. =20

Any further comments/ideas/suggestions?

>   Any ideas?
>=20
> --=20
>  Kov=E1cs Kriszti=E1n (Hidden)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6e7ZaeXHKrTJCxdu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WH0kXaXGVTD0i/8RAiHcAJ9Gk1NFXP1oW6zz2qA3Vsj/cFwMKQCgljvS
ExCXGllJj+Y9es8ZoweAbHM=
=BJad
-----END PGP SIGNATURE-----

--6e7ZaeXHKrTJCxdu--
