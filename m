From: Harald Welte <laforge@gnumonks.org>
Subject: Re: standalone target module??
Date: Sun, 9 Feb 2003 10:44:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030209094415.GQ13269@naboo.fugue.com>
References: <33492.192.168.1.5.1044308966.squirrel@secure.a2hd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1R6ZDISWaA1muLP0"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Schmeder <andy@a2hd.com>
Content-Disposition: inline
In-Reply-To: <33492.192.168.1.5.1044308966.squirrel@secure.a2hd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--1R6ZDISWaA1muLP0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2003 at 01:49:26PM -0800, Andy Schmeder wrote:

> I would like, if possible, to write this as a loadable standalone kernel
> module.  For simplicity, I would prefer to be able to build and test my
> module without having to patch the kernel source.  Is this feasible?

Yes, it is.

> So far I have tried to copy the ipt_MIRROR.c code, change a couple of
> things, compile as a ipt_MYTARGET.o, insmod ipt_MYTARGET.o.  Netfilter
> does not seem to find the new target.  'iptables -A INPUT -i eth1 -j
> MYTARGET' causes iptables to look for /lib/iptables/libipt_MYTARGET.so.

of course.

> The next thing I tried was to run 'ld -shared -o
> /lib/iptables/libipt_MYTARGET.so ipt_MYTARGET.o'.  This generates a number
> of undefined symbols for any of the kernel functions; which makes me think
> that the .so files in /lib/iptables are not actually kernel modules...=20
> unfortunately the files there have been strip'd so I have no idea what is
> in them.

You seem to have misunderstood how iptables extensions are working.
There are always two parts, one in userspace and one in the kernel.
Please look at the source of libipt_MIRROR.c in the
'userspace/extensions' directory of the netfilter CVS tree.  This is the
userspace counterpart to ipt_MIRROR.c inside the kernel.

> What I am really seeking is an example Makefile for building a standalone
> netfilter target as a module.  Does such a thing exist?  I have already
> google'd my eyes out trying to solve this problem with no luck so far.

No.  But it shouldn't be any different than creating a makefile for any
other out-of-kernel compilation (like pcmcia-cs, linux-wlan-ng, etc.).
Please look for examples there, in order to see how to get the
compile-options right, etc.

> Thanks for your time,
> Andy.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--1R6ZDISWaA1muLP0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+RiLvXaXGVTD0i/8RArpsAKCAFHiRloHhArYbVWc4nX4FYYWL2ACeIMz9
rZ8MKoB9QJQyoFP656m+nk0=
=lNPW
-----END PGP SIGNATURE-----

--1R6ZDISWaA1muLP0--
