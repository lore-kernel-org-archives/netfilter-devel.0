From: Harald Welte <laforge@netfilter.org>
Subject: Re: [BUG] active ftp doesn't work since 2.6.9-rc1
Date: Fri, 1 Oct 2004 16:10:50 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041001141050.GH27499@sunbeam.de.gnumonks.org>
References: <20041001111201.GA23033@pc11.op.pod.cz>
	<20041001132248.GG27499@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
Cc: Vitezslav Samel <samel@mail.cz>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>, linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20041001132248.GG27499@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 01, 2004 at 03:22:48PM +0200, Harald Welte wrote:
> On Fri, Oct 01, 2004 at 01:12:01PM +0200, Vitezslav Samel wrote:
> > 	Hi!
> >=20
> >   After upgrade to 2.6.9-rc3 on the firewall (with NAT), active ftp sto=
pped
> > working. The first kernel, which doesn't work is 2.6.9-rc1.
> > Sympotms: passive ftp works O.K., active FTP doesn't open data
> > stream (and in logs there entries about invalid packets - using
> > iptables ... -m state --state INVALID -j LOG)

Please use the following (attached) fix:

DaveM: Please apply and push to Linus:

Thanks!


Fix NAT helper code to update TCP window tracking information
if it resizes payload (and thus alrers sequence numbers).

This patchlet was somehow lost during 2.4.x->2.6.x port of TCP=20
window tracking :(

Signed-off-by: Harald Welte <laforge@netfilter.org>

--- linux-2.6.9-rc3-plain/net/ipv4/netfilter/ip_nat_helper.c	2004-10-01 12:=
08:40.000000000 +0000
+++ linux-2.6.9-rc3-test/net/ipv4/netfilter/ip_nat_helper.c	2004-10-01 13:3=
7:05.283639640 +0000
@@ -347,7 +347,7 @@
 	return 1;
 }
=20
-/* TCP sequence number adjustment.  Returns true or false.  */
+/* TCP sequence number adjustment.  Returns 1 on success, 0 on failure */
 int
 ip_nat_seq_adjust(struct sk_buff **pskb,=20
 		  struct ip_conntrack *ct,=20
@@ -396,7 +396,12 @@
 	tcph->seq =3D newseq;
 	tcph->ack_seq =3D newack;
=20
-	return ip_nat_sack_adjust(pskb, tcph, ct, ctinfo);
+	if (!ip_nat_sack_adjust(pskb, tcph, ct, ctinfo))
+		return 0;
+
+	ip_conntrack_tcp_update(*pskb, ct, dir);
+
+	return 1;
 }
=20
 static inline int

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBXWVqXaXGVTD0i/8RAqslAKCbomLVUexsIUNKJoD5J5ygzirMngCfZKSh
S0NMK0XDGluJTkEZopSo4Uo=
=FQ4R
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
