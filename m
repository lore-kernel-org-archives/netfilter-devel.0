From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 3/3] nfsim-testsuite: don't fail if no loadable modules are
	found
Date: Sat, 5 Nov 2005 12:35:44 +0100
Message-ID: <200511051235.44808@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QkJbDV1vs0kKorc"
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_QkJbDV1vs0kKorc
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  The testsuite fails if no loadable modules are found (for example: 
everything is compiled in statically). The attached patch tries to fix 
the testsuite for fully static configurations.

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_QkJbDV1vs0kKorc
Content-Type: text/x-diff; charset="us-ascii";
	name="03-nfsim-testsuite-dont_fail_if_no_modules_are_found.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="03-nfsim-testsuite-dont_fail_if_no_modules_are_found.patch"

Don't fail if no loadable modules are found.

Index: nfsim-testsuite/test-kernel-source
===================================================================
--- nfsim-testsuite/test-kernel-source	(revision 4444)
+++ nfsim-testsuite/test-kernel-source	(working copy)
@@ -16,7 +16,7 @@
     mkdir $2
     cp simulator $2
     cp core/fakesockopt.so.1.0 $2
-    cp `find . -name *.so` $2
+    cp `find . -name *.so` $2 || true
 }
 
 # Simple check of cached nfsim: if any source file in nfsim newer, rebuild.

--Boundary-00=_QkJbDV1vs0kKorc--
