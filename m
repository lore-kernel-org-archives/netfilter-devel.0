From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/39]: ipt_TCPMSS: reformat
Date: Wed, 20 Sep 2006 10:23:56 +0200 (MEST)
Message-ID: <20060920082448.14636.28002.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_TCPMSS: reformat

- fix whitespace error
- break lines at 80 characters
- reformat some expressions to be more readable

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit feaf79fd9c26309b0bffa69e7b4f835fc8f30179
tree 2cb4ada2adc12cc4cc2130948678893899cfb14f
parent 9e49956af011aa3825b17ab6edd18a9eafa19bc2
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:00 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:00 +0200

 net/ipv4/netfilter/ipt_TCPMSS.c |   58 +++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
index ac8a35e..bfc8d9c 100644
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -31,8 +31,10 @@ static inline unsigned int
 optlen(const u_int8_t *opt, unsigned int offset)
 {
 	/* Beware zero-length options: make finite progress */
-	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0) return 1;
-	else return opt[offset+1];
+	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
+		return 1;
+	else
+		return opt[offset+1];
 }
 
 static unsigned int
@@ -55,7 +57,6 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 
 	iph = (*pskb)->nh.iph;
 	tcplen = (*pskb)->len - iph->ihl*4;
-
 	tcph = (void *)iph + iph->ihl*4;
 
 	/* Since it passed flags test in tcp match, we know it is is
@@ -71,37 +72,39 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 		return NF_DROP;
 	}
 
-	if(tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU) {
-		if(!(*pskb)->dst) {
+	if (tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU) {
+		if (!(*pskb)->dst) {
 			if (net_ratelimit())
-				printk(KERN_ERR
-			       		"ipt_tcpmss_target: no dst?! can't determine path-MTU\n");
+				printk(KERN_ERR "ipt_tcpmss_target: "
+				       "no dst?! can't determine path-MTU\n");
 			return NF_DROP; /* or IPT_CONTINUE ?? */
 		}
 
-		if(dst_mtu((*pskb)->dst) <= (sizeof(struct iphdr) + sizeof(struct tcphdr))) {
+		if (dst_mtu((*pskb)->dst) <= sizeof(struct iphdr) +
+					     sizeof(struct tcphdr)) {
 			if (net_ratelimit())
-				printk(KERN_ERR
-		       			"ipt_tcpmss_target: unknown or invalid path-MTU (%d)\n", dst_mtu((*pskb)->dst));
+				printk(KERN_ERR "ipt_tcpmss_target: "
+				       "unknown or invalid path-MTU (%d)\n",
+				       dst_mtu((*pskb)->dst));
 			return NF_DROP; /* or IPT_CONTINUE ?? */
 		}
 
-		newmss = dst_mtu((*pskb)->dst) - sizeof(struct iphdr) - sizeof(struct tcphdr);
+		newmss = dst_mtu((*pskb)->dst) - sizeof(struct iphdr) -
+						 sizeof(struct tcphdr);
 	} else
 		newmss = tcpmssinfo->mss;
 
  	opt = (u_int8_t *)tcph;
-	for (i = sizeof(struct tcphdr); i < tcph->doff*4; i += optlen(opt, i)){
-		if ((opt[i] == TCPOPT_MSS) &&
-		    ((tcph->doff*4 - i) >= TCPOLEN_MSS) &&
-		    (opt[i+1] == TCPOLEN_MSS)) {
+	for (i = sizeof(struct tcphdr); i < tcph->doff*4; i += optlen(opt, i)) {
+		if (opt[i] == TCPOPT_MSS && tcph->doff*4 - i >= TCPOLEN_MSS &&
+		    opt[i+1] == TCPOLEN_MSS) {
 			u_int16_t oldmss;
 
 			oldmss = (opt[i+2] << 8) | opt[i+3];
 
-			if((tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU) &&
-				(oldmss <= newmss))
-					return IPT_CONTINUE;
+			if (tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU &&
+			    oldmss <= newmss)
+				return IPT_CONTINUE;
 
 			opt[i+2] = (newmss & 0xff00) >> 8;
 			opt[i+3] = (newmss & 0x00ff);
@@ -113,7 +116,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 
 			DEBUGP(KERN_INFO "ipt_tcpmss_target: %u.%u.%u.%u:%hu"
 			       "->%u.%u.%u.%u:%hu changed TCP MSS option"
-			       " (from %u to %u)\n", 
+			       " (from %u to %u)\n",
 			       NIPQUAD((*pskb)->nh.iph->saddr),
 			       ntohs(tcph->source),
 			       NIPQUAD((*pskb)->nh.iph->daddr),
@@ -193,9 +196,9 @@ static inline int find_syn_match(const s
 {
 	const struct ipt_tcp *tcpinfo = (const struct ipt_tcp *)m->data;
 
-	if (strcmp(m->u.kernel.match->name, "tcp") == 0
-	    && (tcpinfo->flg_cmp & TH_SYN)
-	    && !(tcpinfo->invflags & IPT_TCP_INV_FLAGS))
+	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
+	    tcpinfo->flg_cmp & TH_SYN &&
+	    !(tcpinfo->invflags & IPT_TCP_INV_FLAGS))
 		return 1;
 
 	return 0;
@@ -212,11 +215,12 @@ ipt_tcpmss_checkentry(const char *tablen
 	const struct ipt_tcpmss_info *tcpmssinfo = targinfo;
 	const struct ipt_entry *e = e_void;
 
-	if((tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU) && 
-			((hook_mask & ~((1 << NF_IP_FORWARD)
-			   	| (1 << NF_IP_LOCAL_OUT)
-			   	| (1 << NF_IP_POST_ROUTING))) != 0)) {
-		printk("TCPMSS: path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
+	if (tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU &&
+	    (hook_mask & ~((1 << NF_IP_FORWARD) |
+			   (1 << NF_IP_LOCAL_OUT) |
+			   (1 << NF_IP_POST_ROUTING))) != 0) {
+		printk("TCPMSS: path-MTU clamping only supported in "
+		       "FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return 0;
 	}
 
