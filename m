From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/2] nf_conntrack: kill unused callback init_conntrack
Date: Thu, 13 Apr 2006 21:01:47 +0900 (JST)
Message-ID: <200604131201.k3DC1m4I028628@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
Content-Disposition: inline; filename="02-kill-unused-init.patch"
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

[NETFILTER] nf_conntrack: kill unused callback init_conntrack

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit f1564c6e1adcdc14d7e1ab29bafcb9938dc505ea
tree bfb20cb9067537f117785eff788f806d0c3da0a0
parent 783e57517c558ae41171d71496035c08f2e9613c
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Apr 2006 19:00:12 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 13 Apr 2006 15:05:26 +0900

 net/netfilter/nf_conntrack_core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9a2410d..cb423c3 100644
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
