From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Fri, 5 Mar 2004 12:39:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040305113915.GL1105@sunbeam.de.gnumonks.org>
References: <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xdWF/UuCWMRSqXrg"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4047AE0E.1080003@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--xdWF/UuCWMRSqXrg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 04, 2004 at 11:30:38PM +0100, Patrick McHardy wrote:

> This is the latest version of the netfilter+ipsec patches, I will check
> them in in a couple of days after some minor changes.

good work, patrick.  I'm looking forward to seeing those changes in the
mainline kernel.

one minor note:
please #ifdef CONFIG_NETFILTER the nf_reset function (or #define it to
nothing otherwise)


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xdWF/UuCWMRSqXrg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFASGbjXaXGVTD0i/8RAmNgAJ94dbg+ycnq82EROZJpm68GIAUmhQCfTQMV
ftmEA6d6BwGJ7qPyzEi4zGM=
=xUqf
-----END PGP SIGNATURE-----

--xdWF/UuCWMRSqXrg--
