From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] time match does not track DST changes
Date: Sun, 26 Sep 2004 09:43:04 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040926074304.GM3236@sunbeam.de.gnumonks.org>
References: <20040924231126.GA9030@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4IS0x2wnB+8sCNhC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20040924231126.GA9030@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--4IS0x2wnB+8sCNhC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 24, 2004 at 04:11:26PM -0700, Phil Oester wrote:
> The time match does not follow daylight savings time changes.
> Without adding timezone information to the kernel, fixing the
> module doesn't seem possible. =20

Yes, this is one of the reasons why the time match shouldn't be used in
the first place.  Use cron and a small script to modify your ruleset at
the given time(s).

ipt_time will never get into the mainline kernel...

> So, the below just adds a couple notes so users are aware of=20
> this limitation.

I'm fine with this.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4IS0x2wnB+8sCNhC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBVnMIXaXGVTD0i/8RApDoAKCHEwwljlvq+968vEmrAekn8L1gMgCfde7F
fVhvQZYfy4hrk+5uIJz9Z+E=
=FAMs
-----END PGP SIGNATURE-----

--4IS0x2wnB+8sCNhC--
