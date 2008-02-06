From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER 2/3] xt_hashlimit: remove unneeded struct member
Date: Wed, 6 Feb 2008 14:57:23 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802061456590.23855@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802061453480.23855@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51662 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYBFN5Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:57:24 -0500
In-Reply-To: <Pine.LNX.4.64.0802061453480.23855@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 37d4e7f3a3f55274315c8a64bf9c005a0201ce3c
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Jan 29 16:30:58 2008 +0100

    [NETFILTER]: xt_hashlimit: remove unneeded struct member
    
    By allocating ->hinfo, we already have the needed indirection to cope
    with the per-cpu xtables struct match_entry.

    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
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
 
