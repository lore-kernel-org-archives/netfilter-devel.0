From: Harald Welte <laforge@netfilter.org>
Subject: Re: problem regarding ftp helper
Date: Wed, 11 Oct 2006 16:45:52 +0200
Message-ID: <7729.28187293491$1160580037@news.gmane.org>
References: <398911740610110725u4c132362pff2223f50640920e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: manu gautam <manugautam25@gmail.com>
Content-Disposition: inline
In-Reply-To: <398911740610110725u4c132362pff2223f50640920e@mail.gmail.com>
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


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 11, 2006 at 07:55:25PM +0530, manu gautam wrote:
> By looking at the source code I cudnt figure out that how come helper
> is able to put the port information in the expect structure that it
> obtains from PORT command packet in case of active FTP. Other things
> are pretty clear in the NAT and CONNTRACK files.

I'm not really sure if I understand your question correctly. =20

Are you asking why we create an expectation for active FTP?

This is mainly for the case where we have a stateful packet filter (or
NAT) in front of a FTP Server (rather than in front of the client).

In this case, passive / active are reversed, and we need to track (and
possibly nat) the active FTP connections.

Please post further questions to the netfilter-devel mailinglist

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFLQOgXaXGVTD0i/8RAs4tAJ45E5TporzOuDw0kW/E0zFkR7oG+gCfR1eR
D116DeEqJDft1qFXAQnSA/A=
=Yq94
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
