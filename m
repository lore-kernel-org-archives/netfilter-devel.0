From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] [Scalability Question] How many individual rules before performance tanks?
Date: Wed, 26 Nov 2003 20:38:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031126193810.GA3740@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.56.0311251955250.9809@mithrandir.paypc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Apollyon <spambrat@paypc.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.56.0311251955250.9809@mithrandir.paypc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2003 at 08:07:45PM -0800, Apollyon wrote:
> I have a very specialised project in which I need to have potentially hun=
dreds
> of thousands of single-ip# packet deny/accept rules which need to be
> individually added/removed on demand [can be throttled so that changes are
> batched to occur every minute].

please allow me to Cc' my reply to the netfilter mailinglist.  this way
other people can benefit from the answers I give.

> 1) Normal packet flow from one interface to another, traversing all of the
> rules.  The configuration will be a default accept, with thousands
> of razor-sharp deny rules.  With about 200,000 deny rules, for example, w=
ould there be an
> appreciable loss in performance for packets which do NOT trigger a DENY r=
ule?
> Obviously, I don't care about the performance of the DENY rule hits.

you certainly don't want to use iptables (or ipchains/ipfwadm) for a
configuration like this.  Inherent through it's architecture, it will
not scale to 200,000 unordered rules flat in one chain.

> 2) Assuming a very busy network with constantly high traffic [40-60 Mbps],
> would ruleset insertion/removals take a great deal of time to execute in =
such
> an environment?  [Locking issues???]

again, this is not feasible with iptables.  all your rules would be sent
=66rom kernel to userspace, where the single change would be done, and the
whole ruleset be sent back to the kernel.  there is no support for
incremental ruleset changes inside the kernel.

> 3) What is the upper bound of the number of rules?  The BSD OSs seem to h=
ave a
> limit of 65535 uniquely-specifiable rules.  Are there inherent limitation=
s in
> Netfilter?

there is no limitation in iptables.  But they are linearly traversed.
The only optimization you can do is manually organizing them in trees of
user-defined chains.

> 4) If netfilter as it exists cannot perform well in this (admittedly stra=
nge)
> environment, I am willing and able to implement an O(n) packet filter sys=
tem
> which will handle 20 million rules as quickly as 20 using a two-level seg=
mented
> bitmapping strategy.  Mapping the entire IPv4 space would require at most=
 512MB
> with this strategy, allocated in 8K [/16] hunks.

please try your luck with nf-hipac. (www.hipac.org).  They should scale
quite well, especially for applications like yours - with exactly the
same semantics like iptables.

> Robert Seretny
>=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/xQEhXaXGVTD0i/8RAo9CAKCy/D0fjM1xFaHMjmLEAqnthn9acwCgodeF
mdzqWjyFZ7p4uaF1DDFM+mc=
=dRYC
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
