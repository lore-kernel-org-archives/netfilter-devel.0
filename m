From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ipset-5: 2/9] Listing for hash types fixed
Date: Tue,  2 Nov 2010 15:35:27 +0100
Message-ID: <1288708534-14510-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1288708534-14510-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.0.4"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:33595 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab0KBOfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:35:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 2EDC91F4145
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oJXVf7XTEmZk for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id 039F31F4140
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:34 +0100 (CET)
In-Reply-To: <1288708534-14510-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1.7.0.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


The listing was incorrect for large sets, when multiple messages were
required. I assume that one full hash bucket fills into one message,
but that is true for all current hash types.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 kernel/include/linux/netfilter/ip_set_chash.h |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)


--------------1.7.0.4
Content-Type: text/x-patch; name="0002-Listing-for-hash-types-fixed.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0002-Listing-for-hash-types-fixed.patch"

diff --git a/kernel/include/linux/netfilter/ip_set_chash.h b/kernel/include/linux/netfilter/ip_set_chash.h
index 6fd1d32..9a1e26c 100644
--- a/kernel/include/linux/netfilter/ip_set_chash.h
+++ b/kernel/include/linux/netfilter/ip_set_chash.h
@@ -567,6 +567,8 @@ type_pf_list(struct ip_set *set,
 	struct slist *n;
 	const struct type_pf_elem *data;
 	u32 first = cb->args[2];
+	/* We assume that one hash bucket fills into one page */
+	void *incomplete;
 	int i;
 
 	atd = ipset_nest_start(skb, IPSET_ATTR_ADT);
@@ -574,6 +576,7 @@ type_pf_list(struct ip_set *set,
 		return -EFAULT;
 	pr_debug("list hash set %s", set->name);
 	for (; cb->args[2] < jhash_size(h->htable_bits); cb->args[2]++) {
+		incomplete = skb_tail_pointer(skb);
 		slist_for_each(n, &h->htable[cb->args[2]]) {
 			for (i = 0; i < h->array_size; i++) {
 				data = chash_data(n, i);
@@ -602,8 +605,13 @@ type_pf_list(struct ip_set *set,
 	return 0;
 
 nla_put_failure:
-	nla_nest_cancel(skb, nested);
+	nlmsg_trim(skb, incomplete);
 	ipset_nest_end(skb, atd);
+	if (unlikely(first == cb->args[2])) {
+		pr_warn("Can't list set %s: one bucket does not fit into "
+			"a message. Please report it!\n", set->name);
+		cb->args[2] = 0;
+	}
 	return 0;
 }
 
@@ -993,12 +1001,15 @@ type_pf_tlist(struct ip_set *set,
 	struct slist *n;
 	const struct type_pf_elem *data;
 	u32 first = cb->args[2];
+	/* We assume that one hash bucket fills into one page */
+	void *incomplete;
 	int i;
 
 	atd = ipset_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
 		return -EFAULT;
 	for (; cb->args[2] < jhash_size(h->htable_bits); cb->args[2]++) {
+		incomplete = skb_tail_pointer(skb);
 		slist_for_each(n, &h->htable[cb->args[2]]) {
 			for (i = 0; i < h->array_size; i++) {
 				data = chash_tdata(n, i);
@@ -1029,8 +1040,13 @@ type_pf_tlist(struct ip_set *set,
 	return 0;
 
 nla_put_failure:
-	nla_nest_cancel(skb, nested);
+	nlmsg_trim(skb, incomplete);
 	ipset_nest_end(skb, atd);
+	if (unlikely(first == cb->args[2])) {
+		pr_warn("Can't list set %s: one bucket does not fit into "
+			"a message. Please report it!\n", set->name);
+		cb->args[2] = 0;
+	}
 	return 0;
 }
 

--------------1.7.0.4--


