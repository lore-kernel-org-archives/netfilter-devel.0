From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ipt_helper-invert-fix is < 2.4.27
Date: Fri, 1 Oct 2004 15:49:46 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041001224946.GC30842@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/Uq4LBwYP4y1W6pO"
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


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The ipt_helper-invert-fix isn't needed on 2.4.27, but because of
some other changes in the vicinity pom-ng can't determine it has
already been applied.  This breaks --batch mode on 2.4.  Add a 
proper requires entry.

This patch, combined with the previous two pom-ng patches makes
runme --batch work again on 2.4, and closes bugzilla #241 (but
come 2.4.28, it will likely break again)

Phil



--/Uq4LBwYP4y1W6pO
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

--/Uq4LBwYP4y1W6pO--
