From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: [PATCH] KERNEL_DIR support in autogen.sh for
	libnfnetlink/libnetfilter_conntrack
Date: Tue, 15 Nov 2005 09:11:00 +0100
Message-ID: <20051115081100.GA8519@zion.homelinux.com>
References: <Pine.LNX.4.64.0511150044020.15324@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0511150044020.15324@bizon.gios.gov.pl>
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


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Krzysztof,

On Tue, Nov 15, 2005 at 12:48:13AM +0100, Krzysztof Oledzki told us:
> Index: autogen.sh
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- autogen.sh	(revision 4538)
> +++ autogen.sh	(working copy)
> @@ -7,14 +7,15 @@
>      # the headers that we need from the lastest kernel version at autogen
>      # stage.
> =20
> -    INCLUDEDIR=3D/lib/modules/`uname -r`/build/include/linux
> +    INCLUDEDIR=3D${KERNEL_DIR:-/lib/modules/`uname -r`/build}/include/li=
nux
> +

shouldn't INCLUDEDIR be set to something like ${KERNEL_DIR}/include/linux
when KERNEL_DIR is set?? The name KERNEL_DIR implies that this variable
holds the path of the linux kernel, not the path of the linux kernel's
include/linux directory...!?

Just my humble opinion, of course!!


have a nice day :-)

Sven

>      if [ -f $INCLUDEDIR/netfilter/nfnetlink.h ]
>      then
>      	TARGET=3Dinclude/libnfnetlink/linux_nfnetlink.h
>      	echo "Copying nfnetlink.h to linux_nfnetlink.h"
>      	cp $INCLUDEDIR/netfilter/nfnetlink.h $TARGET
>      else
> -    	echo "can't find nfnetlink.h kernel file"
> +    	echo "can't find nfnetlink.h kernel file in $INCLUDEDIR"
>      	exit 1
>      fi
>  }


--=20
Linux zion.homelinux.com 2.6.14-mm2_16 #16 Sun Nov 13 22:16:30 CET 2005 i68=
6 athlon i386 GNU/Linux
 09:07:19 up 1 day, 10:29,  1 user,  load average: 0.03, 0.03, 0.00

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDeZgUo4FAdB2PneQRAmxwAJ92Y9Qgw4nVhzHr/diu53YLD5UN7QCeKWfe
lr+tGiftO0y1R63ygo8kdl4=
=NbEf
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
