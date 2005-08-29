From: Samir Bellabes <sbellabes@mandriva.com>
Subject: [NETFILTER] Kill lockhelp.h for rtsp-conntrack
Date: Mon, 29 Aug 2005 19:27:32 +0200
Message-ID: <m2u0h8vekb.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--=-=-=

Hi,
This patch fix the match 'rtsp-conntrack', after the kill_lockhelp.patch
Please apply at top of the svn tree.

regards,
Samir Bellabes


--=-=-=
Content-Type: text/x-patch; charset=iso-8859-15
Content-Disposition: attachment;
 filename=rtsp-conntrack_kill_lockhelp.patch
Content-Transfer-Encoding: quoted-printable

[NETFILTER] Kill lockhelp.h for rtsp_conntrack

---------------------------------------------------------------------------=
---

 ip_conntrack_rtsp.h |    2 --
 1 files changed, 2 deletions(-)

---------------------------------------------------------------------------=
---
Index: patchlets/rtsp-conntrack/linux-2.6.11/include/linux/netfilter_ipv4/i=
p_conntrack_rtsp.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/rtsp-conntrack/linux-2.6.11/include/linux/netfilter_ipv4/ip_c=
onntrack_rtsp.h	(r=C3=A9vision 4248)
+++ patchlets/rtsp-conntrack/linux-2.6.11/include/linux/netfilter_ipv4/ip_c=
onntrack_rtsp.h	(copie de travail)
@@ -49,8 +49,6 @@
=20
 #ifdef __KERNEL__
=20
-#include <linux/netfilter_ipv4/lockhelp.h>
-
 #define RTSP_PORT   554
=20
 #endif /* __KERNEL__ */

--=-=-=--
