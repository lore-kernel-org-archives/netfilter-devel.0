From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: fix potential use after free in destroy_conntrack
Date: Tue, 24 Jun 2003 18:11:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624161155.GS2645@sunbeam.de.gnumonks.org>
References: <Pine.GSO.4.42.0306201236020.20652-200000@stinky.trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dIV3CY5swYZsO92m"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@stinky.trash.net>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.42.0306201236020.20652-200000@stinky.trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dIV3CY5swYZsO92m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2003 at 12:44:14PM +0200, Patrick McHardy wrote:
> Hi Harald,

btw: harald.welte@gnumonks.org is not a valid email address.

> i missed this in my last patch (remove ct->master double check),
> the reference to the master conntrack should not be dropped
> until the expectation has deleted itself from the list.
> This makes the last patch obsolete.

argh.  I should have read the mailinglist before sending patches to davem.

Will submit an incremental patch to davem before this ends up in the
2.4.22-pre series.

> Best regards,
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

--dIV3CY5swYZsO92m
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++HhLXaXGVTD0i/8RArE2AKCu6VDdJFcRoTXfdRUCG01uP1N62QCfZRsB
J4xs8VRWZGH8FZVSawznQos=
=atsS
-----END PGP SIGNATURE-----

--dIV3CY5swYZsO92m--
