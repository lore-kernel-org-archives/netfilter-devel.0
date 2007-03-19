From: Phil Dibowitz <phil@ipom.com>
Subject: Announce: IPTState 2.2.0
Date: Sun, 18 Mar 2007 22:49:09 -0700
Message-ID: <45FE2455.7070509@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig2F46C5851D2123CE3ADDF0D7"
To: netfilter-devel@lists.netfilter.org
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
--------------enig2F46C5851D2123CE3ADDF0D7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Just an FYI, I've released iptstate 2.2.0.

Version 2.2.0 marks the porting of iptstate to libnetfilter_conntrack (th=
e
new API, specifically). This allowed lots of new features in this version=

such as deleting states from the conntrack table, displaying the per-stat=
e
bytes/packets counters, and more.

Other features include better scrolling support, display of ICMP IDs, and=

support for having a state table larger than 32767 entries.

http://www.phildev.net/iptstate/

Thanks to Pablo and everyone else here for answering my
libnetfilter_conntrack questions!

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enig2F46C5851D2123CE3ADDF0D7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF/iRVN5XoxaHnMrsRAgggAKCAj0XzdecruRwJnKQLM1ls25j4SgCeOVxC
wDFqKluURl8ZGRn0+d8+TTY=
=M4PZ
-----END PGP SIGNATURE-----

--------------enig2F46C5851D2123CE3ADDF0D7--
