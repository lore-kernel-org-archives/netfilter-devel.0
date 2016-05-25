From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_ct_helper: bail out on duplicated ports
Date: Wed, 25 May 2016 11:13:57 +0200
Message-ID: <1464167637-7996-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56515 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbcEYJOR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2016 05:14:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 47E71177EB1
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 11:14:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 35E6A15D632
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 11:14:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B779715D644
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 11:14:09 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Compare the helper name up to the dash, so we can catch if the user has
supplied duplicated ports via module parameters.

Reported-by: Feng Gao <gfree.wind@gmail.com>
Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_helper.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 3b40ec5..94f36f2 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -361,9 +361,10 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_log);
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
-	int ret = 0;
 	struct nf_conntrack_helper *cur;
 	unsigned int h = helper_hash(&me->tuple);
+	const char *slash;
+	int len, ret = 0;
 
 	BUG_ON(me->expect_policy == NULL);
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
@@ -371,7 +372,13 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 
 	mutex_lock(&nf_ct_helper_mutex);
 	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
-		if (strncmp(cur->name, me->name, NF_CT_HELPER_NAME_LEN) == 0 &&
+		slash = strchr(cur->name, '-');
+		if (slash)
+			len = slash - cur->name;
+		else
+			len = NF_CT_HELPER_NAME_LEN;
+
+		if (strncmp(cur->name, me->name, len) == 0 &&
 		    cur->tuple.src.l3num == me->tuple.src.l3num &&
 		    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
 			ret = -EEXIST;
-- 
2.1.4

