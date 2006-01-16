From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: Firewall research
Date: Mon, 16 Jan 2006 16:52:32 -0700
Message-ID: <43CC31C0.4090508@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig70F24E874AAFF1CE196A49CD"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------enig70F24E874AAFF1CE196A49CD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I am a graduate student at the University of Calgary in Calgary, Canada,
working on a Masters' degree in computer science.  I've done some
research on port knocking (see
http://pages.cpsc.ucalgary.ca/~degraaf/papers/), and am currently
looking for a thesis project relating to firewalls and security.  If any
of you has any ideas that you don't have time to play with yourself and
that I might be able to turn into a thesis, I'd appreciate hearing them.

In particular, I'm currently looking into how to build a gateway-based
firewall that calls back to host operating systems to get process and
user names (similar to what the "owner" module does for
locally-generated traffic), and that can (to some extent) track what
processes might be making connections on behalf of other processes (by
tracking process trees and RPC).  I'm having difficulty finding
literature on how and to what extent this problem has been approached in
the past - if any of you know of any resources that I should check out,
I'd appreciate your input.

Thanks,
Rennie deGraaf

--------------enig70F24E874AAFF1CE196A49CD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFDzDHmIvU5mZP08HERAkrPAJ0d0BGCW/q5P0aJ4f2RLDwBSZ/J7QCfVxdD
fnU0GC/VBLSierp8ZPQ6uSE=
=UGqO
-----END PGP SIGNATURE-----

--------------enig70F24E874AAFF1CE196A49CD--
