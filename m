From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Pptp conntrack nat testing
Date: Thu, 8 Jan 2004 01:21:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040108002150.GH6629@obroa-skai.de.gnumonks.org>
References: <FLEALNKCIGAFAECEAEINAEDICAAA.pb@bateauknowledge.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="smOfPzt+Qjm5bNGJ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Boot - Bateau Knowledge <pb@bateauknowledge.nl>
Content-Disposition: inline
In-Reply-To: <FLEALNKCIGAFAECEAEINAEDICAAA.pb@bateauknowledge.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--smOfPzt+Qjm5bNGJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2004 at 11:54:57PM +0100, Paul Boot - Bateau Knowledge wrot=
e:
> Dear Harold,
>=20
> I am currently working on a pptp-client-nat problem. Over here we run a
> simple RedHat9 iptables box using e1000 cards, vlans, a hp ethernet switch
> and masquarading to the Internet. (some 7 VLANs go to the Internet with o=
ne
> interface physical interface to the switch and one interface to a DSL lin=
k)
>=20
> To Internet going pptp-client connections (from windows workstations) over
> this masquarading firewall to an external Linux poptop pptpd server
> sometimes fails. In the /proc conntrack table pptp client ip addresses se=
em
> to be associated with old non-existing connections and the pptp tunnels c=
an
> not be created for a few hours. After a number of hours a windows
> pptp-client connects fine to a Linux pop-top pptpd server.

may I ask about the scale of your installating?  How many pptp sessions
would you have avg/maximum?

> I have done the following:
>=20
> 1. downloaded the latest kernel-source-2.4.20-28.9.rpm
> 2. pathed it with conntrack_pptp support from the
> patch-o-matic-20031219.tar.bz2
> 3. the kernel modules pptp_conntrack compiled fine
> 4. compiled iptables-1.2.9.tar.bz2 with KERNEL_DIR=3D/usr/src/linux-2.4  =
(wich
> contained the kernel-source-2.4.20-28.9 source)

that sounds perfectly fine.

> If you could help me with some answers I would be very happy because we
> badly need pptp-client support over a our masquaraded connection.
>=20
> 1. What is do you mean by can only do NAT connecions from PNS to PAC. (wh=
at
> does PNS and PAC stand for?)

This is the terminology used in the PPTP specification, please look into
the respective RFC's (RFC2637). =20
=20
> I assume:
> PAC, PPTP Access Concentrator
> PNS, PPTP Network Server

yes.

>   Note that this code currently has limitations
>    - can only NAT connections from PNS to PAC
>    - doesnt' support multiple calls within one session
>=20
> The poptop Linux implementations the PNS=3Dpoptop  and the windows-pptp-c=
lient
> is the PAC, right? (http://www.networksorcery.com/enp/rfc/rfc2637.txt)
> I think I need a NAT translation from PAC to PNS, right?

no, according to the RFC, your windows client would be a PNS and the
ppotop server a PAC.  So the conntrack/nat helpers are exactly for the
purpose you are trying to use them for.

> 2. Do you think will the conntrack_pptp module solve my problems or did I
> forget something?

no, in theory it should work.  However, it could be that you are hitting
some obscure bug that nobody else has yet experienced.

please also note that poptop is not able to deal with multiple incoming
pptp sessions from the same ip address!  At least the last time I looked
at the sourcecode, it had no way of differentiating pptp calls by
callID.

> Thankyou very much for your time!
> Kind regards,
> Paul Boot,
> The Netherlands.

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--smOfPzt+Qjm5bNGJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE//KKeXaXGVTD0i/8RAmuxAJsG+RHdfCA0C+QiV/ik5KyiOPNbSACfcUgF
+Pq1j5M9K0Nq5FqnNt/oL7s=
=aZvj
-----END PGP SIGNATURE-----

--smOfPzt+Qjm5bNGJ--
