From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/3]: Fix HW checksum handling in TCPMSS target
Date: Sat, 20 Aug 2005 03:40:07 +0200
Message-ID: <430689F7.5070305@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040401050106040506060301"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------040401050106040506060301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------040401050106040506060301
Content-Type: text/x-patch;
 name="03-2.6.13.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-2.6.13.diff"

[NETFILTER]: Fix HW checksum handling in TCPMSS target

Most importantly, remove bogus BUG() in receive path.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d02587b6086d97c5bb1236c817702f87114c03cc
tree d962e88ca0c71a2f082a6926afffbfd18217d856
parent b477e1c6defc1b0e1181350908714e11de5768dd
author Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 03:35:30 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 03:35:30 +0200

 net/ipv4/netfilter/ipt_TCPMSS.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -61,6 +61,10 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	if (!skb_ip_make_writable(pskb, (*pskb)->len))
 		return NF_DROP;
 
+	if ((*pskb)->ip_summed == CHECKSUM_HW &&
+	    skb_checksum_help(*pskb, out == NULL))
+		return NF_DROP;
+
 	iph = (*pskb)->nh.iph;
 	tcplen = (*pskb)->len - iph->ihl*4;
 
@@ -114,9 +118,10 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 			opt[i+2] = (newmss & 0xff00) >> 8;
 			opt[i+3] = (newmss & 0x00ff);
 
-			tcph->check = cheat_check(htons(oldmss)^0xFFFF,
-						  htons(newmss),
-						  tcph->check);
+			if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
+				tcph->check = cheat_check(htons(oldmss)^0xFFFF,
+							  htons(newmss),
+							  tcph->check);
 
 			DEBUGP(KERN_INFO "ipt_tcpmss_target: %u.%u.%u.%u:%hu"
 			       "->%u.%u.%u.%u:%hu changed TCP MSS option"
@@ -126,7 +131,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 			       NIPQUAD((*pskb)->nh.iph->daddr),
 			       ntohs(tcph->dest),
 			       oldmss, newmss);
-			goto retmodified;
+			goto out;
 		}
 	}
 
@@ -156,8 +161,10 @@ ipt_tcpmss_target(struct sk_buff **pskb,
  	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, tcplen - sizeof(struct tcphdr));
 
-	tcph->check = cheat_check(htons(tcplen) ^ 0xFFFF,
-				  htons(tcplen + TCPOLEN_MSS), tcph->check);
+	if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
+		tcph->check = cheat_check(htons(tcplen) ^ 0xFFFF,
+					  htons(tcplen + TCPOLEN_MSS),
+					  tcph->check);
 	tcplen += TCPOLEN_MSS;
 
 	opt[0] = TCPOPT_MSS;
@@ -165,12 +172,14 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	opt[2] = (newmss & 0xff00) >> 8;
 	opt[3] = (newmss & 0x00ff);
 
-	tcph->check = cheat_check(~0, *((u_int32_t *)opt), tcph->check);
+	if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
+		tcph->check = cheat_check(~0, *((u_int32_t *)opt), tcph->check);
 
 	oldval = ((u_int16_t *)tcph)[6];
 	tcph->doff += TCPOLEN_MSS/4;
-	tcph->check = cheat_check(oldval ^ 0xFFFF,
-				  ((u_int16_t *)tcph)[6], tcph->check);
+	if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
+		tcph->check = cheat_check(oldval ^ 0xFFFF,
+					  ((u_int16_t *)tcph)[6], tcph->check);
 
 	newtotlen = htons(ntohs(iph->tot_len) + TCPOLEN_MSS);
 	iph->check = cheat_check(iph->tot_len ^ 0xFFFF,
@@ -185,10 +194,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	       ntohs(tcph->dest),
 	       newmss);
 
- retmodified:
-	/* We never hw checksum SYN packets.  */
-	BUG_ON((*pskb)->ip_summed == CHECKSUM_HW);
-
+out:
 	(*pskb)->nfcache |= NFC_UNKNOWN | NFC_ALTERED;
 	return IPT_CONTINUE;
 }

