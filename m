From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 17/18] Netfilter:  ftp nonlinear packet fix
Date: Wed, 05 Jan 2005 14:37:13 +1100
Message-ID: <1104896233.20582.85.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: ftp nonlinear packet fix
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

FTP connection tracking assumes it can just dereference tcphdr; not
neccessarily true now we don't linearize in ftp conntrack helper or
tcp connection tracking.  Also found by nfsim.

Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_nat_ftp.c	2005-01-05 13:09:48.801343312 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c	2005-01-05 13:15:49.981435592 +1100
@@ -169,18 +169,16 @@
 static int ftp_data_fixup(const struct ip_ct_ftp_expect *exp_ftp_info,
 			  struct ip_conntrack *ct,
 			  struct sk_buff **pskb,
+			  u32 tcp_seq,
 			  enum ip_conntrack_info ctinfo,
 			  struct ip_conntrack_expect *expect)
 {
 	u_int32_t newip;
-	struct iphdr *iph = (*pskb)->nh.iph;
-	struct tcphdr *tcph = (void *)iph + iph->ihl*4;
 	u_int16_t port;
 	struct ip_conntrack_tuple newtuple;
 
 	DEBUGP("FTP_NAT: seq %u + %u in %u\n",
-	       expect->seq, exp_ftp_info->len,
-	       ntohl(tcph->seq));
+	       expect->seq, exp_ftp_info->len, tcp_seq);
 
 	/* Change address inside packet to match way we're mapping
 	   this connection. */
@@ -217,7 +215,7 @@
 		return 0;
 
 	if (!mangle[exp_ftp_info->ftptype](pskb, newip, port,
-					  expect->seq - ntohl(tcph->seq),
+					  expect->seq - tcp_seq,
 					  exp_ftp_info->len, ct, ctinfo))
 		return 0;
 
@@ -232,7 +230,7 @@
 			 struct sk_buff **pskb)
 {
 	struct iphdr *iph = (*pskb)->nh.iph;
-	struct tcphdr *tcph = (void *)iph + iph->ihl*4;
+	struct tcphdr _tcph, *tcph;
 	unsigned int datalen;
 	int dir;
 	struct ip_ct_ftp_expect *exp_ftp_info;
@@ -255,12 +253,17 @@
 		return NF_ACCEPT;
 	}
 
+	/* We passed tcp tracking, plus ftp helper: this must succeed. */
+	tcph = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_tcph), &_tcph);
+	BUG_ON(!tcph);
+
 	datalen = (*pskb)->len - iph->ihl * 4 - tcph->doff * 4;
 	/* If it's in the right range... */
 	if (between(exp->seq + exp_ftp_info->len,
 		    ntohl(tcph->seq),
 		    ntohl(tcph->seq) + datalen)) {
-		if (!ftp_data_fixup(exp_ftp_info, ct, pskb, ctinfo, exp))
+		if (!ftp_data_fixup(exp_ftp_info, ct, pskb, ntohl(tcph->seq),
+				    ctinfo, exp))
 			return NF_DROP;
 	} else {
 		/* Half a match?  This means a partial retransmisison.
