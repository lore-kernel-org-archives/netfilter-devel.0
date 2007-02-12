From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/22]: Remove unnecessary synchronize_net() in
	nf_register_hook
Date: Mon, 12 Feb 2007 11:36:24 +0100 (MET)
Message-ID: <20070212103623.661.32740.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Remove unnecessary synchronize_net() in nf_register_hook

We're only adding to the list, no need to synchronize.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4e6bba5661fe72e2c570701be4fcf4f2fabfdff2
tree 12e74ddf2a81a31aa4b5d59ba39c6fd0b14d7f5d
parent aa70e344f883b6fb4283024afa9af13376162ed3
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:35:30 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 10:35:30 +0100

 net/netfilter/core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index ad24d0c..a66bd6a 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -69,8 +69,6 @@ int nf_register_hook(struct nf_hook_ops 
 	}
 	list_add_rcu(&reg->list, i->prev);
 	spin_unlock_bh(&nf_hook_lock);
-
-	synchronize_net();
 	return 0;
 }
 EXPORT_SYMBOL(nf_register_hook);
