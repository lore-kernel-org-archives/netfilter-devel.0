From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/13]: nf_conntrack: use ipv6_addr_equal in nf_ct_reasm
Date: Thu, 16 Feb 2006 22:32:10 +0100 (MET)
Message-ID: <20060216213210.6933.41446.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: use ipv6_addr_equal in nf_ct_reasm

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a99f01294a6531c0511ff84bc735e92e12e88c99
tree e0f40422971b69fa0780368c27934f557d12d820
parent d4f037506a5832b329930b927309e911fd42ee4d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 16 Feb 2006 14:17:00 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:00 +0100

 net/ipv6/netfilter/nf_conntrack_reasm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 84ef9a1..3e31903 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -313,8 +313,8 @@ static struct nf_ct_frag6_queue *nf_ct_f
 #ifdef CONFIG_SMP
 	hlist_for_each_entry(fq, n, &nf_ct_frag6_hash[hash], list) {
 		if (fq->id == fq_in->id && 
-		    !ipv6_addr_cmp(&fq_in->saddr, &fq->saddr) &&
-		    !ipv6_addr_cmp(&fq_in->daddr, &fq->daddr)) {
+		    ipv6_addr_equal(&fq_in->saddr, &fq->saddr) &&
+		    ipv6_addr_equal(&fq_in->daddr, &fq->daddr)) {
 			atomic_inc(&fq->refcnt);
 			write_unlock(&nf_ct_frag6_lock);
 			fq_in->last_in |= COMPLETE;
@@ -376,8 +376,8 @@ fq_find(u32 id, struct in6_addr *src, st
 	read_lock(&nf_ct_frag6_lock);
 	hlist_for_each_entry(fq, n, &nf_ct_frag6_hash[hash], list) {
 		if (fq->id == id && 
-		    !ipv6_addr_cmp(src, &fq->saddr) &&
-		    !ipv6_addr_cmp(dst, &fq->daddr)) {
+		    ipv6_addr_equal(src, &fq->saddr) &&
+		    ipv6_addr_equal(dst, &fq->daddr)) {
 			atomic_inc(&fq->refcnt);
 			read_unlock(&nf_ct_frag6_lock);
 			return fq;
