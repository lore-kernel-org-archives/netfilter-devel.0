From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/2] string match for iptables
Date: Thu, 25 Aug 2005 12:42:59 +0200
Message-ID: <20050825104258.GU4442@rama.de.gnumonks.org>
References: <43075517.3070405@eurodev.net> <43075BEA.1030701@trash.net>
	<20050820.131403.37427784.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uw+RRa3pmtkgiNaD"
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050820.131403.37427784.davem@davemloft.net>
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


--Uw+RRa3pmtkgiNaD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sorry for the late reply, I just returned from holidays.

On Sat, Aug 20, 2005 at 01:14:03PM -0700, David S. Miller wrote:

> Our ability to translate netfilter structures in compat mode
> is primitive, at best, and I think we really should try to
> do something about this soon.

mh. I always dreamed of pkttables happening earlier so we don't have to
deal with this...

> This IP tables modules can provide a bit of help, with some kind
> of descriptor, or set of methods the compat layer can call into
> for help (or a flag saying, "no translation necessary").
=20
> One thing about the implementation is that it is apparent that
> people often load an _enormous_ amount of rules.  A large enough
> set that kmalloc() can't get enough space for the entire rule set.

This tends to happen on smp 2.4.x systems, since they use NR_CPUS times
the ruleset size.  On (at least somewhat recent) 2.6.x, we use
num_possible_cpus() to reduce the bloatage.

> I've seen a report about this recently on sparc64, where someone
> tries to load enough ipt_replace rules that the kmalloc() done
> by the compat mode translation stuff was too large.

was this 2.4.x or 2.6.x ? and was it smp or not?

if it was 2.6.x and smp, we could introduce an option that would use
only one ruleset even on multiple cpus.  it will produce counter
cacheline ping-pong but reduce the memory usage significantly.

> One thing that can help is to not put pointers into these rules,
> that is actually the most difficult case to handle.  Without
> pointers, the entire struct can be defined using portable types
> that require no translation.  Once you introduce a pointer, using
> the user's struct as-is becomes impossible.  (as an added bonus
> such rules could thus be sent over the wire as well, if we ever
> wanted to do that)

The only reason why a pointer is needed at all, is the "dump whole table
to userspace, do some modifications and read it back" approach.  I
seriously doubt that we would be able to change that assumption.  If we
did, it wouldn't be iptables anymore, but half-way into pkttables.

As an intermediate solution we could do some form of indirect
resolval/mapping.  The core could provide an allocation wrapper API
which matches/targets could use for malloc'ing their private data
structures.  In addition to a pointer, it would return an (32bit) ID.
That ID can then be embedded in kernel/userspace data structures.  When
userspace rules come in, the ID gets translated to the real pointer by
some call to that API of the core.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Uw+RRa3pmtkgiNaD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDaCyXaXGVTD0i/8RAq62AJ9RwXUqOwkTicfaja0jPe4BbaYJVwCgiyvC
2q7334IaC7/xxO0fEJ8i3oM=
=eMcV
-----END PGP SIGNATURE-----

--Uw+RRa3pmtkgiNaD--
