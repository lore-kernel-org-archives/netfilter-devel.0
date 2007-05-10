From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/09]: ctnetlink: clear helper area and handle
	unchanged helper
Date: Thu, 10 May 2007 15:41:16 +0200 (MEST)
Message-ID: <20070510134034.8559.94686.sendpatchset@localhost.localdomain>
References: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: clear helper area and handle unchanged helper

This patch
- Clears private area for helper even if no helper is assigned to
  conntrack. It might be used by old helper.
- Unchanges if the same helper as the used one is specified.
- Does not find helper if no helper is specified. And it does not
  require private area for helper in that case.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9655305aa47e326950ad24fc072ff19aaf5691f9
tree f8c4bc7c4772b99427327af7bf93007f82e8c69f
parent f1ab39bebc088ba296db8e047b21700b4a77d51c
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 08 May 2007 11:06:18 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 08 May 2007 11:06:18 +0200

 net/netfilter/nf_conntrack_netlink.c |   40 +++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index aa1a97e..d6d39e2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -830,11 +830,6 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
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
@@ -843,25 +838,34 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
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
