From: "Piotr =?iso-8859-2?Q?Gasid=B3o?="
	<quaker@pandora.barbara.ds.polsl.gliwice.pl>
Subject: Re: [PATCH] account match seq_file update [RESEND of RESEND]
Date: Mon, 27 Sep 2004 16:21:03 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040927142103.GA18298@barbara.eu.org>
References: <20040926100202.GA8843@barbara.eu.org> <415817CF.3010007@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=_pandora.barbara.ds.polsl.gliwice.pl-19501-1096294863-0001-2"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <415817CF.3010007@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-19501-1096294863-0001-2
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On pon, 27/09, 03:38:23, Patrick McHardy wrote:
> iptables-based accounting is deprecated, so I expect
> we will remove the account/ACCOUNT match from pom-ng at some
> point.

Yes. I've read Harald Welte announce. I think, that module should stay
till some userspace accounting tool based on /proc/net/ip_conntrack
fields will be created.

My module is mostly used by small ISP (lets say "home" ISP, 100-200
users) as source for rrdtool to create traffic graphs for each IP. It
was developed to replace 200-400 traffic accounting rules with single
one.

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--=_pandora.barbara.ds.polsl.gliwice.pl-19501-1096294863-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQFBWCHPgEmu6PNADqoRAlI+AJ9vepzYnfys99oiAe7bFhDlT4f2/QCcDM2T
uH8xlNANxESAu+tu2ZFO6CI=
=MTYr
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-19501-1096294863-0001-2--
