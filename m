From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/05]: nf_nat: use tcp_sack_block_wire
Date: Fri,  3 Nov 2006 17:46:28 +0100 (MET)
Message-ID: <20061103164840.15103.33513.sendpatchset@localhost.localdomain>
References: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
In-Reply-To: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: use tcp_sack_block_wire

Sync with commit 269bd27e66037a7932cee6d6aa7ef7defd0bfe38:

[TCP]: struct tcp_sack_block annotations

Some of the instances of tcp_sack_block are host-endian, some - net-endian.
Define struct tcp_sack_block_wire identical to struct tcp_sack_block
with u32 replaced with __be32; annotate uses of tcp_sack_block replacing
net-endian ones with tcp_sack_block_wire.  Change is obviously safe since
for cc(1) __be32 is typedefed to u32.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ce071a4e6fcee746b64936ac5c02317cbafdc4ab
tree dfe3fa259ef970d558a6f1a2d7bd0548f0a3140c
parent b4b1bd0185d4054accbd925298f21b4d9eddfeec
author Patrick McHardy <kaber@trash.net> Fri, 03 Nov 2006 17:27:33 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Nov 2006 17:27:33 +0100

 net/ipv4/netfilter/nf_nat_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index ccc39e6..94aa972 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -289,7 +289,7 @@ sack_adjust(struct sk_buff *skb,
 	    struct nf_nat_seq *natseq)
 {
 	while (sackoff < sackend) {
-		struct tcp_sack_block *sack;
+		struct tcp_sack_block_wire *sack;
 		u_int32_t new_start_seq, new_end_seq;
 
 		sack = (void *)skb->data + sackoff;
