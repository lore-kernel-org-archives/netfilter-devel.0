From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/2] nf_conntrack: use ipv6_addr_equal in nf_ct_reasm
Date: Thu, 05 Jan 2006 16:40:15 +0900 (JST)
Message-ID: <200601050740.k057eG3Y017877@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
Content-Disposition: inline; filename="02-nfct-reasm-cleanup.patch"
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

[NETFILTER] nf_conntrack: use ipv6_addr_equal in nf_ct_reasm

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 629a7391cc095248a79153f37977ce9f1071c14d
tree 752505fb5c8b30901c248ce0a651fc92b51da48b
parent 74cb8798222bb7d1aecb0acb91e6eeedf5feb948
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 25 Dec 2005 19:54:14 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 05 Jan 2006 15:25:29 +0900

 net/ipv6/netfilter/nf_conntrack_reasm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index f3e5ffb..ab3387d 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -324,8 +324,8 @@ static struct nf_ct_frag6_queue *nf_ct_f
 #ifdef CONFIG_SMP
 	for (fq = nf_ct_frag6_hash[hash]; fq; fq = fq->next) {
 		if (fq->id == fq_in->id && 
-		    !ipv6_addr_cmp(&fq_in->saddr, &fq->saddr) &&
-		    !ipv6_addr_cmp(&fq_in->daddr, &fq->daddr)) {
+		    ipv6_addr_equal(&fq_in->saddr, &fq->saddr) &&
+		    ipv6_addr_equal(&fq_in->daddr, &fq->daddr)) {
 			atomic_inc(&fq->refcnt);
 			write_unlock(&nf_ct_frag6_lock);
 			fq_in->last_in |= COMPLETE;
@@ -389,8 +389,8 @@ fq_find(u32 id, struct in6_addr *src, st
 	read_lock(&nf_ct_frag6_lock);
 	for (fq = nf_ct_frag6_hash[hash]; fq; fq = fq->next) {
 		if (fq->id == id && 
-		    !ipv6_addr_cmp(src, &fq->saddr) &&
-		    !ipv6_addr_cmp(dst, &fq->daddr)) {
+		    ipv6_addr_equal(src, &fq->saddr) &&
+		    ipv6_addr_equal(dst, &fq->daddr)) {
 			atomic_inc(&fq->refcnt);
 			read_unlock(&nf_ct_frag6_lock);
 			return fq;
