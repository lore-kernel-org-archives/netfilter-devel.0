From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking and Poptop on same box
Date: Fri, 5 Sep 2003 13:55:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030905115534.GD665@obroa-skai.de.gnumonks.org>
References: <3F542C4E.1000307@netbox.biz> <Pine.GSO.4.56.0309031853090.10914@shemp.vdata.com> <3F56E2E2.5040007@netbox.biz> <Pine.GSO.4.56.0309040327250.10914@shemp.vdata.com> <3F57D70B.3040307@netbox.biz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LTeJQqWS0MN7I/qa"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Menno Smits <menno@netbox.biz>
Content-Disposition: inline
In-Reply-To: <3F57D70B.3040307@netbox.biz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 05, 2003 at 10:21:31AM +1000, Menno Smits wrote:
> Jeff Hall wrote:
>=20
> >  > I checked the patches in your posts against a POM patched 2.4.20 ker=
nel
> >  > I used to use here which exhibits the same problems as my 2.4.21=20
> >  kernel.
> >  > I can't even find where your patches to ip_conntrack_pptp.c could be
> >  > applied! (even when trying to apply the patch manually). Key lines=
=20
> >  which
> >  > surround your changes simply don't exist in my tree. I was using POM=
=20
> >  out
> >  > of CVS from a few months ago in that kernel. What POM version are you
> >  > using? Which POM patches are you using?
> >  >
> >I started with the 20030107 POM but then added individual patches I
> >needed from the CVS archives. I tried to detail them as clearly as possi=
ble
> >in the March 2nd and 3rd memos. I'm afraid that is the best I can do now
> >after 6 months.  I'll send you the fully patched sources I'm using in a
> >personal message. I hope you find them useful. I'll send you anything
> >dated newer than when I ran the 20030107 POM against the 2.4.20 base.
>=20
> Thanks for trying to remember. I appreciate that asking you to remember
> what obscure patches you used 6 months ago is a bit of an ask :)

I'm sorry for this whole mess.  Releasing a new version of the
pptp-conntrack-nat patch is on my TODO list for quite some time.  I'll
expect it to be done during the next week.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LTeJQqWS0MN7I/qa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WHm1XaXGVTD0i/8RAgq3AJ0fN2OlCh6otlT5aMcq1/RVAcFa6QCfWtAL
e4oJrwYeMl3ycSTal4rEvmM=
=ZKPZ
-----END PGP SIGNATURE-----

--LTeJQqWS0MN7I/qa--
