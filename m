From: Harald Welte <laforge@netfilter.org>
Subject: Re: why every time that a rule is inserted/appended....
Date: Wed, 28 May 2003 20:30:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030528183045.GB12978@naboo>
References: <3ED2887B.5050807@linux.org.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: diegows <diegows@linux.org.ar>
Content-Disposition: inline
In-Reply-To: <3ED2887B.5050807@linux.org.ar>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2003 at 06:34:51PM -0300, diegows wrote:
> ...the entire table is replaced?

the idea was to have an atomic snapshot from the kernel, which is
especially important for the counters.

ipchains doesn't read a chain atomically and thus packets are still
traversing between rules are being read from the kernel.  This leads to
inconsistencies in=20

> If this could be better, advise me and i try to patch that.

Sure it can be done better, and there have been at least two approaches
to introduce a new kernel/userspace interface, both based on nfnetlink.

However, this is not a 'small patch' but a fundamental design change.

[maybe I'll finally find some time to do pkttables stuff again... but
now there is lots of other distracting stuff like that dual opteron box
;)]

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+1QBVXaXGVTD0i/8RAv1kAKCzfYOi7WOAoES1opKkOuT9oHrafwCcD12p
aQ1ptDdaZhhliK4OrElZPFo=
=STF+
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
