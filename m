From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf V3] netfilter: nf_ct_helper: permit cthelpers with different names via nfnetlink
Date: Sat, 15 Apr 2017 19:27:42 +0800
Message-ID: <1492255662-57602-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:58568 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbdDOL2T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 07:28:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

cthelpers added via nfnetlink may have the same tuple, i.e. except for
the l3proto and l4proto, other fields are all zero. So even with the
different names, we will also fail to add them:
  # nfct helper add ssdp inet udp
  # nfct helper add tftp inet udp
  nfct v1.4.3: netlink error: File exists

So in order to avoid unpredictable behaviour, we should:
1. cthelpers can be selected by nft ct helper obj or xt_CT target, so
report error if duplicated { name, l3proto, l4proto } tuple exist.
2. cthelpers can be selected by nf_ct_tuple_src_mask_cmp when
nf_ct_auto_assign_helper is enabled, so also report error if duplicated
{ l3proto, l4proto, src-port } tuple exist.

Also note, if the cthelper is added from userspace, then the src-port will
always be zero, it's invalid for nf_ct_auto_assign_helper, so there's no
need to check the second point listed above.

Fixes: 893e093c786c ("netfilter: nf_ct_helper: bail out on duplicated helpers")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 V3: no changes, rebase on nf.git and resubmit
 V2: drop to use __nf_conntrack_helper_find, per Pablo

 net/netfilter/nf_conntrack_helper.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 4eeb341..99bcd44 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -386,17 +386,33 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
 	unsigned int h = helper_hash(&me->tuple);
 	struct nf_conntrack_helper *cur;
-	int ret = 0;
+	int ret = 0, i;
 
 	BUG_ON(me->expect_policy == NULL);
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
 	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
 
 	mutex_lock(&nf_ct_helper_mutex);
-	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
-		if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple, &mask)) {
-			ret = -EEXIST;
-			goto out;
+	for (i = 0; i < nf_ct_helper_hsize; i++) {
+		hlist_for_each_entry(cur, &nf_ct_helper_hash[i], hnode) {
+			if (!strcmp(cur->name, me->name) &&
+			    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
+			     cur->tuple.src.l3num == me->tuple.src.l3num) &&
+			    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
+				ret = -EEXIST;
+				goto out;
+			}
+		}
+	}
+
+	/* avoid unpredictable behaviour for auto_assign_helper */
+	if (!(me->flags & NF_CT_HELPER_F_USERSPACE)) {
+		hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
+			if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple,
+						     &mask)) {
+				ret = -EEXIST;
+				goto out;
+			}
 		}
 	}
 	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
-- 
2.5.5


