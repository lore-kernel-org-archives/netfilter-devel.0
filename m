From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH] nfsim: trivial format string typo fix
Date: Wed, 2 Nov 2005 15:17:44 +0100
Message-ID: <200511021517.45463@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JqMaDjBQBHn3RTL"
Cc: laforge@netfilter.org, rusty@netfilter.org
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

--Boundary-00=_JqMaDjBQBHn3RTL
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  While playing with nfsim and nf_conntrack this weekend, I've found a 
trivial typo in core/core.c. Please apply the attached patch. (Yes, 
it's trivial but obviously it causes a segfault.)

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_JqMaDjBQBHn3RTL
Content-Type: text/x-diff; charset="us-ascii";
	name="nfsim-trivial_format_string_typo_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="nfsim-trivial_format_string_typo_fix.patch"

Index: nfsim/core/core.c
===================================================================
--- nfsim/core/core.c	(revision 4423)
+++ nfsim/core/core.c	(working copy)
@@ -386,7 +386,7 @@
 	for (p = __start_module_init; p < __stop_module_init; p++) {
 		ret = (*p)();
 		if (ret)
-			nfsim_log(LOG_UI, "Initcall %p failed: %s\n", p, ret);
+			nfsim_log(LOG_UI, "Initcall %p failed: %d\n", p, ret);
 	}
 }
 

--Boundary-00=_JqMaDjBQBHn3RTL--
