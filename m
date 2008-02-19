From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/07]: Make sure xt_policy.h is unifdef'ed.
Date: Tue, 19 Feb 2008 17:25:49 +0100 (MET)
Message-ID: <20080219162537.13631.27961.sendpatchset@localhost.localdomain>
References: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50471 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYBSQZv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:25:51 -0500
In-Reply-To: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Make sure xt_policy.h is unifdef'ed.

Since the header file xt_policy.h tests __KERNEL__, it should be
unifdef'ed before exporting to userspace.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0776e52cdb04aad5b59c4e12dc16e7b58737c2d2
tree d8f3cb734bad2c4df073262ab9ac14989f28eb28
parent 02413e566cd9a49bcf1f15f69cdc749780181412
author Robert P. J. Day <rpjday@crashcourse.ca> Tue, 19 Feb 2008 17:15:28 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 19 Feb 2008 17:15:28 +0100

 include/linux/netfilter/Kbuild |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 91fef0c..3aff513 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -30,7 +30,6 @@ header-y += xt_mark.h
 header-y += xt_multiport.h
 header-y += xt_owner.h
 header-y += xt_pkttype.h
-header-y += xt_policy.h
 header-y += xt_rateest.h
 header-y += xt_realm.h
 header-y += xt_sctp.h
@@ -47,3 +46,4 @@ unifdef-y += nfnetlink.h
 unifdef-y += nfnetlink_compat.h
 unifdef-y += x_tables.h
 unifdef-y += xt_physdev.h
+unifdef-y += xt_policy.h
