From: Harald Welte <laforge@netfilter.org>
Subject: Re: in-tree include files issues
Date: Sun, 13 Nov 2005 10:53:46 +0100
Message-ID: <20051113095346.GE17476@sunbeam.de.gnumonks.org>
References: <43768EC0.2070801@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zaRBsRFn0XYhEU69"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <43768EC0.2070801@netfilter.org>
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


--zaRBsRFn0XYhEU69
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 13, 2005 at 01:54:24AM +0100, Pablo Neira wrote:
> Hi Harald,
>=20
> netfilter-cvslog-request@lists.netfilter.org wrote:
> > Added: trunk/libnetfilter_log/include/libnetfilter_log/linux_nfnetlink_=
log.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- trunk/libnetfilter_log/include/libnetfilter_log/linux_nfnetlink_log=
=2Eh	2005-11-11 17:06:53 UTC (rev 4506)
> > +++ trunk/libnetfilter_log/include/libnetfilter_log/linux_nfnetlink_log=
=2Eh	2005-11-11 17:07:37 UTC (rev 4507)
>=20
> [...]
>=20
> > Added: trunk/libnetfilter_queue/include/libnetfilter_queue/linux_nfnetl=
ink_queue.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- trunk/libnetfilter_queue/include/libnetfilter_queue/linux_nfnetlink=
_queue.h	2005-11-11 17:07:37 UTC (rev 4507)
> > +++ trunk/libnetfilter_queue/include/libnetfilter_queue/linux_nfnetlink=
_queue.h	2005-11-11 17:14:55 UTC (rev 4508)
>=20
> I don't like this too much. This implies that we'll have to worry about
> propagating the changes that we make in kernel space to the libraries. I
> propose you something different: The idea is copying the include files
> required at autogen.sh stage. See the patch attached.

yes, this is what we've originally discussed but I haven't yet received
such a patch.  Also, plain copying is not enough, since we need to
mangle the include paths, etc. (at least for the other libraries, not
for libnfnetlink alone).

I used to have issues with this 'copying' approach, too.  But from all
teh experience we've got with iptables now, I think it's better than
anything else ;)

We're not allowed to do modifications to existing definitions in those
header files anyway... only additions.

> BTW, libnfnetlink is currently broken, it doesn't seem to compile. I
> guess that the release 0.11 is affected as well, so we'll have to do
> another release :(.

mh.  seems like I have too current kernel headers installed.

But you can't unconditionally define, it, but rather have to place it
into a #ifndef / #endif clause.

>  gcc -DPACKAGE_NAME=3D\"\" -DPACKAGE_TARNAME=3D\"\" -DPACKAGE_VERSION=3D\=
"\"
> -DPACKAGE_STRING=3D\"\" -DPACKAGE_BUGREPORT=3D\"\"
> -DPACKAGE=3D\"libnfnetlink\" -DVERSION=3D\"0.0.12\" -DSTDC_HEADERS=3D1
> -DHAVE_SYS_TYPES_H=3D1 -DHAVE_SYS_STAT_H=3D1 -DHAVE_STDLIB_H=3D1
> -DHAVE_STRING_H=3D1 -DHAVE_MEMORY_H=3D1 -DHAVE_STRINGS_H=3D1
> -DHAVE_INTTYPES_H=3D1 -DHAVE_STDINT_H=3D1 -DHAVE_UNISTD_H=3D1 -DHAVE_DLFC=
N_H=3D1
> -I. -I. -I../include -I -fPIC -Wall -g -O2 -MT libnfnetlink.lo -MD -MP
> -MF .deps/libnfnetlink.Tpo -c libnfnetlink.c  -fPIC -DPIC -o
> .libs/libnfnetlink.o
> libnfnetlink.c: In function `nfnl_open':
> libnfnetlink.c:89: error: `NETLINK_NETFILTER' undeclared (first use in
> this function)
> libnfnetlink.c:89: error: (Each undeclared identifier is reported only on=
ce
> libnfnetlink.c:89: error: for each function it appears in.)
>=20
> NETLINK_NETFILTER is defined in netlink.h, but since revision 4500 that
> you introduced we don't need a kernel tree anymore.

well, we still need include/linux/netlink.h, which is supposed to
contain that definition (but which doesn't on old systems) :(

> In short, the patch attached does the following things:
> - Add NETLINK_NETFILTER missing definition
> - Remove KERNELDIR from Makefile.am, it's not defined anymore.
> - Copy include files at autogen.sh
=20
> If you decide to apply this patch, please remove linux_libnfnetlink.h
> from the SVN tree as well.

Somehow I like to have it in SVN, this way we have all the files from a
particular release in svn.

If we don't commit the file to svn, then you can't just do a simple
'diff' to notice the changes between two libnfnetlink releases, since
the differences in linux_nfnetlink.h will be missing.

We could keep it in svn, and still use your copying patch.  This way the
changes would be committed at the next 'commit'.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zaRBsRFn0XYhEU69
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDdw0qXaXGVTD0i/8RAljyAJ0SDmv2lgMl7EMfNvUKJRkb/K92WwCfdc8N
4CJdm0rq3raw4mshDzFPbCI=
=RJAb
-----END PGP SIGNATURE-----

--zaRBsRFn0XYhEU69--
