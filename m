From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK] use negative return values as error on
 l3proto processing
Date: Mon, 08 Aug 2005 17:36:05 +0900 (JST)
Message-ID: <200508080836.j788a5TX019221@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Aug__8_17_36_05_2005_689)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Mon_Aug__8_17_36_05_2005_689)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Harald,

This patch changes the return values of L3 protocol processing
like L4 protocol processing.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Mon_Aug__8_17_36_05_2005_689)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-l3proto_err.patch"

[NETFILTER] use negative return values as error on l3proto processing.

This patch changes the return values of L3 protocol processing
like L4 protocol processing.

---
commit 745bb895699402a7031588faa4f260afc656f4dd
tree 5352f867ed4103931e5c47ff43ef105ccec10685
parent b4cfffe82a33f72621196cdc7a79d6b0fb0085df
author <kozakai@alprut.(none)> Mon, 08 Aug 2005 01:54:48 +0900
committer <kozakai@alprut.(none)> Mon, 08 Aug 2005 01:54:48 +0900

 include/linux/netfilter/nf_conntrack_l3proto.h |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    7 +++----
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    7 +++----
 net/netfilter/nf_conntrack_core.c              |    4 ++--
 net/netfilter/nf_conntrack_l3proto_generic.c   |    5 ++---
 5 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_l3proto.h b/include/linux/netfilter/nf_conntrack_l3proto.h
--- a/include/linux/netfilter/nf_conntrack_l3proto.h
+++ b/include/linux/netfilter/nf_conntrack_l3proto.h
@@ -66,7 +66,7 @@ struct nf_conntrack_l3proto
 	 *	*protonum: protocol number
 	 */
 	int (*prepare)(struct sk_buff **pskb, unsigned int hooknum,
-		       unsigned int *dataoff, u_int8_t *protonum, int *ret);
+		       unsigned int *dataoff, u_int8_t *protonum);
 
 	u_int32_t (*get_features)(const struct nf_conntrack_tuple *tuple);
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -96,7 +96,7 @@ nf_ct_ipv4_gather_frags(struct sk_buff *
 
 static int
 ipv4_prepare(struct sk_buff **pskb, unsigned int hooknum, unsigned int *dataoff,
-	     u_int8_t *protonum, int *ret)
+	     u_int8_t *protonum)
 {
 	/* Never happen */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) {
@@ -104,14 +104,13 @@ ipv4_prepare(struct sk_buff **pskb, unsi
 			printk(KERN_ERR "ipv4_prepare: Frag of proto %u (hook=%u)\n",
 			(*pskb)->nh.iph->protocol, hooknum);
 		}
-		*ret = NF_DROP;
-		return 0;
+		return -NF_DROP;
 	}
 
 	*dataoff = (*pskb)->nh.raw - (*pskb)->data + (*pskb)->nh.iph->ihl*4;
 	*protonum = (*pskb)->nh.iph->protocol;
 
-	return 1;
+	return NF_ACCEPT;
 }
 
 int nat_module_is_loaded = 0;
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -139,7 +139,7 @@ int nf_ct_ipv6_skip_exthdr(struct sk_buf
 
 static int
 ipv6_prepare(struct sk_buff **pskb, unsigned int hooknum, unsigned int *dataoff,
-	     u_int8_t *protonum, int *ret)
+	     u_int8_t *protonum)
 {
 	unsigned int extoff;
 	unsigned char pnum;
@@ -159,13 +159,12 @@ ipv6_prepare(struct sk_buff **pskb, unsi
 		DEBUGP("ip6_conntrack_core: can't find proto in pkt\n");
 		NF_CT_STAT_INC(error);
 		NF_CT_STAT_INC(invalid);
-		*ret =  NF_ACCEPT;
-		return 0;
+		return -NF_ACCEPT;
 	}
 
 	*dataoff = protoff;
 	*protonum = pnum;
-	return 1;
+	return NF_ACCEPT;
 }
 
 static u_int32_t ipv6_get_features(const struct nf_conntrack_tuple *tuple)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -938,9 +938,9 @@ nf_conntrack_in(int pf, unsigned int hoo
 	}
 
 	l3proto = nf_ct_find_l3proto((u_int16_t)pf);
-	if (l3proto->prepare(pskb, hooknum, &dataoff, &protonum, &ret) == 0) {
+	if ((ret = l3proto->prepare(pskb, hooknum, &dataoff, &protonum)) <= 0) {
 		DEBUGP("not prepared to track yet or error occured\n");
-		return ret;
+		return -ret;
 	}
 
 	proto = nf_ct_find_proto((u_int16_t)pf, protonum);
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -72,11 +72,10 @@ static int generic_print_conntrack(struc
 
 static int
 generic_prepare(struct sk_buff **pskb, unsigned int hooknum,
-		unsigned int *dataoff, u_int8_t *protonum, int *ret)
+		unsigned int *dataoff, u_int8_t *protonum)
 {
 	/* Never track !!! */
-	*ret = NF_ACCEPT;
-	return 0;
+	return -NF_ACCEPT;
 }
 
 

----Next_Part(Mon_Aug__8_17_36_05_2005_689)----
