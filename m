From: Stephen Frost <sfrost@snowman.net>
Subject: rp_filter
Date: Fri, 27 Dec 2002 16:11:14 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021227211113.GK677@ns>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jaoouwwPWoQSJZYp"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
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


--jaoouwwPWoQSJZYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey all,

  Can we *please* move the rp_filter cruft into the firewalling code
  proper?  I've had yet another friend come to me asking for help after
  fighting with his iptables setup for 6 hours trying to get it to work
  to discover the whole problem was rp_filter getting in the way.  If
  rp_filter was part of the actual firewalling code where it should be
  people wouldn't run into this stupid problem.

  rp_filter is an obscure option that only the poor souls who ran into
  it know about.  I've met people who have implemented it all by hand in
  iptables because they didn't know it existed, and then didn't entirely
  trust it.  The people who need the option (those who actually run
  routers or firewalls) know they need it and will take care of having
  it enabled in their firewalling code, for most people (desktop users=20
  and whatnot) it's useless anyway because they've only got one
  interface.

  	Stephen

--jaoouwwPWoQSJZYp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+DMHxrzgMPqB3kigRAmcMAKCWRfEnCG+QzgpMr98tx23ESqAZJQCfYmfh
GzPe6aANfiHb0t/fkozLpwU=
=JlQx
-----END PGP SIGNATURE-----

--jaoouwwPWoQSJZYp--
