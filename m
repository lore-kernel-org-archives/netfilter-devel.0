From: Harald Welte <laforge@netfilter.org>
Subject: Re: conntrack-acct patch
Date: Fri, 23 Jul 2004 01:07:04 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040723050704.GA354@obroa-skai.de.gnumonks.org>
References: <41005CB6.9070400@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41005CB6.9070400@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 23, 2004 at 02:32:54AM +0200, Patrick McHardy wrote:
> Hi Harald,

Hi Patrick!
=20
> I have a question about the conntrack-acct patch. Why is accounting
> done with timer refreshing ? Is it just because the function already
> takes ip_conntrack_lock ?=20

Yes, exactly... this is the reason.  ip_ct_refresh() was the only place
where we always grabbed a writelock.

> I think accounting should be done in the core after the conntrack
> protocol accepted the packet, instead of adding side-effects to
> ip_ct_refresh, which might even need some no-account flag one day for
> things like ctnetlink.

It already has a no-account parameter (as used by the amanda helper).

I know the API sucks, but I didn't want to introduce yet another
lock/unlock cycle into this very performance-relevant path.

> Regards
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAJz3XaXGVTD0i/8RAomkAJ4oOSkGuAlCSToh+0YCoC+e0kzTkwCgpZjc
/Mvkfra1udP/yyU2pg0U8Dg=
=IGgA
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
