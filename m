From: Tom Marshall <tommy@home.tig-grr.com>
Subject: Re: suggestion, p-o-m, iplimit for ipv6 protocol
Date: Tue, 29 Apr 2003 20:30:35 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430033035.GB4762@home.tig-grr.com>
References: <Pine.LNX.4.50.0304222153490.22016-100000@cki.net.pl> <20030427130838.GI990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Marek Figielski <raptorek@cki.net.pl>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030427130838.GI990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 27, 2003 at 03:08:38PM +0200, Harald Welte wrote:
> On Tue, Apr 22, 2003 at 10:08:33PM +0200, Marek Figielski wrote:
> >=20
> > I am user of iptables and p-o-m. At the moment there is no netfilter
> > allowing to limit outgoing connections via ip6 (like iplimit for ipv4).=
 Of
> > course I know that there is 'limit' for ip6tables, but his practical
> > application is a little other than ipt 'iplimit'. I think that
> > 'iplimit' from iptables written for ipv6 protocol (for ip6tables)
> > would be good idea. I hope You'll think about it.
>=20
> As there is no connection tracking for IPv6, there is no chance of
> implementing an 'iplimit' match for ip6_tables :(

Sorry for a perhaps naive question, but why is there no IPv6 conntrack?

--=20
Guilty until proven innocent: abusing the legal system in the name of the
war on terror.  http://www.wired.com/news/conflict/0,2100,58326,00.html

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iEYEARECAAYFAj6vQ1sACgkQFMm9uvwPXW5qpgCcDZpjJup8AGeo4O6QRkvU1/0H
FjUAnjAaRcvPwRdyCsH5JmBIuokZ9eUM
=jPyr
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
