From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] ipt_REJECT re-sync
Date: Thu, 11 Sep 2003 17:40:08 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030911074604.C6A202C0C7@lists.samba.org>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: davem@redhat.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Name: REJECT nonlinear fixes after sync with 2.4
Author: Rusty Russell
Status: Booted on 2.6.0-test5-bk1

D: Harald synced up ipt_REJECT.c from 2.4 route fixes, but it had
D: changed a fair bit because of the nonlinear fixes.  This repairs it.
D: 
D: 1) Copying of tcp header onto stack.
D: 2) ...which also checks length requirement.
D: 3) Skip checksum check: requires linear packet.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .22921-linux-2.6.0-test2/net/ipv4/netfilter/ipt_REJECT.c .22921-linux-2.6.0-test2.updated/net/ipv4/netfilter/ipt_REJECT.c
--- .22921-linux-2.6.0-test2/net/ipv4/netfilter/ipt_REJECT.c	2003-07-31 01:50:21.000000000 +1000
+++ .22921-linux-2.6.0-test2.updated/net/ipv4/netfilter/ipt_REJECT.c	2003-07-31 15:08:26.000000000 +1000
@@ -80,45 +80,34 @@ static inline struct rtable *route_rever
 static void send_reset(struct sk_buff *oldskb, int local)
 {
 	struct sk_buff *nskb;
-	struct tcphdr *otcph, *tcph;
+	struct tcphdr otcph, *tcph;
 	struct rtable *rt;
-	unsigned int otcplen;
 	u_int16_t tmp_port;
 	u_int32_t tmp_addr;
 	int needs_ack;
 	int hh_len;
 
-	/* IP header checks: fragment, too short. */
-	if (oldskb->nh.iph->frag_off & htons(IP_OFFSET)
-	    || oldskb->len < (oldskb->nh.iph->ihl<<2) + sizeof(struct tcphdr))
+	/* IP header checks: fragment. */
+	if (oldskb->nh.iph->frag_off & htons(IP_OFFSET))
 		return;
 
-	otcph = (struct tcphdr *)((u_int32_t*)oldskb->nh.iph + oldskb->nh.iph->ihl);
-	otcplen = oldskb->len - oldskb->nh.iph->ihl*4;
-
 	if (skb_copy_bits(oldskb, oldskb->nh.iph->ihl*4,
-			  otcph, sizeof(*otcph)) < 0)
-		return;
+			  &otcph, sizeof(otcph)) < 0)
+ 		return;
 
 	/* No RST for RST. */
-	if (otcph->rst)
-		return;
-
-	/* Check checksum. */
-	if (tcp_v4_check(otcph, otcplen, oldskb->nh.iph->saddr,
-			 oldskb->nh.iph->daddr,
-			 csum_partial((char *)otcph, otcplen, 0)) != 0)
+	if (otcph.rst)
 		return;
 
+	/* FIXME: Check checksum --RR */
 	if ((rt = route_reverse(oldskb, local)) == NULL)
 		return;
 
 	hh_len = (rt->u.dst.dev->hard_header_len + 15)&~15;
 
-	/* Copy skb (even if skb is about to be dropped, we can't just
-           clone it because there may be other things, such as tcpdump,
-           interested in it). We also need to expand headroom in case
-	   hh_len of incoming interface < hh_len of outgoing interface */
+	/* We need a linear, writeable skb.  We also need to expand
+	   headroom in case hh_len of incoming interface < hh_len of
+	   outgoing interface */
 	nskb = skb_copy_expand(oldskb, hh_len, skb_tailroom(oldskb),
 			       GFP_ATOMIC);
 	if (!nskb) {
@@ -155,12 +144,13 @@ static void send_reset(struct sk_buff *o
 
 	if (tcph->ack) {
 		needs_ack = 0;
-		tcph->seq = otcph->ack_seq;
+		tcph->seq = otcph.ack_seq;
 		tcph->ack_seq = 0;
 	} else {
 		needs_ack = 1;
-		tcph->ack_seq = htonl(ntohl(otcph->seq) + otcph->syn + otcph->fin
-				      + otcplen - (otcph->doff<<2));
+		tcph->ack_seq = htonl(ntohl(otcph.seq) + otcph.syn + otcph.fin
+				      + oldskb->len - oldskb->nh.iph->ihl*4
+				      - (otcph.doff<<2));
 		tcph->seq = 0;
 	}
 

--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
