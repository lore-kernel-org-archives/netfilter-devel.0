From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 1/18]: Associate locally generated ICMP errors with
 conntrack of original packet
Date: Mon, 20 Dec 2004 08:14:06 +0100
Message-ID: <41C67BBE.9060508@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020409020604050807000400"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------020409020604050807000400
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Associate locally generated ICMP errors with conntrack of
original packet. Slightly more intrusive than the 2.6
version because it has to add the "skb" argument to the
getfrag callback of ip_build_xmit. Fixes an information
leak with DNAT, also required for the other ICMP fixes.


--------------020409020604050807000400
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 21:47:00+01:00 kaber@coreworks.de 
#   [NETFILTER]: Associate locally generated ICMP errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/netsyms.c
#   2004/12/05 21:46:59+01:00 kaber@coreworks.de +1 -0
#   [NETFILTER]: Associate locally generated ICMP errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/udp.c
#   2004/12/05 21:46:59+01:00 kaber@coreworks.de +4 -2
#   [NETFILTER]: Associate locally generated ICMP errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/raw.c
#   2004/12/05 21:46:59+01:00 kaber@coreworks.de +2 -2
#   [NETFILTER]: Associate locally generated ICMP errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_REJECT.c
#   2004/12/05 21:46:59+01:00 kaber@coreworks.de +2 -14
#   [NETFILTER]: Associate locally generated ICMP errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/ip_output.c
#   2004/12/05 21:46:59+01:00 kaber@coreworks.de +8 -6
#   [NETFILTER]: Associate locally generated ICMP errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/icmp.c
#   2004/12/05 21:46:59+01:00 kaber@coreworks.de +5 -1
#   [NETFILTER]: Associate locally generated ICMP errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/core/netfilter.c
#   2004/12/05 21:46:59+01:00 kaber@coreworks.de +13 -4
#   [NETFILTER]: Associate locally generated ICMP errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/net/ip.h
#   2004/12/05 21:46:59+01:00 kaber@coreworks.de +2 -1
#   [NETFILTER]: Associate locally generated ICMP errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter.h
#   2004/12/05 21:46:59+01:00 kaber@coreworks.de +2 -0
#   [NETFILTER]: Associate locally generated ICMP errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter.h b/include/linux/netfilter.h
--- a/include/linux/netfilter.h	2004-12-20 06:59:19 +01:00
+++ b/include/linux/netfilter.h	2004-12-20 06:59:19 +01:00
@@ -153,6 +153,7 @@
 extern inline struct arpt_target *
 arpt_find_target_lock(const char *name, int *error, struct semaphore *mutex);
 extern void (*ip_ct_attach)(struct sk_buff *, struct nf_ct_info *);
+extern void nf_ct_attach(struct sk_buff *, struct sk_buff *);
 
 #ifdef CONFIG_NETFILTER_DEBUG
 extern void nf_dump_skb(int pf, struct sk_buff *skb);
@@ -163,6 +164,7 @@
 
 #else /* !CONFIG_NETFILTER */
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn) (okfn)(skb)
+static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif /*CONFIG_NETFILTER*/
 
 /* From arch/i386/kernel/smp.c:
diff -Nru a/include/net/ip.h b/include/net/ip.h
--- a/include/net/ip.h	2004-12-20 06:59:19 +01:00
+++ b/include/net/ip.h	2004-12-20 06:59:19 +01:00
@@ -102,7 +102,8 @@
 				      int getfrag (const void *,
 						   char *,
 						   unsigned int,
-						   unsigned int),
+						   unsigned int,
+						   struct sk_buff *),
 				      const void *frag,
 				      unsigned length,
 				      struct ipcm_cookie *ipc,
diff -Nru a/net/core/netfilter.c b/net/core/netfilter.c
--- a/net/core/netfilter.c	2004-12-20 06:59:19 +01:00
+++ b/net/core/netfilter.c	2004-12-20 06:59:19 +01:00
@@ -622,11 +622,20 @@
 }
 #endif /*CONFIG_INET*/
 
