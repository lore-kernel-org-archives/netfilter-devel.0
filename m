From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 09/10] nf_nat: Fixes invalid access due to reallocating
 exntesion area
Date: Tue, 26 Jun 2007 02:22:42 +0900 (JST)
Message-ID: <200706251722.l5PHMhVd004839@toshiba.co.jp>
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


ct_extend_add called in nf_conntrack_alter_reply can reallocate
extension aera and the pointer to private arae for NAT can be changed.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/ipv4/netfilter/nf_nat_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index fd10584..e370d15 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -297,7 +297,6 @@ nf_nat_setup_info(struct nf_conn *ct,
 			return NF_ACCEPT;
 		}
 	}
-	info = &nat->info;
 
 	NF_CT_ASSERT(hooknum == NF_IP_PRE_ROUTING ||
 		     hooknum == NF_IP_POST_ROUTING ||
@@ -335,6 +334,8 @@ nf_nat_setup_info(struct nf_conn *ct,
 
 		srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		write_lock_bh(&nf_nat_lock);
+		/* nf_conntrack_alter_reply might re-allocate exntension aera */
+		info = &nfct_nat(ct)->info;
 		info->ct = ct;
 		list_add(&info->bysource, &bysource[srchash]);
 		write_unlock_bh(&nf_nat_lock);
-- 
1.5.2.2
