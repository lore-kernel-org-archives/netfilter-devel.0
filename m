From: Phil Dibowitz <phil@ipom.com>
Subject: Re: libnetfilter_conntrack question
Date: Tue, 13 Mar 2007 11:34:20 -0700
Message-ID: <45F6EEAC.1020300@ipom.com>
References: <45F4B34F.3020007@ipom.com> <45F527F2.40404@netfilter.org>
	<45F6558A.2070601@ipom.com> <45F671CA.6010401@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigD95CCA6B432D209F32883DDF"
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
--------------enigD95CCA6B432D209F32883DDF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Pablo Neira Ayuso wrote:
> Phil Dibowitz wrote:
>> Another question - is there a way to get the nfct flags map outside of=
 a
>> hook? I don't see a way to pull it down, but I could be missing it.
>=20
> Sorry, I don't understand what you mean.

Inside nfct there is a flags unsigned int that says stuff like "do you ha=
ve
counters enabled" and various other things. Is there a function I can cal=
l
to get it?

For example - if a user requests display of byte/packet counters, I'd lik=
e
to be able to check if support for that is in the kernel, if it's not, sa=
y
so, throw a message about it, and then continue on rather than figure it =
out
in a hook and try and save off some data about it so I can handle it late=
r.

> BTW, I suggest you to have a look a new_api_test.c under utils/ to get
> quick look on the new API. The old API is deprecated and will vanish
> sooner or later, new apps must use the new API.

Thakns for the heads up. ..and I just ported my app from
/proc/net/ip_conntrack to libnetfilter-conntrack-0.0.30. Just so I know, =
do
you plan any other major API changes soon?

Anyway... new_api_test.c does _test_ the API... the only thing I currentl=
y
use in my app is

nfct_open()
nfct_register_callback()
nfct_dump_conntrack_table()
nfct_close()

and then in my hook I just go digging through the nfct_conntrack struct f=
or
the data I want.

The struct appears the same. But instead of dump_conntrack, it looks like=

I'd call nfct_callback_register() with NFCT_ALL and then nfct_query with
NFCT_Q_DUMP... or am I missing some other change here from a quick glance=
 at
the code?

Thanks again,
--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enigD95CCA6B432D209F32883DDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF9u6sN5XoxaHnMrsRAka/AJ4pffRmTkfUmhwwxaypUHGUpLcjbgCglvPa
NEM9NLKIeEgPPrlfnlXoTEg=
=5CZl
-----END PGP SIGNATURE-----

--------------enigD95CCA6B432D209F32883DDF--
