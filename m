From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/2]: nfctnetlink: assign helper to newly created conntrack
Date: Fri, 24 Nov 2006 02:17:44 +0900 (JST)
Message-ID: <200611231717.kANHHkHt002612@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net, kadlec@blackhole.kfki.hu, pablo@netfilter.org
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


This fixes the bug which doesn't assign helper to newly created
conntrack via nf_conntrack_netlink.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit b34563e3485e5fdd3c386130fec8189837dff34d
tree ec87de26f96b1747bb6826b62b0c794d04af34c0
parent 66c669baa7d70b8d135da67f36c8dba12cea71b8
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 24 Nov 2006 00:57:41 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 24 Nov 2006 00:57:41 +0900

 net/netfilter/nf_conntrack_netlink.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bd0156a..77a46ee 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -949,6 +949,7 @@ ctnetlink_create_conntrack(struct nfattr
 {
 	struct nf_conn *ct;
 	int err = -EINVAL;
+	struct nf_conn_help *help;
 
 	ct = nf_conntrack_alloc(otuple, rtuple);
 	if (ct == NULL || IS_ERR(ct))
@@ -976,9 +977,16 @@ ctnetlink_create_conntrack(struct nfattr
 		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
 
+	help = nfct_help(ct);
+	if (help)
+		help->helper = nf_ct_helper_find_get(rtuple);
+
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
 
+	if (help && help->helper)
+		nf_ct_helper_put(help->helper);
+
 	return 0;
 
 err:	
