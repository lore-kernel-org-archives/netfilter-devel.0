From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/04]: nf_nat_proto_gre: do not modify/corrupt GREv0
	packets through NAT
Date: Thu,  3 May 2007 03:25:59 +0200 (MEST)
Message-ID: <20070503012440.12818.75627.sendpatchset@localhost.localdomain>
References: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat_proto_gre: do not modify/corrupt GREv0 packets through NAT

While porting some changes of the 2.6.21-rc7 pptp/proto_gre conntrack
and nat modules to a 2.4.32 kernel I noticed that the gre_key function
returns a wrong pointer to the GRE key of a version 0 packet thus
corrupting the packet payload.

The intended behaviour for GREv0 packets is to act like
nf_conntrack_proto_generic/nf_nat_proto_unknown so I have ripped the
offending functions (not used anymore) and modified the
nf_nat_proto_gre modules to not touch version 0 (non PPTP) packets.

Signed-off-by: Jorge Boncompte <jorge@dti2.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 08130cb0faa275f6a8290a39942e58c18cec3533
tree 01dab60a8b7759c68701292b636000bc063492d3
parent 316258f1e782f387bcd01fd81d673aaeec24b8dc
author Jorge Boncompte <jorge@dti2.net> Wed, 02 May 2007 16:17:31 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 03 May 2007 02:51:46 +0200

 include/linux/netfilter/nf_conntrack_proto_gre.h |   18 ------------------
 net/ipv4/netfilter/nf_nat_proto_gre.c            |   20 ++++++++------------
 2 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index 4e6bbce..535e421 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -87,24 +87,6 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 /* delete keymap entries */
 void nf_ct_gre_keymap_destroy(struct nf_conn *ct);
 
-/* get pointer to gre key, if present */
-static inline __be32 *gre_key(struct gre_hdr *greh)
-{
-	if (!greh->key)
-		return NULL;
-	if (greh->csum || greh->routing)
-		return (__be32 *)(greh+sizeof(*greh)+4);
-	return (__be32 *)(greh+sizeof(*greh));
-}
-
-/* get pointer ot gre csum, if present */
-static inline __sum16 *gre_csum(struct gre_hdr *greh)
-{
-	if (!greh->csum)
-		return NULL;
-	return (__sum16 *)(greh+sizeof(*greh));
-}
-
 extern void nf_ct_gre_keymap_flush(void);
 extern void nf_nat_need_gre(void);
 
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index e5a34c1..af8ba79 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -72,6 +72,11 @@ gre_unique_tuple(struct nf_conntrack_tuple *tuple,
 	__be16 *keyptr;
 	unsigned int min, i, range_size;
 
+	/* If there is no master conntrack we are not PPTP,
+	   do not change tuples */
+	if (!conntrack->master)
+		return 0;
+
 	if (maniptype == IP_NAT_MANIP_SRC)
 		keyptr = &tuple->src.u.gre.key;
 	else
@@ -122,18 +127,9 @@ gre_manip_pkt(struct sk_buff **pskb, unsigned int iphdroff,
 	if (maniptype != IP_NAT_MANIP_DST)
 		return 1;
 	switch (greh->version) {
-	case 0:
-		if (!greh->key) {
-			DEBUGP("can't nat GRE w/o key\n");
-			break;
-		}
-		if (greh->csum) {
-			/* FIXME: Never tested this code... */
-			nf_proto_csum_replace4(gre_csum(greh), *pskb,
-					       *(gre_key(greh)),
-					       tuple->dst.u.gre.key, 0);
-		}
-		*(gre_key(greh)) = tuple->dst.u.gre.key;
+	case GRE_VERSION_1701:
+		/* We do not currently NAT any GREv0 packets.
+		 * Try to behave like "nf_nat_proto_unknown" */
 		break;
 	case GRE_VERSION_PPTP:
 		DEBUGP("call_id -> 0x%04x\n", ntohs(tuple->dst.u.gre.key));
