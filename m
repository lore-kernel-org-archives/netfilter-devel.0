From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: [TRIVIAL] DEBUGFTP() in ip_nat_ftp is unresolved symbol
Date: 29 Sep 2002 12:15:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1033294530.561.6.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-nOmPpEi32jVQvAKPpc2Z"
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


--=-nOmPpEi32jVQvAKPpc2Z
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

ip_conntrack_ftp.c contains a macro DEBUGFTP that is not defined
anywhere, it's a typo for DEBUGP.

The reason nobody ever noticed is that it's wrapped inside an
#if 0 
...
#endif

Patch attached.

Regards,
Filip




--=-nOmPpEi32jVQvAKPpc2Z
Content-Disposition: attachment; filename=ip_conntrack_ftp.typofix.20020929-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=ip_conntrack_ftp.typofix.20020929-1;
	charset=ANSI_X3.4-1968

diff -urN -X dontdiff linux-2.4.20-pre8/net/ipv4/netfilter/ip_conntrack_ftp=
.c linux-2.4.20-pre8-ftpfix/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.4.20-pre8/net/ipv4/netfilter/ip_conntrack_ftp.c	2002-09-29 11:5=
4:49.000000000 +0200
+++ linux-2.4.20-pre8-ftpfix/net/ipv4/netfilter/ip_conntrack_ftp.c	2002-09-=
29 11:59:13.000000000 +0200
@@ -200,7 +200,7 @@
=20
 		DEBUGP("ftp: string mismatch\n");
 		for (i =3D 0; i < plen; i++) {
-			DEBUGFTP("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
+			DEBUGP("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
 				 i, data[i], data[i],
 				 pattern[i], pattern[i]);
 		}

--=-nOmPpEi32jVQvAKPpc2Z--
