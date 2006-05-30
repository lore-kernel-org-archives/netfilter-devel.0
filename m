From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [NETFILTER 05/17]: recent match: replace by rewritten version
Date: Tue, 30 May 2006 14:10:18 -0400
Message-ID: <20060530181018.GW8588@kenobi.snowman.net>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
	<20060529223413.24834.97896.sendpatchset@localhost.localdomain>
	<20060530131150.GV8588@kenobi.snowman.net>
	<447C45C3.5000502@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MET8MpPxp2u2c48q"
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <447C45C3.5000502@trash.net>
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


--MET8MpPxp2u2c48q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Patrick McHardy (kaber@trash.net) wrote:
> Stephen Frost wrote:
> > I havn't had a chance to check yet, but was something done about the
> > last round of issues I pointed out?  Specifically, concerns that entries
> > in the table which are never updated will not end up in the list to be
> > candidates for deletion due to the eviction policy?  I don't think it'd
> > be a good plan to move to this till that's fixed (it's not hard to fix,
> > either).
>=20
> Already fixed.

Great, thanks.  I've now reviewed the version in DaveM's net-2.6.18 git
tree and it looks good to me.  I'll try and do some real-world testing
on it this weekend.  I'm very curious if these changes will allow for
larger lists than was previously possible.

	Thanks again,

		Stephen

--MET8MpPxp2u2c48q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEfIqKrzgMPqB3kigRAlSgAJ48i+OTKtlE4piTMGuyjFAaQBbviACeNmqe
aRqYQppzwAslKLloGHEGHkM=
=dcdL
-----END PGP SIGNATURE-----

--MET8MpPxp2u2c48q--
