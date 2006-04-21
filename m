From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/07]: nf_conntrack: kill unused callback init_conntrack
Date: Fri, 21 Apr 2006 03:06:53 +0200 (MEST)
Message-ID: <20060421010653.8466.74858.sendpatchset@localhost.localdomain>
References: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: kill unused callback init_conntrack

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 81d5f60a185910989bc5778e3ea7ee03bda7f36d
tree 03c41d336c6528c11e024a1e42e100281cc0bd3e
parent 030e806c1db0d3a278585b83475d1a6f9a874788
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 21 Apr 2006 01:21:30 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 21 Apr 2006 01:21:30 +0200

 net/netfilter/nf_conntrack_core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e302222..f9b83f9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -178,9 +178,6 @@ static struct {
 	/* allocated slab cache + modules which uses this slab cache */
 	int use;
 
-	/* Initialization */
-	int (*init_conntrack)(struct nf_conn *, u_int32_t);
-
 } nf_ct_cache[NF_CT_F_NUM];
 
 /* protect members of nf_ct_cache except of "use" */
