From: Harald Welte <laforge@netfilter.org>
Subject: Re: libiptc memory leak - PATCH
Date: Fri, 2 May 2003 17:21:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030502152147.GK26924@sunbeam.de.gnumonks.org>
References: <3EA46FDE.6040806@i.cz> <20030427125345.GD990@sunbeam.de.gnumonks.org> <3EACD4D1.90704@i.cz> <20030430154721.GD685@sunbeam.de.gnumonks.org> <1051879671.3823.17.camel@tux.rsn.bth.se> <1051883276.3811.24.camel@tux.rsn.bth.se> <1051884858.3823.32.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="72k7VsmfIboquFwl"
Cc: =?iso-8859-1?B?VG9t4T8=?= Lejdar <tomas.lejdar@i.cz>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1051884858.3823.32.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--72k7VsmfIboquFwl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2003 at 04:14:19PM +0200, Martin Josefsson wrote:
> On Fri, 2003-05-02 at 15:47, Martin Josefsson wrote:
> > On Fri, 2003-05-02 at 14:47, Martin Josefsson wrote:
> >=20
> > > This patch breaks {ip,ip6}tables-{save,restore} and it runs free() on
> > > the wrong memoryaddress (I think free() does the right thing anyway b=
ut
> > > the patch still breaks stuff).
> >=20
> > Ok, I was wrong, it did free on a correct memoryaddress, I'll fix up my
> > patch and resend, sorry about that.
>=20
> Here's an updated patch that fixes the memory-leak in the previous one.

applied this one instead of the other.

> This should fix it correctly (I hope), iptables, iptables-{save,restore}
> works fine.

we'll see.  I think iptables-1.2.9 is in a quite distant future, so
I hope we discover any potentially introduced bugs until then.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--72k7VsmfIboquFwl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+so0LXaXGVTD0i/8RApZAAKCBZWEhX1JO71lIbhFt4SsPMLVVsQCgpNLj
sHiApwTMfHVFkZOGwAzvhCQ=
=4m0n
-----END PGP SIGNATURE-----

--72k7VsmfIboquFwl--
