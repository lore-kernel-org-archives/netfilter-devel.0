From: Harald Welte <laforge@netfilter.org>
Subject: Re: Fw: 2.6.15-rc2-mm1 problems (get_cpu / NUMA optimizations)
Date: Thu, 24 Nov 2005 21:58:28 +0100
Message-ID: <20051124205828.GD31478@sunbeam.de.gnumonks.org>
References: <20051123.155603.64967447.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="txpH036gwkJjxLXT"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net, Eric Dumazet <dada1@cosmosbay.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051123.155603.64967447.davem@davemloft.net>
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


--txpH036gwkJjxLXT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2005 at 03:56:03PM -0800, David S. Miller wrote:
>=20
> I've seen this reported multiple times.
>=20
> It seems that module load is attempted by IP-tables while
> some locks are held, or similar.

yes, this was introduced by the recent NUMA patches that introduced
get_cpu() / put_cpu() all over the place. =20

Seems like I only now realize the implications that this has all over
the code, and to be honest, I'm not confident that there is a short-term
fix since a lot of code needs to be audited. =20

Also, apart from just the iptables core,  we actually call the
checkentry() and destroy() functions of the match/target extensions
under get_cpu() now.  Plugin authors always assumed that they'd be able
to do stuff like kmalloc(GFP_KERNEL) since they are guaranteed to always
only be called from userspace context under the ipt_mutex.

I'm further analyzing our options, but we might have to pull out that
NUMA change, especially since I'm heading for FOSS.in/linux-bangalore in
a couple of days.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--txpH036gwkJjxLXT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDhil0XaXGVTD0i/8RAt7rAJ9RjP2DN+Mh7oXzhq1g3HiAtupCXwCdFdY0
4srDtYJkkWoqPqIl5cxhOeE=
=rhZR
-----END PGP SIGNATURE-----

--txpH036gwkJjxLXT--
