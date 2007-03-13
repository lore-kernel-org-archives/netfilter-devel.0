From: Phil Dibowitz <phil@ipom.com>
Subject: Re: libnetfilter_conntrack question
Date: Tue, 13 Mar 2007 00:40:58 -0700
Message-ID: <45F6558A.2070601@ipom.com>
References: <45F4B34F.3020007@ipom.com> <45F527F2.40404@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigB04947D3B379BA8A19455491"
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F527F2.40404@netfilter.org>
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
--------------enigB04947D3B379BA8A19455491
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Pablo Neira Ayuso wrote:
> Phil Dibowitz wrote:
>> For what it's worth, I'm using libnetfilter_conntrack 0.0.31 on a 2.6.=
15.6
>> kernel (yes, I know, it's a bit old). /proc/net/ip_conntrack shows mor=
e
>> expected data - source and destinations being different.
>=20
> That release is from the Stone age, we've got one more recent, and
> you're using the old API, please upgrade. I would also suggest you to
> upgrade your kernel, at least to 2.6.18.
>=20

Noted.

Another question - is there a way to get the nfct flags map outside of a
hook? I don't see a way to pull it down, but I could be missing it.

Thanks,
--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enigB04947D3B379BA8A19455491
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF9lWKN5XoxaHnMrsRAlyOAJ9quNnL9ULhkRy/fMqDN7G4R2hwZwCff6YZ
Ym62CdwYEQG2jRTrADVXur4=
=i4fn
-----END PGP SIGNATURE-----

--------------enigB04947D3B379BA8A19455491--
