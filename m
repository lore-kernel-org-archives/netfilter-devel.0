From: Harald Welte <laforge@netfilter.org>
Subject: Re: Question about reference count of expectations in 2.6.14 tree
Date: Thu, 11 Aug 2005 15:51:35 +0200
Message-ID: <20050811135135.GJ4130@rama.de.gnumonks.org>
References: <200508100111.j7A1Bok9010084@toshiba.co.jp>
	<20050811133545.GI4130@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nb8zVy0QMK3AA1xu"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	netfilter-devel@lists.netfilter.org, kaber@trash.net, pablo@eurodev.net
Content-Disposition: inline
In-Reply-To: <20050811133545.GI4130@rama.de.gnumonks.org>
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


--nb8zVy0QMK3AA1xu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 11, 2005 at 03:35:45PM +0200, Harald Welte wrote:
> On Wed, Aug 10, 2005 at 10:11:49AM +0900, Yasuyuki KOZAKAI wrote:
> >=20
> > # Well, the mail I sent yesterday seems not to reach list, so I resent =
it.
> > # Sorry if you have already received same mail.
>=20
> clamav has some problems at the listserver, so the list was stuck for
> some time :(
>=20
> > In 2.6.14 tree, ip_conntrack_expect_insert() increments the reference
> > count of expectations twice. I understand that once is for timer.
> > What is next incrementing for ? expectation list ?
>=20
> Good question.  To me it looks like a bug introduced when merging
> Rusty's conntrack-refcounting patch and the original ctnetlink code.

Looking at it again, and doing some tests: The current code works,
/proc/slabinfo shows me there is no expectation leak.

This is because the reference count is also put two times:  in
unlink_expect, and in expectation_timed_out().  Almost all over the
place, first unlink_expect() drops the first refcount, and
ip_conntrack_espect_put() is called explicitly to drop the second.

So yes, one count seems to be for the timer, the second one for
ip_conntrack_expect_list.  Two references.

I think it would be possible to remove the second atomic_inc() and all
the ip_conntrack_put() that immediately follow ulink_expect() - but
would it be worth the effort?  Isn't it an over-optimization that is
likely to cause bugs later on?

Patrick? Pablo?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nb8zVy0QMK3AA1xu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC+1fnXaXGVTD0i/8RAlj0AJoCxsq/4bNym7TH8oGSkFawXgKZCQCdHfax
LJpT5VolThwUpbwdRnEab+I=
=+vJw
-----END PGP SIGNATURE-----

--nb8zVy0QMK3AA1xu--
