From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Delete Conntrack Entries From Userspace?
Date: Sun, 9 Feb 2003 10:45:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030209094531.GR13269@naboo.fugue.com>
References: <95E2AB7E9225D211ABE100104B9E8E119E4C48@anet1.amplifynet.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="djJN5oi3zFpblwUd"
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Middour, Chris" <cmiddour@amplifynet.com>
Content-Disposition: inline
In-Reply-To: <95E2AB7E9225D211ABE100104B9E8E119E4C48@anet1.amplifynet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--djJN5oi3zFpblwUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2003 at 05:09:22PM -0800, Middour, Chris wrote:
> I have a need to remove a conntrack entry for ip protocol 50 (the IPSEC
> protocol).
>
> Is there any way to get iptables to remove a conntrack entry (without cod=
ing
> it myself in the kernel?)

as connection tracking is _not_ part of iptables, there is no way using
the iptables commmand.

You might want to have a look at the nfnetlink-ctnetlink-patch in
patch-o-matic, and in addition to libnfnetlink and libctnetlink in the
iptables CVS tree.  there is also a small example application called
'ctnltest' in the libctnetlink directory.  It implements exactly what
you want.

> Thanks very much!
> --Chris Middour

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--djJN5oi3zFpblwUd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+RiM7XaXGVTD0i/8RAruKAJ9MndjqY7r04SEKXiiDrauYV+Na3ACdHva0
+/1U1rXJPN6WaJ7YseQaJsI=
=5hDl
-----END PGP SIGNATURE-----

--djJN5oi3zFpblwUd--
