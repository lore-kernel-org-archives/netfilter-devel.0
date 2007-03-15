From: Phil Dibowitz <phil@ipom.com>
Subject: Re: libnetfilter_conntrack question
Date: Wed, 14 Mar 2007 22:21:33 -0700
Message-ID: <45F8D7DD.8040901@ipom.com>
References: <45F4B34F.3020007@ipom.com> <45F527F2.40404@netfilter.org>
	<45F6558A.2070601@ipom.com> <45F671CA.6010401@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigBEB6B7C8BC83EA4AD0F04B3D"
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F671CA.6010401@netfilter.org>
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
--------------enigBEB6B7C8BC83EA4AD0F04B3D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Pablo Neira Ayuso wrote:
> Phil Dibowitz wrote:
>> Another question - is there a way to get the nfct flags map outside of=
 a
>> hook? I don't see a way to pull it down, but I could be missing it.
>=20
> Sorry, I don't understand what you mean.

Pablo, et al,

In the new API the flags bitmap I mentioned above is gone.

What's the "right" way to determine stuff like (flags & NFCT_COUNTERS_ORI=
G)?
It used to get passed into the callback in the old API, but no longer doe=
s.

Thanks again for all your help!
--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enigBEB6B7C8BC83EA4AD0F04B3D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF+NfdN5XoxaHnMrsRApavAJ9ai0ZcpPPIQiiDRUitNnD7yfOn9wCfemtA
AI2kL9wLRhJufc+YhfeTxbM=
=3nKs
-----END PGP SIGNATURE-----

--------------enigBEB6B7C8BC83EA4AD0F04B3D--
