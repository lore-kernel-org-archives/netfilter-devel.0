From: pablo@netfilter.org
Subject: [PATCH] netfilter: xt_osf: fix inversion
Date: Sun, 24 Mar 2013 11:34:13 +0100
Message-ID: <1364121253-7081-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38320 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab3CXKeZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Mar 2013 06:34:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

-m osf --genre Windows
-m osf ! --genre Windows

are both matching.

Reported-by: Reported-by: Bourne Without <blackhole@airpost.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_osf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index a5e673d..110c848 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -201,6 +201,7 @@ xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 	unsigned char opts[MAX_IPOPTLEN];
 	const struct xt_osf_finger *kf;
 	const struct xt_osf_user_finger *f;
+	bool invert = info->flags & XT_OSF_INVERT;
 
 	if (!info)
 		return false;
@@ -349,7 +350,7 @@ xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 	if (fcount)
 		fmatch = FMATCH_OK;
 
-	return fmatch == FMATCH_OK;
+	return (fmatch == FMATCH_OK) ^ invert;
 }
 
 static struct xt_match xt_osf_match = {
-- 
1.7.10.4

