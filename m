From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] man page: alphabetize extensions + add physdev entry
Date: Tue, 18 Feb 2003 18:38:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030218173828.GU11812@sunbeam.de.gnumonks.org>
References: <200302132039.58656.bdschuym@pandora.be> <20030214072944.GI14794@sunbeam.de.gnumonks.org> <20030218164739.GF445@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vy1A5eXR7jld12ZH"
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20030218164739.GF445@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Vy1A5eXR7jld12ZH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2003 at 05:47:40PM +0100, Herv=E9 Eychenne wrote:
> > What also is on my TODO list for some time:  Put manpage sections for
> > all recently-added-to-mainstream-kernel matches+targets.  I think the
> > manpage hasn't been synced with the by-default available matches/targets
> > for quite some time.
>=20
> Oh, really?
> It seems to me that my last patch added the missing matches and
> targets, and that none has been added since (although I remember
> having posted a request on netfilter-devel about the possible
> inclusion of NETMAP in mainstream kernel and received no answer...).
>=20
> I just checked my /usr/src/linux-2.4.20/net/ipv4/netfilter and I saw
> no match or target available in mainstream kernel (this is what you
> mean by "default", am I right?) which is missing in the current
> iptables manpage...

oops, great :)  So let's just assume everything is fine then.  Thanks a
lot.

> However, some new options in existing netfilter modules may well be
> missing (I didn't check), if the person who added them didn't provide
> any manpage update in his patch, which is of course a very bad thing
> (not) to do.

yes, I know.  But this kind of laziness even happens to me (because I
just don't think about it...)

>  Herve

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Vy1A5eXR7jld12ZH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Um+UXaXGVTD0i/8RAvPNAKCB2ArJXGYAD3L1GNYUTcRRn/DU3ACdFncR
F4BjxVDdx4AFzNm2NlGxewo=
=t0O1
-----END PGP SIGNATURE-----

--Vy1A5eXR7jld12ZH--
