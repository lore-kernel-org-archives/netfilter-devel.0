From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Wed, 17 May 2006 06:55:03 -0400
Message-ID: <20060517105503.GR7774@kenobi.snowman.net>
References: <20060515204142.GO7774@kenobi.snowman.net> <20060515210342.GP7774@kenobi.snowman.net> <446AC1FB.5070406@trash.net> <20060516.235910.71774114.davem@davemloft.net> <446ACE67.4030700@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jcwRHPSxFqmwpRFb"
Cc: "David S. Miller" <davem@davemloft.net>, azez@ufomechanic.net,
	willy@w.ods.org, gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	marcelo@kvack.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751144AbWEQKzG@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <446ACE67.4030700@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--jcwRHPSxFqmwpRFb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Patrick McHardy (kaber@trash.net) wrote:
> David S. Miller wrote:
> > Is there any reasonable reason to allow ip_pkt_list_tot to ever be
> > larger than say 255?  If we can accept that limit, we can shrink
> > the recent_entry considerably by packing the index and nstamps
> > into a single word next to ttl.
>=20
> My primary goal was full compatibility, I have no idea about real-life
> usage though. Maybe Stephen can answer this.

I don't recall ever seeing > 255 usage.  It's been pretty rare for it to
be changed from the default at all from what I've seen.  Making the
limit be 255 seems perfectly reasonable to me.

	Thanks,

		Stephen

--jcwRHPSxFqmwpRFb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEawEHrzgMPqB3kigRAjMMAJ92CfODRrxPzNj0jUwyfK5FVJZpFACfcKqd
cyCkvPPUZnGhPWpgr80Pwfg=
=iweL
-----END PGP SIGNATURE-----

--jcwRHPSxFqmwpRFb--
