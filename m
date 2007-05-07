From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 5/5]: nf_nat: Clears helper private area when NATing
Date: Mon, 07 May 2007 12:01:35 +0900 (JST)
Message-ID: <200705070301.l4731ZdH017501@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
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


Some helpers (eg. ftp) assume that private area in conntrack is
filled with zero. It should be cleared when helper is changed.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/netfilter/nf_conntrack_core.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 94000a4..e8b5c2d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -888,8 +888,13 @@ void nf_conntrack_alter_reply(struct nf_
 	NF_CT_DUMP_TUPLE(newreply);
 
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (!ct->master && help && help->expecting == 0)
-		help->helper = __nf_ct_helper_find(newreply);
+	if (!ct->master && help && help->expecting == 0) {
+		struct nf_conntrack_helper *helper;
+		helper = __nf_ct_helper_find(newreply);
+		if (helper)
+			memset(&help->help, 0, sizeof(help->help));
+		help->helper = helper;
+	}
 	write_unlock_bh(&nf_conntrack_lock);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
-- 
1.4.4
