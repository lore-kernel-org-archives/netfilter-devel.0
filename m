From: Harald Welte <laforge@netfilter.org>
Subject: Re: suggestion, p-o-m, iplimit for ipv6 protocol
Date: Sun, 27 Apr 2003 15:08:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427130838.GI990@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.50.0304222153490.22016-100000@cki.net.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7GFA+bvAY1vP//DC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Marek Figielski <raptorek@cki.net.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.50.0304222153490.22016-100000@cki.net.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7GFA+bvAY1vP//DC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 10:08:33PM +0200, Marek Figielski wrote:
>=20
> I am user of iptables and p-o-m. At the moment there is no netfilter
> allowing to limit outgoing connections via ip6 (like iplimit for ipv4). Of
> course I know that there is 'limit' for ip6tables, but his practical
> application is a little other than ipt 'iplimit'. I think that
> 'iplimit' from iptables written for ipv6 protocol (for ip6tables)
> would be good idea. I hope You'll think about it.

As there is no connection tracking for IPv6, there is no chance of
implementing an 'iplimit' match for ip6_tables :(

sorry,

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7GFA+bvAY1vP//DC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9ZWXaXGVTD0i/8RArH3AJ9uxE9vCgAnH1fPdl9zxlq4DoH9SACgoxAE
yRA9p0Lhg9NunnKUvhNEXPA=
=RII1
-----END PGP SIGNATURE-----

--7GFA+bvAY1vP//DC--