-/* This does not belong here, but ipt_REJECT needs it if connection
-   tracking in use: without this, connection may not be in hash table,
-   and hence manufactured ICMP or RST packets will not be associated
-   with it. */
+/* This does not belong here, but locally generated errors need it if connection
+   tracking in use: without this, connection may not be in hash table, and hence
+   manufactured ICMP or RST packets will not be associated with it. */
 void (*ip_ct_attach)(struct sk_buff *, struct nf_ct_info *);
+
+void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb)
+{
+	void (*attach)(struct sk_buff *, struct nf_ct_info *);
+
+	if (skb->nfct && (attach = ip_ct_attach) != NULL) {
+		mb(); /* Just to be sure: must be read before executing this */
+		attach(new, skb->nfct);
+	}
+}
 
 void __init netfilter_init(void)
 {
diff -Nru a/net/ipv4/icmp.c b/net/ipv4/icmp.c
--- a/net/ipv4/icmp.c	2004-12-20 06:59:19 +01:00
+++ b/net/ipv4/icmp.c	2004-12-20 06:59:19 +01:00
@@ -281,11 +281,15 @@
  *	Checksum each fragment, and on the first include the headers and final checksum.
  */
  
-static int icmp_glue_bits(const void *p, char *to, unsigned int offset, unsigned int fraglen)
+static int icmp_glue_bits(const void *p, char *to, unsigned int offset,
+                          unsigned int fraglen, struct sk_buff *skb)
 {
 	struct icmp_bxm *icmp_param = (struct icmp_bxm *)p;
 	struct icmphdr *icmph;
 	unsigned int csum;
+
+	if (icmp_pointers[icmp_param->data.icmph.type].error)
+		nf_ct_attach(skb, icmp_param->skb);
 
 	if (offset) {
 		icmp_param->csum=skb_copy_and_csum_bits(icmp_param->skb,
diff -Nru a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c	2004-12-20 06:59:19 +01:00
+++ b/net/ipv4/ip_output.c	2004-12-20 06:59:19 +01:00
@@ -438,7 +438,8 @@
 		  int getfrag (const void *,
 			       char *,
 			       unsigned int,	
-			       unsigned int),
+			       unsigned int,
+			       struct sk_buff *),
 		  const void *frag,
 		  unsigned length,
 		  struct ipcm_cookie *ipc,
@@ -607,7 +608,7 @@
 		 *	User data callback
 		 */
 
-		if (getfrag(frag, data, offset, fraglen-fragheaderlen)) {
+		if (getfrag(frag, data, offset, fraglen-fragheaderlen, skb)) {
 			err = -EFAULT;
 			kfree_skb(skb);
 			goto error;
@@ -647,7 +648,8 @@
 		  int getfrag (const void *,
 			       char *,
 			       unsigned int,	
-			       unsigned int),
+			       unsigned int,
+			       struct sk_buff *),
 		  const void *frag,
 		  unsigned length,
 		  struct ipcm_cookie *ipc,
@@ -721,10 +723,10 @@
 		iph->daddr=rt->rt_dst;
 		iph->check=0;
 		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
-		err = getfrag(frag, ((char *)iph)+iph->ihl*4,0, length-iph->ihl*4);
+		err = getfrag(frag, ((char *)iph)+iph->ihl*4,0, length-iph->ihl*4, skb);
 	}
 	else
-		err = getfrag(frag, (void *)iph, 0, length);
+		err = getfrag(frag, (void *)iph, 0, length, skb);
 
 	if (err)
 		goto error_fault;
@@ -921,7 +923,7 @@
  *	Fetch data from kernel space and fill in checksum if needed.
  */
 static int ip_reply_glue_bits(const void *dptr, char *to, unsigned int offset, 
-			      unsigned int fraglen)
+			      unsigned int fraglen, struct sk_buff *skb)
 {
         struct ip_reply_arg *dp = (struct ip_reply_arg*)dptr;
 	u16 *pktp = (u16 *)to;
diff -Nru a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
--- a/net/ipv4/netfilter/ipt_REJECT.c	2004-12-20 06:59:19 +01:00
+++ b/net/ipv4/netfilter/ipt_REJECT.c	2004-12-20 06:59:19 +01:00
@@ -22,18 +22,6 @@
 #define DEBUGP(format, args...)
 #endif
 
-/* If the original packet is part of a connection, but the connection
-   is not confirmed, our manufactured reply will not be associated
-   with it, so we need to do this manually. */
-static void connection_attach(struct sk_buff *new_skb, struct nf_ct_info *nfct)
-{
-	void (*attach)(struct sk_buff *, struct nf_ct_info *);
-
-	/* Avoid module unload race with ip_ct_attach being NULLed out */
-	if (nfct && (attach = ip_ct_attach) != NULL)
-		attach(new_skb, nfct);
-}
-
 static inline struct rtable *route_reverse(struct sk_buff *skb, int hook)
 {
 	struct iphdr *iph = skb->nh.iph;
@@ -187,7 +175,7 @@
 	if (nskb->len > nskb->dst->pmtu)
 		goto free_nskb;
 
-	connection_attach(nskb, oldskb->nfct);
+	nf_ct_attach(nskb, oldskb);
 
 	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, nskb, NULL, nskb->dst->dev,
 		ip_finish_output);
@@ -323,7 +311,7 @@
 	icmph->checksum = ip_compute_csum((unsigned char *)icmph,
 					  length - sizeof(struct iphdr));
 
-	connection_attach(nskb, skb_in->nfct);
+	nf_ct_attach(nskb, skb_in);
 
 	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, nskb, NULL, nskb->dst->dev,
 		ip_finish_output);
diff -Nru a/net/ipv4/raw.c b/net/ipv4/raw.c
--- a/net/ipv4/raw.c	2004-12-20 06:59:19 +01:00
+++ b/net/ipv4/raw.c	2004-12-20 06:59:19 +01:00
@@ -266,7 +266,7 @@
  */
   
 static int raw_getfrag(const void *p, char *to, unsigned int offset,
-			unsigned int fraglen)
+		       unsigned int fraglen, struct sk_buff *skb)
 {
 	struct rawfakehdr *rfh = (struct rawfakehdr *) p;
 	return memcpy_fromiovecend(to, rfh->iov, offset, fraglen);
@@ -277,7 +277,7 @@
  */
  
 static int raw_getrawfrag(const void *p, char *to, unsigned int offset,
-				unsigned int fraglen)
+				unsigned int fraglen, struct sk_buff *skb)
 {
 	struct rawfakehdr *rfh = (struct rawfakehdr *) p;
 
diff -Nru a/net/ipv4/udp.c b/net/ipv4/udp.c
--- a/net/ipv4/udp.c	2004-12-20 06:59:19 +01:00
+++ b/net/ipv4/udp.c	2004-12-20 06:59:19 +01:00
@@ -390,7 +390,8 @@
  *	Copy and checksum a UDP packet from user space into a buffer.
  */
  
-static int udp_getfrag(const void *p, char * to, unsigned int offset, unsigned int fraglen) 
+static int udp_getfrag(const void *p, char * to, unsigned int offset,
+                       unsigned int fraglen, struct sk_buff *skb)
 {
 	struct udpfakehdr *ufh = (struct udpfakehdr *)p;
 	if (offset==0) {
@@ -417,7 +418,8 @@
  *	Copy a UDP packet from user space into a buffer without checksumming.
  */
  
-static int udp_getfrag_nosum(const void *p, char * to, unsigned int offset, unsigned int fraglen) 
+static int udp_getfrag_nosum(const void *p, char * to, unsigned int offset,
+                             unsigned int fraglen, struct sk_buff *skb) 
 {
 	struct udpfakehdr *ufh = (struct udpfakehdr *)p;
 
diff -Nru a/net/netsyms.c b/net/netsyms.c
--- a/net/netsyms.c	2004-12-20 06:59:19 +01:00
+++ b/net/netsyms.c	2004-12-20 06:59:19 +01:00
@@ -606,6 +606,7 @@
 EXPORT_SYMBOL(nf_setsockopt);
 EXPORT_SYMBOL(nf_getsockopt);
 EXPORT_SYMBOL(ip_ct_attach);
+EXPORT_SYMBOL(nf_ct_attach);
 #ifdef CONFIG_INET
 #include <linux/netfilter_ipv4.h>
 EXPORT_SYMBOL(ip_route_me_harder);

--------------020409020604050807000400--
