From: Harald Welte <laforge@netfilter.org>
Subject: Re: New Version (1.13) of PPTP conntrack/nat helper
Date: Tue, 23 Sep 2003 16:49:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030923144924.GM31401@sunbeam.de.gnumonks.org>
References: <20030922203033.GD31401@sunbeam.de.gnumonks.org> <3F704CC7.7060508@able.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gs9iBZf6UKWgztis"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wim Ceulemans <wim.ceulemans@able.be>
Content-Disposition: inline
In-Reply-To: <3F704CC7.7060508@able.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Gs9iBZf6UKWgztis
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2003 at 03:38:15PM +0200, Wim Ceulemans wrote:
> Hi Harald
>=20
> Thanks for the patch.
>=20
> I tried patch-o-matic-20030922 with kernel 2.4.22 and connection to the=
=20
> PPTP server seems to work reliable now. Before this patch, connecting=20
> from a winxp machine did  succeed one out of 2 times, now it always=20
> succeeds.
>=20
> However, I also tried forwarding port 1723 and gre to a pptp server=20
> (win2000) behind the firewall. And there seems to be a problem with=20
> forwarding of the gre protocol. The connection to port 1723 behind the=20
> firewall succeeeds, but I don't see gre packets pass the firewall. I=20
> added these rules:
>=20
> iptables -t nat -A  PREROUTING -p TCP -d <wanip> --dport 1723 -j DNAT=20
> --to <winip>:1723
> iptables -t nat -A  PREROUTING -p GRE -d <wanip> -j DNAT --to <winip>

This is _not_ how it works.  Please just DNAT the 1723/tcp connection.
The gre connection is DNAT'ed accordingly (just like with any other nat
helper).  so please skip the second rule

> iptables -A FORWARD -p TCP -d <winip> --dport 1723 -j ACCEPT
> iptables -A FORWARD -p GRE -d <winip> -j ACCEPT

Those are not stateful rules.  You should make sure that you only accept=20
ESTABLISHED and RELATED gre.  Otherwise weird problems might occur.

If it still doesn't work, please check if you have enabled
CONFIG_IP_NF_NAT_LOCAL or not.  (try it with and without).

If it still doesn't work, please enable debugging (set the '#if 0' to
'#if 1' in ip_conntrack_pptp.c and ip_nat_pptp.c, ignore the compiler
warnings and send me the syslog excerpt of _one_ failing session.

> Regards
> Wim

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Gs9iBZf6UKWgztis
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/cF10XaXGVTD0i/8RAm0iAJ9cx/hhhY/uSXBafnurDlP9doI/zACdGF0M
iLMkJrNCFyd4mwdPiRWSOEo=
=I5MG
-----END PGP SIGNATURE-----

--Gs9iBZf6UKWgztis--
