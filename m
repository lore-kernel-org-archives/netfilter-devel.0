From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Makefile typo for man page
Date: Wed, 8 Sep 2004 15:04:05 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040908220405.GA16532@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
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


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Trivial typo prevents libip6t_targets.man from being included in build. 
Reported by Olaf Rempel.

This fixes bugzilla #239

Phil




--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-libip6t

diff -ru ipt-orig/Makefile ipt-new/Makefile
--- ipt-orig/Makefile	2004-06-17 07:21:07.000000000 -0400
+++ ipt-new/Makefile	2004-09-08 17:58:29.008998392 -0400
@@ -172,7 +172,7 @@
 	sed -e '/@MATCH@/ r extensions/libipt_matches.man' -e '/@TARGET@/ r extensions/libipt_targets.man' iptables.8.in >iptables.8
 
 ip6tables.8: ip6tables.8.in extensions/libip6t_matches.man extensions/libip6t_targets.man
-	sed -e '/@MATCH@/ r extensions/libip6t_matches.man' -e '/@TARGET@/ r extensions/libiptt_targets.man' ip6tables.8.in >ip6tables.8
+	sed -e '/@MATCH@/ r extensions/libip6t_matches.man' -e '/@TARGET@/ r extensions/libip6t_targets.man' ip6tables.8.in >ip6tables.8
 
 # Development Targets
 .PHONY: install-devel-man3

--HlL+5n6rz5pIUxbD--
