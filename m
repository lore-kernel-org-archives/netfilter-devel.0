From: Alexander Samad <alex@samad.com.au>
Subject: Re: Netfilter+IPsec patches
Date: Thu, 27 May 2004 14:46:13 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040527044613.GC24464@samad.com.au>
References: <20040526033537.GH4402@samad.com.au> <40B53CCE.40704@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40B53CCE.40704@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--RIYY1s2vRbPFwWeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 27, 2004 at 02:56:46AM +0200, Patrick McHardy wrote:
> Alexander Samad wrote:
> >Patrick
> >
> >whilst debugging a ipsec bug I noticed these problems
> >
> >when you do a tcpdump you the decrypted packet seems to show up
> > twice it seems to be the exact same packet.
>=20
> Yes, this is a consequence of passing the packets though the stack again
> once we know decapsulation is finished. It will also cause statistics
> to account for the packet twice.
Understand that, but I see the unencapsulated packet twice (tcpdump
see's it 3 times enc + 2 x unencap)
>=20
> >
> >I am running this on a debian 2.6.4 kernel with the netfilter patchs
> >applied
> >(up to date cvs)
> >
> >
> >tcpdump output
> >=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >13:23:05.868512 0:a:8b:6a:30:8c 0:5:5d:64:c6:4e 0800 150:
> >202.154.115.130 > 138.130.55.80: ESP(spi=3D0x6e3852ef,seq=3D0x29)
> >13:23:05.868512 0:a:8b:6a:30:8c 0:5:5d:64:c6:4e 0800 98: 192.168.5.1 >
> >192.168.10.1: icmp: echo request (DF)
> >13:23:05.868512 0:a:8b:6a:30:8c 0:5:5d:64:c6:4e 0800 98: 192.168.5.1 >
> >192.168.10.1: icmp: echo request (DF)
> >
> >
> >my other problem is when I ping across the ipsec tunnel  from the remote
> >end to the server end I see the packets come in the interface, I see
> >them in the INPUT table and in the mangle table, but it never seems to
> >get back to the application
>=20
> Please give some more details on the configuration, like:
>=20
> Are you using NAT ?
> Are you marking the packets in the mangle table ?
> Are the packets forwarded when they get out of the tunnel ?
>=20
> When you see the packets in the INPUT chain, does their source- and
> destination address match your policy ?
>=20
> Regards
> Patrick
I did some futher testing, I was in NAT-T mode, when I removed the
nat'ing it started to work.

I had not being doing anything in mangle, but I did put in some lines to
accept and to count the packets.

I did the same on the INPUT chain as well and then placed a LOG before
(lines 1&2 on INPUT) and it seemed to have the right information.

The packets are destined for the box that terminates the IPSEC tunnel.
I am presume it met the policy as the packets where decrypted.



>=20
> >
> >
> >
> >from ipsec auto --status
> >=3D=3D=3D=3D
> >000 "roadwarrior.internet.nat"[4]:
> >192.168.8.0/22=3D=3D=3D138.130.55.80:4500[C=3DAU, ST=3DNSW, L=3DSydney, =
O=3DA.Samad
> >Pty Ltd, OU=3DAlfred St, CN=3Dsydlxfw01,
> >E=3Dsydlxfw01@samad.com.au]---138.130.52.1...144.137.104.46:4500[C=3DAU,
> >ST=3DNSW, L=3DSydney, O=3DA.Samad Pty Ltd, OU=3DAlfred St,
> >CN=3Dasamadlx.samad.com.au, E=3Dasamadlx@samad.com.au]=3D=3D=3D192.168.8=
=2E2/32;
> >erouted; eroute owner: #30
> >
> >Thanks
> >Alex
>=20
>=20

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAtXKVkZz88chpJ2MRAh4ZAJ9lOWnLjHFbNyKIvCeHHraY3vMWAQCeKNkk
YjhvQGYE4GgOXu4wVwUHpc4=
=PzQ+
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--
