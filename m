From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: [BUG] Security Announcement: ip6tables bug - level: very high
Date: 06 Jun 2002 00:58:08 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023317890.912.28.camel@hoi>
References: <Pine.LNX.4.33.0206031139030.4553-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-/ZNe9GeUlgfFDpUIn/MR"
Cc: "Kraus, Darko" <DKraus@smartbus.org>,
	Harald Welte <laforge@gnumonks.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter Devel <netfilter-devel@lists.samba.org>
In-Reply-To: <Pine.LNX.4.33.0206031139030.4553-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-/ZNe9GeUlgfFDpUIn/MR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

My worst nightmare came true: a very serious bug in the ip6tables code.
I can not beleive it, so please test it!

On 31 May 2002, Kraus, Darko sent a letter to Jozsef Kadlecsik:
> I have notices two not functional things in ip6tables:
> - ip6tables -A FORWARD -j ACCEPT -p all   <--- the protocol type "all" do=
es
> not match anything. I have to specify individually tcp, udp and icmpv6 in
> order to get forwarded.
> - ip6tables -A FORWARD -j REJECT causes segmentation fault.
> I am using kernel V2.4.18 with latest IPtables 1.2.6a. Also I have applie=
d
> Rusty's patch-o-matic that came with iptables-1.2.6a.tar.gz to that kerne=
l.
> My host is running as a router, and I have no problems setting up iptable=
s
> for IPv4. IPv6 is the one who causes these problems. I am using a tunnel
> broker to connect to the internet via IPv6. If you need some additional i=
nfo
> please let me know.
Yes, it's true (I will fix this ASAP).
After this I started to play with the test packets.

The exapmle scenario:
# ip6tables -L
# tcpreplay6 <pure-icmpv6
# tcpreplay6 <ah-len24-spi4096-clean-dst-len8-sub2-len4-pad1-pad1
// or any other packet with extension headers
# ip6tables -A OUTPUT -p ipv6-icmp
# tcpreplay6 <pure-icmpv6
# ip6tables -L OUTPUT -n -v
Chain OUTPUT (policy ACCEPT 1 packets, 57 bytes)
 pkts bytes target     prot opt in     out    source destination       =20
    1    57            icmpv6    *      *      ::/0   ::/0      =20
# tcpreplay6 <ah-len24-spi4096-clean-dst-len8-sub2-len4-pad1-pad1
// or any other packet with extension headers


*** The kernel crashed immediately. ***

(The test packets can be found in the pool:
http://www.securityaudit.hu/Netfilter/addons/TestPackets/ )

The POSSIBLE location of the problem:
linux/net/ipv6/netfilter/ip6_tables.c
ip6_packet_match() function,
line 231:
-                hdrptr =3D (u_int8_t *)(ipv6 + 1);
+                hdrptr =3D (u_int8_t *)((void *)ipv6 + 1);

In patch form:
[..............]
--- ip6_tables-p0bug.c	Wed Jun  5 23:57:31 2002
+++ ip6_tables.c	Thu Jun  6 00:45:54 2002
@@ -228,7 +228,7 @@
 	if((ip6info->flags & IP6T_F_PROTO)) {
 		u_int8_t currenthdr =3D ipv6->nexthdr;
 		u_int8_t *hdrptr;
-		hdrptr =3D (u_int8_t *)(ipv6 + 1);
+		hdrptr =3D (u_int8_t *)((void *)ipv6 + 1);
 		do {
 			if (ip6info->proto =3D=3D currenthdr) {
 				if(ip6info->invflags & IP6T_INV_PROTO)
[..............]

Other problem:
ip6_nexthdr() function:
[..............]
--- ip6_tables-p0bug.c	Wed Jun  5 23:57:31 2002
+++ ip6_tables.c	Thu Jun  6 00:50:11 2002
@@ -138,7 +138,6 @@
    and returns the new header value, else returns 0 */
 static u_int8_t ip6_nexthdr(u_int8_t currenthdr, u_int8_t *hdrptr)
 {
-	int i;
 	u_int8_t hdrlen, nexthdr =3D 0;
 	switch(currenthdr){
 		case IPPROTO_AH:
@@ -147,7 +146,7 @@
 		repeatedly...with a large stick...no, an even LARGER
 		stick...no, you're still not thinking big enough */
 			nexthdr =3D *hdrptr;
-			hdrlen =3D hdrptr[i] * 4 + 8;
+			hdrlen =3D hdrptr[1] * 4 + 8;
 			hdrptr =3D hdrptr + hdrlen;
 			break;
 		/*stupid rfc2402 */
[..............]
The variable 'i' used uninitzialized - a copied buggy code?

I don't know which one is the correct solution, I will test it (maybe in
an hour).

*** Affected systems ***
Any Linux system, which has a rule with protocol match (-p)!

*** Preparedness ***
Any script-kiddie, or a plain user with instructions.
Automated tool: possible

*** Result ***
Kernel crash

*** Required packet ***
- any IPv6 packet with options (fix: near the 1st patch)
- IPv6 packet with AH option (fix: near the 2nd patch)

Regards,

	kisza

--=20
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /-----Member of the BUTE-MIS-SEARCHlab------>

--=-/ZNe9GeUlgfFDpUIn/MR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQA8/peAnrsnmOKV9J8RAoa0AJ0QlqLbUco4oCaduUHok44w72kK9gCg37lF
hpT3jG1cQlf93VlrD5KCBtY=
=+I2r
-----END PGP SIGNATURE-----

--=-/ZNe9GeUlgfFDpUIn/MR--
