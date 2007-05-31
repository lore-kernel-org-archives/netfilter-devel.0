From: Eric Leblond <eric@inl.fr>
Subject: [Patch conntrack-tools] fix error message in configure.in
Date: Thu, 31 May 2007 13:39:56 +0200
Message-ID: <1180611596.3972.4.camel@ghlodit.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-As9aw0DPwGLLYWVpwTw7"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


--=-As9aw0DPwGLLYWVpwTw7
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

The following patch fixes an error message in configure.in. configure
was asking to install bison instead of flex if flex test failed.

BR,
-- 
Eric Leblond <eric@inl.fr>
INL SARL

--=-As9aw0DPwGLLYWVpwTw7
Content-Disposition: attachment; filename=conntrack-tools-flex.diff
Content-Type: text/x-patch; name=conntrack-tools-flex.diff; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Index: configure.in
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- configure.in	(r=C3=A9vision 6852)
+++ configure.in	(copie de travail)
@@ -26,8 +26,8 @@
 AC_CHECK_PROGS(XLEX,$LEX flex lex,none)
 if test "$XLEX" =3D "none"
 then
-	echo "*** Error: No suitable bison/yacc found. ***"
-	echo "    Please install the 'bison' package."
+	echo "*** Error: No suitable flex/lex found. ***"
+	echo "    Please install the 'flex' package."
 	exit 1
 fi
=20

--=-As9aw0DPwGLLYWVpwTw7--
