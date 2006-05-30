From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [NETFILTER 05/17]: recent match: replace by rewritten version
Date: Tue, 30 May 2006 09:11:50 -0400
Message-ID: <20060530131150.GV8588@kenobi.snowman.net>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
	<20060529223413.24834.97896.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFRfxei4j9xfgtfb"
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <20060529223413.24834.97896.sendpatchset@localhost.localdomain>
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


--UFRfxei4j9xfgtfb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Patrick McHardy (kaber@trash.net) wrote:
> [NETFILTER]: recent match: replace by rewritten version

I havn't had a chance to check yet, but was something done about the
last round of issues I pointed out?  Specifically, concerns that entries
in the table which are never updated will not end up in the list to be
candidates for deletion due to the eviction policy?  I don't think it'd
be a good plan to move to this till that's fixed (it's not hard to fix,
either).

I'll try and get a chance to re-review it, again, later today...

	Thanks,

		Stephen

--UFRfxei4j9xfgtfb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEfESVrzgMPqB3kigRAib5AKCB5ANBFw0yb5JlO/7j320xA3ThrACdHqO8
WZQ9PQKpHzI8DEHoaJOr70g=
=F4DR
-----END PGP SIGNATURE-----

--UFRfxei4j9xfgtfb--
