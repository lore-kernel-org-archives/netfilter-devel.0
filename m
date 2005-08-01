From: Harald Welte <laforge@netfilter.org>
Subject: Re: Bug Report: IPtables 1.2.* segfaulted by iptables 1.3.*
Date: Mon, 1 Aug 2005 22:02:33 +0200
Message-ID: <20050801200233.GA4156@rama.de.gnumonks.org>
References: <9927912d05072704113d7e8707@mail.gmail.com>
	<e756d62eb5442015@mayday.cix.co.uk>
	<20050729105834.GD7063@rama.de.gnumonks.org>
	<Pine.LNX.4.61.0508010918570.7329@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Cc: Robert de Bath <list-netfilter@debath.co.uk>,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0508010918570.7329@yvahk01.tjqt.qr>
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


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 01, 2005 at 09:19:48AM +0200, Jan Engelhardt wrote:
>=20
> >mh, mixing multiple versions of the tools is a bad idea anyway.  We have
>=20
> There are .version members in the info struct of both userspace and=20
> kernelspace modules - if they are different, why did not iptables catch t=
his?

sorry, this is for different layout of the 'per match' or 'per target'
data structures.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC7n/YXaXGVTD0i/8RAuTjAJwLvfoH6hhCrDWaKWkr+uaCh+w6aACfXBe8
GhRf65E15ZSuf4l79rVe17k=
=usHe
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
