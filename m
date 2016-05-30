From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf,v2] netfilter: nf_ct_helper: bail out on duplicated helpers
Date: Mon, 30 May 2016 19:18:53 +0200
Message-ID: <1464628733-1215-1-git-send-email-pablo@netfilter.org>
Cc: gfree.wind@gmail.com, ap420073@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36519 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161249AbcE3RTL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 13:19:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C888E1B5CA5
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:19:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B9CA41B327D
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:19:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BD6391B3264
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:19:04 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't allow registration of helpers using the same tuple:

	{ l3proto, l4proto, src-port }

We lookup for the helper from the packet path using this tuple through
__nf_ct_helper_find(). Therefore, we have to avoid having two helpers
with the same tuple to ensure predictible behaviour.

Don't compare the helper string names anyway since it is valid to
register two helpers with the same name, but using different tuples.
This is also implicitly fixing up duplicated helper registration via
ports= modparam since the name comparison was defeating the tuple
duplication validation.

Reported-by: Feng Gao <gfree.wind@gmail.com>
Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_helper.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 3b40ec5..48de9be 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -361,9 +361,10 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_log);
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
-	int ret = 0;
-	struct nf_conntrack_helper *cur;
+	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
 	unsigned int h = helper_hash(&me->tuple);
+	struct nf_conntrack_helper *cur;
+	int ret = 0;
 
 	BUG_ON(me->expect_policy == NULL);
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
@@ -371,9 +372,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 
 	mutex_lock(&nf_ct_helper_mutex);
 	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
-		if (strncmp(cur->name, me->name, NF_CT_HELPER_NAME_LEN) == 0 &&
-		    cur->tuple.src.l3num == me->tuple.src.l3num &&
-		    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
+		if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple, &mask)) {
 			ret = -EEXIST;
 			goto out;
 		}
-- 
2.1.4

