From: Alexander Samad <alex@samad.com.au>
Subject: Netfilter+IPsec patches
Date: Wed, 26 May 2004 13:35:37 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040526033537.GH4402@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hK8Uo4Yp55NZU70L"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hK8Uo4Yp55NZU70L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Patrick

whilst debugging a ipsec bug I noticed these problems

when you do a tcpdump you the decrypted packet seems to show up
 twice it seems to be the exact same packet.

I am running this on a debian 2.6.4 kernel with the netfilter patchs
applied
(up to date cvs)


tcpdump output
=3D=3D=3D=3D=3D=3D=3D=3D=3D
13:23:05.868512 0:a:8b:6a:30:8c 0:5:5d:64:c6:4e 0800 150:
202.154.115.130 > 138.130.55.80: ESP(spi=3D0x6e3852ef,seq=3D0x29)
13:23:05.868512 0:a:8b:6a:30:8c 0:5:5d:64:c6:4e 0800 98: 192.168.5.1 >
192.168.10.1: icmp: echo request (DF)
13:23:05.868512 0:a:8b:6a:30:8c 0:5:5d:64:c6:4e 0800 98: 192.168.5.1 >
192.168.10.1: icmp: echo request (DF)


my other problem is when I ping across the ipsec tunnel  from the remote
end to the server end I see the packets come in the interface, I see
them in the INPUT table and in the mangle table, but it never seems to
get back to the application



=66rom ipsec auto --status
=3D=3D=3D=3D
000 "roadwarrior.internet.nat"[4]:
192.168.8.0/22=3D=3D=3D138.130.55.80:4500[C=3DAU, ST=3DNSW, L=3DSydney, O=
=3DA.Samad
Pty Ltd, OU=3DAlfred St, CN=3Dsydlxfw01,
E=3Dsydlxfw01@samad.com.au]---138.130.52.1...144.137.104.46:4500[C=3DAU,
ST=3DNSW, L=3DSydney, O=3DA.Samad Pty Ltd, OU=3DAlfred St,
CN=3Dasamadlx.samad.com.au, E=3Dasamadlx@samad.com.au]=3D=3D=3D192.168.8.2/=
32;
erouted; eroute owner: #30

Thanks
Alex

--hK8Uo4Yp55NZU70L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAtBCJkZz88chpJ2MRAqnDAJ99dhIpzcT2tYaE/QtYugzI+lqKfQCgrvtZ
OW25LNtoNccS4blig9bw7fc=
=89gz
-----END PGP SIGNATURE-----

--hK8Uo4Yp55NZU70L--
