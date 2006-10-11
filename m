From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: Re: new match extension to implement port knocking in one rule
Date: Tue, 10 Oct 2006 23:33:15 -0600
Message-ID: <452C821B.1000002@cpsc.ucalgary.ca>
References: <20061011034021.26783.qmail@web39501.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig1860A5A0BA43478BEF02489B"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: federikkom <federikkom@yahoo.com.ar>
In-Reply-To: <20061011034021.26783.qmail@web39501.mail.mud.yahoo.com>
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
--------------enig1860A5A0BA43478BEF02489B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

federikkom wrote:
> Hi everybody, we have been working in a netfilter extension to implemen=
t port knocking in a easy way. The idea is to set everything in just one =
iptables rule:
>=20

<snip>

If you're interested in port knocking, you might want to read this
paper:  http://www.acsac.org/2005/abstracts/156.html  It covers security
issues relating to port knocking in detail, and presents an architecture
 for solving most of them.

Full disclosure:  I wrote that paper.  Feel free to contact me if you
have questions.

Rennie deGraaf



--------------enig1860A5A0BA43478BEF02489B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFLIIgIvU5mZP08HERAk9jAJ4hWJjuSqjRL+Oxity3hcyVMGCF+wCeITLD
RokSOAA/WG5KOrGz6oECUk0=
=9eQO
-----END PGP SIGNATURE-----

--------------enig1860A5A0BA43478BEF02489B--
