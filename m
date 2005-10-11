From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 16:23:04 +0200
Message-ID: <20051011142304.GA4756@rama.de.gnumonks.org>
References: <20051010.141518.60492651.davem@davemloft.net>
	<434AE017.2020905@trash.net> <434AE28B.2070607@trash.net>
	<20051010.150623.94217913.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051010.150623.94217913.davem@davemloft.net>
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


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2005 at 03:06:23PM -0700, David S. Miller wrote:

> If you need to allocate per-cpu data there are very straightforward
> ways to do this.  Many other subsystems do this in an error free
> manner and I think netfilter iptables can do it too. :)

Yes, it _could_ if the design was not originally making the assumption
that the cpuid space is contiuous.  I think it could still be solved
(without running into any userspace compatibility issues), although not
in a very straightforward way :(  iptables very much predates any
per_cpu code...

given that discontiguous processor id's seem to be very rare, I think
it's fine to waste some memory on those few systems by ussing this
"allocate array from 0 to max smp processor id" approach.

Any kind of mapping, as David pointed out, is probably difficult and
prone to cause races, etc.

For a better solution, I was thinking about having an array ouf pointers
for entry points (e.g. instead of using TABLE_OFFSET() to calculate an
offset, dereference the table address from that pointer array.  The
array is indexed by smp_processor_id(), and at allocation time we only
allocate memory (and fill in pointers) for those smp_processor_id()'s
that actually exist.  This will require some more intrusive changes,
which I'm not inclined to add for 2.6.14.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDS8rIXaXGVTD0i/8RAg25AKC0OCXzEChwVrtBoSNV4s3SFp+4SACdEwMv
M8bRHvA1FvbrkOWa2JgrMrA=
=KgVA
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
