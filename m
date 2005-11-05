From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 2/2] nf_conntrack: free layer-3 specific protocol tables at
	cleanup
Date: Sat, 5 Nov 2005 12:55:08 +0100
Message-ID: <200511051255.08714@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_c2JbD4pZroOxnzS"
Cc: Harald Welte <laforge@netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_c2JbD4pZroOxnzS
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  nfsim complained about memory leaks caused by not kfree()-ing the 
layer3-specific protocol tables when nf_conntrack is removed. The 
attached patch tries to add the missing kfree() calls.

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_c2JbD4pZroOxnzS
Content-Type: text/x-diff; charset="us-ascii";
	name="03-nf_conntrack-free_layer3_proto_tables.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="03-nf_conntrack-free_layer3_proto_tables.patch"

[NETFILTER] Free layer-3 specific protocol tables at cleanup

Although the comment around the allocation code tells us that
the layer-3 specific protocol tables will be freed when cleaning up,
they aren't. And this makes nfsim complain loudly...

Signed-off-by: KOVACS Krisztian <hidden@balabit.hu>

---
commit e7f59b326ea02ed98dfbacd06ed8932efe4e0de3
tree ab6704864b46f9d7e94431495165cfefba1b9316
parent 43659ba2b9e9f9871bb8cad6769c693a3fc629af
author KOVACS Krisztian <hidden@balabit.hu> Fri, 04 Nov 2005 11:37:25 +0100
committer KOVACS Krisztian <hidden@balabit.hu> Fri, 04 Nov 2005 11:37:25 +0100

 net/netfilter/nf_conntrack_core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9a67c79..ea094b2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1395,6 +1395,13 @@ void nf_conntrack_cleanup(void)
 	kmem_cache_destroy(nf_conntrack_expect_cachep);
 	free_conntrack_hash(nf_conntrack_hash, nf_conntrack_vmalloc,
 			    nf_conntrack_htable_size);
+
+	/* free l3proto protocol tables */
+	for (i = 0; i < PF_MAX; i++)
+		if (nf_ct_protos[i]) {
+			kfree(nf_ct_protos[i]);
+			nf_ct_protos[i] = NULL;
+		}
 }
 
 static struct list_head *alloc_hashtable(int size, int *vmalloced)

--Boundary-00=_c2JbD4pZroOxnzS--
