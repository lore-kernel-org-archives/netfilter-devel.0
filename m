From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: remove unused netns_ct member
Date: Thu, 10 Nov 2016 14:17:01 +0100
Message-ID: <1478783821-15979-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51464 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932336AbcKJNQo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 08:16:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

since 23014011ba420 ('netfilter: conntrack: support a fixed size of 128 distinct labels')
this isn't needed anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netns/conntrack.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index e469e85de3f9..3d06d94d2e52 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -91,7 +91,6 @@ struct netns_ct {
 	struct nf_ip_net	nf_ct_proto;
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
 	unsigned int		labels_used;
-	u8			label_words;
 #endif
 };
 #endif
-- 
2.7.3

