From: Harald Welte <laforge@netfilter.org>
Subject: Re: New target to control a fake network interface
Date: Wed, 22 Jun 2005 14:00:31 +0200
Message-ID: <20050622120031.GD4551@obroa-skai.de.gnumonks.org>
References: <1119319953.4109.59.camel@envy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3XA6nns4nE4KvaS/"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Corey Giovanella <coreygiovanella@challenge-engineering.com>
Content-Disposition: inline
In-Reply-To: <1119319953.4109.59.camel@envy>
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


--3XA6nns4nE4KvaS/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 21, 2005 at 02:12:33AM +0000, Corey Giovanella wrote:
> Hi all,
>=20
> I just finished some code I've been working on and I figured I'd post a
> message here incase anyone is interested in using it.

sure, I agree that it's good to draw people's attention to this.

> What I have done is written two new kernel modules: a fake network
> interface module and a new iptables target that remote controls the
> packet counters on the fake interface.  The fake interface itself, does
> nothing.

mh.  I'm not sure whether I like this idea (cool hack) or whether I'd
rather say: Fix the userspace programs.

I think I have a general tendency towards the 'cool hack' side ;)

> For example I use this so I can view internet traffic separately from my
> local lan traffic in Gkrellm. =20

well, I would rather say it's interesting for DROP'ed packets.  This way
you can see how much of your current inbound (or outbound) traffic gets
dropped..

I haven't yet looked at the code, since I'm currently travelling and
have only offline email access.  Consider this as a general call: "mail
all code in plain text to this list rather than sending URL's".

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3XA6nns4nE4KvaS/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCuVLfXaXGVTD0i/8RAhhzAJ0XyWCDTJbN+qm5wHDBLAr+4AOsXwCfYK0c
afz2blQnHTZptzwc7N0SZDM=
=j4MQ
-----END PGP SIGNATURE-----

--3XA6nns4nE4KvaS/--
