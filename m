From: Daniel 'NebuchadnezzaR' Dehennin <nebuchadnezzar@nerim.net>
Subject: tcp-windows-tracking and 2.6.6
Date: Sat, 15 May 2004 12:55:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87hduiez82.fsf@thorr.asgardr.info>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

tcp-windows-tracking do not apply on 2.6.6:
patching file net/ipv4/netfilter/ip_conntrack_proto_tcp.c
Hunk #4 FAILED at 712.
Hunk #5 succeeded at 857 (offset 2 lines).
Hunk #6 succeeded at 953 (offset 2 lines).
1 out of 6 hunks FAILED -- saving rejects to file net/ipv4/netfilter/ip_con=
ntrack_proto_tcp.c.rej

It does not look as a trivial fix for me so I let expert resolve the
problem ;-)

Thanks.
=2D-=20
Daniel 'NebuchadnezzaR' Dehennin
R=E9cup=E9rer ma clef GPG:
gpg --keyserver pgp.mit.edu --recv-keys 0x4CA73DC6

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iQEVAwUAQKX3NdWamn5Mpz3GAQIM6Af+MEeMXzzZsXhDnJJan0EXDZ6eGvJ7HhQh
O9M4b83onRT2VaPHIH3pCJuYJ9OixjmmpxFNO6kdft5a/NywJrw5T7yEZ7TdQGb8
WwYXABW/ySNjzcCwIfuxJyyQThfbU9+TV1wRPlRvBWa7x7MKjfXKUmA1oGqWAGhd
H+dxBqMLDcDQi8+g/YyQjxncA7Yl+OgF9Utq4O7cSAKwHTwxCWaejf33e8u60xSr
kCnkR8zleYp2bZbm7cYTB004RdIBkj/MCjbHB4MSUuAYeQ7gu4QsGGg/81IveGsX
zEQm6F1rlmK9Gf3I7X5zDdnp3HLcKC3WTIOl6Xmrg487FUEsJpnwVg==
=FEIq
-----END PGP SIGNATURE-----
--=-=-=--
