From: Harald Welte <laforge@netfilter.org>
Subject: Re: why don't we use /etc/protocols ?
Date: Sun, 28 Mar 2004 20:45:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040328184541.GA7039@sunbeam.de.gnumonks.org>
References: <4059F06F.1050306@globo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HSVPcR81XVhxeM7P"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pedro =?iso-8859-1?Q?Lamar=E3o?= <pedro.lamarao@globo.com>
Content-Disposition: inline
In-Reply-To: <4059F06F.1050306@globo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HSVPcR81XVhxeM7P
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 18, 2004 at 03:54:39PM -0300, Pedro Lamar=E3o wrote:
> Browsing the code I stumbled at this FIXME in iptables-save.c and=20
> produced the following patch. Please review it and send me comments.=20
> I'll be over this code for some time, so, if there is more of this kind=
=20
> of FIXME, I'd gladly work on it.

Thanks for your patch.  I think the original idea of that array was to
have it working even if there is no /etc/protocols (small embedded
system, ..).

So in a 'perfect' world, we would keep our small table for
commonly-used protocol and only query /etc/protocols if we don't have a
match.

Please also update iptables.c to make it consistent with
iptables-save/restore.

>  Pedro
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HSVPcR81XVhxeM7P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZx1VXaXGVTD0i/8RAgoTAJ9gvFZAZoIxz2fmyzFxcXdJiyQrdQCfXCWv
wl7M5LFQ1cdH314M2UbNu4E=
=JLp6
-----END PGP SIGNATURE-----

--HSVPcR81XVhxeM7P--
