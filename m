From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] GRE: fixup gre_keymap_lookup() return type
Date: Fri, 26 May 2006 23:07:16 +0400
Message-ID: <20060526190716.GA7266@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
To: netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

GRE keys are 16-bit wide.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv4/netfilter/ip_conntrack_proto_gre.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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

