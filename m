From: Harald Welte <laforge@netfilter.org>
Subject: Re: RAM and conntrack performance: first draft of the document is online
Date: Thu, 27 Nov 2003 12:10:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127111019.GC3373@obroa-skai.de.gnumonks.org>
References: <20031028151032.GD726@eychenne.org> <20031103081240.GQ1536@sunbeam.de.gnumonks.org> <20031125153543.GD1082@eychenne.org> <20031125205723.GE2971@obroa-skai.de.gnumonks.org> <20031126034231.GA1044@eychenne.org> <20031126113645.GF3121@obroa-skai.de.gnumonks.org> <3FC4D429.3050401@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Cc: Herve Eychenne <rv@wallfire.org>,
	Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3FC4D429.3050401@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2003 at 05:26:17PM +0100, Patrick McHardy wrote:
> I recall someone wanted to make a patch for this some time ago to
> prevent timer storms, do you have any information if anyone is currently
> working on this ? Otherwise I might just do both ..

I think somebody had already written such a patch (gandalf?), however
he didn't see any significant performance difference.

> Best regards,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/xduaXaXGVTD0i/8RAtB9AJ93vJUoUEVFllEHaj4cIDAge0HwdwCglnhW
/G2qAUAjSaxJ4p2dx1JUUpg=
=xM7W
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
