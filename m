From: Harald Welte <laforge@netfilter.org>
Subject: Re: BUG() in ip_ct_event_cache_flush()?
Date: Fri, 7 Oct 2005 06:09:06 +0200
Message-ID: <20051007040906.GC5953@rama>
References: <20051005.234046.88863607.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051005.234046.88863607.davem@davemloft.net>
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


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 05, 2005 at 11:40:46PM -0700, David S. Miller wrote:
>=20
> I've seen an OOPS backtrace with current 2.6.x kernels
> that seems to be in ip_ct_event_cache_flush().

:( do you have the oops/backtrace?

> This loop there is suspect:
>=20
> 	for_each_cpu(cpu) {
> 		ecache =3D &per_cpu(ip_conntrack_ecache, cpu);
> 		if (ecache->ct)
> 			ip_conntrack_put(ecache->ct);
> 	}
>=20
> This should use "for_each_online_cpu()" I think.  Non-possible
> cpus end up with percpu pointers being NULL or undefined.

Mh, but what happens if we take offline a cpu?  Let's say the event
cache is used on four cpus, but then one cpu goes offline.  Ideally, we
would still flush the event cache for that cpu that now has become
offline, since otherwise we loose the event.

According to the documentation in include/cpumask.h, "for_each_cpu"
actually iterates over 'num_possible_map'.  So how would we end up with
a "non-possible" cpu, according to your comment?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRfTiXaXGVTD0i/8RAgOvAJ4t/Ll6JJAM6N78J3DaXEm4M6ADtACfZGET
I+dLL94w1QZRZpHW9hB8X2I=
=s5jZ
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
