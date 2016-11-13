From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 38/39] netfilter: conntrack: remove unused netns_ct member
Date: Sun, 13 Nov 2016 23:25:32 +0100
Message-ID: <1479075933-4491-39-git-send-email-pablo@netfilter.org>
References: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47834 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965290AbcKMW0c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Nov 2016 17:26:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4DC93C1060
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D934DA801
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58472DA841
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:29 +0100 (CET)
In-Reply-To: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

since 23014011ba420 ('netfilter: conntrack: support a fixed size of 128 distinct labels')
this isn't needed anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4

