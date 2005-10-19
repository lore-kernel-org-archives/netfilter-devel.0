From: Harald Welte <laforge@netfilter.org>
Subject: Re: PATCH Re: ipt_ulog.h versus ebt_ulog.h
Date: Wed, 19 Oct 2005 15:10:44 +0200
Message-ID: <20051019131044.GG26672@sunbeam.de.gnumonks.org>
References: <dj519g$ke6$1@sea.gmane.org> <435614E6.1080200@ufomechanic.net>
	<43564497.20009@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <43564497.20009@ufomechanic.net>
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


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 19, 2005 at 02:05:27PM +0100, Amin Azez wrote:
> Do we need an equivalent patch for ulog2?

there is no ulog2 inside the kernel.  nfnetlink_log is the system that
obsoletes ULOG.  nfnetlink_log transports both, the indev/outdev _and_
the phys{in,out}dev to userspace.

> ipt_ULOG was logging the bridge device instead of the physical devices
> (for bridged packets at least).

yes, which is the correct behaviour from a technical point of view.

> Harald; also does it make sense with ulog2 to talk about merging
> ebt_ulog_packet_msg and ulog_packet_msg?

please look at nfnetlink_log.  It supersedes any of the old in-kernel
ulog stuff, and is totally independent of any fixed messages.

Since ipt_ULOG (and as far as my opinion goes, ebt_ulog as well) is
scheduled for feature removal,  I will not apply your patch.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDVkXUXaXGVTD0i/8RAsAHAKCm3EHubpKqiQlF3aOVwipQCmP7rwCeKk9j
Eyn6uBcBKTvLZnnF5u0MItk=
=aBWF
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--
