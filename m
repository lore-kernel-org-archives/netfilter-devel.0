From: Harald Welte <laforge@netfilter.org>
Subject: Re: A patch to delete items in ip_conntrack hash table
Date: Wed, 16 Jul 2003 18:54:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030716165434.GB735@naboo>
References: <096f01c34926$57c4b540$e600a8c0@udtech.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Shen Rong <rshen@udtech.com.cn>
Content-Disposition: inline
In-Reply-To: <096f01c34926$57c4b540$e600a8c0@udtech.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 13, 2003 at 06:05:52PM +0800, Shen Rong wrote:
> Hi,
>    I write a patch to delete specified item in ip_conntrack hash
> table through setsockopt. A demo program is also attached.

Thanks for contributing to the netfilter project.

>    Will it be ok for normal use? Is there any hidden issues on it?
> Please give me any type of feedback. Thanks a lot.

Why didn't you use the already-existing means of deleting connection
tracking items:  ctnetlink?

Unless I am missing anything, I think we will stick with one mechanism
rather than replicating the same functionality.

> Shenrong
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/FYNJXaXGVTD0i/8RAnfnAJ44l7jneBqJ+dYLcyhMg/ESdKSdwACfQreY
Q00Rt+1ElOm5Sz7hXRAM9wU=
=T3oI
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
