From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: several small patches
Date: Tue, 17 Jun 2003 18:04:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030617160438.GE936@naboo>
References: <3EECBFF1.2070503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RpqchZ26BWispMcB"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3EECBFF1.2070503@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 15, 2003 at 08:50:25PM +0200, Patrick McHardy wrote:
> Hi Harald,
> these are some patches that summed up, mostly one liners.

Thanks.

> 1. ip_conntrack-outdated-comment.diff:
> remove outdated comment in ip_conntrack_expect_related
> that seems to have it's origin in time before newnat. it also
> makes the initialization of new->use explicit.

fine with me.

> 2. ip-conntrack-unneeded-check.diff:
> remove double-check for ct->master, master_ct() also does the
> check.

ack.

> 3. ip-conntrack-unconfirmed-expect.diff:
> in init_conntrack: do not delete timer/call expect function for
> connections matching expectations from unconfirmed connections.

Again, correct.

> 4. unneeded-init.diff:
> this is an old patch which removes some memset(x,0,..) for
> data in bss segment. some more unneeded initializations since
> last post:
>=20
> - conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list.next =3D NULL
> in init_conntrack() seems to be forgotten when IPS_CONFIRMED
> was introduced.

true.

> - memset and INIT_LIST_HEAD in ip_conntrack_expect_related()
> are not required, memory is overwritten in the next line anyway
> and list-member heads don't need to be initialized.

ok, that was my mistake... I somehow didn't notice the fact that only
the master list head needs to be initialized.  But this is, obviously,
correct.

> 5. ip-conntrack-expect-drop-refcnt.diff:
> drop master conntrack refcnt before setting expectant =3D NULL in
> remove_expectations. untested but seems to make sense.

There have been recent changes in this part of code...

Jozsef: Any objections?

=20
> 6. ip-conntrack-remove_expectations-list_for_each_safe.diff:
> use list_for_each_safe in remove_expectations

ok, a cosmetic correction.

I'll put 1-4 and 6 into patch-o-matic, 5 is Jozsef's call.

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

--RpqchZ26BWispMcB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+7zwWXaXGVTD0i/8RAvuFAJ9cfL9TDKhdHFq85WCQeiIMKU774wCfTKmR
1de/CmSanNR3WXfZfep6QbI=
=Gwzr
-----END PGP SIGNATURE-----

--RpqchZ26BWispMcB--
