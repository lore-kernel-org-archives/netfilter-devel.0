From: Alexander Samad <alex@samad.com.au>
Subject: iptables 1.3.1 crashes on iptables-restore
Date: Wed, 30 Mar 2005 13:46:16 +1000
Message-ID: <20050330034616.GA8639@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I have just build 1.3.1 (svn version 3805)  with these patches
 policy=20
TARPIT iprange raw dstlimit time IPMARK CLASSIFY
dropped-table pool realm TCPLAG ULOG account nf_conntrack nth owner-
socketlookup ownercmd conntrack-cacheline-opt osf mport tcp-window-
tracking quota from POM-NG


when I try to do a iptables-restore with about 800 lines I get a
segmentation fault.

What is the most expediant way to track this problem down ?

Alex

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCSiEIkZz88chpJ2MRApf+AKDEQ/0NQ9buOyfAI83dkMmCAo/lPwCgv4Q0
/T/RUjLiqfG9u2vrXq+Trbg=
=OHUu
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
