From: Phil Dibowitz <phil@ipom.com>
Subject: Re: libnetfilter_conntrack question
Date: Fri, 16 Mar 2007 01:44:07 -0700
Message-ID: <45FA58D7.4030507@ipom.com>
References: <45F4B34F.3020007@ipom.com> <45F527F2.40404@netfilter.org>
	<45F6558A.2070601@ipom.com> <45F671CA.6010401@netfilter.org>
	<45F8D7DD.8040901@ipom.com> <45F92FD3.2080708@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigCF694C6A64573D9679EC3ABD"
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F92FD3.2080708@netfilter.org>
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
--------------enigCF694C6A64573D9679EC3ABD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Pablo Neira Ayuso wrote:
> Phil Dibowitz wrote:
>> In the new API the flags bitmap I mentioned above is gone.
>>
>> What's the "right" way to determine stuff like (flags &
>> NFCT_COUNTERS_ORIG)?
>> It used to get passed into the callback in the old API, but no longer
>> does.
>=20
> There is a nfct_attr_is_set(...) function to check if an attribute is
> set or not.

Ah. Perfect. Thanks.

One other question - I noticed that I can't seem to delete ICMP states. T=
his
is true both from my own code, as well as from conntrack(8):

[phil@rider libnetfilter_conntrack]$ sudo grep icmp /proc/net/ip_conntrac=
k
icmp     1 29 src=3D10.1.1.2 dst=3D209.40.128.125 type=3D8 code=3D0 id=3D=
43603
[UNREPLIED] src=3D209.40.128.125 dst=3D10.1.1.2 type=3D0 code=3D0 id=3D43=
603 use=3D1

[phil@rider libnetfilter_conntrack]$ sudo conntrack -D conntrack  -s
10.1.1.2 -d 209.40.128.125 -p icmp --icmp-type 8 --icmp-code 0
NFNETLINK answers: No such file or directory
Operation failed: such conntrack doesn't exist

I get the same thing either way - that the conntrack doesn't exist. I can=

delete TCP and UDP just fine, but not ICMP. And just for clarity, yes, I'=
m
attempting to delete it before it expires (this is easy to check by keepi=
ng
iptstate running in a window).

Am I doing something wrong, or can you not delete ICMP states?

Thanks!
--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enigCF694C6A64573D9679EC3ABD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF+loIN5XoxaHnMrsRAtcjAJ0WebKcpjpqhxrS/aVevTTxHFkzgACfRt2p
7ed2c4LSCh6lHh9Yv04eAo4=
=Vrrw
-----END PGP SIGNATURE-----

--------------enigCF694C6A64573D9679EC3ABD--
