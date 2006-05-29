From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/17]: PPTP helper: fixup gre_keymap_lookup() return
	type
Date: Tue, 30 May 2006 00:34:38 +0200 (MEST)
Message-ID: <20060529223437.24834.99611.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP helper: fixup gre_keymap_lookup() return type

GRE keys are 16-bit wide.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 52bbecd4b81c32f9c8275aede42aed6897893349
tree 514f3c51a3d6df8905455169d05d8c633920dbff
parent b82b2937b979e17f29c68496a99a68cee14ceab3
author Alexey Dobriyan <adobriyan@gmail.com> Tue, 30 May 2006 00:08:47 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:08:47 +0200

 net/ipv4/netfilter/ip_conntrack_proto_gre.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_gre.c b/net/ipv4/netfilter/ip_conntrack_proto_gre.c
index 5679479..21ee124 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_gre.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_gre.c
@@ -77,10 +77,10 @@ static inline int gre_key_cmpfn(const st
 }
 
 /* look up the source key for a given tuple */
-static u_int32_t gre_keymap_lookup(struct ip_conntrack_tuple *t)
+static __be16 gre_keymap_lookup(struct ip_conntrack_tuple *t)
 {
 	struct ip_ct_gre_keymap *km;
-	u_int32_t key = 0;
+	__be16 key = 0;
 
 	read_lock_bh(&ip_ct_gre_lock);
 	km = LIST_FIND(&gre_keymap_list, gre_key_cmpfn,
@@ -190,7 +190,7 @@ static int gre_pkt_to_tuple(const struct
 			   struct ip_conntrack_tuple *tuple)
 {
 	struct gre_hdr_pptp _pgrehdr, *pgrehdr;
-	u_int32_t srckey;
+	__be16 srckey;
 	struct gre_hdr _grehdr, *grehdr;
 
 	/* first only delinearize old RFC1701 GRE header */
