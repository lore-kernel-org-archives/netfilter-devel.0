From: Netfilter Core Team <coreteam@netfilter.org>
Subject: [SECURITY] Netfilter Security Advisory: NAT Remote DOS (SACK mangle)
Date: Sat, 2 Aug 2003 16:34:17 +0200
Sender: netfilter-announce-admin@lists.netfilter.org
Message-ID: <20030802143417.GB21074@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Cc: vendor-sec@lst.de, bugtraq@securityfocus.com, lwn@lwn.net
Return-path: <netfilter-announce-admin@lists.netfilter.org>
To: Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-announce-admin@lists.netfilter.org
List-Help: <mailto:netfilter-announce-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-announce@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-announce/>
List-Id: netfilter-devel.vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

                  Netfilter Core Team Security Advisory
                 =20
                           CVE: CAN-2003-0467

Subject:

  Netfilter / NAT Remote DoS

Released:

  01 Aug 2003

Effects:

  Under limited circumstances, a remote user may be able to crash a
  machine doing Network Address Translation (NAT).

Estimated Severity:

  Medium.

Systems Affected:

  Linux 2.4.20 kernels and recent 2.5 kernels with
  CONFIG_IP_NF_NAT_FTP or CONFIG_IP_NF_NAT_IRC enabled, or the
  ip_nat_ftp or ip_nat_irc modules loaded, on which ftp and irc users
  are not packet filtered out.

Solution:

  BEST: Upgrade to Linux kernels 2.4.21 (stable), or apply the patch below.

  OR: As a workaround, the modules can be removed, or iptables can
  be used to block untrusted users from initiating ftp or irc
  connections through the NAT machine.

Details:

  This was verified by Rusty Russell on 2.4.20, and verified fixed
  with this patch.

Vendor Statement:

  Red Hat: All of the 2.4.20-based kernels shipped by Red Hat already
           contain the patch and are not vulnerable to this issue.
  Others:  unknown

Credits:
  The problem was found, and the fix implemented by the Netfilter Core Team.

Contact:
  coreteam@netfilter.org

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/curren=
t-dontdiff --minimal linux-2.4.21-pre7/net/ipv4/netfilter/ip_nat_helper.c w=
orking-2.4.21-pre7-sackadjust/net/ipv4/netfilter/ip_nat_helper.c
--- linux-2.4.21-pre7/net/ipv4/netfilter/ip_nat_helper.c	2003-04-06 15:26:4=
8.000000000 +1000
+++ working-2.4.21-pre7-sackadjust/net/ipv4/netfilter/ip_nat_helper.c	2003-=
04-14 23:18:38.000000000 +1000
@@ -366,54 +365,49 @@ sack_adjust(struct tcphdr *tcph,=20
 }
 		=09
=20
-/* TCP SACK sequence number adjustment, return 0 if sack found and adjuste=
d */
-static inline int
+/* TCP SACK sequence number adjustment. */
+static inline void
 ip_nat_sack_adjust(struct sk_buff *skb,
-			struct ip_conntrack *ct,
-			enum ip_conntrack_info ctinfo)
+		   struct ip_conntrack *ct,
+		   enum ip_conntrack_info ctinfo)
 {
-	struct iphdr *iph;
 	struct tcphdr *tcph;
-	unsigned char *ptr;
-	int length, dir, sack_adjusted =3D 0;
+	unsigned char *ptr, *optend;
+	unsigned int dir;
=20
-	iph =3D skb->nh.iph;
-	tcph =3D (void *)iph + iph->ihl*4;
-	length =3D (tcph->doff*4)-sizeof(struct tcphdr);
+	tcph =3D (void *)skb->nh.iph + skb->nh.iph->ihl*4;
+	optend =3D (unsigned char *)tcph + tcph->doff*4;
 	ptr =3D (unsigned char *)(tcph+1);
=20
 	dir =3D CTINFO2DIR(ctinfo);
=20
-	while (length > 0) {
-		int opcode =3D *ptr++;
+	while (ptr < optend) {
+		int opcode =3D ptr[0];
 		int opsize;
=20
 		switch (opcode) {
 		case TCPOPT_EOL:
-			return !sack_adjusted;
+			return;
 		case TCPOPT_NOP:
-			length--;
+			ptr++;
 			continue;
 		default:
-			opsize =3D *ptr++;
-			if (opsize > length) /* no partial opts */
-				return !sack_adjusted;
+			opsize =3D ptr[1];
+			 /* no partial opts */
+			if (ptr + opsize > optend || opsize < 2)
+				return;
 			if (opcode =3D=3D TCPOPT_SACK) {
 				/* found SACK */
 				if((opsize >=3D (TCPOLEN_SACK_BASE
 					       +TCPOLEN_SACK_PERBLOCK)) &&
 				   !((opsize - TCPOLEN_SACK_BASE)
 				     % TCPOLEN_SACK_PERBLOCK))
-					sack_adjust(tcph, ptr-2,
+					sack_adjust(tcph, ptr,
 						    &ct->nat.info.seq[!dir]);
-			=09
-				sack_adjusted =3D 1;
 			}
-			ptr +=3D opsize-2;
-			length -=3D opsize;
+			ptr +=3D opsize;
 		}
 	}
-	return !sack_adjusted;
 }
=20
 /* TCP sequence number adjustment */

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
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
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/K8vpNfqJzMqajVsRAuIqAKCackGU/IeQsPjPkOi5Yy237ccQFACfYEIW
8L8yUtqjWrWQC2zFJAvILXU=
=Cro8
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
