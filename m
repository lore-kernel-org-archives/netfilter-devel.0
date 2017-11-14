From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf-next] netfilter: nf_defrag_ipv4: Skip defrag if NOTRACK is set
Date: Mon, 13 Nov 2017 18:37:26 -0700
Message-ID: <1510623446-9115-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48650 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdKNBhs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 20:37:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

conntrack defrag is needed only if some module like CONNTRACK or NAT
explicitly requests it. For plain forwarding scenarios, defrag is
not needed and can be skipped if NOTRACK is set in a rule.

Since conntrack defrag is currently higher priority than raw table,
setting NOTRACK is not sufficient. We need to introduce a lower
priority rule and deprecate the existing rule.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 include/uapi/linux/netfilter_ipv4.h | 3 ++-
 net/ipv4/netfilter/nf_defrag_ipv4.c | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv4.h b/include/uapi/linux/netfilter_ipv4.h
index e6b1a84..cedf7b4 100644
--- a/include/uapi/linux/netfilter_ipv4.h
+++ b/include/uapi/linux/netfilter_ipv4.h
@@ -57,9 +57,10 @@
 
 enum nf_ip_hook_priorities {
 	NF_IP_PRI_FIRST = INT_MIN,
-	NF_IP_PRI_CONNTRACK_DEFRAG = -400,
+	NF_IP_PRI_CONNTRACK_DEFRAG = -400, /* deprecated */
 	NF_IP_PRI_RAW = -300,
 	NF_IP_PRI_SELINUX_FIRST = -225,
+	NF_IP_PRI_CONNTRACK_DEFRAG_V1 = -210,
 	NF_IP_PRI_CONNTRACK = -200,
 	NF_IP_PRI_MANGLE = -150,
 	NF_IP_PRI_NAT_DST = -100,
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 37fe1616..6496890 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -80,7 +80,7 @@ static unsigned int ipv4_conntrack_defrag(void *priv,
 #endif
 #endif
 	/* Gather fragments. */
-	if (ip_is_fragment(ip_hdr(skb))) {
+	if (skb->_nfct != IP_CT_UNTRACKED && ip_is_fragment(ip_hdr(skb))) {
 		enum ip_defrag_users user =
 			nf_ct_defrag_user(state->hook, skb);
 
@@ -95,13 +95,13 @@ static unsigned int ipv4_conntrack_defrag(void *priv,
 		.hook		= ipv4_conntrack_defrag,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
-		.priority	= NF_IP_PRI_CONNTRACK_DEFRAG,
+		.priority	= NF_IP_PRI_CONNTRACK_DEFRAG_V1,
 	},
 	{
 		.hook           = ipv4_conntrack_defrag,
 		.pf             = NFPROTO_IPV4,
 		.hooknum        = NF_INET_LOCAL_OUT,
-		.priority       = NF_IP_PRI_CONNTRACK_DEFRAG,
+		.priority       = NF_IP_PRI_CONNTRACK_DEFRAG_V1,
 	},
 };
 
-- 
1.9.1

