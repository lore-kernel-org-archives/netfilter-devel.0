From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Concerning ULOG and the MAC logging bug
Date: Mon, 9 Dec 2002 19:39:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021209183930.GN2223@sunbeam.de.gnumonks.org>
References: <003101c29ca5$289c8b40$0200a8c0@KevlarPC>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kkcDP0v44wDpNmbp"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gael Mauleon <gmauleon@free.fr>
Content-Disposition: inline
In-Reply-To: <003101c29ca5$289c8b40$0200a8c0@KevlarPC>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--kkcDP0v44wDpNmbp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 05, 2002 at 10:27:48PM +0100, Gael Mauleon wrote:
> Hi, I am new here so excuse me first for my bad english and then for all
> mistake i can make :))

Don't mention it.  Most people on this world (including me) are not
native english speakers.

> So I found a bug in ULOG concerning the logging of MAC Address,
> searching the list archive i  found a patch from Harald  Welte but I
> think a better one can be written in this, but since i am new to
> kernel/netfilter coding perhaps that's not the way to
> do it [...]


> Since the payload can also be exploited with wrong data , i would
> prefer a memset solution like this to the else solution proposed. And
> we can then erase all the else.

Indeed this is an alternative solution. The question is: What is more
efficient: Memsetting the whole structure or a potential branch
introduced by the 'else' clause. =20

And: What do you mean by 'payload can be exploited with wrong data'. Are
you talking about the to-be-logged packet which will become the payload
of the netlink message?  How could this contain wrong data?

> And let me know if there is a better way to tell about bugs and put
> some code changes.

for code changes we usually use unified diff (diff -u) between original
and changed code.  It can easily be read by a human being and also
automatically applied in case we really want to accept this change.

> Thx.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--kkcDP0v44wDpNmbp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE99ONiXaXGVTD0i/8RAsVFAKCZf2YjlfDWcaAMO90AMvv2GUs/lACfT7z0
uNJfG/ybaQ2D2wqnUajiZoI=
=gkog
-----END PGP SIGNATURE-----

--kkcDP0v44wDpNmbp--
