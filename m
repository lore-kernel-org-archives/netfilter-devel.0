From: Harald Welte <laforge@netfilter.org>
Subject: Re: libiptc memory leak - PATCH
Date: Fri, 2 May 2003 17:14:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030502151458.GJ26924@sunbeam.de.gnumonks.org>
References: <3EA46FDE.6040806@i.cz> <20030427125345.GD990@sunbeam.de.gnumonks.org> <3EACD4D1.90704@i.cz> <20030430154721.GD685@sunbeam.de.gnumonks.org> <1051879671.3823.17.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hABqaeELJqnDDeDE"
Cc: =?iso-8859-1?B?VG9t4T8=?= Lejdar <tomas.lejdar@i.cz>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1051879671.3823.17.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hABqaeELJqnDDeDE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2003 at 02:47:51PM +0200, Martin Josefsson wrote:
> On Wed, 2003-04-30 at 17:47, Harald Welte wrote:
> > On Mon, Apr 28, 2003 at 09:14:25AM +0200, Tom=E1? Lejdar wrote:
> > > Hi,
> > > I thing there is no problem, the memory is freed only when the
> > > function next_chain returns NULL and run through the chains is on the=
 end.
> > > In the next call of first_chain() is memory alocated again in=20
> > > populate_cache().
> >=20
> > no, it's fine.  It was a misunderstanding. I'll apply your patch now.
> > Sorry for the fuzz.
>=20
> This patch breaks {ip,ip6}tables-{save,restore} and it runs free() on
> the wrong memoryaddress (I think free() does the right thing anyway but
> the patch still breaks stuff).

*sigh*.  I knew that I should have tested it before accepting.

> I've attached a patch that reverts this patch and adds
> iptc_exit(iptc_handle_t h) that takes care of the freeing.
> It also contains some small cleanups.

I'll apply your patch, thanks Martin.

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

--hABqaeELJqnDDeDE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+sotyXaXGVTD0i/8RAsj1AKCRzPnfmfQ7fyaEPL8wxzcgZMNjxgCeM7Z5
H1lIs0+eNQ02Exod/L/iBUI=
=PHDx
-----END PGP SIGNATURE-----

--hABqaeELJqnDDeDE--
