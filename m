From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/04]: nf_conntrack: fix the race on assign helper to
	new conntrack
Date: Mon, 27 Nov 2006 19:20:56 +0100 (MET)
Message-ID: <20061127182056.17688.99624.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: fix the race on assign helper to new conntrack

The found helper cannot be assigned to conntrack after unlocking
nf_conntrack_lock. This tries to find helper to assign again.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a88ad2f562c2c108f76adfda4d5ee954e09e6d98
tree c0b7259465e28021e6c7a2c3892e742876f45bbf
parent cbf15ed58d4934fe480fc1760a5ea71d35eafcf7
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Mon, 27 Nov 2006 18:56:25 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 27 Nov 2006 19:10:44 +0100

 net/netfilter/nf_conntrack_core.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 836541e..0f58307 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -893,12 +893,6 @@ __nf_conntrack_alloc(const struct nf_con
 
 	memset(conntrack, 0, nf_ct_cache[features].size);
 	conntrack->features = features;
-	if (helper) {
-		struct nf_conn_help *help = nfct_help(conntrack);
-		NF_CT_ASSERT(help);
-		help->helper = helper;
-	}
-
 	atomic_set(&conntrack->ct_general.use, 1);
 	conntrack->ct_general.destroy = destroy_conntrack;
 	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
@@ -982,8 +976,13 @@ #ifdef CONFIG_NF_CONNTRACK_SECMARK
 #endif
 		nf_conntrack_get(&conntrack->master->ct_general);
 		NF_CT_STAT_INC(expect_new);
-	} else
+	} else {
+		struct nf_conn_help *help = nfct_help(conntrack);
+
+		if (help)
+			help->helper = __nf_ct_helper_find(&repl_tuple);
 		NF_CT_STAT_INC(new);
+	}
 
 	/* Overload tuple linked list to put us in unconfirmed list. */
 	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
