From: Phil Dibowitz <phil@ipom.com>
Subject: NFCT_Q_DUMP problem
Date: Wed, 14 Mar 2007 00:19:38 -0700
Message-ID: <45F7A20A.5050302@ipom.com>
References: <45F4B34F.3020007@ipom.com> <45F527F2.40404@netfilter.org>
	<45F6558A.2070601@ipom.com> <45F671CA.6010401@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigF9487ABB49B574024BA84716"
To: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
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
--------------enigF9487ABB49B574024BA84716
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Pablo Neira Ayuso wrote:
> BTW, I suggest you to have a look a new_api_test.c under utils/ to get
> quick look on the new API. The old API is deprecated and will vanish
> sooner or later, new apps must use the new API.

So I sat down to write some test code today on the new API, and I found a=
ll
the nice getter functions, which are awesome... but I can't seem to make =
the
new API work with NFCT_Q_DUMP. I shrunk down my test the bare minimum and=

nfct_query *always* returns errno for "Address family not supported by
protocol" :(

new_api_test.c doesn't test the NFCT_Q_DUMP query, so I'm wondering if it=
's
perhaps a problem in the NFCT_Q_DUMP query type.

Here's some sample code:

[phil@rider nftest]$ cat minitest.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
#include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>

static int conntrack_addcon_hook(enum nf_conntrack_msg_type type,
                        struct nf_conntrack *ct,
                        void *data)
{
        return NFCT_CB_CONTINUE;
}

int main(int argc, char *argv[])
{
        struct nfct_handle *cth;
        struct nf_conntrack *ct;
        int res;

        ct =3D nfct_new();
        if (!ct) {
                printf("Error, couldn't create and nfct\n");
                exit(1);
        }
        cth =3D nfct_open(CONNTRACK, 0);
        if (!cth) {
                printf("Error, couldn't open conntrack table\n");
                exit(1);
        }
        nfct_callback_register(cth, NFCT_T_ALL, conntrack_addcon_hook,
				NULL);
        res =3D nfct_query(cth, NFCT_Q_DUMP, ct);
        if (res < 0) {
                printf("dump failed(%d): %s\n", res, strerror(errno));
        }
        nfct_close(cth);
        return 1;
}


When I run this I get:
  [phil@rider nftest]$ sudo ./minitest
  dump failed(-1): Address family not supported by protocol

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enigF9487ABB49B574024BA84716
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF96IKN5XoxaHnMrsRAhryAJsEmdU131TjUFdBXMFaf6Cbm9762gCeINcQ
yvq9cNIjwf9EMMKPRzyPgJw=
=voqh
-----END PGP SIGNATURE-----

--------------enigF9487ABB49B574024BA84716--
