From: Eric Leblond <eleblond@init-sys.com>
Subject: [bug?] SNAT+DNAT with multiple range
Date: 13 Sep 2002 11:12:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1031908363.12207.35.camel@tech004>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-F5T/Kzt4ZvKCFbzgerYC"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-F5T/Kzt4ZvKCFbzgerYC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

We found something looking like a bug at our compagny when setting up a
load-balancer using DNAT and SNAT.

	    			server (192.168.0.1)=09
PC1------------------- RTRS ----|
	    			server (192.168.0.4)
192.168.0.0/24       192.168.0.20

That's standard but all machines are in the same network.

We use :

Chain PREROUTING (policy ACCEPT 2198 packets, 345K bytes)
 pkts bytes target     prot opt in     out     source               destina=
tion        =20
   19  1140 DNAT       tcp  --  *      *       0.0.0.0/0            192.168=
.0.20       tcp spts:1024:65535 dpt:3389 to:192.168.0.1 192.168.0.4=20

Chain POSTROUTING (policy ACCEPT 2033 packets, 134K bytes)
 pkts bytes target     prot opt in     out     source               destina=
tion        =20
   56  3360 SNAT       tcp  --  *      *       0.0.0.0/0            192.168=
.0.1        tcp spts:1024:65535 dpt:3389 to:192.168.0.2=20
   20  1200 SNAT       tcp  --  *      *       0.0.0.0/0            192.168=
.0.4        tcp spts:1024:65535 dpt:3389 to:192.168.0.2=20

the problem is that, in that case we don't do load balancing, the first
IP 192.168.0.1 is always taken.
If we omit the second SNAT rule, the load balancing operates well, but
we've got no reply ...

Best regards,
--=20
=C9ric Leblond
courriel : eleblond@init-sys.com

--=-F5T/Kzt4ZvKCFbzgerYC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQA9gawGnxA7CdMWjzIRAhEqAJ0dOAaFLpQWVArzUFBPPDk99o3sIQCaA+XS
glN/tGrDYmNK2jzLElx67QY=
=koJv
-----END PGP SIGNATURE-----

--=-F5T/Kzt4ZvKCFbzgerYC--
