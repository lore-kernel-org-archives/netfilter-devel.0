From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Delete nfcache use in ip_table
Date: Fri, 06 May 2005 02:25:26 +0200
Message-ID: <427AB976.8040402@eurodev.net>
References: <427A469D.8030305@eurodev.net> <427A49F6.2090607@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050201020307090105080100"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <427A49F6.2090607@trash.net>
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
--------------050201020307090105080100
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>>I could keep this as a seperate patch in conntrack-event-api pom-ng, but
>>I prefer kill it now and forget about it. If you've got no reason to
>>object, please then pass it to davem.
> 
> 
> No objections, but please remove it in all files under
> net/ipv4/netfilter.

I've deleted all references to nfcache found in ipv4 and ipv6.

While I was at it, I thought about killing NFC_* stuff in 
include/linux/netfilter[_ipv4].h, then I realized that old iptables 
versions won't compile if I do so. Those will have to remain there to 
ensure backward compatibility compilation.

--
Pablo

--------------050201020307090105080100
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ip_conntrack_core.c  (mode:100644 sha1:28d9425d5c390dac7601953e65043e973833e7aa)
+++ uncommitted/net/ipv4/netfilter/ip_conntrack_core.c  (mode:100644)
@@ -627,9 +627,6 @@
 		return NF_DROP;
 	}
 
-	/* FIXME: Do this right please. --RR */
-	(*pskb)->nfcache |= NFC_UNKNOWN;
-
 /* Doesn't cover locally-generated broadcast, so not worth it. */
 #if 0
 	/* Ignore broadcast: no `connection'. */
@@ -966,7 +963,6 @@
 	}
 
 	ip_send_check(skb->nh.iph);
-	skb->nfcache |= NFC_ALTERED;
 #ifdef CONFIG_NETFILTER_DEBUG
 	/* Packet path as if nothing had happened. */
 	skb->nf_debug = olddebug;
Index: net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ip_nat_core.c  (mode:100644 sha1:9fc6f93af0dd15de8933a14e053bf8cdf41dfb69)
+++ uncommitted/net/ipv4/netfilter/ip_nat_core.c  (mode:100644)
@@ -321,7 +321,6 @@
 {
 	struct iphdr *iph;
 
-	(*pskb)->nfcache |= NFC_ALTERED;
 	if (!skb_ip_make_writable(pskb, iphdroff + sizeof(*iph)))
 		return 0;
 
Index: net/ipv4/netfilter/ip_nat_standalone.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ip_nat_standalone.c  (mode:100644 sha1:79f56f662b336bb1a48298af7c0d03c1e1d73b89)
+++ uncommitted/net/ipv4/netfilter/ip_nat_standalone.c  (mode:100644)
@@ -73,8 +73,6 @@
 	IP_NF_ASSERT(!((*pskb)->nh.iph->frag_off
 		       & htons(IP_MF|IP_OFFSET)));
 
-	(*pskb)->nfcache |= NFC_UNKNOWN;
-
 	/* If we had a hardware checksum before, it's now invalid */
 	if ((*pskb)->ip_summed == CHECKSUM_HW)
 		if (skb_checksum_help(*pskb, (out == NULL)))
Index: net/ipv4/netfilter/ip_queue.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ip_queue.c  (mode:100644 sha1:9e40dffc204f3438e0dbabc1ed89be0031f13449)
+++ uncommitted/net/ipv4/netfilter/ip_queue.c  (mode:100644)
@@ -375,7 +375,6 @@
 	if (!skb_ip_make_writable(&e->skb, v->data_len))
 		return -ENOMEM;
 	memcpy(e->skb->data, v->payload, v->data_len);
-	e->skb->nfcache |= NFC_ALTERED;
 
 	/*
 	 * Extra routing may needed on local out, as the QUEUE target never
Index: net/ipv4/netfilter/ip_tables.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ip_tables.c  (mode:100644 sha1:8a54f92b8496a4218a243c35ab2b55ec659e7d18)
+++ uncommitted/net/ipv4/netfilter/ip_tables.c  (mode:100644)
@@ -313,7 +313,6 @@
 	do {
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
-		(*pskb)->nfcache |= e->nfcache;
 		if (ip_packet_match(ip, indev, outdev, &e->ip, offset)) {
 			struct ipt_entry_target *t;
 
Index: net/ipv4/netfilter/ipt_CLASSIFY.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ipt_CLASSIFY.c  (mode:100644 sha1:9842e6e231845c7aec4e42dafe4585f03fca4def)
+++ uncommitted/net/ipv4/netfilter/ipt_CLASSIFY.c  (mode:100644)
@@ -32,10 +32,8 @@
 {
 	const struct ipt_classify_target_info *clinfo = targinfo;
 
-	if((*pskb)->priority != clinfo->priority) {
+	if((*pskb)->priority != clinfo->priority)
 		(*pskb)->priority = clinfo->priority;
-		(*pskb)->nfcache |= NFC_ALTERED;
-	}
 
 	return IPT_CONTINUE;
 }
Index: net/ipv4/netfilter/ipt_CONNMARK.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ipt_CONNMARK.c  (mode:100644 sha1:30ddd3e18eb747184b80eea693778058a85c14ec)
+++ uncommitted/net/ipv4/netfilter/ipt_CONNMARK.c  (mode:100644)
@@ -61,10 +61,8 @@
 	    case IPT_CONNMARK_RESTORE:
 		nfmark = (*pskb)->nfmark;
 		diff = (ct->mark ^ nfmark) & markinfo->mask;
-		if (diff != 0) {
+		if (diff != 0)
 		    (*pskb)->nfmark = nfmark ^ diff;
-		    (*pskb)->nfcache |= NFC_ALTERED;
-		}
 		break;
 	    }
 	}
Index: net/ipv4/netfilter/ipt_DSCP.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ipt_DSCP.c  (mode:100644 sha1:3ea4509099f907ec15fe0975e3dc9d8def7f78eb)
+++ uncommitted/net/ipv4/netfilter/ipt_DSCP.c  (mode:100644)
@@ -51,7 +51,6 @@
 						 sizeof(diffs),
 						 (*pskb)->nh.iph->check
 						 ^ 0xFFFF));
-		(*pskb)->nfcache |= NFC_ALTERED;
 	}
 	return IPT_CONTINUE;
 }
Index: net/ipv4/netfilter/ipt_ECN.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ipt_ECN.c  (mode:100644 sha1:ada9911118e9a7ec2ee841db8b3f250e48bfb71c)
+++ uncommitted/net/ipv4/netfilter/ipt_ECN.c  (mode:100644)
@@ -43,7 +43,6 @@
 						 sizeof(diffs),
 						 (*pskb)->nh.iph->check
 						 ^0xFFFF));
-		(*pskb)->nfcache |= NFC_ALTERED;
 	} 
 	return 1;
 }
@@ -86,7 +85,6 @@
 	else
 		if (skb_checksum_help(*pskb, inward))
 			return 0;
-	(*pskb)->nfcache |= NFC_ALTERED;
 	return 1;
 }
 
Index: net/ipv4/netfilter/ipt_MARK.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ipt_MARK.c  (mode:100644 sha1:33c6f9b63b8d7af0d0fa36c74158b0fc633f2e37)
+++ uncommitted/net/ipv4/netfilter/ipt_MARK.c  (mode:100644)
@@ -29,10 +29,8 @@
 {
 	const struct ipt_mark_target_info *markinfo = targinfo;
 
-	if((*pskb)->nfmark != markinfo->mark) {
+	if((*pskb)->nfmark != markinfo->mark)
 		(*pskb)->nfmark = markinfo->mark;
-		(*pskb)->nfcache |= NFC_ALTERED;
-	}
 	return IPT_CONTINUE;
 }
 
@@ -61,10 +59,8 @@
 		break;
 	}
 
-	if((*pskb)->nfmark != mark) {
+	if((*pskb)->nfmark != mark)
 		(*pskb)->nfmark = mark;
-		(*pskb)->nfcache |= NFC_ALTERED;
-	}
 	return IPT_CONTINUE;
 }
 
Index: net/ipv4/netfilter/ipt_REJECT.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ipt_REJECT.c  (mode:100644 sha1:266d64979286dd039245355d108af146e8e5ba8d)
+++ uncommitted/net/ipv4/netfilter/ipt_REJECT.c  (mode:100644)
@@ -145,7 +145,6 @@
 
 	/* This packet will not be the same as the other: clear nf fields */
 	nf_reset(nskb);
-	nskb->nfcache = 0;
 	nskb->nfmark = 0;
 #ifdef CONFIG_BRIDGE_NETFILTER
 	nf_bridge_put(nskb->nf_bridge);
Index: net/ipv4/netfilter/ipt_TCPMSS.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ipt_TCPMSS.c  (mode:100644 sha1:1049050b2bfbc0a5123662548b37ac382e1cb11f)
+++ uncommitted/net/ipv4/netfilter/ipt_TCPMSS.c  (mode:100644)
@@ -189,7 +189,6 @@
 	/* We never hw checksum SYN packets.  */
 	BUG_ON((*pskb)->ip_summed == CHECKSUM_HW);
 
-	(*pskb)->nfcache |= NFC_UNKNOWN | NFC_ALTERED;
 	return IPT_CONTINUE;
 }
 
