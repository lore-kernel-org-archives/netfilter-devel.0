From: Harald Welte <laforge@netfilter.org>
Subject: Re: Problems with 25_natcore-nohelper patch
Date: Fri, 4 Jul 2003 20:29:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030704182917.GV7073@sunbeam.de.gnumonks.org>
References: <200305081512.31038.raivis@mt.lv> <Pine.GSO.4.03.10305090250510.7371-100000@shemp.vdata.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4eYdsOpNbj/aD8un"
Cc: Raivis Bucis <raivis@mt.lv>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jeff Hall <hall@vdata.com>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.03.10305090250510.7371-100000@shemp.vdata.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4eYdsOpNbj/aD8un
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2003 at 03:14:09AM -0400, Jeff Hall wrote:

> Did you also apply the patches below? They're from a message to Harald
> Welte on 2003/4/8 and I believe they pertain to the problem you're
> having.
>=20
> I tested the pptp client from sourceforge.net on a machine also running
> a PoPToP server and was able to make a successful outgoing connection from
> that machine.
>=20
> If these patches don't solve your problem, let me know and I'll send you
> all the pertinent sources.

> On Thu, 8 May 2003, Raivis Bucis wrote:
>=20
> > I would like to inform you that width 25_natcore-nohelper patch PPTP
> > NAT stops working correctly. Specifically PPTP client (PAC) on the
> > box that has ip_nat_pptp.o loaded doesn't work.
> >=20
> > Since PPTP NAT allways changes callerID, it is required that
> > pptp_nat helper is also allways called, but pptp client TCP
> > controlling connection doesn't have any manips, and only associated
> > GRE conntrack has manips for callerID changing. So pptp_nat helper
> > can not change callerID in controll connection and PPTP doesn't work
> > anymore.
> >=20
> > Is this a known problem?
> >=20
> > Raivis

Since I didn't receive any update on this issue:  Raivis, ist the
problem now solved when this patchlet from Jeffs original mail (also
submitted to the mainstream kernel since 2.4.20)had been applied?

> --- ip_nat_standalone.c.prepatch        Sun Mar 16 01:41:45 2003
> +++ ip_nat_standalone.c Thu Apr  3 19:52:09 2003
> @@ -121,8 +121,13 @@
>  			if (ct->master
>  			    && master_ct(ct)->nat.info.helper
>  			    && master_ct(ct)->nat.info.helper->expect) {
> -				ret =3D call_expect(master_ct(ct), pskb,=20
> +				if(master_ct(ct)->nat.info.num_manips) {
> +					ret =3D call_expect(master_ct(ct), pskb,=20
>  						hooknum, ct, info);
> +				} else {
> +					WRITE_UNLOCK(&ip_nat_lock);
> +					return NF_ACCEPT;
> +				}
>  			} else {
>  #ifdef CONFIG_IP_NF_NAT_LOCAL

alternatively, please try a 2.4.21 kernel with the pptp patch from
patch-o-matic and tell me if the problem still persists.

thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4eYdsOpNbj/aD8un
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/Bcd9XaXGVTD0i/8RAnuCAJ98naGQVkOGALneAAPsRKQxif1+wgCdGDot
G4+mMlYy1Pqps7BFNnhOn98=
=QvTJ
-----END PGP SIGNATURE-----

--4eYdsOpNbj/aD8un--
