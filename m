From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/09]: nf_conntrack: Removes duplicated declarations
Date: Thu, 10 May 2007 15:41:14 +0200 (MEST)
Message-ID: <20070510134031.8559.74950.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: Removes duplicated declarations

These are also in include/net/netfilter/nf_conntrack_helper.h

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit aeca1c226efa93ec47d21303d907d7ab18c30f0e
tree f35fccc4722bc6fe48e574e2c2596723bb01b673
parent f1103257fddbe3a55b4ae964741cefb5026c20ec
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 08 May 2007 11:06:18 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 08 May 2007 11:06:18 +0200

 include/net/netfilter/nf_conntrack.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 1c6b8bd..4732432 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -183,13 +183,6 @@ extern void nf_conntrack_hash_insert(struct nf_conn *ct);
 
 extern void nf_conntrack_flush(void);
 
-extern struct nf_conntrack_helper *
-nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple);
-extern void nf_ct_helper_put(struct nf_conntrack_helper *helper);
-
-extern struct nf_conntrack_helper *
-__nf_conntrack_helper_find_byname(const char *name);
-
 extern int nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
 				const struct nf_conntrack_tuple *orig);
 
