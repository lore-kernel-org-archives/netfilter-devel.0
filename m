From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/07]: xt_hashlimit: remove unneeded struct member
Date: Tue, 19 Feb 2008 17:25:51 +0100 (MET)
Message-ID: <20080219162538.13631.71043.sendpatchset@localhost.localdomain>
References: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50473 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYBSQZw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:25:52 -0500
In-Reply-To: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_hashlimit: remove unneeded struct member

By allocating ->hinfo, we already have the needed indirection to cope
with the per-cpu xtables struct match_entry.

[Patrick: do this now before the revision 1 struct is used by userspace]

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4e2e7aba6471fcd945a3f8fdc40d5cf11e7039b3
tree fee4fdd8dfbf77ac747e89a316b591fab09bf884
parent 0776e52cdb04aad5b59c4e12dc16e7b58737c2d2
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 19 Feb 2008 17:15:28 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 19 Feb 2008 17:15:28 +0100

 include/linux/netfilter/xt_hashlimit.h |    1 -
 net/netfilter/xt_hashlimit.c           |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
index 58b818e..51b18d8 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -61,7 +61,6 @@ struct xt_hashlimit_mtinfo1 {
 
 	/* Used internally by the kernel */
 	struct xt_hashlimit_htable *hinfo __attribute__((aligned(8)));
-	struct xt_hashlimit_mtinfo1 *master __attribute__((aligned(8)));
 };
 
 #endif /*_XT_HASHLIMIT_H*/
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 744c7f2..5418ce5 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -774,9 +774,6 @@ hashlimit_mt_check(const char *tablename, const void *inf,
 		return false;
 	}
 	mutex_unlock(&hlimit_mutex);
-
-	/* Ugly hack: For SMP, we only want to use one set */
-	info->master = info;
 	return true;
 }
 
