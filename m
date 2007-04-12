From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: Locking in iptables target functions
Date: Thu, 12 Apr 2007 12:40:12 -0600
Message-ID: <461E7D0C.8010408@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigB648F7B73BBE73C17A8B126E"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------enigB648F7B73BBE73C17A8B126E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

Are interrupts disabled while iptables match and target functions are
being evaluated?  If so, then is there an efficient method to test this?
 If not, they why does the kernel complain when I attempt to acquire a
spinlock from within a target function?

Rennie deGraaf


--------------enigB648F7B73BBE73C17A8B126E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGHn0QIvU5mZP08HERAldiAKCaqZCpozr+QhSUIBhts265vitfeQCg215X
s7mzJMBo/nJ6+4O6qoNZIFw=
=gJNS
-----END PGP SIGNATURE-----

--------------enigB648F7B73BBE73C17A8B126E--
