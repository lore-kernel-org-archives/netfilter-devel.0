From: Tom Marshall <tommy@home.tig-grr.com>
Subject: Re: Experimental RTSP modules
Date: Sat, 24 May 2003 07:30:23 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030524143023.GA31579@home.tig-grr.com>
References: <20030406033532.GA23082@home.tig-grr.com> <20030523195843.GQ3077@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030523195843.GQ3077@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2003 at 09:58:43PM +0200, Harald Welte wrote:
> On Sat, Apr 05, 2003 at 07:35:32PM -0800, Tom Marshall wrote:
> > Please note this is an experimental module.  It works for me.  It may w=
ork
> > for you, it may panic your kernel, or it may just sit there using ram.
>=20
> great news. If you could convert it to patch-o-matic format, I'm happy
> to include it!

Thank you.

I am interested in getting the module into the mainline kernel.  I believe
this is where the majority of users are.  I have not and will not use p-o-m=
.=20
I will convert the patch to use kernel coding standards if someone would
sponsor the change to the 2.4 kernel, but any changes necessary to use p-o-m
will need to be done by someone else because I have zero interest.

> >  * Handle multiple SETUP messages in a single packet.
> >  * Un-mangle client_port on return trip.
>=20
> Any progress so far?

Well, no feedback so far at all so I have left the code alone for the
moment.  I'm sure you are familiar with the phenomenon.  ;-)

--=20
Football combines the two worst features of American life.
It is violence punctuated by committee meetings.
        -- George F. Will

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iEYEARECAAYFAj7Pgf8ACgkQFMm9uvwPXW5lrwCeLV6ldy6BPZsy52oaFPsStHJF
rhcAn1yRgye0gBPOoiALyDFG8eqVQ3pL
=i13C
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
