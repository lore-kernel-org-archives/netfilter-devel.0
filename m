From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/18]: Decrease number of pointer derefs in
	nf_conntrack_core.c
Date: Thu,  5 Jan 2006 05:06:32 +0100 (MET)
Message-ID: <20060105040556.23512.44215.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Decrease number of pointer derefs in nf_conntrack_core.c

Benefits of the patch:
 - Fewer pointer dereferences should make the code slightly faster.
 - Size of generated code is smaller
 - improved readability

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2cc96aa2efb6f3950c9a506eed4c7cab5d8de076
tree 6c418e18f4d385a8340381cd67cf82c62961fd24
parent d0fc264ffbc6c3886020dc2ef60d4aa1cecec51c
author Jesper Juhl <jesper.juhl@gmail.com> Thu, 05 Jan 2006 02:51:54 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:51:54 +0100

 net/netfilter/nf_conntrack_core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a7c7b49..0c5b01d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1129,6 +1129,7 @@ static inline int refresh_timer(struct n
 int nf_conntrack_expect_related(struct nf_conntrack_expect *expect)
 {
 	struct nf_conntrack_expect *i;
+	struct nf_conn *master = expect->master;
 	int ret;
 
 	DEBUGP("nf_conntrack_expect_related %p\n", related_to);
@@ -1149,9 +1150,9 @@ int nf_conntrack_expect_related(struct n
 		}
 	}
 	/* Will be over limit? */
-	if (expect->master->helper->max_expected && 
-	    expect->master->expecting >= expect->master->helper->max_expected)
-		evict_oldest_expect(expect->master);
+	if (master->helper->max_expected && 
+	    master->expecting >= master->helper->max_expected)
+		evict_oldest_expect(master);
 
 	nf_conntrack_expect_insert(expect);
 	nf_conntrack_expect_event(IPEXP_NEW, expect);
