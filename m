From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfilter: avoid additional compare.
Date: Thu, 05 Nov 2009 11:10:10 +0800
Message-ID: <4AF24212.6050809@gmail.com>
Reply-To: xiaosuo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52354 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZKEDJ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 22:09:57 -0500
Received: by yxe17 with SMTP id 17so6958827yxe.33
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Nov 2009 19:10:02 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

avoid additional compare.

avoid additional compare.

signed-off-by: Changli Gao <xiaosuo@gmail.com>
----

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ca6e68d..b917d6a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -512,11 +512,17 @@ static noinline int early_drop(struct net *net, unsigned int hash)
 			cnt++;
 		}
 
-		if (ct && unlikely(nf_ct_is_dying(ct) ||
-				   !atomic_inc_not_zero(&ct->ct_general.use)))
-			ct = NULL;
-		if (ct || cnt >= NF_CT_EVICTION_RANGE)
+		if (ct != NULL) {
+			if (likely(!nf_ct_is_dying(ct) &&
+				   atomic_inc_not_zero(&ct->ct_general.use)))
+				break;
+			else
+				ct = NULL;
+		}
+
+		if (cnt >= NF_CT_EVICTION_RANGE)
 			break;
+
 		hash = (hash + 1) % nf_conntrack_htable_size;
 	}
 	rcu_read_unlock();


