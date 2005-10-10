From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH/RFC/RFT] add "revision" support to arp_tables and
	ip6_tables
Date: Mon, 10 Oct 2005 18:32:56 +0200
Message-ID: <20051010163256.GB5627@rama>
References: <20051009222628.GC6593@rama.customers.eurospot.com>
	<434A373B.1060406@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	David Miller <davem@davemloft.net>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Content-Disposition: inline
In-Reply-To: <434A373B.1060406@gmx.net>
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


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2005 at 11:41:15AM +0200, Carl-Daniel Hailfinger wrote:

> >[NETFILTER] {ip6,arp}_tables: Add support for match/target revisions
> >This patch synchronizes {ip6,arp}_tables with recent changes in ip_table=
s.
> >It adds support for multiple revisions per match/target.
> >diff --git a/include/linux/netfilter_arp/arp_tables.h=20
> >b/include/linux/netfilter_arp/arp_tables.h
> >--- a/include/linux/netfilter_arp/arp_tables.h
> >+++ b/include/linux/netfilter_arp/arp_tables.h
> >@@ -68,7 +68,8 @@ struct arpt_entry_target
> > 			u_int16_t target_size;
> >  			/* Used by userspace */
> >-			char name[ARPT_FUNCTION_MAXNAMELEN];
> >+			char name[ARPT_FUNCTION_MAXNAMELEN-1];
> >+			u_int8_t revision;
> > 		} user;
> > 		struct {
> > 			u_int16_t target_size;
>=20
> This will explode once revision!=3D0 because the string stored in name is=
 not NULL-terminated=20
> anymore if it is ARPT_FUNCTION_MAXNAMELEN-1 long.

Are you referring to something specific inside arp_tables kernel or
userspace code?  We had a similar change in ip_tables some time ago, and
just made sure that the userspace program ("iptables") didn't generate
any strings longer than IPT_FUNCTION_NAMELEN-2.  Since we never had any
matches or targets that used the full length, there is no problem. =20

At least inside the mainline kernel, I cannot see any targets/matches
for ip6_tables or arp_tables that actually have 30 characters of length.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSpe4XaXGVTD0i/8RAolWAJ4i9KNSDAhOWrEyzAFaeFmfsdhOgQCfVb75
0PM9FCZbNe5i8rUbZWflVEc=
=JHcA
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
