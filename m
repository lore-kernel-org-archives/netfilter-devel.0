From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 05/10] [NETFILTER]: annotate nf_conntrack_sane with const
Date: Sat, 26 Jan 2008 02:37:33 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801260237280.15243@fbirervta.pbzchgretzou.qr>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48218 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbYAZBhe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:37:34 -0500
In-Reply-To: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Annotate nf_conntrack_sane variables with const qualifier and remove
a few casts.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/netfilter/nf_conntrack_sane.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index b5a16c6..a70051d 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -62,8 +62,9 @@ static int help(struct sk_buff *skb,
 		enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff, datalen;
-	struct tcphdr _tcph, *th;
-	char *sb_ptr;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
+	void *sb_ptr;
 	int ret = NF_ACCEPT;
 	int dir = CTINFO2DIR(ctinfo);
 	struct nf_ct_sane_master *ct_sane_info;
@@ -99,7 +100,7 @@ static int help(struct sk_buff *skb,
 		if (datalen != sizeof(struct sane_request))
 			goto out;
 
-		req = (struct sane_request *)sb_ptr;
+		req = sb_ptr;
 		if (req->RPC_code != htonl(SANE_NET_START)) {
 			/* Not an interesting command */
 			ct_sane_info->state = SANE_STATE_NORMAL;
@@ -123,7 +124,7 @@ static int help(struct sk_buff *skb,
 		goto out;
 	}
 
-	reply = (struct sane_reply_net_start *)sb_ptr;
+	reply = sb_ptr;
 	if (reply->status != htonl(SANE_STATUS_SUCCESS)) {
 		/* saned refused the command */
 		pr_debug("nf_ct_sane: unsuccessful SANE_STATUS = %u\n",
-- 
1.5.3.4

