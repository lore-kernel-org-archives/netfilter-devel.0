From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Mon, 15 May 2006 17:03:42 -0400
Message-ID: <20060515210342.GP7774@kenobi.snowman.net>
References: <44643BFD.3040708@trash.net> <9a8748490605120409x3851ca4fn14fc9c52500701e4@mail.gmail.com> <44647280.1030602@trash.net> <446490BB.10801@ufomechanic.net> <44683AFF.4070200@trash.net> <20060515142834.GL7774@kenobi.snowman.net> <4468CD3C.3000908@trash.net> <20060515192738.GN7774@kenobi.snowman.net> <4468DFF6.5020304@trash.net> <20060515204142.GO7774@kenobi.snowman.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JF+ytOk7PH04NsRm"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965222AbWEOVDn@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>,
	Amin Azez <azez@ufomechanic.net>,
	"David S. Miller" <davem@davemloft.net>, willy@w.ods.org,
	gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	marcelo@kvack.org
Content-Disposition: inline
In-Reply-To: <20060515204142.GO7774@kenobi.snowman.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--JF+ytOk7PH04NsRm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Stephen Frost (sfrost@snowman.net) wrote:
> * Patrick McHardy (kaber@trash.net) wrote:
> > This is the updated patch, it changes the eviction strategy
> > to LRU and fixes a bug related to TTL handling, the TTL stored
> > in the entry should only be overwritten if the IPT_RECENT_TTL
> > flag is set.
>=20
> I thought that I had convinced myself that the TTL handling was okay and
> that where it was overwritten wasn't harmful.  Oh well.

Looking at this again...  The ttl isn't copied into 'ttl' unless the
check_set has TTL turned on.  This means that the overwritting was fine,
if you accept that you can only ever match on TTL, or never match on it.
That doesn't seem right to me.  The TTL in the table should always be
kept up-to-date and the only question is if the current rule requires it
for a match or not.  This isn't a huge change, just set the local
variable always but check for if it's asked to match before calling the
lookup.  Or you could move it into an if/else block.

	Thanks,

		Stephen

--JF+ytOk7PH04NsRm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEaOyurzgMPqB3kigRAi9bAJ9Lt/Uly96YMfbc9aqLM7xv6ZhalACcD3CW
9rxaHkBEipDLz6NEXEjSiJY=
=iT1a
-----END PGP SIGNATURE-----

--JF+ytOk7PH04NsRm--
