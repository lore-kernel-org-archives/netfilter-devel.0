From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] cosmetic ipt_unclean update
Date: Thu, 2 Oct 2003 16:43:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002144300.GH5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ccWoVK0blSAgmhl2"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ccWoVK0blSAgmhl2
Content-Type: multipart/mixed; boundary="BstnvG52tZMVQOpr"
Content-Disposition: inline


--BstnvG52tZMVQOpr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patchto your 2.4 tree and push it to Marcelo.
Thanks.


Author: Patrick McHardy <kaber@trash.net>

Use a pre-built table for TCP flag checks instead of individual 'if'
statemens in ipt_unclean.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BstnvG52tZMVQOpr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="55_ipt_unclean-tcp-flag-table.patch"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1214  -> 1.1215=20
#	net/ipv4/netfilter/ipt_unclean.c	1.8     -> 1.9   =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/12	kaber@trash.net		1.1215
# [NETFILTER]: Use pre-built table for TCP flag-check in ipt_unclean.
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_unclean.c b/net/ipv4/netfilter/ipt_uncle=
an.c
--- a/net/ipv4/netfilter/ipt_unclean.c	Sat Jul 12 05:40:25 2003
+++ b/net/ipv4/netfilter/ipt_unclean.c	Sat Jul 12 05:40:25 2003
@@ -259,6 +259,24 @@
 #define	TH_ECE	0x40
 #define	TH_CWR	0x80
=20
+/* table of valid flag combinations - ECE and CWR are always valid */
+static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1=
] =3D
+{
+	[TH_SYN]			=3D 1,
+	[TH_SYN|TH_ACK]			=3D 1,
+	[TH_RST]			=3D 1,
+	[TH_RST|TH_ACK]			=3D 1,
+	[TH_RST|TH_ACK|TH_PUSH]		=3D 1,
+	[TH_FIN|TH_ACK]			=3D 1,
+	[TH_ACK]			=3D 1,
+	[TH_ACK|TH_PUSH]		=3D 1,
+	[TH_ACK|TH_URG]			=3D 1,
+	[TH_ACK|TH_URG|TH_PUSH]		=3D 1,
+	[TH_FIN|TH_ACK|TH_PUSH]		=3D 1,
+	[TH_FIN|TH_ACK|TH_URG]		=3D 1,
+	[TH_FIN|TH_ACK|TH_URG|TH_PUSH]	=3D 1
+};
+
 /* TCP-specific checks. */
 static int
 check_tcp(const struct iphdr *iph,
@@ -330,19 +348,7 @@
=20
 	/* CHECK: TCP flags. */
 	tcpflags =3D (((u_int8_t *)tcph)[13] & ~(TH_ECE|TH_CWR));
-	if (tcpflags !=3D TH_SYN
-	    && tcpflags !=3D (TH_SYN|TH_ACK)
-		&& tcpflags !=3D TH_RST
-	    && tcpflags !=3D (TH_RST|TH_ACK)
-	    && tcpflags !=3D (TH_RST|TH_ACK|TH_PUSH)
-	    && tcpflags !=3D (TH_FIN|TH_ACK)
-	    && tcpflags !=3D TH_ACK
-	    && tcpflags !=3D (TH_ACK|TH_PUSH)
-	    && tcpflags !=3D (TH_ACK|TH_URG)
-	    && tcpflags !=3D (TH_ACK|TH_URG|TH_PUSH)
-	    && tcpflags !=3D (TH_FIN|TH_ACK|TH_PUSH)
-	    && tcpflags !=3D (TH_FIN|TH_ACK|TH_URG)
-	    && tcpflags !=3D (TH_FIN|TH_ACK|TH_URG|TH_PUSH)) {
+	if (!tcp_valid_flags[tcpflags]) {
 		limpk("TCP flags bad: %u\n", tcpflags);
 		return 0;
 	}

--BstnvG52tZMVQOpr--

--ccWoVK0blSAgmhl2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDl0XaXGVTD0i/8RAtYiAJ4i7EftvtVhvTbM6zMwYP1hOxXS5wCfboYB
Vy5TUO3e0k5gMdN5p0ueKVM=
=4DqM
-----END PGP SIGNATURE-----

--ccWoVK0blSAgmhl2--
