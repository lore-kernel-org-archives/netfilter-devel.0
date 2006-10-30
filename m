From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/05]: nf_conntrack: add missing unlock in
	get_next_corpse()
Date: Mon, 30 Oct 2006 19:19:01 +0100 (MET)
Message-ID: <20061030181859.32038.61354.sendpatchset@localhost.localdomain>
References: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: add missing unlock in get_next_corpse()

Add missing unlock in get_next_corpse() in nf_conntrack. It was missed
during the removal of listhelp.h . Also remove an unneeded use of
nf_ct_tuplehash_to_ctrack() in the same function.

Should be applied before 2.6.19 is released.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4de9f9e71c273a4f53f82c5dd3e48f25cb3893f9
tree 7ec3e2872f3820ed76117ea463adab561d9645b9
parent 2e3d7fd325d9327881f17aec50619caaf1aeab00
author Martin Josefsson <gandalf@wlug.westbo.se> Mon, 30 Oct 2006 16:31:19 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 30 Oct 2006 16:31:19 +0100

 net/netfilter/nf_conntrack_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 093b3dd..836541e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1520,9 +1520,10 @@ get_next_corpse(int (*iter)(struct nf_co
 		if (iter(ct, data))
 			goto found;
 	}
+	write_unlock_bh(&nf_conntrack_lock);
 	return NULL;
 found:
-	atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
+	atomic_inc(&ct->ct_general.use);
 	write_unlock_bh(&nf_conntrack_lock);
 	return ct;
 }
