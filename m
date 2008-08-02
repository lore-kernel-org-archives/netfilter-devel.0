From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Update pom-ng docs for new iptables snapshots
Date: Sat, 2 Aug 2008 16:41:56 -0700
Message-ID: <20080802234156.GA26595@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:55702
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751052AbYHBXl5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Aug 2008 19:41:57 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Attempting to run pom-ng's runme against an iptables snapshot
which has not yet had release.sh run in it will fail.  Update
docs to reflect this.

This closes bugzilla #538.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>


diff -ruN pom-orig/README pom-new/README
--- pom-orig/README	2008-08-01 14:55:55.000000000 -0700
+++ pom-new/README	2008-08-02 16:03:04.000000000 -0700
@@ -2,9 +2,13 @@
    This is the patch-o-matic-ng distribution by the netfilter project
    (http://www.netfilter.org/)
 
-   As of iptables-1.2.7, patch-o-matic is distributed as a seperate
+   As of iptables-1.2.7, patch-o-matic is distributed as a separate
    package, available from ftp://ftp.netfilter.org/pub/patch-o-matic-ng.
 
+   NOTE: if you are building against an unreleased (snapshot) version
+   of iptables, make sure you have run release.sh in the iptables tree.
+   Otherwise, runme will fail as it won't find the iptables Makefile.
+
