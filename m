From: Harald Welte <laforge@netfilter.org>
Subject: Re: Delition of rule after altering data in check/match entry
Date: Tue, 15 Jul 2003 14:28:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030715122846.GH7198@naboo>
References: <02b201c34a1c$faef6ac0$010f430a@elitecore7>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z0eOaCaDLjvTGF2l"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sumit Pandya <sumit@elitecore.com>
Content-Disposition: inline
In-Reply-To: <02b201c34a1c$faef6ac0$010f430a@elitecore7>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--z0eOaCaDLjvTGF2l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2003 at 09:01:22PM +0530, Sumit Pandya wrote:
> Hi All,
>     In a netfilter match or check extension at the time of rule-insertion,
> If I update any data passed along
>     1> void *matchinfo (argument to matchentry) or
>     2> void *targinfo  (argument to checkentry)
> Then I'm not able to delete same inserted rule.
>     Is there something regarding caching of the data? Does It require to
> notify iptables somewhere about this change?

Just at first glance, I think this is quite possible (and certainly not
the desired behaviour).   Can you please verify that this bug is also
present with already-existing matches/targets that change
targinfo/matchinfo contents (like the nth or random match)?

If so, please commit this as a bug report to bugzilla.netfilter.org.

> Thanks,
> -- Sumit

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--z0eOaCaDLjvTGF2l
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/E/N9XaXGVTD0i/8RAkipAKCNuMynSHX5g69yT9zCp2wUaBxDAACgiF9r
GCXHmZ88nmvmOl5tnxEJHqo=
=iBRt
-----END PGP SIGNATURE-----

--z0eOaCaDLjvTGF2l--
