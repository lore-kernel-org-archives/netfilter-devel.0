From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 06/11] xt_psd: split struct host into generic and af-dependent structure
Date: Sun, 16 Sep 2012 23:29:50 +0200
Message-ID: <1347830995-19226-7-git-send-email-fw@strlen.de>
References: <1347830995-19226-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33807 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab2IPVcn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:32:43 -0400
In-Reply-To: <1347830995-19226-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/xt_psd.c |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index e66ea56..2baec8e 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -68,7 +68,6 @@ struct port {
 struct host {
 	struct host *next;
 	unsigned long timestamp;
-	struct in_addr src_addr;
 	__be16 src_port;
 	uint16_t count;
 	uint8_t weight;
@@ -76,6 +75,19 @@ struct host {
 };
 
 /**
+ * Information we keep per ipv4 source address.
+ */
+struct host4 {
+	struct host host;
+	__be32 saddr;
+};
+
+static struct host4 *host_to_host4(const struct host *h)
+{
+	return (struct host4 *) h;
+}
+
+/**
  * State information.
  * @list:	list of source addresses
  * @hash:	pointers into the list
@@ -83,7 +95,7 @@ struct host {
  */
 static struct {
 	spinlock_t lock;
-	struct host list[LIST_SIZE];
+	struct host4 list[LIST_SIZE];
 	struct host *hash[HASH_SIZE];
 	int index;
 } state;
@@ -184,6 +196,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	u_int8_t proto;
 	unsigned long now;
 	struct host *curr, *last = NULL, **head;
+	struct host4 *curr4;
 	int hash, count = 0;
 	/* Parameters from userspace */
 	const struct xt_psd_info *psdinfo = match->matchinfo;
@@ -230,7 +243,8 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	/* Do we know this source address already? */
 	curr = *head;
 	while (curr != NULL) {
-		if (curr->src_addr.s_addr == iph->saddr)
+		curr4 = host_to_host4(curr);
+		if (curr4->saddr == iph->saddr)
 			break;
 		count++;
 		curr = host_get_next(curr, &last);
@@ -252,7 +266,8 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 		/* We know this address, but the entry is outdated. Mark it unused, and
 		 * remove from the hash table. We'll allocate a new entry instead since
 		 * this one might get re-used too soon. */
-		curr->src_addr.s_addr = 0;
+		curr4 = host_to_host4(curr);
+		curr4->saddr = 0;
 		ht_unlink(head, last);
 		last = NULL;
 	}
@@ -272,14 +287,15 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	 * hash table already because of the HASH_MAX check above). */
 
 	/* First, find it */
-	if (state.list[state.index].src_addr.s_addr != 0)
-		head = &state.hash[hashfunc(state.list[state.index].src_addr.s_addr)];
+	if (state.list[state.index].saddr != 0)
+		head = &state.hash[hashfunc(state.list[state.index].saddr)];
 	else
 		head = &last;
 	last = NULL;
 	curr = *head;
 	while (curr != NULL) {
-		if (curr == &state.list[state.index])
+		curr4 = host_to_host4(curr);
+		if (curr4 == &state.list[state.index])
 			break;
 		last = curr;
 		curr = curr->next;
@@ -294,7 +310,8 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	}
 
 	/* Get our list entry */
-	curr = &state.list[state.index++];
+	curr4 = &state.list[state.index++];
+	curr = &curr4->host;
 	if (state.index >= LIST_SIZE)
 		state.index = 0;
 
@@ -304,7 +321,8 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	*head = curr;
 
 	/* And fill in the fields */
-	curr->src_addr.s_addr = iph->saddr;
+	curr4 = host_to_host4(curr);
+	curr4->saddr = iph->saddr;
 	curr->timestamp = now;
 	curr->count = 1;
 	curr->weight = get_port_weight(psdinfo, dest_port);
-- 
1.7.8.6

