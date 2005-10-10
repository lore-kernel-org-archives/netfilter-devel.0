From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] use 32bit counters for connection-based accounting
Date: Mon, 10 Oct 2005 11:47:17 +0200
Message-ID: <20051010094717.GA5347@rama.customers.eurospot.com>
References: <20051007105451.GE4719@rama>
	<20051007.132619.129111295.davem@davemloft.net>
	<20051007220435.GJ4450@rama.customers.eurospot.com>
	<20051010051633.GE9644@oknodo.bof.de>
	<20051010083028.GB5091@rama.customers.eurospot.com>
	<20051010085934.GF9644@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20051010085934.GF9644@oknodo.bof.de>
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


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

On Mon, Oct 10, 2005 at 10:59:35AM +0200, Patrick Schaaf wrote:

> I personally would have no problem with configuring this at compile time,
> if neccessary. It was good to read that userlevel already gets typed
> counters, so must cope.

ok.

> I have one (ignorant) question left: when a certain byte counter
> for some direction/flow overflows, is the packet counter forced
> to overflow at the same time? Same question for when the packet
> counter overflows - does the associated byte counter wrap, too?
> (I intuit such would be desired behaviour. Wouldn't it?)

no, the counters will overflow independently - and we have no indication
that such an event occurred.

> Re number-of-packets at 32 bit, I can only tell that in the
> real world I know, the Radius protocol is sprouting extended
> attributes to communicate the overflow (high 32 bit) part
> of the per-connection (DSL-session etc) packet counters.
> (The same two-attribute approach was used years ago for the
> byte counters, but everybody was sure 32 bit packet counters
> were good enough). Oh, the Radius practise does not include
> any means to flag 'I overflowed, some time in the past'.

Radius is, however, used for doing accounting on "per line" basis, that
is per dialup/dsl session.  Yes, i see, in the case of PPTP/L2TP all
packets within such a session are likely to end up in one conntrack...

> Hmm. Would it be hard to have each conntrack start out with
> 32 bit counters, plus an 'I overflowed' indicator? And some
> additional memory (isn't there a nice 'ext *' interface now)
> is used for the very rare conntracks which indeed need
> 64-bit counters?

ct_extend was never merged, though we probably will port and submit it
on top of nf_conntrack (nf_conntrack goes into 2.6.15).  I think at this
point a "start with 32bits but allocate 64bit countes on demand"
approach would be the best solution.

meanwhile, I'll hack up a patch that will make 32/64bit a
Kconfig-option, and try to add some overflow indicator.  That's all
post-2.6.14, though.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSjilXaXGVTD0i/8RAlkzAKCRaUGDgxqpmCBKzTTRPqFsUw858wCffzJt
MeAIa1D9GDx/MZiFml9gafg=
=ChzR
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
