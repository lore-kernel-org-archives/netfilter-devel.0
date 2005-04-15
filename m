From: Harald Welte <laforge@netfilter.org>
Subject: Re: REJECT target / need-fragment ?
Date: Fri, 15 Apr 2005 11:36:18 +0200
Message-ID: <20050415093618.GG25433@sunbeam.de.gnumonks.org>
References: <20050314125747.GA18233@paradigm.rfc822.org>
	<42373578.8060806@trash.net>
	<20050406113859.GA5335@paradigm.rfc822.org>
	<20050410203008.GP9155@sunbeam.de.gnumonks.org>
	<20050411223144.GA13620@paradigm.rfc822.org>
	<9151ac2a05041304326389f0e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iiGw1pLv4Q7HfyNL"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Filip Sneppe <filip.sneppe@gmail.com>
Content-Disposition: inline
In-Reply-To: <9151ac2a05041304326389f0e4@mail.gmail.com>
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


--iiGw1pLv4Q7HfyNL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 13, 2005 at 01:32:01PM +0200, Filip Sneppe wrote:
> On 4/12/05, Florian Lohoff <flo@rfc822.org> wrote:
> > On Sun, Apr 10, 2005 at 10:30:08PM +0200, Harald Welte wrote:
> > >
> > > thanks, looks fine to me.  I've applied the userspace part and put the
> > > kernel part into my list of pending patches.
> > >
> >=20
> > The kernel part needs an intialization in _v1 for the pmtu value -
> > Otherwise we leak the short pmtu as it gets used uninitialized.
> > Probably 1500 is a good value.
> >=20
> Hi Florian,
>=20
> FYI, You may want to check the compilation of svn iptables against
> a 2.4 kernel.

I've now pulled out the changes.  Please re-submit after confirming that=20

1) you can compile iptables with the pmtu patch against old (non-pmtu)
   2.6 kernel
2) you can compile iptables with the pmtu patch against old (non-pmtu)
   2.6 kernel
3) you can compile old non-pmtu iptables without pmtu patch against new
   (pmtu) 2.6 kernel

Thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--iiGw1pLv4Q7HfyNL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCX4sSXaXGVTD0i/8RAtFHAJ9N967LioITOg49Opiy6dPEo8l+dACglHO3
HT0xm5z3J5CtA20Xeh8Edic=
=ewZe
-----END PGP SIGNATURE-----

--iiGw1pLv4Q7HfyNL--
