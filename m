From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/09]: nf_nat: Clears helper private area when NATing
Date: Thu, 10 May 2007 15:41:18 +0200 (MEST)
Message-ID: <20070510134035.8559.15799.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: Clears helper private area when NATing

Some helpers (eg. ftp) assume that private area in conntrack is
filled with zero. It should be cleared when helper is changed.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 204674154410105c5b614101779698b439c2d864
tree c1d5f9835776353a1c53b7313f880ae4a6d8b2f1
parent 9655305aa47e326950ad24fc072ff19aaf5691f9
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 08 May 2007 11:06:19 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 08 May 2007 11:06:19 +0200

 net/netfilter/nf_conntrack_core.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 94000a4..e8b5c2d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -888,8 +888,13 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
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
