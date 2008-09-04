From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 01/04]: netfilter: nf_conntrack_sip: de-static helper pointers
Date: Thu,  4 Sep 2008 16:15:54 +0200 (MEST)
Message-ID: <20080904141554.6414.14525.sendpatchset@x2.localnet>
References: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62491 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYIDOP4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:15:56 -0400
In-Reply-To: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit db38a4d83523e816a26a33eef5f7e98262699c90
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Thu Sep 4 14:22:05 2008 +0200

    netfilter: nf_conntrack_sip: de-static helper pointers
    
    Helper's ->help hook can run concurrently with itself, so iterating over
    SIP helpers with static pointer won't work reliably.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 2f9bbc0..1fa306b 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1193,7 +1193,6 @@ static const struct sip_handler sip_handlers[] = {
 static int process_sip_response(struct sk_buff *skb,
 				const char **dptr, unsigned int *datalen)
 {
-	static const struct sip_handler *handler;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	unsigned int matchoff, matchlen;
@@ -1214,6 +1213,8 @@ static int process_sip_response(struct sk_buff *skb,
 	dataoff = matchoff + matchlen + 1;
 
 	for (i = 0; i < ARRAY_SIZE(sip_handlers); i++) {
+		const struct sip_handler *handler;
+
 		handler = &sip_handlers[i];
 		if (handler->response == NULL)
 			continue;
@@ -1228,13 +1229,14 @@ static int process_sip_response(struct sk_buff *skb,
 static int process_sip_request(struct sk_buff *skb,
 			       const char **dptr, unsigned int *datalen)
 {
-	static const struct sip_handler *handler;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	unsigned int matchoff, matchlen;
 	unsigned int cseq, i;
 
 	for (i = 0; i < ARRAY_SIZE(sip_handlers); i++) {
+		const struct sip_handler *handler;
+
 		handler = &sip_handlers[i];
 		if (handler->request == NULL)
 			continue;
