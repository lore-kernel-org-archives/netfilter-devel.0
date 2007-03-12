From: Phil Dibowitz <phil@ipom.com>
Subject: Re: libnetfilter_conntrack question
Date: Sun, 11 Mar 2007 23:40:12 -0700
Message-ID: <45F4F5CC.30208@ipom.com>
References: <45F4B34F.3020007@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigF6F3F5EA5861EB8C0B4759E7"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F4B34F.3020007@ipom.com>
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
--------------enigF6F3F5EA5861EB8C0B4759E7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Phil Dibowitz wrote:
> Hey folks,
>=20
> I've been playing with libnetfilter_conntrack, and I quite like where t=
he
> interface has come.
>=20
> I'm having a bit of a problem though, apparently understanding the
> nfct_conntrack struct, however.
>=20
> I have a bit of sample code that registers a callback and then calls
> nfct_dump_conntrack_table(). My callback is essentially just:

::sigh::

You can ignore the question. Since inet_ntoa uses static buffers, it was
simply inet_ntoa() overwriting that buffer before the sprintf() was done.=


Sorry for the noise.
--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enigF6F3F5EA5861EB8C0B4759E7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF9PXMN5XoxaHnMrsRAgsyAKCbulrILSZNtZh9w0BLZXPE3jXnQgCaAxQD
BRfRkBtQwQZvoPE/Bq/Z2lk=
=VDYE
-----END PGP SIGNATURE-----

--------------enigF6F3F5EA5861EB8C0B4759E7--
