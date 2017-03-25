From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_ct_helper: permit cthelpers with different names via nfnetlink
Date: Sat, 25 Mar 2017 21:03:23 +0800
Message-ID: <1490447003-18592-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:52032 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750903AbdCYNEB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Mar 2017 09:04:01 -0400
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
 net/netfilter/nf_conntrack_helper.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6dc44d9..a28ecfa 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -386,10 +386,20 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
 
 	mutex_lock(&nf_ct_helper_mutex);
-	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
-		if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple, &mask)) {
-			ret = -EEXIST;
-			goto out;
+	if (__nf_conntrack_helper_find(me->name, me->tuple.src.l3num,
+				       me->tuple.dst.protonum)) {
+		ret = -EEXIST;
+		goto out;
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


