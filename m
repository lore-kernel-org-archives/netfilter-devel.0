From: Harald Welte <laforge@gnumonks.org>
Subject: Re: target_info read only?
Date: Tue, 21 Jan 2003 10:58:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030121095826.GL15225@sunbeam.de.gnumonks.org>
References: <3E2C883F.7070707@hipac.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="451BZW+OUuJBCAYj"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E2C883F.7070707@hipac.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--451BZW+OUuJBCAYj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2003 at 12:37:35AM +0100, Thomas Heinz wrote:
> Hi
>=20
> A netfilter target (struct ipt_entry_target) can contain an
> arbitrary amount of private data which is delivered to the
> target function in case the corresponding rule matches.

true.

> Now it would be possible for the target function to modify
> the private data although I haven't seen any target that
> does this. In contrast to targets this behaviour is quite
> normal for matches, especially stateful ones.

true.

> 1) Is there any target (kernel and cvs) that already modifies
>    its private data (maybe I have overlooked one)?

Not that I am aware of....  You might want to look for the PSD target (yes,
it was a target before it became a match).  This was years ago.

> 2) If ! 1) is there any reason for which targets might want
>    to write to their private data buffer and if not can
>    I assume that netfilter targets must (sort of unwritten law
>    like) treat their private data as read only?

no. they can.  But please note that (like matchinfo) you are operating
on per-cpu local data.  So in an SMP system, there will be one targinfo
per cpu.

> Regards,
> Thomas

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--451BZW+OUuJBCAYj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+LRnCXaXGVTD0i/8RAiv1AJ0fvX9bEQ5gsjB2Hc04yzt0KW6CZgCghQXQ
055PXcC23ClEwEZp2HPXFQE=
=Zt87
-----END PGP SIGNATURE-----

--451BZW+OUuJBCAYj--
