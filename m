From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPP2P 0.7 update (POM-ng patch included)
Date: Tue, 1 Feb 2005 11:07:53 +0100
Message-ID: <20050201100753.GT6878@sunbeam.de.gnumonks.org>
References: <41CB587A.4000402@studserv.uni-leipzig.de>
	<20050104104108.GU11370@sunbeam.de.gnumonks.org>
	<41DB0781.50301@studserv.uni-leipzig.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qXPE+6hUsFlDAc0e"
Cc: netfilter-devel@lists.netfilter.org
To: Eicke Friedrich <mai97bwf@studserv.uni-leipzig.de>
Content-Disposition: inline
In-Reply-To: <41DB0781.50301@studserv.uni-leipzig.de>
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


--qXPE+6hUsFlDAc0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 04, 2005 at 10:15:45PM +0100, Eicke Friedrich wrote:
> But thinking about it your're absolutely right so
> I've removed both switches from IPP2P.

Thanks for taking this into consideration.

> Users can use -p tcp or -p udp for a single protocol only or omit -p
> at all to search both protocols. Sorry 'bout this and thanks for the
> hint Harald. IPP2P 0.7.2 as patch against pom-ng is attached.

sorry for the long delay, now committed to svn (Revision 3623)

> Regards,
> Eicke
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qXPE+6hUsFlDAc0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/1T5XaXGVTD0i/8RAjh0AKCTCHPCpTCTBVhGPUNU/JRsMnm/bQCeM2yJ
oa4zP+cksOk2E9Mscic6avE=
=uiZK
-----END PGP SIGNATURE-----

--qXPE+6hUsFlDAc0e--
