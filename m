From: Harald Welte <laforge@netfilter.org>
Subject: Re: REJECT target / need-fragment ?
Date: Sun, 10 Apr 2005 22:30:08 +0200
Message-ID: <20050410203008.GP9155@sunbeam.de.gnumonks.org>
References: <20050314125747.GA18233@paradigm.rfc822.org>
	<42373578.8060806@trash.net>
	<20050406113859.GA5335@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mN1JkpzzjA4mCWyC"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Florian Lohoff <flo@rfc822.org>
Content-Disposition: inline
In-Reply-To: <20050406113859.GA5335@paradigm.rfc822.org>
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


--mN1JkpzzjA4mCWyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 06, 2005 at 01:38:59PM +0200, Florian Lohoff wrote:
> On Tue, Mar 15, 2005 at 08:20:24PM +0100, Patrick McHardy wrote:
> > Florian Lohoff wrote:
> > >Hi,
> > >i'd like to reject packets based on their size and send back and
> > >icmp-must-fragment with a configurable size. As i can see no such
> > >possibility is there currently. The REJECT target itself does not
> > >offer this.
>=20
> > Yes, but adding yet another target that does something already done
> > elsewhere is not a good idea. You could try to extend ipt_REJECT
> > in a way similar to Rusty's patch "Add bitops to ipt_MARK without
> > breaking compatbility".
>=20
> Ok - Had a boring network change this morning - results:

thanks, looks fine to me.  I've applied the userspace part and put the
kernel part into my list of pending patches.


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mN1JkpzzjA4mCWyC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCWYzQXaXGVTD0i/8RAgZAAJ0VZoSFi+PNo+sTC5T/3PFbfa/2MwCfWFgd
GQNb7uipVC3D72GLfiVeOjk=
=WXZx
-----END PGP SIGNATURE-----

--mN1JkpzzjA4mCWyC--
