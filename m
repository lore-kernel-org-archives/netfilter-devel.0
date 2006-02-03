From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/14]: nf_conntrack: check address family when finding
	protocol module
Date: Fri,  3 Feb 2006 14:44:03 +0100 (MET)
Message-ID: <20060203134403.2141.95037.sendpatchset@localhost.localdomain>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: check address family when finding protocol module

__nf_conntrack_{l3}proto_find() doesn't check the passed protocol family,
then it's possible to touch out of the array which has only AF_MAX items.

Spotted by Pablo Neira Ayuso.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit edf3735e79f637f92f34d0848bfb6c0ea45a9349
tree bb8c411bf1f695008b7bc22f7d05d58ac5dea997
parent 04e7be099c349b1c9646ad3cc2c409775c846334
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 03 Feb 2006 12:27:36 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:27:36 +0100

 include/net/netfilter/nf_conntrack_l3proto.h |   15 +++++++++------
 net/netfilter/nf_conntrack_core.c            |    2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 67856eb..dac43b1 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -88,12 +88,6 @@ extern struct nf_conntrack_l3proto *nf_c
 extern int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto);
 extern void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
 
-static inline struct nf_conntrack_l3proto *
-__nf_ct_l3proto_find(u_int16_t l3proto)
-{
-	return nf_ct_l3protos[l3proto];
-}
-
 extern struct nf_conntrack_l3proto *
 nf_ct_l3proto_find_get(u_int16_t l3proto);
 
@@ -103,4 +97,13 @@ extern void nf_ct_l3proto_put(struct nf_
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
 extern struct nf_conntrack_l3proto nf_conntrack_generic_l3proto;
+
+static inline struct nf_conntrack_l3proto *
+__nf_ct_l3proto_find(u_int16_t l3proto)
+{
+	if (unlikely(l3proto >= AF_MAX))
+		return &nf_conntrack_generic_l3proto;
+	return nf_ct_l3protos[l3proto];
+}
+
 #endif /*_NF_CONNTRACK_L3PROTO_H*/
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 62bb509..0ce337a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -188,7 +188,7 @@ extern struct nf_conntrack_protocol nf_c
 struct nf_conntrack_protocol *
 __nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol)
 {
-	if (unlikely(nf_ct_protos[l3proto] == NULL))
+	if (unlikely(l3proto >= AF_MAX || nf_ct_protos[l3proto] == NULL))
 		return &nf_conntrack_generic_protocol;
 
 	return nf_ct_protos[l3proto][protocol];
