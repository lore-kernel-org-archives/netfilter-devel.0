From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] use 32bit counters for connection-based accounting
Date: Mon, 10 Oct 2005 10:30:28 +0200
Message-ID: <20051010083028.GB5091@rama.customers.eurospot.com>
References: <20051007105451.GE4719@rama>
	<20051007.132619.129111295.davem@davemloft.net>
	<20051007220435.GJ4450@rama.customers.eurospot.com>
	<20051010051633.GE9644@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20051010051633.GE9644@oknodo.bof.de>
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


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2005 at 07:16:33AM +0200, Patrick Schaaf wrote:
> > > > [NETFILTER] Use only 32bit counters for CONNTRACK_ACCT
> [...]
> Dave:
> > > I would like to actually suggest you keep the 64-bit counters.
>=20
> For what it's worth, I second this suggestion. With 64-bit counters
> in kernel/conntrack proper, as-yet-uninvented new matches and targets
> can do fancy things to practically all real world data streams,
> whatever fancy things they want to invent - the base is there.

Mh. Ok, so I vote for making them configurable. It's not a big deal, and
ctnetlink can deal with it (64bit and 32bit counters even have different Ta=
gs)

> When somebody gets an idea of a useful new match or target that
> would need 64-bit per-conntrack counters, and he sees that he'll
> have to implement kernel->user->kernel roundabout communication
> just to get at the full counters, the idea will DIE IMMEDIATELY.

that's true.  But I also refuse to waste 16bytes (which may well cost us
yet another cacheline per conntrack) just of some 'future ideas' of
which we don't really know yet.

Especially since we're trying to move a lot of stuff to userspace
anyways.  Conntrack helpers will soon be able to run in userspace, by
using nfnetlink_queue and ctnetlink.  In the long term we'll also have
cheap ruleset modifications on a per-rule granularity... so a userspace
daemon could keep adding the counters and then modify the ruleset.
Currently you could emulate this with ipt_condition, but that's more of
a hack.

> BTW, how wide are the regular iptables per-rule byte/packet counters?
> Do we still have the 64-byte-per-each-and-every-rule wasted (and
> always touched / brought in cache)=20

Yes,_but_
1) the way how iptables is designed prevents any changes to the
structure layout without breaking userspace compatibility.  If we had a
development kerne, we can do that.  But not for a stable release.
Both pkttables and nf-hipac 'fix' this problem.

2) _usually_ people tend to have way more connection tracking entries
than rules.  Conntracks quite commonly go in the counts of
hundred-thousands, where iptables rules are typically several oders of
magnitude less.

> for input/output network interface
> name/mask, even when no network interface matching is done at all?

yes, yes, yes.  It's all so wrong.  As stated before, we cannot fix it
for compatibility reasons.  We can fix ctnetlink, though.

So I vote for a Kconfig option that decides whether to use 64bit or
32bit for number-of-bytes countes.  number-of-packets will be fixed to
32bit.  Agreed?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSiakXaXGVTD0i/8RAnhVAJ98cxR3KQqCwFrxpl81AWioVhJjngCgtJ2B
EA/oXV95Qe+VMwuLM4baLnQ=
=MAO7
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
