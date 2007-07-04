From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: Re: netfilter queue not on filter table
Date: Wed, 04 Jul 2007 10:15:42 -0600
Message-ID: <468BC7AE.8060303@cpsc.ucalgary.ca>
References: <717e7cba0707030739h48ce146es8a0e67744af3f790@mail.gmail.com>	<717e7cba0707030814h2de28c4fx8b672b518a9c008d@mail.gmail.com>	<717e7cba0707030818m2e646709wea0e8a5306904f79@mail.gmail.com>	<200707040308.l643826W014886@toshiba.co.jp>
	<717e7cba0707040500y1bf24073x59d4c6621b25292b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig595F66F821B05F14400AD23C"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <717e7cba0707040500y1bf24073x59d4c6621b25292b@mail.gmail.com>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig595F66F821B05F14400AD23C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Stanis=C5=82aw Pitucha wrote:
> Great - thanks! That solved the capturing problem. Now I'm using QUEUE
> on both PREROUTING and OUTPUT.
> But now I've got another one:
> I'm rewriting addresses like in standard dnat:
> client <-> gateway (choosing server) <-> servers
>=20
> Outgoing ones are delivered as they should: (own logging fragment)
> Tried packet: From: 192.168.1.37:32938 to: 192.168.1.111:53
> Redirection! - Sent packet: From: 192.168.1.37:32938 to: 192.168.1.1:53=

>=20
> Incoming packet gets changed:
> Got packet: From: 192.168.1.1:53 to: 192.168.1.37:32938  'n redirected
> Delivered packet: From: 192.168.1.111:53 to: 192.168.1.37:32938
>=20
> but application doesn't see it. Additionally wireshark sees outgoing
> packet changed, but incoming one original:
> 192.168.1.1:53->192.168.1.37:32938. Is that normal? What can be the
> reason? If I leave source address unchanged, packet arrives to the app
> with real source without problems.
>=20
> Thanks


Are you getting messages similar to "ip_rt_bug" in dmesg when incoming
packets get redirected?  If so, see this thread:
http://lists.netfilter.org/pipermail/netfilter-devel/2007-May/027849.html=


As for wireshark, I think that it sees incoming packets before netfilter
does and outgoing packets after netfilter finishes with them.  That
would explain the behaviour that you're seeing.

Rennie deGraaf



--------------enig595F66F821B05F14400AD23C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFGi8eyIvU5mZP08HERAoRtAJ4g4jQYCQgUiCSPdntFZqShItwqJACfQenN
Qcy+u60X17KeGPS3lQ975IA=
=mLs6
-----END PGP SIGNATURE-----

--------------enig595F66F821B05F14400AD23C--