Index: net/ipv4/netfilter/ipt_TOS.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ipt_TOS.c  (mode:100644 sha1:85c70d240f8bf433e6e7b59d7cc9712371a5769b)
+++ uncommitted/net/ipv4/netfilter/ipt_TOS.c  (mode:100644)
@@ -46,7 +46,6 @@
 						 sizeof(diffs),
 						 (*pskb)->nh.iph->check
 						 ^0xFFFF));
-		(*pskb)->nfcache |= NFC_ALTERED;
 	}
 	return IPT_CONTINUE;
 }
Index: net/ipv6/netfilter/ip6_queue.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv6/netfilter/ip6_queue.c  (mode:100644 sha1:c54830b895939ed78f099978841d48a0d1d4a457)
+++ uncommitted/net/ipv6/netfilter/ip6_queue.c  (mode:100644)
@@ -379,7 +379,6 @@
 	if (!skb_ip_make_writable(&e->skb, v->data_len))
 		return -ENOMEM;
 	memcpy(e->skb->data, v->payload, v->data_len);
-	e->skb->nfcache |= NFC_ALTERED;
 
 	/*
 	 * Extra routing may needed on local out, as the QUEUE target never
Index: net/ipv6/netfilter/ip6t_MARK.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv6/netfilter/ip6t_MARK.c  (mode:100644 sha1:d09ceb05013a90346f916a44a5c77830164a4250)
+++ uncommitted/net/ipv6/netfilter/ip6t_MARK.c  (mode:100644)
@@ -28,10 +28,8 @@
 {
 	const struct ip6t_mark_target_info *markinfo = targinfo;
 
-	if((*pskb)->nfmark != markinfo->mark) {
+	if((*pskb)->nfmark != markinfo->mark)
 		(*pskb)->nfmark = markinfo->mark;
-		(*pskb)->nfcache |= NFC_ALTERED;
-	}
 	return IP6T_CONTINUE;
 }
 

--------------050201020307090105080100--
