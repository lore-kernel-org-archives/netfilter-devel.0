From: Phil Dibowitz <phil@ipom.com>
Subject: libnetfilter_conntrack question
Date: Sun, 11 Mar 2007 18:56:31 -0700
Message-ID: <45F4B34F.3020007@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigB2B8AC017F0032FDD1B0DA45"
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
--------------enigB2B8AC017F0032FDD1B0DA45
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey folks,

I've been playing with libnetfilter_conntrack, and I quite like where the=

interface has come.

I'm having a bit of a problem though, apparently understanding the
nfct_conntrack struct, however.

I have a bit of sample code that registers a callback and then calls
nfct_dump_conntrack_table(). My callback is essentially just:

sprintf(buf,"%s:%d %s:%d %d",
                inet_ntoa(ct->tuple[NFCT_DIR_ORIGINAL].src),
                ct->tuple[NFCT_DIR_ORIGINAL].l4src,
                inet_ntoa(ct->tuple[NFCT_DIR_ORIGINAL].dst),
                ct->tuple[NFCT_DIR_ORIGINAL].l4dst,
                ct->tuple[NFCT_DIR_ORIGINAL].protonum);

The problem is... I always get the same thing for src and dst and sometim=
es
for l4src/l4dst

In the example above, I get every connection is listed as going from some=

internal machine to *itself* but to/from different ports:

If I do ORIGINAL for src and REPLY for dst everything is going from some
internal IP to the same internal IP on the *same port*.

If I set them all to REPLY, I get mostly external IPs with a few internal=

IPs, but again, it's all from some IP to that *same* IP.

I even tried ORIGINAL with src and REPLY as src for the destination on a
whim which also gave me all internal addresses.

I've yet to figure out how to pull the source and destination for a given=

nfct_conntrack struct.

For what it's worth, I'm using libnetfilter_conntrack 0.0.31 on a 2.6.15.=
6
kernel (yes, I know, it's a bit old). /proc/net/ip_conntrack shows more
expected data - source and destinations being different.

Any help would be appreciated, thanks.
--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enigB2B8AC017F0032FDD1B0DA45
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF9LNPN5XoxaHnMrsRAr3CAJ0SxA4kdrZSl8Fw7kKB0WnMgw2mmwCfUAzg
FlDp8USMNYZ9mZZKg7yt5y4=
=50xR
-----END PGP SIGNATURE-----

--------------enigB2B8AC017F0032FDD1B0DA45--