--------------040401050106040506060301
Content-Type: text/x-patch;
 name="03-2.6.14.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-2.6.14.diff"

[NETFILTER]: Fix HW checksum handling in TCPMSS target

Most importantly, remove bogus BUG() in receive path.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit be3af8346490b612b4f031e5421efcc3660ae6a8
tree e685b08f68938861c6e16744703e5e53e24e421d
parent f1929b1a15a9a7d9761b344d3522698bd656154e
author Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 03:29:14 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 20 Aug 2005 03:29:14 +0200

 net/ipv4/netfilter/ipt_TCPMSS.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -61,6 +61,10 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	if (!skb_make_writable(pskb, (*pskb)->len))
 		return NF_DROP;
 
+	if ((*pskb)->ip_summed == CHECKSUM_HW &&
+	    skb_checksum_help(*pskb, out == NULL))
+		return NF_DROP;
+
 	iph = (*pskb)->nh.iph;
 	tcplen = (*pskb)->len - iph->ihl*4;
 
@@ -114,9 +118,10 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 			opt[i+2] = (newmss & 0xff00) >> 8;
 			opt[i+3] = (newmss & 0x00ff);
 
-			tcph->check = cheat_check(htons(oldmss)^0xFFFF,
-						  htons(newmss),
-						  tcph->check);
+			if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
+				tcph->check = cheat_check(htons(oldmss)^0xFFFF,
+							  htons(newmss),
+							  tcph->check);
 
 			DEBUGP(KERN_INFO "ipt_tcpmss_target: %u.%u.%u.%u:%hu"
 			       "->%u.%u.%u.%u:%hu changed TCP MSS option"
@@ -126,7 +131,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 			       NIPQUAD((*pskb)->nh.iph->daddr),
 			       ntohs(tcph->dest),
 			       oldmss, newmss);
-			goto retmodified;
+			goto out;
 		}
 	}
 
@@ -156,8 +161,10 @@ ipt_tcpmss_target(struct sk_buff **pskb,
  	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, tcplen - sizeof(struct tcphdr));
 
-	tcph->check = cheat_check(htons(tcplen) ^ 0xFFFF,
-				  htons(tcplen + TCPOLEN_MSS), tcph->check);
+	if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
+		tcph->check = cheat_check(htons(tcplen) ^ 0xFFFF,
+					  htons(tcplen + TCPOLEN_MSS),
+					  tcph->check);
 	tcplen += TCPOLEN_MSS;
 
 	opt[0] = TCPOPT_MSS;
@@ -165,12 +172,14 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	opt[2] = (newmss & 0xff00) >> 8;
 	opt[3] = (newmss & 0x00ff);
 
-	tcph->check = cheat_check(~0, *((u_int32_t *)opt), tcph->check);
+	if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
+		tcph->check = cheat_check(~0, *((u_int32_t *)opt), tcph->check);
 
 	oldval = ((u_int16_t *)tcph)[6];
 	tcph->doff += TCPOLEN_MSS/4;
-	tcph->check = cheat_check(oldval ^ 0xFFFF,
-				  ((u_int16_t *)tcph)[6], tcph->check);
+	if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY)
+		tcph->check = cheat_check(oldval ^ 0xFFFF,
+					  ((u_int16_t *)tcph)[6], tcph->check);
 
 	newtotlen = htons(ntohs(iph->tot_len) + TCPOLEN_MSS);
 	iph->check = cheat_check(iph->tot_len ^ 0xFFFF,
@@ -185,10 +194,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	       ntohs(tcph->dest),
 	       newmss);
 
- retmodified:
-	/* We never hw checksum SYN packets.  */
-	BUG_ON((*pskb)->ip_summed == CHECKSUM_HW);
-
+out:
 	return IPT_CONTINUE;
 }
 

--------------040401050106040506060301--
