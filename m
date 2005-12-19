From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] Debian packages for libnfnetlink, libnetfilter-{queue,
	log, conntrack}, conntrack
Date: Mon, 19 Dec 2005 11:47:28 +0100
Message-ID: <20051219104728.GZ7006@sunbeam.de.gnumonks.org>
References: <20051127173411.GA2031@roonstrasse.net>
	<438A02D3.3030203@trash.net>
	<20051202102345.GA29691@roonstrasse.net>
	<43A59A5F.1010006@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1+kiJ7gFzGEgD6MU"
Cc: Max Kellermann <max@duempel.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <43A59A5F.1010006@trash.net>
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


--1+kiJ7gFzGEgD6MU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 18, 2005 at 06:20:31PM +0100, Patrick McHardy wrote:
> Max Kellermann wrote:
> >On 2005/11/27 20:02, Patrick McHardy <kaber@trash.net> wrote:
> >>Very nice, but please wait with trying to get them into
> >>sid until we have resolved the CTA_PROTO_NUM issue.
> >ok, please notify me when the new release is out.
>=20
> I've changed libnetlink_conntrack to use the correct type, I guess
> we should release this soon. Harald, I'm not familiar with the
> process, can you please take care of this?

yes, I'll do a new release.  Do we only need libnetfilter_conntrack, or
also other packages (libnfnetlink / conntrack)?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--1+kiJ7gFzGEgD6MU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDpo/AXaXGVTD0i/8RAqG7AJ0Rjcl9RgVtVjtru3sI+WNU7/BWNQCfSmIa
fJr5nVw4y70Kugd/B/5yv3c=
=dFht
-----END PGP SIGNATURE-----

--1+kiJ7gFzGEgD6MU--
