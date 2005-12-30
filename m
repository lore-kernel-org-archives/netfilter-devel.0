From: "Gilles Espinasse" <g.esp@free.fr>
Subject: [Patch] set Requires: iptables > 1.2.11
Date: Fri, 30 Dec 2005 18:29:30 +0100
Message-ID: <06fa01c60d66$97bf74d0$f9b5a8c0@pii350>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_06F7_01C60D6E.F929AEE0"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.

------=_NextPart_000_06F7_01C60D6E.F929AEE0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Due to the fact that extensions/libipt_set.h is missing in iptables-1.2.11,
I would suggest to add this  in pom for set extension
Requires: iptables > 1.2.11

Signed-off-by: Gilles Espinasse <g.esp@free.fr>

------=_NextPart_000_06F7_01C60D6E.F929AEE0
Content-Type: application/octet-stream;
	name="set_info.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="set_info.patch"

Index: patch-o-matic-ng/patchlets/set/info=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- patch-o-matic-ng/patchlets/set/info	(revision 6340)=0A=
+++ patch-o-matic-ng/patchlets/set/info	(working copy)=0A=
@@ -2,4 +2,5 @@=0A=
 Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>=0A=
 Status: Beta=0A=
 Repository: base=0A=
+Requires: iptables > 1.2.11=0A=
 Recompile: kernel, netfilter, iptables=0A=

------=_NextPart_000_06F7_01C60D6E.F929AEE0--
