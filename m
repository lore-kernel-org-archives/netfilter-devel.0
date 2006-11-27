From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/04]: nfctnetlink: assign helper to newly created
	conntrack
Date: Mon, 27 Nov 2006 19:20:55 +0100 (MET)
Message-ID: <20061127182054.17688.538.sendpatchset@localhost.localdomain>
References: <20061127182053.17688.57354.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061127182053.17688.57354.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfctnetlink: assign helper to newly created conntrack

This fixes the bug which doesn't assign helper to newly created
conntrack via nf_conntrack_netlink.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cbf15ed58d4934fe480fc1760a5ea71d35eafcf7
tree ce0afad3be2d1944b321c5e135f3cee84281f29e
parent a07a4f6c88cef7a5cbe0950229913dd087434f88
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 27 Nov 2006 18:56:24 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 27 Nov 2006 19:10:44 +0100

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
@@ -976,9 +977,16 @@ #if defined(CONFIG_NF_CONNTRACK_MARK)
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
