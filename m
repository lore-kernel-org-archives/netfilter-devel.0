From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: ippool -X not working
Date: Mon, 08 Dec 2003 18:40:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1070905216.813.11.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0312051604100.3680-300000@filer.marasystems.com>
	 <1070646289.22338.3.camel@tux.rsn.bth.se>
	 <3FD474EB.90906@fabricadeideias.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i5ZTBmA2s2j1URRpycNb"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rodrigo Severo <rodrigo.lists@fabricadeideias.com>
In-Reply-To: <3FD474EB.90906@fabricadeideias.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-i5ZTBmA2s2j1URRpycNb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2003-12-08 at 13:56, Rodrigo Severo wrote:

> During iptables make I get:
>=20
> [root@fellini iptables-1.2.9]# make
> Extensions found: IPv4:IPMARK IPv4:ROUTE IPv4:condition IPv4:mport=20
> IPv4:pool IPv4:POOL IPv4:recent IPv4:string IPv4:time IPv6:ah IPv6:esp=20
> IPv6:frag IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
> cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/=20
> -DIPTABLES_VERSION=3D\"1.2.9\"  -fPIC -o extensions/libipt_pool_sh.o -c=20
> extensions/libipt_pool.c
> In file included from extensions/libipt_pool.c:13:
> include/libippool/ip_pool_support.h:17: parse error before=20
> "ip_pool_get_index"
> include/libippool/ip_pool_support.h:17: warning: type defaults to `int'=20
> in declaration of `ip_pool_get_index'
> include/libippool/ip_pool_support.h:17: warning: data definition has no=20
> type or storage class
> include/libippool/ip_pool_support.h:24: parse error before "ip_pool_t"
>=20
> AFAICT, the problem is the lack of ip_pool_t definition, but I can't=20
> find a place where it IS defined so I could include it in ip_pool_support=
.h.
>=20
> I have not compiled userspace ippool yet.
>=20
> Suggestions?

What you need to do (which I failed to mention) is to completely remove
the old ippool (otherwise it will try to compile it which will fail)

rm -rf iptables-1.2.9/ippool

And did you replace iptables-1.2.9/extensions/libipt_{pool,POOL}.c with
the files from the ippool-0.3.2b/iptables/ directory?

If you do these two things it should compile nicely.

Then you probably have to modify ippool-0.3.2b/userspace/Makefile a
little, you need to change IPPOOL_LIB_DIR (where it will search for the
compiled libs at runtime) and CFLAGS (needs to point to the new kernel
with ippool support).

Maybe it's time someone wrote a small installation-howto, and maybe
replaced the code in netfilter cvs with this code as it works a lot
better than the old code (the old code might work well with Henrik's
patches, I've never used them...)
There's still some work to be done on ippool, the question is like
always when it will be done... nobody knows.

--=20
/Martin

--=-i5ZTBmA2s2j1URRpycNb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/1Ld/Wm2vlfa207ERAkthAJwKVN64yJ9yd51ckBrMShrIZirBdwCcCxcf
t5Ot2TDLbDHiFJaF0wC55PE=
=e4mq
-----END PGP SIGNATURE-----

--=-i5ZTBmA2s2j1URRpycNb--
