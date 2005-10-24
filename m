From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] autogen.sh for conntrack
Date: Mon, 24 Oct 2005 10:07:16 +0200
Message-ID: <1130141237.11255.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-sWZ//uGvIw3VTIGVxLSt"
Cc: gryzor@inl.fr, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--=-sWZ//uGvIw3VTIGVxLSt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Here's just a simple autogen.sh for conntrack. I've suppressed explicit
linking with 1.6 version as this is really boring.

BR, 
-- 
Eric Leblond <eric@inl.fr>

--=-sWZ//uGvIw3VTIGVxLSt
Content-Disposition: attachment; filename=conntrack-autogen.diff
Content-Type: text/x-patch; name=conntrack-autogen.diff; charset=us-ascii
Content-Transfer-Encoding: quoted-printable

Index: autogen.sh
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- autogen.sh	(r=C3=A9vision 0)
+++ autogen.sh	(r=C3=A9vision 0)
@@ -0,0 +1,18 @@
+#!/bin/sh
+
+run ()
+{
+    echo "running: $*"
+    eval $*
+
+    if test $? !=3D 0 ; then
+	echo "error: while running '$*'"
+	exit 1
+    fi
+}
+
+run aclocal
+run libtoolize -f
+run autoheader
+run automake -a
+run autoconf

Modification de propri=E9t=E9s sur autogen.sh
___________________________________________________________________
Nom : svn:executable
   + *


--=-sWZ//uGvIw3VTIGVxLSt--
