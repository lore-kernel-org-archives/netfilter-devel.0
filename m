From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] 3/3 ipt_helper-invert-fix requirements
Date: Tue, 26 Oct 2004 14:23:00 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041026212300.GD2598@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oJ71EGRlYNjSvfq7"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The ipt_helper-invert-fix isn't needed on 2.4.27, but because of
some other changes in the vicinity pom-ng can't determine it has
already been applied.  Add a proper requires entry.

Phil



--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipthelper

diff -ruN pom-orig/ipt_helper-invert-fix/info pom-new/ipt_helper-invert-fix/info
--- pom-orig/ipt_helper-invert-fix/info	2004-03-17 20:09:05.000000000 -0500
+++ pom-new/ipt_helper-invert-fix/info	2004-10-01 18:38:39.485828512 -0400
@@ -1,3 +1,4 @@
 Author: Patrick McHardy <kaber@trash.net>
 Status: Pending for kernel inclusion
+Requires: linux-2.4 < 2.4.27
 Repository: pending

--oJ71EGRlYNjSvfq7--
