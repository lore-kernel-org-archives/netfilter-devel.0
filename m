From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] big endian patch against netfilter after PPTP NAT pat ch
Date: Mon, 10 Feb 2003 14:29:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030210132955.GA24861@sunbeam.de.gnumonks.org>
References: <771F217D7A4AF84494632457889470A412D77E@bcmsg011.corp.ads> <3E41A7BC.20209@snapgear.com> <20030209092911.GO13269@naboo.fugue.com> <20030209165347.GA1737@oknodo.bof.de> <20030210110144.GX24861@sunbeam.de.gnumonks.org> <20030210123142.GA8730@rave.iinet.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U7F658e60E1K4csu"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: levsky@rave.iinet.net.au
Content-Disposition: inline
In-Reply-To: <20030210123142.GA8730@rave.iinet.net.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--U7F658e60E1K4csu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2003 at 08:31:42PM +0800, levsky@rave.iinet.net.au wrote:

> > Anybody volunteering to make a patch?  It's very easy, you don't even
> > need to know how to program ;)
>=20
> If you don't mind an offer from a complete unknown, I'd be happy
> to take it on as a learning experience.

Sure, no problem.  Just send me the patch and I'll review it to make
sure it's correct.

I have now converted (as an example) the pptp conntrack/nat helper, see
the 'line 392/416' hook in

http://cvs.netfilter.org/netfilter-extensions/helpers/pptp/ip_nat_pptp.c.di=
ff?r1=3Dtext&tr1=3D1.3&r2=3Dtext&tr2=3D1.2&f=3Du

Please use the latest 2.4.21-preX kernel for your patch and try to catch
all places within net/{ipv4,ipv6}/netfilter/*.c where this kind of
structure initialization is used.

Thanks in advance

> Cheers
> Mark

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--U7F658e60E1K4csu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+R6lTXaXGVTD0i/8RAhbQAJ4jtfy4zIlLCzbU56wha9uGDXQZwwCfcEsL
WErtzMGyFPaKCwDqXn6bTYs=
=//6U
-----END PGP SIGNATURE-----

--U7F658e60E1K4csu--
