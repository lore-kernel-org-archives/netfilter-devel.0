From: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
Subject: Re: libiptc/rules with MAC match
Date: Wed, 12 Feb 2003 22:05:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030212210522.GG30133@calix.csn.tu-chemnitz.de>
References: <647994215.20030212211303@habitat-b.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CGDBiGfvSTbxKZlW"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <647994215.20030212211303@habitat-b.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--CGDBiGfvSTbxKZlW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 12, 2003 at 09:13:03PM +0100, DarKRaveR wrote:

>   Within this struct there an ipt_ip struct, with the properties:
>   char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
>   unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
>=20
>   What's the difference between those two ?

just have a look at parse_interface() in $IPT_SOURCE/iptables.c or
ip_packet_match() in $KERNELDIR/net/ipv4/netfilter/ip_tables.c.


To make a long story short:=20

Iptables allows you to specify a device like this: "-i eth+", which
means all devices that start with "eth".

In this example iniface would contain: "eth+", whereas iniface_mask
contains something like { 0xFF,0xFF,0xFF,NULL }.

So when iptables comes to compare the actual device with the device
specified in the rule it compares only the first 3 caracters.

Example:

eth1  actual device of packet
eth+  device in rule
1110  mask (see every "1" as a "0xFF" for a character comparator)
----
eth   -> match


At least this is how I understood the sources.

Ciao!
    Thomas

--=20
In theory, there is no difference between theory and practice.
In practice, there is.

--CGDBiGfvSTbxKZlW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+SrcRT7fd1jhuy5cRAvqzAJsFsOCWZ5IsTVLuhoRDZ+zLvPHfuQCePx3b
KT2ZBQZGWKtEXLwyIIH37Sg=
=Th26
-----END PGP SIGNATURE-----

--CGDBiGfvSTbxKZlW--
