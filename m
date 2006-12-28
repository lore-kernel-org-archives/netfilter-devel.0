From: Victor Stinner <victor.stinner@inl.fr>
Subject: Fix small bug in nfnl_subsys_open (uninitialized values)
Date: Thu, 28 Dec 2006 19:58:35 +0100
Message-ID: <200612281958.35720.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bPBlF7jqn7gq1r5"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_bPBlF7jqn7gq1r5
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I found a bug in libnfnetlink, function nfnl_subsys_open(). I attached a patch 
to fix it.

The problem is that callback structures weren't initialized. So sometimes, 
bytes are nul, sometimes... not.

Victor Stinner
http://www.inl.fr/

--Boundary-00=_bPBlF7jqn7gq1r5
Content-Type: text/x-diff; charset="us-ascii";
	name="libnfnetlink_subsys_open.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="libnfnetlink_subsys_open.patch"

Index: src/libnfnetlink.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- src/libnfnetlink.c	(r=C3=A9vision 6716)
+++ src/libnfnetlink.c	(copie de travail)
@@ -244,7 +244,7 @@
 		return NULL;
 	}
=20
=2D	ssh->cb =3D malloc(sizeof(*(ssh->cb)) * cb_count);
+	ssh->cb =3D calloc(cb_count, sizeof(*(ssh->cb)));
 	if (!ssh->cb)
 		return NULL;
=20

--Boundary-00=_bPBlF7jqn7gq1r5--
