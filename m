From: Fabrice MARIE <fabrice@celestix.com>
Subject: [PATCH] tftp conntrack patch makefile fix
Date: Thu, 4 Jul 2002 19:12:35 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <ag17f3$su9$2@main.gmane.org>
Reply-To: fabrice@celestix.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_ZS1QFC3S9AI5NJR832ZB"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_ZS1QFC3S9AI5NJR832ZB
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit


[oops .. pressed enter too fast :( ]

Hello,

Attached patch should fix the tftp conntrack patch to
make it apply properly again.

Have a nice day,

Fabrice.

http://fabnetwork.ifrance.com/fabnetwork/
--
Fabrice MARIE
Senior R&D Engineer
Celestix Networks
http://www.celestix.com/

"Silly hacker, root is for administrators"
       -Unknown
--------------Boundary-00=_ZS1QFC3S9AI5NJR832ZB
Content-Type: text/x-diff;
  charset="us-ascii";
  name="conntrack_tftp_patch_makefile_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="conntrack_tftp_patch_makefile_fix.patch"

diff -uNr cvs/netfilter/userspace/patch-o-matic/extra/tftp-conntrack-nat.patch.makefile-3 netfilter/userspace/patch-o-matic/extra/tftp-conntrack-nat.patch.makefile-3
--- cvs/netfilter/userspace/patch-o-matic/extra/tftp-conntrack-nat.patch.makefile-3	2002-04-15 19:33:13.000000000 +0800
+++ netfilter/userspace/patch-o-matic/extra/tftp-conntrack-nat.patch.makefile-3	2002-07-04 18:43:00.000000000 +0800
@@ -1,2 +1,2 @@
-# NAT helpers
+# NAT helpers 
 obj-$(CONFIG_IP_NF_NAT_TFTP) += ip_nat_tftp.o

--------------Boundary-00=_ZS1QFC3S9AI5NJR832ZB--
