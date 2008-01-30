From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 60/69]: nf_conntrack_sane: annotate SANE helper with const
Date: Wed, 30 Jan 2008 21:18:26 +0100 (MET)
Message-ID: <20080130201823.29874.89440.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60794 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765842AbYA3US1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:27 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sane: annotate SANE helper with const

Annotate nf_conntrack_sane variables with const qualifier and remove
a few casts.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5eb90087e67023fc3314f7a59702720e2ffe0fc4
tree d0172cc159828b536ef1aa5f41781f494f1dfa24
parent 2f3c5e5beb62ae34c4edbb59dd62c9e6c0580c8c
author Jan Engelhardt <jengelh@computergmbh.de> Wed, 30 Jan 2008 21:03:16 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:16 +0100

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
