From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: CT: allow to set userspace helper status flag
Date: Tue, 12 Apr 2011 23:59:33 +0200
Message-ID: <20110412215933.3145.9103.stgit@decadence>
References: <20110412215458.3145.40830.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46088 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab1DLV7h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:59:37 -0400
In-Reply-To: <20110412215458.3145.40830.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is new feature and bug fix at the same time.

With this patch, the CT target allows to set the conntrack's
userspace helper status flags. This flag is used to tell the
conntrack system to explicitly allocate the helper extension.

This helper extension is useful to link the userspace expectations
with the master conntrack that is being tracked from one userspace
helper.

This feature fixes a problem in the current approach of the
userspace helper support. Basically, if the master conntrack that
has got a userspace expectation vanishes, the expectations point to
one invalid memory address. Thus, triggering an oops in the
expectation deletion event path.

I decided not to add a new revision of the CT target because
I only needed to add a new flag for it. I'll document in this
issue in the iptables manpages. I have also changed the return
value from EINVAL to EOPNOTSUPP if one flag not supported is
specified. Thus, in the future adding new features that only
require a new flag can be added without a new revision.

Reported-by: Sam Roberts <vieuxtech@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h |    4 ++++
 include/linux/netfilter/xt_CT.h               |    3 ++-
 net/netfilter/nf_conntrack_helper.c           |   12 ++++++++++++
 net/netfilter/xt_CT.c                         |    8 +++++---
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 50cdc25..6097edd 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -80,6 +80,10 @@ enum ip_conntrack_status {
 	/* Conntrack is a fake untracked entry */
 	IPS_UNTRACKED_BIT = 12,
 	IPS_UNTRACKED = (1 << IPS_UNTRACKED_BIT),
+
+	/* Conntrack has a userspace helper. */
+	IPS_USERSPACE_HELPER_BIT = 13,
+	IPS_USERSPACE_HELPER = (1 << IPS_USERSPACE_HELPER_BIT),
 };
 
 /* Connection tracking event types */
diff --git a/include/linux/netfilter/xt_CT.h b/include/linux/netfilter/xt_CT.h
index b56e768..6390f09 100644
--- a/include/linux/netfilter/xt_CT.h
+++ b/include/linux/netfilter/xt_CT.h
@@ -3,7 +3,8 @@
 
 #include <linux/types.h>
 
-#define XT_CT_NOTRACK	0x1
+#define XT_CT_NOTRACK		0x1
+#define XT_CT_USERSPACE_HELPER	0x2
 
 struct xt_ct_target_info {
 	__u16 flags;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 1bdfea3..4d90102 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -121,6 +121,18 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	int ret = 0;
 
 	if (tmpl != NULL) {
+		/* we've got a userspace helper. */
+		if (tmpl->status & IPS_USERSPACE_HELPER) {
+			help = nf_ct_helper_ext_add(ct, flags);
+			if (help == NULL) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			rcu_assign_pointer(help->helper, NULL);
+			__set_bit(IPS_USERSPACE_HELPER_BIT, &ct->status);
+			ret = 0;
+			goto out;
+		}
 		help = nfct_help(tmpl);
 		if (help != NULL)
 			helper = help->helper;
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 782e519..5f6279b 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -62,8 +62,8 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par)
 	int ret = 0;
 	u8 proto;
 
-	if (info->flags & ~XT_CT_NOTRACK)
-		return -EINVAL;
+	if (info->flags & ~(XT_CT_NOTRACK | XT_CT_USERSPACE_HELPER))
+		return -EOPNOTSUPP;
 
 	if (info->flags & XT_CT_NOTRACK) {
 		ct = nf_ct_untracked_get();
@@ -92,7 +92,9 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par)
 				  GFP_KERNEL))
 		goto err3;
 
-	if (info->helper[0]) {
+	if (info->flags & XT_CT_USERSPACE_HELPER) {
+		__set_bit(IPS_USERSPACE_HELPER_BIT, &ct->status);
+	} else if (info->helper[0]) {
 		ret = -ENOENT;
 		proto = xt_ct_find_proto(par);
 		if (!proto)

