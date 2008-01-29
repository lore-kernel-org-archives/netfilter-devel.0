From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER]: xt_hashlimit: remove unneeded struct member
Date: Tue, 29 Jan 2008 19:03:50 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291636390.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42783 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbYA2SDv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:03:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 9cd6d44dfc02166640166a44c27c3dc0a98b4ac3
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Jan 29 16:30:58 2008 +0100

    [NETFILTER]: xt_hashlimit: remove unneeded struct member
    
    By allocating ->hinfo, we already have the needed indirection to cope
    with the per-cpu xtables struct match_entry.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

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
index 71572f9..d685ec4 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -772,9 +772,6 @@ hashlimit_mt_check(const char *tablename, const void *inf,
 		return false;
 	}
 	mutex_unlock(&hlimit_mutex);
-
-	/* Ugly hack: For SMP, we only want to use one set */
-	info->master = info;
 	return true;
 }
 

