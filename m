From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 4/5]: nfctnetlink: Clears helper area and handles unchanged
 helper
Date: Mon, 07 May 2007 12:01:24 +0900 (JST)
Message-ID: <200705070301.l4731OEh017262@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


This patch
- Clears private area for helper even if no helper is assigned to
  conntrack. It might be used by old helper.
- Unchanges if the same helper as the used one is specified.
- Does not find helper if no helper is specified. And it does not
  require private area for helper in that case.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/netfilter/nf_conntrack_netlink.c |   40 ++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index aa1a97e..d6d39e2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -830,11 +830,6 @@ ctnetlink_change_helper(struct nf_conn *
 	char *helpname;
 	int err;
 
-	if (!help) {
-		/* FIXME: we need to reallocate and rehash */
-		return -EBUSY;
-	}
-
 	/* don't change helper of sibling connections */
 	if (ct->master)
 		return -EINVAL;
@@ -843,25 +838,34 @@ ctnetlink_change_helper(struct nf_conn *
 	if (err < 0)
 		return err;
 
-	helper = __nf_conntrack_helper_find_byname(helpname);
-	if (!helper) {
-		if (!strcmp(helpname, ""))
-			helper = NULL;
-		else
-			return -EINVAL;
-	}
-
-	if (help->helper) {
-		if (!helper) {
+	if (!strcmp(helpname, "")) {
+		if (help && help->helper) {
 			/* we had a helper before ... */
 			nf_ct_remove_expectations(ct);
 			help->helper = NULL;
-		} else {
-			/* need to zero data of old helper */
-			memset(&help->help, 0, sizeof(help->help));
 		}
+
+		return 0;
 	}
 
+	if (!help) {
+		/* FIXME: we need to reallocate and rehash */
+		return -EBUSY;
+	}
+
+	helper = __nf_conntrack_helper_find_byname(helpname);
+	if (helper == NULL)
+		return -EINVAL;
+
+	if (help->helper == helper)
+		return 0;
+
+	if (help->helper)
+		/* we had a helper before ... */
+		nf_ct_remove_expectations(ct);
+
+	/* need to zero data of old helper */
+	memset(&help->help, 0, sizeof(help->help));
 	help->helper = helper;
 
 	return 0;
-- 
1.4.4
