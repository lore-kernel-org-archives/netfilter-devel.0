From: Alexander Samad <alex@samad.com.au>
Subject: Re: Problem with apply patch connlimit to 2.6.10 (debian 2.6.10-6)
Date: Sat, 26 Mar 2005 11:15:04 +1100
Message-ID: <20050326001504.GE10616@samad.com.au>
References: <20050325234332.GD10616@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050325234332.GD10616@samad.com.au>
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


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 26, 2005 at 10:43:32AM +1100, Alexander Samad wrote:
> Hi
>=20
>=20
> I have been trying to apply the connlimit patch to a debian kernel
> source package.  These are the other patches I apply
>=20
> policy TARPIT iprange raw dstlimit ROUTE time IPMARK CLASSIFY
> dropped-table pool realm TCPLAG ULOG account connlimit nf_conntrack nth
> owner-socketlookup ownercmd conntrack-cacheline-opt
>=20
> But I this error when I try and compile the kernel=20
>=20
>   CC [M]  net/ipv4/netfilter/ipt_connlimit.o
> net/ipv4/netfilter/ipt_connlimit.c: In function `count_them':
> net/ipv4/netfilter/ipt_connlimit.c:100: error: structure has no member
> named `infos'
> net/ipv4/netfilter/ipt_connlimit.c:107: error: structure has no member
> named `infos'
> make[5]: *** [net/ipv4/netfilter/ipt_connlimit.o] Error 1
> make[4]: *** [net/ipv4/netfilter] Error 2
> make[3]: *** [net/ipv4] Error 2
> make[2]: *** [net] Error 2
> make[2]: Leaving directory
> `/mnt/space0/alex/src/kernel/debian/kernel-source-2.6.10.wrk'
> make[1]: *** [stamp-build] Error 2
> make[1]: Leaving directory
> `/mnt/space0/alex/src/kernel/debian/kernel-source-2.6.10.wrk'
> make: *** [kernel] Error 2
>=20
>=20
> I have had a look in include/linux/netfilter_ipv4/ip_conntrack.h  and it
> seems like the structure has gone  and I am not sure what else I need to
> apply to make it compile.

I noticed on bugszilla there is an open bug about connlimit not
compiling on 2.6.11 (Bugzilla Bug 317) and the patch seems to remove any
access to infos !  Should i be using the patch attached to this bugzilla
?

>=20
> I have had similiar problems with ipv6 REJECT patch, but I have built a
> linux/include/linux/netfilter_ipv6/ip6t_REJECT.h that can be patched
> (but there might be stuff missing from there as well!
>=20
> and suggestions what I can do
>=20
> Thanks
> Alex



--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCRKmIkZz88chpJ2MRAs+fAJ9Cw6RZFu49UcO8NUABRGttUx/5NwCdFv/K
t4HK+/W35qm+P0cuDqLQPGc=
=0I0m
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
