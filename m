From: Michael Bauer <mihi@ch3cooh.org>
Subject: iptables Parseing Bug
Date: Tue, 1 Jul 2003 21:21:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030701192122.GA22816@nacl.ch3cooh.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,
While rewriting my firewall rules I found a Bug in iptables/ip6tables
command line parsing, it interpretes the correct beginning of an
argument as the whole argument. For example:

iptables -A INPUT -p tcp --sp 22 -j ACCEPT

works, it interpretes --sp as --sport. This is that far no problem.
But what if you construct something like:

iptables -A INPUT -p tcp -m mport --sport 22 --dports 1:1024 -j ACCEPT

it fails with the error:

iptables v1.2.8: multiport can only have one option

because it interpretes --sport as --sports. I worked around that useing
--sport before -m mport, but it took a long time getting the error I
made. I know it's only cosmetics, but it's a bug ;)

greetings mihi
--=20
=2Eplan: Get an ibook
	-> check http://unet.univie.ac.at/~a9900470/ibook

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (OpenBSD)
Comment: For info see http://www.gnupg.org

iD8DBQE/Ad8yduFamyGEthkRAtY6AKC0YafwiglLS0qRNZBE6sSu90tlKACgz1Hp
r/3IGrk1QtQdFrZ2pCLE+MQ=
=qZhk
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
