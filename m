From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.4] netfilter ipt_conntrack/ipt_state moduse count
Date: Mon, 2 Feb 2004 16:21:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040202152149.GG24449@obroa-skai.de.gnumonks.org>
References: <20040127214857.GE11761@sunbeam.de.gnumonks.org> <pan.2004.02.01.12.59.36.391644@altlinux.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Cc: netfilter-devel@lists.netfilter.org,
	Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sergey Vlasov <vsu@altlinux.ru>
Content-Disposition: inline
In-Reply-To: <pan.2004.02.01.12.59.36.391644@altlinux.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Cc'ing Rusty, he's the kernel modules expert ;)

On Sun, Feb 01, 2004 at 03:59:40PM +0300, Sergey Vlasov wrote:
> On Tue, 27 Jan 2004 22:48:57 +0100, Harald Welte wrote:
>=20
> > Hi Dave!
> >=20
> > Please apply the following fix to your 2.4.x tree.  A 2.6.x fix is not
> > needed, because of it's different reference counting.
>=20
> Looks like the patch is buggy - it will oops in the failure path if
> ip_conntrack is not a module (it will call __MOD_DEC_USE_COUNT(NULL)).

mh, indeed.  So the behaviour prior to the patch was buggy, after the
patch it's still buggy, but in a different (even more obvious) way.

> Also, why this manual refcounting is needed here at all?
> ipt_conntrack.o and ipt_state.o have references at least to
> ip_conntrack_get(), which is exported by ip_conntrack.o.  Because of
> this, there is no way to unload ip_conntrack without unloading
> ipt_conntrack and ipt_state first.

That's a good question.  I actually think this might have been
introduced historically.

As you correctly indicate, there is no reason for explicit reference
counting in all the cases where ip_conntrack_module is used:

ip_nat_standalone.c : is using conntrack functions anyway
ipt_conntrack.c: calls ip_conntrack_get()
ipt_helper.c: calls ip_conntrack_get()
ipt_state.c: calls ip_conntrack_get()

I will prepare another patch that removes all refcounting, as you have
suggested.

Rusty: Any idea why this was ever introduced in 2.4.x ?  Am I missing
something?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAHmsMXaXGVTD0i/8RAghZAJ9pF8C6B6MKBNKb9XnwM6K8cwrA+ACfTA1u
O4xY9I23M0Yfdo9QBSgDJ9E=
=GrmG
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
